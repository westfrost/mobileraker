#!/usr/bin/env bash
# Installs the APK on the CI emulator, starts it and collects a screenshot + logcat.
set -x
OUT=ci-out
PKG=com.mobileraker.personal
adb install -r "$OUT/mobileraker-plus-x86_64.apk" > "$OUT/06-install.log" 2>&1
adb logcat -c
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1
sleep 45
adb exec-out screencap -p > "$OUT/screen-1.png"
sleep 20
adb exec-out screencap -p > "$OUT/screen-2.png"
if adb shell pidof "$PKG" > /dev/null; then echo "RUNNING" > "$OUT/06-alive.txt"; else echo "NOT RUNNING" > "$OUT/06-alive.txt"; fi
adb logcat -d > "$OUT/06-logcat-full.txt"
grep -E "flutter|FATAL|AndroidRuntime|Exception|Error" "$OUT/06-logcat-full.txt" | grep -v "chatty" | tail -400 > "$OUT/06-logcat.txt"
exit 0
