/*
 * Personal re-implementation for a non-commercial build of Mobileraker.
 *
 * Talks to Spoolman through Moonraker's `server.spoolman.*` JSON-RPC API, so no extra
 * network setup is needed: if Moonraker has the [spoolman] component, this works.
 */

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:common/data/dto/pagination_result.dart';
import 'package:common/exceptions/mobileraker_exception.dart';
import 'package:common/network/jrpc_client_provider.dart';
import 'package:common/network/json_rpc_client.dart';
import 'package:common/util/extensions/ref_extension.dart';
import 'package:common/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../dto/create_filament.dart';
import '../dto/create_spool.dart';
import '../dto/create_vendor.dart';
import '../dto/get_filament.dart';
import '../dto/get_spool.dart';
import '../dto/get_vendor.dart';
import '../dto/spoolman_entity_type_enum.dart';
import '../dto/spoolman_extra_field.dart';
import '../dto/spoolman_filter.dart';
import '../dto/spoolman_server_info.dart';
import '../dto/update_filament.dart';
import '../dto/update_spool.dart';
import '../dto/update_vendor.dart';

part 'spoolman_service.g.dart';

@riverpod
SpoolmanService spoolmanService(Ref ref, String machineUUID) {
  ref.keepAliveFor(const Duration(minutes: 2));
  return SpoolmanService(ref, machineUUID);
}

// ----------------------------------------------------------------------------
// Lists
//
// Moonraker's proxy does not forward Spoolman's `X-Total-Count` header, so the full
// (filtered) list is fetched once and paginated locally. This keeps totals and
// "load more" exact, and is cheap for home-sized inventories.
// ----------------------------------------------------------------------------

@riverpod
Future<List<GetSpool>> _allSpools(Ref ref, String machineUUID, SpoolmanFilter filters) {
  ref.keepAliveFor(const Duration(seconds: 45));
  return ref.watch(spoolmanServiceProvider(machineUUID)).fetchSpools(filters);
}

@riverpod
Future<List<GetFilament>> _allFilaments(Ref ref, String machineUUID, SpoolmanFilter filters) {
  ref.keepAliveFor(const Duration(seconds: 45));
  return ref.watch(spoolmanServiceProvider(machineUUID)).fetchFilaments(filters);
}

@riverpod
Future<List<GetVendor>> _allVendors(Ref ref, String machineUUID, SpoolmanFilter filters) {
  ref.keepAliveFor(const Duration(seconds: 45));
  return ref.watch(spoolmanServiceProvider(machineUUID)).fetchVendors(filters);
}

PaginationResult<T> _paginate<T>(List<T> all, int? page, int? pageSize) {
  final p = page ?? 0;
  if (pageSize == null || pageSize <= 0) return PaginationResult<T>(all, all.length, 0, all.isEmpty ? 1 : all.length);
  final start = (p * pageSize).clamp(0, all.length);
  final end = (start + pageSize).clamp(0, all.length);
  return PaginationResult<T>(all.sublist(start, end), all.length, p, pageSize);
}

@riverpod
Future<PaginationResult<GetSpool>> spoolList(
  Ref ref,
  String machineUUID, {
  int? page,
  int? pageSize,
  SpoolmanFilter? filters,
}) async {
  ref.keepAliveFor();
  final all = await ref.watch(_allSpoolsProvider(machineUUID, filters ?? const SpoolmanFilter.empty()).future);
  return _paginate(all, page, pageSize);
}

@riverpod
Future<PaginationResult<GetFilament>> filamentList(
  Ref ref,
  String machineUUID, {
  int? page,
  int? pageSize,
  SpoolmanFilter? filters,
}) async {
  ref.keepAliveFor();
  final all = await ref.watch(_allFilamentsProvider(machineUUID, filters ?? const SpoolmanFilter.empty()).future);
  return _paginate(all, page, pageSize);
}

@riverpod
Future<PaginationResult<GetVendor>> vendorList(
  Ref ref,
  String machineUUID, {
  int? page,
  int? pageSize,
  SpoolmanFilter? filters,
}) async {
  ref.keepAliveFor();
  final all = await ref.watch(_allVendorsProvider(machineUUID, filters ?? const SpoolmanFilter.empty()).future);
  return _paginate(all, page, pageSize);
}

// ----------------------------------------------------------------------------
// Single entities
// ----------------------------------------------------------------------------

@riverpod
Future<GetSpool?> spool(Ref ref, String machineUUID, int id) {
  ref.keepAliveFor();
  return ref.watch(spoolmanServiceProvider(machineUUID)).getSpool(id);
}

@riverpod
Future<GetFilament?> filament(Ref ref, String machineUUID, int id) {
  ref.keepAliveFor();
  return ref.watch(spoolmanServiceProvider(machineUUID)).getFilament(id);
}

@riverpod
Future<GetVendor?> vendor(Ref ref, String machineUUID, int id) {
  ref.keepAliveFor();
  return ref.watch(spoolmanServiceProvider(machineUUID)).getVendor(id);
}

// ----------------------------------------------------------------------------
// Active spool
// ----------------------------------------------------------------------------

/// Id of the spool Moonraker currently tracks usage for (null = none).
@riverpod
Stream<int?> activeSpoolId(Ref ref, String machineUUID) async* {
  ref.keepAliveFor(const Duration(minutes: 1));
  final service = ref.watch(spoolmanServiceProvider(machineUUID));

  final controller = StreamController<int?>();
  ref.onDispose(controller.close);

  // Moonraker pushes `notify_active_spool_set` whenever the active spool changes.
  ref.listen(jrpcMethodEventProvider(machineUUID, 'notify_active_spool_set'), (_, next) {
    final params = next.value?['params'];
    final payload = params is List ? params.firstOrNull : params;
    if (payload is Map) {
      final id = payload['spool_id'];
      controller.add(id is int ? id : int.tryParse('${id ?? ''}'));
    }
  });

  controller.add(await service.getActiveSpoolId());
  yield* controller.stream.distinct();
}

@riverpod
Stream<GetSpool?> activeSpool(Ref ref, String machineUUID) async* {
  ref.keepAliveFor(const Duration(minutes: 1));
  final id = await ref.watch(activeSpoolIdProvider(machineUUID).future);
  if (id == null) {
    yield null;
    return;
  }
  final service = ref.watch(spoolmanServiceProvider(machineUUID));

  // Weight changes while printing (Moonraker reports usage to Spoolman), so keep it fresh.
  final timer = Stream<void>.periodic(const Duration(seconds: 45));
  yield await service.getSpool(id);
  await for (final _ in timer) {
    try {
      yield await service.getSpool(id);
    } catch (e) {
      talker.warning('[Spoolman] Could not refresh active spool $id', e);
    }
  }
}

// ----------------------------------------------------------------------------
// Settings / meta data
// ----------------------------------------------------------------------------

@riverpod
Future<String?> _spoolmanCurrencyAsync(Ref ref, String machineUUID) async {
  ref.keepAliveFor(const Duration(minutes: 10));
  return ref.watch(spoolmanServiceProvider(machineUUID)).getCurrency();
}

/// Currency code configured in Spoolman (e.g. `EUR`, `DKK`). Null while loading/unknown.
@riverpod
String? spoolmanCurrency(Ref ref, String machineUUID) {
  return ref.watch(_spoolmanCurrencyAsyncProvider(machineUUID)).value;
}

@riverpod
Future<List<SpoolmanExtraField>> spoolmanExtraFields(Ref ref, String machineUUID, SpoolmanEntityType type) async {
  ref.keepAliveFor(const Duration(minutes: 10));
  return ref.watch(spoolmanServiceProvider(machineUUID)).getExtraFields(type);
}

@riverpod
Future<SpoolmanServerInfo> spoolmanServerInfo(Ref ref, String machineUUID) {
  ref.keepAliveFor(const Duration(minutes: 10));
  return ref.watch(spoolmanServiceProvider(machineUUID)).getServerInfo();
}

// ----------------------------------------------------------------------------
// Service
// ----------------------------------------------------------------------------

class SpoolmanService {
  SpoolmanService(this._ref, this.machineUUID);

  /// Spoolman's QR codes encode `web+spoolman:s-<id>`.
  static final RegExp qrCodeRegEx = RegExp(r'^web\+spoolman:s-(?<id>[0-9]+)$');

  final Ref _ref;
  final String machineUUID;

  JsonRpcClient get _client => _ref.read(jrpcClientProvider(machineUUID));

  /// Sends a request through Moonraker's Spoolman proxy and returns the decoded body.
  Future<dynamic> _proxy(String method, String path, {Map<String, String>? query, Object? body}) async {
    final params = <String, dynamic>{
      'request_method': method,
      'path': path,
      if (query != null && query.isNotEmpty) 'query': Uri(queryParameters: query).query,
      if (body != null) 'body': body,
      'use_v2_response': true,
    };
    talker.info('[Spoolman@$machineUUID] $method $path ${params['query'] ?? ''}');
    final RpcResponse resp;
    try {
      resp = await _client.sendJRpcMethod('server.spoolman.proxy', params: params);
    } on JRpcError catch (e, s) {
      throw MoonrakerSpoolmanProxyException(e.code, e.message, parentException: e, parentStack: s);
    }

    final result = resp.result;
    if (result.containsKey('response') || result.containsKey('error')) {
      final error = result['error'];
      if (error != null) {
        final code = error is Map ? (error['status_code'] as num?)?.toInt() ?? 500 : 500;
        final message = error is Map ? '${error['message'] ?? error}' : '$error';
        throw MoonrakerSpoolmanProxyException(code, message);
      }
      return result['response'];
    }
    // Moonraker without v2 responses: raw body (lists are wrapped by the rpc client).
    if (result.length == 1 && result['list'] is List) return result['list'];
    return result;
  }

  List<Map<String, dynamic>> _asList(dynamic body) =>
      [for (final e in (body as List? ?? const [])) (e as Map).cast<String, dynamic>()];

  /// Forces all cached Spoolman data of this machine to be fetched again.
  void refresh() => _invalidateAll();

  void _invalidateAll() {
    _ref.invalidate(_allSpoolsProvider);
    _ref.invalidate(_allFilamentsProvider);
    _ref.invalidate(_allVendorsProvider);
    _ref.invalidate(spoolProvider);
    _ref.invalidate(filamentProvider);
    _ref.invalidate(vendorProvider);
    _ref.invalidate(activeSpoolProvider(machineUUID));
  }

  // -- Lists ------------------------------------------------------------------

  Future<List<GetSpool>> fetchSpools([SpoolmanFilter filter = const SpoolmanFilter.empty()]) async {
    final body = await _proxy('GET', '/v1/spool', query: {'sort': 'id:asc', ...filter.toQueryParameters()});
    return _asList(body).map(GetSpool.fromJson).toList();
  }

  Future<List<GetFilament>> fetchFilaments([SpoolmanFilter filter = const SpoolmanFilter.empty()]) async {
    final body = await _proxy('GET', '/v1/filament', query: {'sort': 'id:asc', ...filter.toQueryParameters()});
    return _asList(body).map(GetFilament.fromJson).toList();
  }

  Future<List<GetVendor>> fetchVendors([SpoolmanFilter filter = const SpoolmanFilter.empty()]) async {
    final body = await _proxy('GET', '/v1/vendor', query: {'sort': 'name:asc', ...filter.toQueryParameters()});
    return _asList(body).map(GetVendor.fromJson).toList();
  }

  Future<List<String>> allMaterials() async {
    final body = await _proxy('GET', '/v1/material');
    return [for (final m in (body as List? ?? const [])) if (m != null && '$m'.isNotEmpty) '$m'];
  }

  Future<List<String>> allLocations() async {
    final body = await _proxy('GET', '/v1/location');
    return [for (final m in (body as List? ?? const [])) if (m != null && '$m'.isNotEmpty) '$m'];
  }

  // -- Single -----------------------------------------------------------------

  Future<T?> _getOrNull<T>(String path, T Function(Map<String, dynamic>) parse) async {
    try {
      final body = await _proxy('GET', path);
      return body is Map ? parse(body.cast<String, dynamic>()) : null;
    } on MoonrakerSpoolmanProxyException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<GetSpool?> getSpool(int id) => _getOrNull('/v1/spool/$id', GetSpool.fromJson);

  Future<GetFilament?> getFilament(int id) => _getOrNull('/v1/filament/$id', GetFilament.fromJson);

  Future<GetVendor?> getVendor(int id) => _getOrNull('/v1/vendor/$id', GetVendor.fromJson);

  // -- Spools -----------------------------------------------------------------

  Future<GetSpool> createSpool(CreateSpool dto) async {
    final body = await _proxy('POST', '/v1/spool', body: dto.toJson());
    _invalidateAll();
    return GetSpool.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<GetSpool> updateSpool(UpdateSpool dto) async {
    final body = await _proxy('PATCH', '/v1/spool/${dto.id}', body: dto.toJson());
    _invalidateAll();
    return GetSpool.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<void> deleteSpool(GetSpool spool) async {
    await _proxy('DELETE', '/v1/spool/${spool.id}');
    _invalidateAll();
  }

  Future<GetSpool> archiveSpool(GetSpool spool, [bool archive = true]) async {
    if (archive && await getActiveSpoolId() == spool.id) await clearActiveSpool();
    return updateSpool(UpdateSpool(id: spool.id, archived: archive));
  }

  /// Positive values consume filament, negative values add it back.
  Future<GetSpool> adjustFilamentOnSpool({required GetSpool spool, double? length, double? weight}) async {
    assert(length != null || weight != null, 'Either length or weight must be provided');
    final body = await _proxy('PUT', '/v1/spool/${spool.id}/use', body: {
      if (weight != null) 'use_weight': weight,
      if (weight == null && length != null) 'use_length': length,
    });
    _invalidateAll();
    return GetSpool.fromJson((body as Map).cast<String, dynamic>());
  }

  /// Sets the remaining weight by measuring the spool (gross weight incl. empty spool).
  Future<GetSpool> measureSpool({required GetSpool spool, required double grossWeight}) async {
    final body = await _proxy('PUT', '/v1/spool/${spool.id}/measure', body: {'weight': grossWeight});
    _invalidateAll();
    return GetSpool.fromJson((body as Map).cast<String, dynamic>());
  }

  // -- Filaments --------------------------------------------------------------

  Future<GetFilament> createFilament(CreateFilament dto) async {
    final body = await _proxy('POST', '/v1/filament', body: dto.toJson());
    _invalidateAll();
    return GetFilament.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<GetFilament> updateFilament(UpdateFilament dto) async {
    final body = await _proxy('PATCH', '/v1/filament/${dto.id}', body: dto.toJson());
    _invalidateAll();
    return GetFilament.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<void> deleteFilament(GetFilament filament) async {
    await _proxy('DELETE', '/v1/filament/${filament.id}');
    _invalidateAll();
  }

  // -- Vendors ----------------------------------------------------------------

  Future<GetVendor> createVendor(CreateVendor dto) async {
    final body = await _proxy('POST', '/v1/vendor', body: dto.toJson());
    _invalidateAll();
    return GetVendor.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<GetVendor> updateVendor(UpdateVendor dto) async {
    final body = await _proxy('PATCH', '/v1/vendor/${dto.id}', body: dto.toJson());
    _invalidateAll();
    return GetVendor.fromJson((body as Map).cast<String, dynamic>());
  }

  Future<void> deleteVendor(GetVendor vendor) async {
    await _proxy('DELETE', '/v1/vendor/${vendor.id}');
    _invalidateAll();
  }

  // -- Active spool -----------------------------------------------------------

  Future<int?> getActiveSpoolId() async {
    final resp = await _client.sendJRpcMethod('server.spoolman.get_spool_id');
    final id = resp.result['spool_id'];
    return id is int ? id : int.tryParse('${id ?? ''}');
  }

  Future<RpcResponse> setActiveSpool(GetSpool spool) {
    talker.info('[Spoolman@$machineUUID] Setting active spool to #${spool.id}');
    return _client.sendJRpcMethod('server.spoolman.post_spool_id', params: {'spool_id': spool.id});
  }

  Future<RpcResponse> setActiveSpoolId(int id) =>
      _client.sendJRpcMethod('server.spoolman.post_spool_id', params: {'spool_id': id});

  Future<RpcResponse> clearActiveSpool() {
    talker.info('[Spoolman@$machineUUID] Clearing active spool');
    return _client.sendJRpcMethod('server.spoolman.post_spool_id', params: {'spool_id': null});
  }

  // -- Meta -------------------------------------------------------------------

  Future<String?> getCurrency() async {
    try {
      final body = await _proxy('GET', '/v1/setting/currency');
      if (body is! Map) return null;
      final raw = body['value'];
      final decoded = raw is String ? (jsonDecode(raw) as Object?) : raw;
      return decoded is String && decoded.isNotEmpty ? decoded : null;
    } catch (e) {
      talker.warning('[Spoolman@$machineUUID] Could not read currency', e);
      return null;
    }
  }

  Future<List<SpoolmanExtraField>> getExtraFields(SpoolmanEntityType type) async {
    try {
      final body = await _proxy('GET', '/v1/field/${type.apiName}');
      return _asList(body).map((e) => SpoolmanExtraField.fromJson(e, type)).sortedBy<num>((e) => e.order);
    } catch (e) {
      // Older Spoolman versions have no extra fields.
      talker.warning('[Spoolman@$machineUUID] Could not read extra fields for $type', e);
      return const [];
    }
  }

  Future<SpoolmanServerInfo> getServerInfo() async {
    final body = await _proxy('GET', '/v1/info');
    return SpoolmanServerInfo.fromJson((body as Map).cast<String, dynamic>());
  }

  /// Parses a scanned QR payload into a spool id (`web+spoolman:s-12`, a plain `12` or a Spoolman URL).
  static int? spoolIdFromQr(String raw) {
    final trimmed = raw.trim();
    final m = qrCodeRegEx.firstMatch(trimmed);
    if (m != null) return int.tryParse(m.namedGroup('id')!);
    final url = RegExp(r'/spool/show/(\d+)').firstMatch(trimmed);
    if (url != null) return int.tryParse(url.group(1)!);
    return int.tryParse(trimmed);
  }
}
