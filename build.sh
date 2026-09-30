#!/bin/sh
# Wraps ludo.html into a standalone installable page at www/index.html
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="hu">\n<head>\n<meta charset="utf-8">\n'
  printf '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, user-scalable=no">\n'
  printf '<meta name="theme-color" content="#15313d">\n<link rel="manifest" href="manifest.json">\n<link rel="icon" href="icon.svg">\n'
  printf '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}</style>\n'
  printf '</head>\n<body>\n'
  cat ludo.html
  printf '\n</body>\n</html>\n'
} > www/index.html
