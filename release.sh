#!/bin/sh
# Builds a signed APK and publishes it as a GitHub release. Installed apps (1.1.0 and later)
# find the release on startup and offer it as an update.
#
# Usage: sh release.sh 1.2.0 "- What changed (shown to players, in Hungarian)"
# Needs: the GitHub CLI (gh) logged in, Android Studio's SDK and Java, android/keystore.properties.
set -e
cd "$(dirname "$0")"

VERSION="$1"
NOTES="$2"
[ -n "$VERSION" ] || { echo "Usage: sh release.sh <version> [release notes]"; exit 1; }
echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || { echo "Version must look like 1.2.0"; exit 1; }
command -v gh >/dev/null || { echo "The GitHub CLI (gh) is required: https://cli.github.com, then run: gh auth login"; exit 1; }
[ -f android/keystore.properties ] || { echo "android/keystore.properties is missing, so the APK can't be signed"; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "Commit or stash your changes first"; exit 1; }
git rev-parse -q --verify "refs/tags/v$VERSION" >/dev/null && { echo "Tag v$VERSION already exists"; exit 1; }

# Every release needs a higher versionCode than the one installed, or Android rejects the update
GRADLE=android/app/build.gradle
CODE=$(( $(sed -n 's/^ *versionCode \([0-9][0-9]*\).*/\1/p' "$GRADLE") + 1 ))
sed -i "s/^\( *versionCode \)[0-9][0-9]*/\1$CODE/; s/^\( *versionName \)\".*\"/\1\"$VERSION\"/" "$GRADLE"

sh build.sh
npx cap sync android
(
  cd android
  export JAVA_HOME="${JAVA_HOME:-C:/Program Files/Android/Android Studio/jbr}"
  export GRADLE_USER_HOME="${GRADLE_USER_HOME:-D:/Android/.gradle}"
  ./gradlew --no-daemon -q assembleRelease
)
mkdir -p dist
APK="dist/ki-nevet-a-vegen-$VERSION.apk"
cp android/app/build/outputs/apk/release/app-release.apk "$APK"

git add "$GRADLE"
git commit -q -m "Release $VERSION" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git tag "v$VERSION"
git push -q
git push -q origin "v$VERSION"
gh release create "v$VERSION" "$APK" --title "Ki nevet a végén? $VERSION" --notes "${NOTES:-Új verzió: $VERSION}"
echo "Published v$VERSION (versionCode $CODE): $APK"
