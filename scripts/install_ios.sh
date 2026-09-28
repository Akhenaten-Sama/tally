#!/usr/bin/env bash
# Builds a release of one brand and installs it on a connected iPhone.
#
#   scripts/install_ios.sh            # Tally (portfolio)
#   scripts/install_ios.sh cmb        # Cooperative Mortgage Bank pitch build
#
# Each brand gets its own app name, icon and bundle ID, so they install side
# by side. Xcode project files are restored afterwards, even on failure.
set -euo pipefail

BRAND=${1:-tally}
cd "$(dirname "$0")/.."

# LAUNCH_RGB: launch screen background, 0–1 per channel.
case "$BRAND" in
  tally) NAME=Tally;  BUNDLE=dev.olalekan.tally;     ICON=AppIcon;     LAUNCH_RGB="0.055 0.231 0.180" ;;
  cmb)  NAME=CMBank; BUNDLE=dev.olalekan.tally.cmb; ICON=AppIcon-cmb; LAUNCH_RGB="0 0.478 0.271" ;;
  *) echo "Unknown brand: $BRAND (expected tally or cmb)" >&2; exit 1 ;;
esac

PLIST=ios/Runner/Info.plist
PBXPROJ=ios/Runner.xcodeproj/project.pbxproj
STORYBOARD=ios/Runner/Base.lproj/LaunchScreen.storyboard
LAUNCH_IMAGES=ios/Runner/Assets.xcassets/LaunchImage.imageset
BACKUP=$(mktemp -d)
cp "$PLIST" "$PBXPROJ" "$STORYBOARD" "$BACKUP/"
cp -R "$LAUNCH_IMAGES" "$BACKUP/LaunchImage.imageset"
restore() {
  cp "$BACKUP/Info.plist" "$PLIST"
  cp "$BACKUP/project.pbxproj" "$PBXPROJ"
  cp "$BACKUP/LaunchScreen.storyboard" "$STORYBOARD"
  rm -rf "$LAUNCH_IMAGES" && cp -R "$BACKUP/LaunchImage.imageset" "$LAUNCH_IMAGES"
}
trap restore EXIT

# Branded launch screen: logo image and background colour.
cp ios/brand_assets/"$BRAND"/LaunchImage*.png "$LAUNCH_IMAGES/"
read -r R G B <<< "$LAUNCH_RGB"
sed -i '' -E \
  "s/<color key=\"backgroundColor\" red=\"[0-9.]+\" green=\"[0-9.]+\" blue=\"[0-9.]+\"/<color key=\"backgroundColor\" red=\"$R\" green=\"$G\" blue=\"$B\"/" \
  "$STORYBOARD"

/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $NAME" "$PLIST"
sed -i '' \
  -e "s/PRODUCT_BUNDLE_IDENTIFIER = dev.olalekan.tally;/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE;/" \
  -e "s/ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;/ASSETCATALOG_COMPILER_APPICON_NAME = $ICON;/" \
  "$PBXPROJ"

# Live lookup keys, if present (git-ignored; see config/README.md).
KEY_ARGS=()
if [ -f config/keys.json ]; then
  KEY_ARGS=(--dart-define-from-file=config/keys.json)
  echo "Using live lookup keys from config/keys.json"
fi

flutter build ios --release --dart-define=BRAND="$BRAND" "${KEY_ARGS[@]}"

DEVICE=${DEVICE:-$(flutter devices --machine 2>/dev/null | python3 -c '
import json, sys
phones = [d for d in json.load(sys.stdin) if d["targetPlatform"].startswith("ios") and not d["emulator"]]
print(phones[0]["id"] if phones else "")')}
if [ -z "$DEVICE" ]; then
  echo "No iPhone connected. Plug it in, unlock it, and run again." >&2
  exit 1
fi

xcrun devicectl device install app --device "$DEVICE" build/ios/iphoneos/Runner.app
xcrun devicectl device process launch --device "$DEVICE" --terminate-existing "$BUNDLE"
echo "Installed $NAME on $DEVICE"
