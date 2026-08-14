# Locale (EN / DE)

In-game text stays English in `.tres` / scene files. `Utils.translate()` looks the source string up in `data/locale/de.json` when `Settings.language` is `de`, then substitutes the existing runtime tokens (`{PONYNAME}`, `{GOOD_WAGE}`, …).

- Options: **English** / **Deutsch**. Choice is stored in `user://settings.cfg`
- `GlobalSignals.language_changed` refreshes `DefaultBtn`, `localize_tree`, and dynamic labels
- Tab signals keep the English page key (`Map`, `Wiki`, …) even when the label is `Karte`
- Event buttons look up the English label (`Accept`) and add `"> "` after translation
- `de.json` is the source of truth. Missing keys stay English.
