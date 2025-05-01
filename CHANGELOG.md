# Changelog

All notable changes to the Universal Map Plugin will be documented in this file.

---

## [v0.1.0] – Initial Release

🗓 Released: 2025-05-01

### ✨ Features

- Added support for abstract and grid map modes
- Created web portal integration for viewing maps
- Added token management: `@map/addtoken`, `@map/move`
- Added terrain object support: `@map/addobject`
- Implemented fog of war: `@map/reveal`, `@map/hide`
- Admin-safe uninstall with confirmation: `@map/uninstall/confirm`

### 🗂 Configuration

- `universal_map.yml` – Command shortcuts and plugin settings
- `universal_map_objects.yml` – Object types, icons, and cover rules

### ✅ Ares Compatibility

- Supports `plugin/install` and `plugin/uninstall`
- Auto-loads commands, web request handlers, and help files
- Built using Ares plugin best practices

---

Future versions will include:
- Initiative and range mechanics
- Stealth and hidden token modes
- GM-driven scene-based map triggers
