#!/bin/sh
# Wraps ludo.html into a standalone installable page at www/index.html (also the Android app's web content).
# The standalone copy uses the bundled fonts in www/fonts so it works offline.
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="hu">\n<head>\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, user-scalable=no">\n'
  printf '<meta name="theme-color" content="#1c3b46">\n<link rel="manifest" href="manifest.json">\n<link rel="icon" href="icon.svg">\n'
  # Safe areas: env() in browsers, --safe-area-inset-* injected by Capacitor's SystemBars on Android
  printf '<style>:root{padding-top:max(env(safe-area-inset-top,0px),var(--safe-area-inset-top,0px));padding-bottom:max(env(safe-area-inset-bottom,0px),var(--safe-area-inset-bottom,0px))}[hidden]{display:none!important}</style>\n'
  printf '</head>\n<body>\n'
  grep -v 'rel="preconnect"' ludo.html | sed 's#<link rel="stylesheet" href="https://fonts.googleapis.com/[^"]*">#<link rel="stylesheet" href="fonts/fonts.css">#'
  printf '\n</body>\n</html>\n'
} > www/index.html
