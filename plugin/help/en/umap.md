---
toc: Map Commands
order: 1
summary: Tactical and narrative maps for web & in-game.
aliases:
- gridmap
- maps
---

# Map System

The map system allows GMs to create tactical or narrative maps using either a grid or abstract zones. You can place tokens (players, NPCs, ships) and terrain objects (cover, obstacles), and use fog of war to hide and reveal parts of the map.

You can then view and interact with the map from the web portal.

**Supported Map Modes**
- **Abstract**: Near/Medium/Far/Extreme-style zones (good for narrative/space combat).
- **Grid**: Square-based positioning (ideal for FS3 ground combat or tactical play).

Each map is associated with a room. Only one map can be active per room.


## Creating & Viewing Maps

`umap/create <title>=<options>`  
Creates a new map. Options include:
- `grid` — creates a grid map
- `fog` — enables fog of war

Example:  
`umap/create City Street Battle=grid fog`


`umap/view <id>`  
Shows the web portal link to view the map by ID.


## Token Management

`umap/addtoken <name>=<zone or x,y>`  
Adds a token to the current map.

Examples:
- Abstract map: `umap/addtoken Scout=Near`
- Grid map: `umap/addtoken Droid=4,2`


`umap/move <name>=<zone or x,y>`  
Moves a token on the map.


## Terrain Objects

`umap/addobject <type>=<zone or x,y>`  
Places a terrain object (e.g., crate, wall) on the map.


## Fog of War

`umap/reveal <zone or x,y>`  
Reveals a fogged section of the map.

`umap/hide <zone or x,y>`  
Re-fogs a section of the map.


## Map Management

`umap/delete <id>`  
Deletes the map and all associated data.


## Notes

- Maps are viewable via the web portal.
- More advanced features like weapon range checking are supported through the web interface.
- Future support for initiative, stealth tokens, and more is planned.
