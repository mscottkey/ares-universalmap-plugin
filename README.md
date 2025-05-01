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

To fully remove this plugin:

1. Run `@map/uninstall` to delete all map data and associated tokens/objects.
2. Delete the following from your game server:
   - `plugins/universal_map/`
   - `game/config/universal_map.yml`
   - `webportal/assets/universal_map/map.bundle.js`
3. Remove `universal_map` from `game/config/plugins.yml`.
4. Restart your game server.

For more details, see [Ares plugin removal guide](https://aresmush.com/tutorials/code/plugins.html#removing-plugins).

---

## License

MIT. Use it, fork it, break it — all yours.
