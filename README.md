# Ki nevet a végén?

A Ludo board game for phones. You play against one or three computer opponents. The game text is in Hungarian.

## Files

- `ludo.html` is the game: board, dice, AI opponents and sound effects in a single file.
- `www/` is a standalone build that can be hosted or added to an Android home screen. It contains `index.html`, `manifest.json` and `icon.svg`.
- `build.sh` rebuilds `www/index.html` from `ludo.html`. Run it after editing the game:

```bash
sh build.sh
```

## Rules

- Roll a 6 to bring a token out of its base.
- A 6, a capture or getting a token home earns another roll.
- Three 6s in a row end your turn.
- Tokens on star squares cannot be captured.
- A token needs the exact number to reach home.
