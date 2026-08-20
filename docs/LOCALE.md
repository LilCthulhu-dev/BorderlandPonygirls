# Locale (EN / DE)

Optional German UI. **Default stays English.** This is not Godot's TranslationServer / CSV / gettext.

English source strings stay in `.tres` / scenes. `Utils.translate()` looks the string up in `data/locale/de.json` when `Settings.language` is `de`, then substitutes the usual runtime tokens (`{PONYNAME}`, `{GOOD_WAGE}`, …).

**Missing keys stay English.** New quests do not break. You do not have to translate everything, and you do not need to learn Godot i18n.

## Where to switch language

Options → **Game Options** → Language: **English** / **Deutsch**. Stored in `user://settings.cfg`.

## Adding a new string

1. Write the English in the `.tres` / script as usual.
2. Optionally add `"English source": "German"` to `data/locale/de.json`.
3. Check leftovers:

```
python3 scripts/locale_missing.py
```

If you edit an English line that already has a DE key, update or delete that key — otherwise German silently falls back to the new English.

## Rules (so DE does not break logic)

- Tab signals keep the English page key (`Map`, `Wiki`, …). Localized `Karte` would stop map travel.
- Event buttons look up `Accept` / `Decline`, then add `"> "` after translation.
- Format strings: `translate("Gain %s gold.") % n`, not `translate("Gain %s gold." % n)`.
- Combat `victory_txt` / `defeat_txt` are translated first. Do not translate a concatenated blob.
