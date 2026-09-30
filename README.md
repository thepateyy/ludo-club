# Ki nevet a végén?

A Ludo board game for phones. You play against one or three computer opponents. The game text is in Hungarian.

## Files

- `ludo.html` is the game: board, dice, AI opponents and sound effects in a single file.
- `www/` is a standalone build that can be hosted or added to an Android home screen. It contains `index.html`, `manifest.json` and `icon.svg`.
- `build.sh` rebuilds `www/index.html` from `ludo.html`. Run it after editing the game:

```bash
sh build.sh
```

## Levels and rewards

You earn XP for bringing tokens out (+3), capturing (+15 each), getting a token home (+20), and your final place (1st place is +120 against 3 opponents or +80 against 1). Against the "Ügyes" (sharp) computer, the place bonus is multiplied by 1.5.

Every level from 2 to 20 unlocks a token design, dice skin or table colour. Levels 5, 10, 15 and 20 also give a new title. You can pick what to use in the menu under "Gyűjtemény". Progress is saved in the browser on your device.

## Rules

- Roll a 6 to bring a token out of its base.
- A 6, a capture or getting a token home earns another roll.
- Three 6s in a row end your turn.
- Tokens on star squares cannot be captured.
- A token needs the exact number to reach home.
