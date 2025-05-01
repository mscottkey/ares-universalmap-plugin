## Universal Map plugin for AresMUSH  
NO SUPPORT GUARANTEED — GOOD LUCK :)

This plugin adds a flexible, UI-driven map system to AresMUSH. It supports both abstract and grid-based maps, tokens, fog of war, and terrain objects. It is fully self-contained, uses no external services, and runs in local Ares games.

Built for narrative use (like Star Wars FFG), tactical games (like FS3), and anything in between.

---

## Features

- Grid or abstract mode
- Tokens for characters, NPCs, ships, etc.
- Terrain objects with configurable effects (e.g. cover)
- Fog of war (hide/reveal zones or squares)
- Web viewer integrated into the Ares portal (React-based)

---

## Notes

- All configuration is YAML-based and lives in `game/config/universal_map.yml`
- The portal map viewer is built with React and bundled into `webportal/assets/universal_map/map.bundle.js`
- You’ll need Node + Webpack to rebuild the viewer after making UI changes

---

## Help

Type `help map` in-game for a full list of commands and usage examples.

---

## Uninstall

You will need to remove all the database fields and objects from the database, then remove the plugin itself. See removing plugins for help.

---

## License

MIT. Use it, fork it, break it — all yours.
