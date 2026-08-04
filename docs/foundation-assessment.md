# Foundation Assessment: universalmap → UCC Covenant Space Combat

Assessment of `ares-universalmap-plugin` as the foundation for the AresMUSH
space/space-combat system. Findings verified against AresMUSH core source
(`engine/aresmush/plugin/plugin_manager.rb`, `commands/dispatcher.rb`,
`cron.rb`, `web/engine_api_server.rb`, and the `fs3skills`/`fs3combat`
plugins).

---

## 1. What the plugin actually implements

### Working, verified by reading the code

- **Data model** (`plugin/public/universal_map_model.rb`): three Ohm/Redis
  models — `UniversalMapGrid` (title, mode, fog state), `UniversalMapToken`
  (name, x/y or zone, optional `character_id`), `UniversalMapObject`
  (object_type, x/y or zone). Idiomatic Ares persistence; this is real,
  persistent, room-independent state.
- **Grid and abstract modes**, chosen at `umap/create`, both render.
- **In-game ASCII rendering** (`map_view_template.rb`): grid render with
  fog overlay, object/token symbols, bounds checking; abstract render with
  configured zone order/descriptions. This works and is the most reusable
  piece in the repo.
- **Command plumbing**: dispatcher, `CommandHandler` commands with
  `parse_args`/`required_args`/`check_*`/`handle`, ERB templates, locale
  file, help file, YAML config, admin checks, confirm-gated uninstall.
  All structured exactly per Ares conventions — matches core plugin style.
- **Web request handlers** (`plugin/web/`): view/add-token/move-token/
  add-object/reveal/hide, correctly registered via
  `get_web_request_handler` and using `Website.check_login`.

### Broken (would fail at runtime today)

1. **`umap/move` crashes.** `umap_move_cmd.rb` contains a stale copy of
   `UmapAddObjectCmd`, not a `UmapMoveCmd`. The dispatcher references the
   `UmapMoveCmd` constant → `NameError`. There is no in-game token move at
   all (only the web handler can move tokens).
2. **`umap/reveal` crashes.** `umap_reveal_cmd.rb` defines a second
   `UmapHideCmd`, not `UmapRevealCmd` → same `NameError`.
3. **Duplicate class definitions with divergent behavior.** Two
   `UmapAddObjectCmd`s and two `UmapHideCmd`s exist; whichever file loads
   last silently overwrites the other's methods. Load order happens to
   mask a locale bug (`umap_addobject_cmd.rb` passes `type:` where the
   locale string needs `%{name}` — that path would raise
   `I18n::MissingInterpolationArgument` if it won the load race).
4. **Two rival fog-of-war systems.** The renderers and reveal/hide web
   handlers use the `revealed` array; the model's `fogged?` method and the
   room-title-based `UmapHideCmd` use the `fog_data` hash. `fogged?` is
   never called by anything. One of the two systems is dead weight
   depending on file load order.
5. **`def load` is dead code.** Core's `PluginManager` calls
   `init_plugin` on the plugin module (and `load`, as written, is an
   instance method — never callable on the module anyway). The
   reindex-on-boot workaround never runs; only the manual `umap/reindex`
   command does.
6. **Install-name footgun.** Core resolves the module by comparing the
   plugin *folder name* (upcased) to module constants. `Universalmap`
   matches a folder named `universalmap` only; installing per `plugin.yml`'s
   `universal_map` name raises `SystemNotFoundException` at boot.

### Aspirational (shipped, but cannot work as-is)

The "React-based web-portal map viewer" is a stub:

- `webportal/routes/map.jsx` is **0 bytes** — and the Ares portal is an
  **Ember** app, so a `.jsx` route wouldn't wire in regardless.
- The bundled component fetches `GET /api/map?id=...`. The Ares engine
  exposes web handlers only via `POST /request` (JSON `cmd` + `args`) on
  the engine API port, reached through the portal's gameApi service. That
  fetch can never hit `MapRequestHandler`.
- Path mismatch: bundle lives at `webportal/assets/map.bundle.js`; the hbs
  template and README both reference `assets/universal_map/map.bundle.js`.
- The bundled React component renders only title/mode/fog flag — no grid,
  tokens, objects, or interactivity. The six web request handlers have no
  client UI that calls them.

### Other observations

- **No tests.** Gemfile pulls rspec; there is no `specs/` directory.
- **No per-map dimensions.** Grid size comes from global config defaults
  (all maps are 10×10 unless the global default changes); `umap/create`
  takes no size argument.
- `safe_tokens`/`safe_objects` full-scan every token in the game as a
  workaround for Ohm collection indexing problems (the commit history is
  largely a fight with Redis indexing). Fine at MUSH scale, but the web
  view handler still uses the unsafe `map.tokens` path.
- Help file documents room-based syntax (`umap/addtoken <name>=<loc>`,
  one map per room) that doesn't match the implemented map-id-based
  syntax — a leftover of a design change mid-stream.

### Verdict on solidity

**As a structural template: good.** The Ares conventions — plugin layout,
command handlers, Ohm models, templates, locales, help, config, web
handlers — are all correct and match core plugins. This is genuinely
valuable as the "structured EXACTLY right" reference.

**As a runtime foundation: alpha.** Two of ten commands crash, fog has a
split-brain implementation, boot-time repair never runs, and the web
viewer is a facade. Roughly: the skeleton is sound, the muscles are
partly attached, the web face is a mask.

---

## 2. Extend it or sit beside it?

**Recommendation: sit beside it.** Build the space system as a new plugin
that uses universalmap as a *conventions template*, not as a code
dependency. Keep universalmap (repaired at leisure) for ground/narrative
maps.

Reasoning:

- **The reusable core is small.** What the space system would actually
  reuse is ~100 lines of ASCII grid rendering and the general shape of the
  model layer. The rest (fog zones, crates/trees, character tokens,
  abstract Near/Far zones) is ground-scene furniture.
- **The token model is too thin to carry ships.** A ship needs facing,
  velocity, size class, systems, hardpoints, crew stations, damage state.
  Bolting that onto `UniversalMapToken` (int x/y + zone + icon) either
  bloats the shared model with space-only fields or forces a parallel
  "ship references token" indirection across plugin boundaries — Ares
  plugins share a flat `AresMUSH::` namespace with no dependency
  management, so cross-plugin coupling is all convention and load-order
  luck.
- **Repair cost exceeds reuse value.** Making universalmap trustworthy
  (fix the four broken/duplicated commands, unify fog, per-map sizes,
  tests) is real work that buys nothing space-specific.
- **Blast radius.** A space-combat system will iterate hard. Iterating
  inside the plugin that also serves ground scenes couples two unrelated
  cadences.

### How many plugins?

**One plugin, not three.** Conceptually map/ships/combat stay separate as
folders *inside* one `space` plugin (`plugin/map/`, `plugin/ships/`,
`plugin/combat/`), because:

- Ares has no plugin dependency mechanism — three plugins would rely on
  alphabetical load order and shared global namespace to find each other.
- One `get_cmd_handler`, one config file, one locale, one help tree, one
  install step, one uninstall.
- The core `fs3combat` plugin is precedent: one plugin, many helper
  modules (`helpers/vehicles_helper.rb`, `damage_helper.rb`, …).

Split later only if a second game genuinely wants the map without the
ships.

---

## 3. Is "space as a queried stateful console" achievable? Yes — proven.

This repo *is* the existence proof: Ohm models in Redis are persistent,
global, and room-independent; commands query and render them from any
room; no scheduler, no core changes. The space system is the same
pattern with a richer model:

- RP happens in normal grid rooms (bridge, cockpit, CIC).
- `space/tac` (etc.) renders the persistent tactical state as an ASCII
  sensor display wherever you are — diegetically, reading instruments.
- Web portal later gets the same state via a web request handler
  (correctly wired through `POST /request` this time).

No part of this touches core.

---

## 4. Verified core APIs the space system will lean on

- **FS3 skill rolls**: `FS3Skills.one_shot_roll(char, roll_params)` and
  `FS3Skills.one_shot_die_roll(dice)` are public API
  (`plugins/fs3skills/public/fs3skills_api.rb`). Every human action
  (piloting, gunnery, engineering, damage control) resolves through
  these — we never reimplement skills.
- **Boot hook**: define `self.init_plugin` on the plugin module (NOT
  `load`) — `PluginManager` calls it after load.
- **Web**: `get_web_request_handler` + engine `POST /request` dispatch.
- **Phase-2 feasibility (preliminary — validate after POC):**
  - `Global.dispatcher.queue_timer(seconds, description, client, &block)`
    is a sanctioned EventMachine one-shot timer used by many core plugins
    (jobs, mail, forum, scenes). A self-re-arming queue_timer gives
    N-second ticks with **zero core changes**. Caveats: timers die on
    restart (re-arm from `init_plugin`), run on the single reactor
    thread (ticks must be cheap), and need rescue+re-arm on error.
  - The engine `CronEvent` (via `get_event_handler`) ticks at **1-minute
    granularity** — fine for slow strategic updates, too coarse for a
    flight-sim feel.
  - Conclusion: pseudo-real-time looks feasible inside sanctioned APIs,
    but stays deferred until the turn-based POC works.

---

## 5. Repair list for universalmap itself (separate track, optional)

If/when universalmap is fixed for ground use:

1. Restore `UmapMoveCmd` in `umap_move_cmd.rb`; restore `UmapRevealCmd`
   in `umap_reveal_cmd.rb` (delete the stale duplicate classes).
2. Pick one fog system (`revealed` array is the one everything renders
   from); delete `fog_data` + `fogged?` or make them the single source.
3. Rename `def load` → `def self.init_plugin`.
4. Fix the `object_added` locale interpolation (`type:` vs `%{name}`).
5. Per-map width/height attributes; `umap/create` size option.
6. Fix `map_hide_request.handler.rb` filename; use `safe_tokens`/
   `safe_objects` in `MapRequestHandler`.
7. Align help text with actual command syntax.
8. Web viewer: implement the Ember route, fix the bundle path, and call
   the engine API correctly — or drop the portal claim from the README.

None of this blocks the space POC, since the space plugin sits beside it.

---

## 6. Proposed next step (step 2 of the brief)

Architecture proposal for the single `space` plugin — models
(`SpaceSector`, `SpaceShip`, `SpaceShipClass`, `SpaceContact`,
`SpaceCombat`), size-class/silhouette mechanics, firing arcs and facing,
crew stations mapped to FS3 rolls, and the turn-based round resolution
flow — to be agreed before any combat code is written, per the brief.
