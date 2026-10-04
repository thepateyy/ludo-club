# Ki nevet a végén?

A Ludo board game for phones. You play against one or three computer opponents. The game text is in Hungarian.

## Files

- `ludo.html` is the game: board, dice, AI opponents and sound effects in a single file.
- `www/` is a standalone build that can be hosted or added to an Android home screen. It contains `index.html`, `manifest.json` and `icon.svg`.
- `build.sh` rebuilds `www/index.html` from `ludo.html`. Run it after editing the game:

```bash
sh build.sh
```

## Android app

The `android/` folder is a Capacitor project that packages `www/` as an Android app (`com.thepateyy.kinevet`). Fonts are bundled in `www/fonts`, so the app works offline.

Building needs the Android SDK and a Java runtime, for example from Android Studio:

```bash
npm install
npm run sync
cd android
JAVA_HOME="/c/Program Files/Android/Android Studio/jbr" ./gradlew assembleRelease
```

The signed APK is written to `android/app/build/outputs/apk/release/app-release.apk`.

Release builds are signed with the key described in `android/keystore.properties`. That file and the keystore are never committed. Keep a backup of both: Android only installs an update over the existing app when it is signed with the same key.

To change the app icon, edit the images in `assets/` and run `npx @capacitor/assets generate --android`.

## Opponents

Each computer player is a character with a portrait, a play style and speech-bubble reactions (captures, getting captured, tokens home, rolling a 6):

- **Bence** (agresszív) goes for captures and takes risks.
- **Anna** (óvatos) keeps her tokens safe and prefers star squares.
- **Dóri** (kaotikus) often makes random moves.
- **Matyi** (macskakirály) is a grey tabby cat with a crown. He meows and asks for food. Tap him to feed him: a fed Matyi purrs and plays lazily for a few of his turns, while a hungry Matyi pounces like the aggressive style.

Opponents are picked at random each game. Your first game after this update always includes Matyi.

## Levels, coins and the shop

The level cap is 100. You earn XP for bringing tokens out (+3), capturing (+15 each), getting a token home (+20), and your final place (1st place is +120 against 3 opponents or +80 against 1). Each level needs 25 XP more than the one before, up to 1,000 XP per level from level 37 onwards, so level 100 takes about 82,000 XP.

You earn coins for capturing (+5 each), getting a token home (+5), your final place (1st place is +100 against 3 opponents or +60 against 1), and every level-up (20 + 5 × the new level). Against the "Ügyes" (sharp) computer, place XP and place coins are multiplied by 1.5.

Cosmetics (token designs, dice skins and table colours) come two ways:

- **Level rewards:** one item at every level from 2 to 20, then one every 5 levels up to 100. Titles come at levels 5, 10 and 15, then every 10 levels.
- **Shop items:** bought with coins in the menu under "Bolt", for 250 to 2,000 coins.

Progress is saved in the browser on your device.

## Rules

- Roll a 6 to bring a token out of its base.
- A 6, a capture or getting a token home earns another roll.
- Three 6s in a row end your turn.
- Tokens on star squares cannot be captured.
- A token needs the exact number to reach home.
