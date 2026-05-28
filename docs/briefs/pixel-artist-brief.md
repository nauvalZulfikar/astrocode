# AstroCode -- Pixel Art Hiring Brief

**Document version:** 1.0 | **Date:** 2026-05-25
**Prepared by:** Art Director, AstroCode
**For:** Freelance pixel artist (Fiverr / Upwork)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Technical Specs](#2-technical-specs)
3. [Complete Asset List with Priority](#3-complete-asset-list-with-priority)
4. [Style Guide](#4-style-guide)
5. [Delivery Format](#5-delivery-format)
6. [Budget Guidance](#6-budget-guidance)
7. [Reference Image Board](#7-reference-image-board)
8. [Appendix A: Full Color Palette](#appendix-a-full-color-palette)
9. [Appendix B: Kade Maren Reference Description](#appendix-b-kade-maren-reference-description)

---

## 1. Project Overview

**Game name:** AstroCode
**Genre:** Top-down pixel art survival / automation / educational programming
**Engine:** Godot 4.3+
**Native resolution:** 320x180 viewport, scaled to display
**Tile grid:** 16x16 pixels per tile
**Target framerate:** 60 FPS (animation framerate is separate -- see Section 2)
**Platforms:** Windows, Linux, Mac, Steam Deck (day 1)
**Age rating:** PEGI 7 / ESRB E10+

**Premise:** A solo astronaut crash-lands on an alien planet (Thyra-7) and survives by writing real Python code to program robots, wiring circuits to power a base, and eventually training AI models. The game spans 60 in-game days across 8 biomes, progressing from desperate crash survival to a fully automated colony. There is NO combat. The planet's environment (storms, toxic gas, extreme temperatures) is the antagonist.

**Art tone:** Warm, grounded, worn sci-fi. Think a field engineer's workshop, not a space marine's armory. Equipment is scuffed, patched, functional. Colors are rich and saturated but never neon. Lighting is atmospheric -- burnt-orange skies, bioluminescent caverns, molten lava glow. The world feels lived-in and tactile.

- **NOT** clean, sterile, or clinical (no Apple-store-in-space aesthetic)
- **NOT** grimdark, gritty, or desaturated
- **NOT** cartoonish or chibi-cute (characters have proportions, not bobbleheads)
- **YES** warm, worn, cozy-tense. A campfire in an alien storm. A lighthouse keeper building a city.

**Style references (see Section 7 for specifics):**
- **Stardew Valley** -- character proportions, tile density, farm/base structure readability
- **Hyper Light Drifter** -- palette richness, environmental color storytelling, atmospheric lighting
- **Celeste** -- pixel clarity, animation crispness, sub-pixel smoothness in motion

---

## 2. Technical Specs

### Canvas and Grid

| Parameter | Value |
|---|---|
| Tile size | 16x16 pixels |
| Character sprite size (humanoid) | 32x48 pixels (2 tiles wide, 3 tiles tall) |
| Robot sprite size (standard) | 16x16 pixels (1 tile) |
| Robot sprite size (Atlas only) | 16x24 pixels (1 tile wide, 1.5 tiles tall) |
| Robot sprite size (Pip only) | 8x8 pixels (half tile) |
| Viewport / canvas | 320x180 pixels |
| Scaling | Integer scaling to display resolution (no sub-pixel filtering) |

### Color Palette

**Maximum 32 colors across the entire game.** All assets must share a single unified palette. This is non-negotiable -- it ensures visual cohesion at 320x180 resolution where every pixel matters.

The Kade Maren palette (below) is the anchor. Build the full 32-color palette around these existing colors, adding biome-specific hues (blues for Brine Hollows, reds for Ferric Badlands, turquoise for Spore Marshes, etc.) while keeping the total at or below 32.

**Kade anchor palette (8 colors already locked):**

| Name | Hex | Usage |
|---|---|---|
| Suit orange | `#D4742C` | Kade's jumpsuit, warm accent throughout |
| Suit shadow | `#A85520` | Kade's suit dark, warm shadow tone |
| Helmet white | `#E8E8E0` | Light metals, clean surfaces |
| Visor cyan | `#4CF0F0` | Visor glow, UI highlights, hologram base |
| Skin tone | `#C08860` | Kade's skin, wood-like warm surfaces |
| Hair black | `#282828` | Darkest value, outlines if used, deep shadow |
| Gloves/boots grey | `#484848` | Dark machinery, heavy equipment |
| Belt brown | `#5C3C20` | Leather, organic darks, soil |

The remaining 24 colors must cover: salt white/grey (Alkaline Flats), luminescent blue (Brine Hollows), rust red and iron oxide (Ferric Badlands), turquoise and bioluminescent green (Spore Marshes), translucent amber and prismatic highlights (Glass Dunes), obsidian black and thaline glow purple (Resonance Peaks), ice blue and aurora teal (Polar Sink), magma red-gold and basalt dark (Magma Veins), plus UI colors (HP red, O2 blue, energy yellow, hunger green).

**Deliverable:** Provide the final 32-color palette as a 32x1 PNG swatch file alongside the first asset batch.

### Animation

| Parameter | Value |
|---|---|
| Standard animation framerate | 8 FPS |
| Fast-action animation framerate | 12 FPS (sprint, hurt, die, effects) |
| Sub-pixel animation | YES -- use for walk cycles and smooth motions |
| Looping | All idle and ambient animations must loop seamlessly |

### File Format

| Parameter | Value |
|---|---|
| Format | PNG |
| Background | Transparent (alpha channel) |
| Frames | Individual files per frame (NOT sprite sheets) |
| Color profile | sRGB |
| Bit depth | 32-bit RGBA |

**Why individual frames:** Godot's AtlasTexture and AnimatedSprite2D handle atlas packing internally. Individual frames give us maximum flexibility for re-ordering, re-timing, and hot-swapping during development.

### Naming Convention

All files must follow this exact pattern:

```
<category>_<name>_<direction>_<action>_<frame>.png
```

**Categories:** `char`, `robot`, `tile`, `ui`, `item`, `fx`, `struct`, `circuit`

**Examples:**
- `char_kade_south_walk_01.png`
- `char_kade_south_walk_02.png`
- `char_kade_east_idle_01.png`
- `robot_scuttle_south_move_03.png`
- `robot_pip_south_idle_01.png`
- `tile_alkaline_ground_v1.png`
- `tile_alkaline_ground_v2.png`
- `tile_alkaline_rock_v1.png`
- `ui_bar_hp_frame.png`
- `ui_bar_hp_fill.png`
- `item_scrap_metal.png`
- `item_circuit_board.png`
- `fx_gather_sparkle_01.png`
- `struct_shelter_built.png`
- `struct_shelter_ghost.png`
- `circuit_resistor.png`

**Directions:** `south`, `north`, `east`, `west` (4-directional for characters and robots). Assets without direction (items, UI, tiles) omit the direction segment.

**Frame numbering:** Two digits, starting at `01`. `_01`, `_02`, ..., `_12`.

---

## 3. Complete Asset List with Priority

### PRIORITY 0 -- Prototype (deliver first, estimated 2-3 weeks)

This is the minimum needed to build a playable vertical slice covering Days 1-8 (Alkaline Flats only).

---

#### P0-A: Characters (32x48 pixels each)

##### Kade Maren (Protagonist)

**Status:** 8-direction static rotation sprites ALREADY EXIST (see attached reference). These need to be used as the visual anchor. The existing sprites are 68x68 canvas but the character occupies roughly 32x48 within that space. **For new work, deliver on a 32x48 canvas, trimmed tight to the character.**

**Existing sprites to match:** south, south-east, east, north-east, north, north-west, west, south-west static rotations. These establish the art style. All new Kade animations must be pixel-perfect consistent with these.

**Description:** Southeast Asian male, 28. Medium-brown skin. Messy black hair pushed to one side, sticking out from under a white open-face half-helmet (climbing helmet style, scuffed). Small cyan-glowing flip-up visor above eyes. Tiny yellow headlamp on right side. Burnt orange mechanic's coveralls (NOT sleek sci-fi). White mission patch on chest (2x2px). Faded red-white flag patch on left shoulder. Scuffs and a patched tear on left knee. Dark grey collar ring. Dark brown tool belt (multi-tool on right hip, wire spool on left). Chunky dark grey oversized gloves and boots. Single grey knee pad (left knee only -- asymmetric). Small dark grey backpack with orange strap (visible from side/back). No weapons ever.

**Key visual feature:** Visor always glows cyan -- this is the player beacon in darkness.

**Animations needed (4 directions each: south, north, east, west):**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| idle | 4 | 8 | Subtle breathing, visor flickers once per loop |
| walk | 6 | 8 | Arms swing, hair bounces slightly, sub-pixel foot movement |
| sprint | 6 | 12 | Body leans forward, hair trails back, faster arm pump |
| gather | 4 | 8 | Kneels down, reaches forward with one hand, picks up |
| interact | 3 | 8 | Extends arm forward, presses/touches something |
| code | 4 | 8 | Seated, typing on invisible terminal, head tilts side-to-side |
| hurt | 2 | 12 | Flinch backward, red damage flash overlay |
| die | 4 | 12 | Stumbles, collapses to ground, visor flickers and goes dark |

**Total Kade frames: 4 directions x (4+6+6+4+3+4+2+4) = 4 x 33 = 132 frames**

**Note on SABLE:** SABLE is the ship's AI. It appears as text in the UI -- it has NO sprite. Do not create any art for SABLE.

---

#### P0-B: Robots (16x16 pixels each unless noted)

All robots are 4-directional (south, north, east, west). Every robot gets the same 6 animation states. Robots are mechanical -- they do not breathe or emote. Their "personality" comes from their silhouette and movement style.

**Universal robot animation set:**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| idle | 2 | 8 | Subtle mechanical hum -- a tiny bob, antenna rotation, or LED blink |
| move | 4 | 8 | Locomotion cycle (legs, treads, hover, etc. per robot type) |
| work | 4 | 8 | Performing primary function (gathering, scanning, welding, etc.) |
| low_battery | 2 | 8 | Slower movement, LED dims or flickers orange |
| error | 2 | 12 | Jerky movement, red LED flash, sparks (1-2 pixels) |
| shutdown | 1 | -- | Static frame: powered off, LED dark, slumped/settled posture |

##### 1. Scuttle (Gatherer)
- **Shape:** Low and wide, 6 articulated legs (insect-like), compact rectangular body
- **Color:** Rust orange body (`#D4742C` base, darker `#A85520` underside), dark grey legs (`#484848`)
- **Key feature:** Two small claw arms at front for grabbing resources. Claws open/close during work animation
- **Personality in motion:** Scurries -- legs move fast, body stays low and stable. Like a determined crab
- **Work animation:** Claws reach forward, grab, pull resource into body cavity
- **Total frames:** 4 directions x (2+4+4+2+2+1) = 4 x 15 = 60 frames

##### 2. Ohm (Sensor)
- **Shape:** Tall, thin vertical pole on a small circular base (tripod feet). Taller than wide -- sprite is 16x16 but the pole reaches near the top
- **Color:** White body (`#E8E8E0`), blue accent rings (`visor cyan #4CF0F0` or palette blue), dark grey base
- **Key feature:** Rotating sensor dish on top (like a small radar). Dish rotates in idle animation
- **Personality in motion:** Glides smoothly -- base moves, pole stays upright. Dish constantly scanning
- **Work animation:** Dish spins faster, blue glow pulses from sensor rings, data readout effect (tiny pixel sparkle)
- **Total frames:** 4 x 15 = 60 frames

##### 3. Welder (Builder)
- **Shape:** Boxy, stocky, tank-tread base (no legs). Rectangular body with a single articulated arm ending in a welding torch
- **Color:** Dark grey body (`#484848`), yellow-black hazard stripes on sides (use palette yellow), orange welding tip glow
- **Key feature:** Welding torch arm. During work animation, the torch tip glows bright orange/white with 1-pixel spark particles
- **Personality in motion:** Slow, deliberate, heavy. Treads grind. Like a small bulldozer
- **Work animation:** Arm extends, torch tip glows, 1-2 spark pixels fly off
- **Total frames:** 4 x 15 = 60 frames

##### 4. Plow (Farmer)
- **Shape:** Round, low dome body (like a Roomba). Front-mounted scoop/blade. Thin seed dispensing tube at rear
- **Color:** Green body (palette green, earthy not neon), brown scoop (`#5C3C20`), dark grey undercarriage
- **Key feature:** Front scoop and rear seed tube. Scoop tilts during work animation
- **Personality in motion:** Putters along steadily. Wobbles slightly side to side. Like a slow, happy beetle
- **Work animation:** Scoop tilts down into soil, seed tube drops tiny pixels behind it
- **Total frames:** 4 x 15 = 60 frames

##### 5. Drift (Scout)
- **Shape:** Sleek, narrow, aerodynamic wedge shape. Low profile. Small wheels or hover effect (your choice -- hover preferred)
- **Color:** White body (`#E8E8E0`), single red racing stripe along the side (palette red), dark antenna wire at rear
- **Key feature:** Antenna at rear, streamlined shape conveys speed. Optional: tiny exhaust trail (1px particles) during move
- **Personality in motion:** Fast and darty. Quick direction changes. Like a dragonfly on wheels
- **Work animation:** Stops, antenna extends upward, scanning sweep effect (arc of 1px dots)
- **Total frames:** 4 x 15 = 60 frames

##### 6. Mule (Hauler)
- **Shape:** Large (fills most of the 16x16 space), boxy cargo hauler. Flat open cargo bed on top. Heavy-duty wheels (4 visible from sides)
- **Color:** Brown body (`#5C3C20` lighter), steel/grey cargo bed frame (`#484848`), dark wheels
- **Key feature:** Flat cargo bed -- should look visibly empty when not carrying, and you can imagine crates on it. No arm or tool
- **Personality in motion:** Lumbers slowly. Heavy and deliberate. Slight chassis bounce on uneven terrain
- **Work animation:** Back end tilts up slightly (dumping cargo), items slide off
- **Total frames:** 4 x 15 = 60 frames

##### 7. Pip (Swarm Unit) -- 8x8 pixels
- **Shape:** TINY. Round/spherical, single body. No limbs. Floats/hovers
- **Color:** Bright yellow body (palette yellow), single LED "eye" on front (white when active, dark when off)
- **Key feature:** Smallest sprite in the game. Just a glowing yellow ball with one eye-dot. Players will see swarms of 6-12 of these
- **Personality in motion:** Buzzes and bobs. Quick, erratic micro-movements. Like a firefly
- **Work animation:** LED pulses brighter (broadcasting data), small ring of 1px dots expands outward (mesh signal)
- **Note:** Due to 8x8 size, direction may not be visually distinct. Provide at minimum south and east; west = east mirrored; north = back-of-sphere (no LED visible)
- **Total frames:** 4 x 15 = 60 frames (or 2 directions x 15 = 30, mirrored for the other 2)

##### 8. Atlas (Autonomous) -- 16x24 pixels
- **Shape:** Humanoid bipedal. Small head, broad shoulders, proportioned like a miniature astronaut or humanoid mech. Stands on two feet
- **Color:** White body (`#E8E8E0`), gold accent trim (palette warm gold/yellow), dark grey joints
- **Key feature:** Glowing chest core -- a 2x2 pixel area on the chest that pulses with a warm golden/cyan light. This is the AI processor. It pulses faster when the robot is "thinking"
- **Personality in motion:** Smooth, confident, human-like walking. Most "alive" of all the robots. Slight head-tilt during idle
- **Work animation:** Chest core glows brighter, hands extend forward (working), head tilts as if analyzing
- **Total frames:** 4 x 15 = 60 frames

**Robot summary:**

| Robot | Sprite Size | Frames per Direction | Total Frames |
|---|---|---|---|
| Scuttle | 16x16 | 15 | 60 |
| Ohm | 16x16 | 15 | 60 |
| Welder | 16x16 | 15 | 60 |
| Plow | 16x16 | 15 | 60 |
| Drift | 16x16 | 15 | 60 |
| Mule | 16x16 | 15 | 60 |
| Pip | 8x8 | 15 | 60 (or 30 + mirror) |
| Atlas | 16x24 | 15 | 60 |
| **Robot total** | | | **480 frames** |

---

#### P0-C: Tileset -- Alkaline Flats (16x16 per tile)

The starting biome. Cracked white-grey salt plains under a burnt-orange sky. The Haldane's wreckage is the only vertical structure. Dry, desolate, but NOT ugly -- the salt patterns have a stark, beautiful geometry.

**Ground tiles:**

| Tile | Variants | Notes |
|---|---|---|
| Cracked salt plain | 4 | White-grey base. Crack patterns vary per variant for visual randomization. Some cracks darker, some wider |
| Walkable path | 2 | Slightly smoother/darker than salt plain. Compressed foot traffic look. Player-placed or natural |
| Dark sand | 2 | Transition tile between salt and rock. Brown-grey mix |

**Wall / obstacle tiles:**

| Tile | Variants | Notes |
|---|---|---|
| Rock formation | 3 | Dark grey-brown boulders. 1-tile tall. Blocks movement. Variants = different shapes |
| Ship wreckage (hull) | 4 | Torn metal panels. Orange-grey (Kade's ship color showing through char). Salvageable look. Each variant is a different wreckage chunk |
| Ship wreckage (tall) | 2 | 16x32 (1 tile wide, 2 tiles tall). Larger wreckage pieces standing upright. For the crash site landmark |

**Transition tiles:**

| Tile | Count | Notes |
|---|---|---|
| Salt-to-rock edge | 8 | Standard RPG autotile edge set: N, S, E, W, NE corner, NW corner, SE corner, SW corner. Salt on one side, rock on the other |
| Salt-to-path edge | 4 | N, S, E, W transitions between plain salt and walkable path |

**Decorative tiles (no collision):**

| Tile | Variants | Notes |
|---|---|---|
| Small debris | 3 | Tiny scattered scrap pieces, 1-3 pixels each within the 16x16 tile. Adds visual noise to empty plains |
| Alkaline dust motes | 2 | Very subtle -- 1-2 pale pixels suggesting windblown particles. Optional animated variant (2 frames, particles shift) |
| Crack detail | 2 | Extra crack overlays that can be layered on top of ground tiles for additional variety |

**Tileset total: ~36 tiles**

---

#### P0-D: UI Elements

All UI elements use the game's 32-color palette. UI style is functional, terminal-inspired, warm-dark (not cold-dark). Think amber-on-dark-grey, not green-on-black.

##### Stat Bars

Each stat bar is a horizontal bar with a frame (border) and a fill (inner color). Frame is shared across all bars; fill color differs.

| Element | Size | Colors |
|---|---|---|
| Bar frame (shared) | 48x8 | Dark grey border (`#484848`), darker fill area background |
| HP fill | 46x6 (inside frame) | Red gradient (palette red, darker at left, brighter at right) |
| O2 fill | 46x6 | Blue gradient (palette blue) |
| Energy fill | 46x6 | Yellow gradient (palette yellow) |
| Hunger fill | 46x6 | Green gradient (palette green) |
| Bar tick marks | 46x6 overlay | Subtle 1px vertical lines every ~10% for readability |

**Total: 6 assets (1 frame + 4 fills + 1 tick overlay)**

##### Inventory

| Element | Size | Notes |
|---|---|---|
| Inventory slot (empty) | 18x18 | Dark background with 1px border. Rounded inner corners optional |
| Inventory slot (selected) | 18x18 | Brighter border (cyan or orange highlight), subtle inner glow |
| Inventory slot (filled) | 18x18 | Same as empty but with a subtle background tint showing item rarity (common=none, uncommon=faint blue, rare=faint purple, epic=faint gold) |
| Stack count background | 8x6 | Small dark pill behind the number text (engine renders the number) |

**Total: 4 assets**

##### Buttons

| Element | Size | Notes |
|---|---|---|
| Button default | 48x14 | Dark fill, 1px lighter border, slightly raised look (1px highlight on top edge) |
| Button hover | 48x14 | Slightly brighter fill, border changes to orange or cyan |
| Button pressed | 48x14 | Darker fill, highlight moves to bottom edge (pressed-in look) |
| Button disabled | 48x14 | Desaturated, no highlight |

**Total: 4 assets**

##### Code Editor Frame

| Element | Size | Notes |
|---|---|---|
| Terminal border (9-slice) | 32x32 (source for 9-slice) | Dark background (`#282828` or darker), warm grey border with subtle amber accent line. Corner pieces must tile. 9-slice means the engine stretches the middle sections -- provide a 32x32 source with clear corner, edge, and center regions |
| Line number gutter | 12x16 (repeating) | Slightly lighter dark strip on the left side of the terminal. The engine draws numbers |
| Cursor blink | 2x10 | Simple bright cyan or amber rectangle. 2 frames: visible and invisible |
| Syntax highlight colors | -- | Not a sprite -- just confirm these colors exist in the palette: keyword (orange), string (green), number (cyan), comment (dim grey), error underline (red) |

**Total: 3 assets + palette confirmation**

##### Circuit Builder Frame

| Element | Size | Notes |
|---|---|---|
| Breadboard background | 320x192 (full editor, or 9-slice for flexible sizing) | Light tan/cream grid with holes at regular intervals (every 2px). Looks like a real breadboard. Power rails (red/blue lines) at top and bottom. Grid lines every 16px for snapping guides |
| Component socket highlight | 16x16 | Green glow overlay for valid placement, red for invalid |

**Total: 2 assets (breadboard can be 9-slice)**

##### Dialog Box

| Element | Size | Notes |
|---|---|---|
| Dialog background (9-slice) | 48x32 | Dark semi-transparent fill, warm border. Fits at bottom of 320x180 screen. Engine stretches to full width |
| Portrait frame | 36x36 | Border frame that holds a character portrait. Warm metallic border with subtle bolts/rivets (sci-fi functional) |
| Name tag background | 48x10 | Small dark pill above the dialog box for the speaker's name |
| Dialog advance indicator | 6x6 | Small bouncing down-arrow or blinking cursor to indicate "press to continue". 2 frames |

**Total: 4 assets**

##### Minimap Frame

| Element | Size | Notes |
|---|---|---|
| Minimap border | 52x52 | Circular or rounded-square border. Warm metal look. Holds a 48x48 minimap area inside. The engine renders the minimap contents |
| Player dot | 3x3 | Bright cyan dot (Kade's visor color) for player position on minimap |
| Robot dot | 2x2 | Orange dot for robot positions |
| POI marker | 3x3 | Small diamond or triangle for points of interest |

**Total: 4 assets**

**UI total: ~27 assets**

---

#### P0-E: Items and Resources (16x16 icons each)

Every item is a single 16x16 icon on a transparent background. These appear in inventory slots, crafting menus, and when dropped on the ground. They should be instantly recognizable at 16x16. Silhouette clarity is paramount -- a player must distinguish scrap_metal from iron_ore at a glance.

##### Raw Resources (21 items)

| Item Name | Visual Description |
|---|---|
| `scrap_metal` | Jagged torn metal chunk. Silver-grey with one orange rust spot |
| `copper_wire` | Small coil of wire. Warm copper-orange color. Coiled 3-4 times |
| `salt_crystal` | White translucent cubic crystal. One highlight facet. Clean geometric shape |
| `iron_ore` | Dark reddish-brown rough chunk. Angular, dense-looking |
| `silicon` | Flat dark grey wafer/chip shape. Subtle blue sheen on surface |
| `quartz_crystal` | Elongated hexagonal prism. Pale pink-white, transparent look. One bright highlight |
| `brine_solution` | Small sealed container/flask. Blue-green liquid visible inside. Cork or cap on top |
| `magnetite` | Black-dark grey stone with subtle metallic sheen. Rounded, magnetic-looking (optional: tiny particles clinging to it) |
| `biomass` | Green-brown organic lump. Fungal texture -- lumpy, slightly glowing green spots |
| `enzyme_sap` | Small vial with amber-gold viscous liquid. Thicker than brine, honey-like |
| `phosphor_spores` | Cluster of tiny turquoise-green glowing dots. Like captured fireflies in a small jar or just a floating cluster |
| `pure_silica` | Smooth, refined version of silicon. Brighter, cleaner edges. Almost glass-like |
| `thaline_crystal` | THE key resource. Distinct purple-blue crystal with internal glow. Slightly larger visual weight than other crystals. 2-3 facets visible |
| `solar_grade_glass` | Thin square pane shape. Transparent with prismatic rainbow edge highlight |
| `piezo_crystal` | Small angular crystal, darker than thaline. Subtle vibration lines (1px motion marks) |
| `rare_earth_metals` | Cluster of small metallic nuggets. Mix of silver and warm gold tones |
| `liquid_methane` | Sealed pressurized canister. Blue-white frost effect on surface. Cold look |
| `cryo_polymer` | Translucent blue-white block/sheet. Ice-like but clearly synthetic/processed |
| `superconducting_ice` | Ice crystal with visible wire-like veins running through it. Blue-white with metallic threads |
| `volcanic_glass` | Black obsidian shard. Razor-sharp edges. One red-orange ember glow at base |
| `ultra_pure_metal` | Polished ingot shape. Mirror-bright silver. The cleanest, most refined-looking item in the game |

##### Crafted Components (8 items)

| Item Name | Visual Description |
|---|---|
| `circuit_board` | Small green PCB rectangle with visible copper traces (thin orange lines). 1-2 tiny component bumps |
| `battery` | Cylindrical battery shape (like AA). Two-tone: dark body, bright terminal on top. Small lightning bolt icon or "+" symbol |
| `sensor_module` | Small square circuit with a visible lens or probe tip on one side. Blue accent |
| `motor` | Cylindrical with visible shaft poking out one end. Dark grey body, copper coil peek |
| `microcontroller` | Black IC chip shape with tiny silver pins on sides. Smaller than circuit board, more refined |
| `bio_fuel` | Green-brown canister or fuel cell. Organic-meets-industrial look. Leaf-like icon or "BF" label |
| `emp_shield` | Flat hexagonal plate. Dark grey with a faint electromagnetic wave pattern (concentric arcs) |
| `neural_core` | The most advanced component. Small glowing orb or chip with visible neural-net-like trace pattern. Purple-cyan glow |

**Item total: 29 icons**

---

#### P0-F: Effects

| Effect | Size | Frames | FPS | Notes |
|---|---|---|---|---|
| Gather sparkle | 16x16 | 4 | 12 | Small white-cyan sparkles that play when Kade or a robot picks up a resource. Sparkle outward then fade |
| Damage flash | 32x48 | 2 | 12 | Red-tinted overlay for Kade's sprite on hit. Frame 1: bright red tint. Frame 2: slightly dimmer. Played over the character sprite as a multiplicative or additive overlay |
| Visor glow | 32x32 | 1 | -- | Static additive light circle. Soft cyan radial gradient from center to edge. Used as a light source overlay around Kade during night. Transparent at edges, bright at center |
| Robot status: running | 4x4 | 1 | -- | Small green dot. Placed above robot sprite |
| Robot status: low battery | 4x4 | 2 | 8 | Small red dot, blinks. Frame 1: visible, frame 2: dim |
| Robot status: idle | 8x6 | 2 | 4 | Tiny "zzz" text or three dots that bob up and down |
| Robot status: error | 6x6 | 2 | 12 | Red exclamation mark "!" that flashes. Frame 1: bright red, frame 2: dark/off |

**Effect total: 7 effects, ~14 frames**

---

#### P0 Summary

| Category | Asset Count | Frame Count |
|---|---|---|
| Kade Maren animations | 1 character, 8 animations | 132 frames |
| Robots (8 types) | 8 robots, 6 animations each | 480 frames |
| Alkaline Flats tileset | ~36 tiles | 36 tiles + 4 animated |
| UI elements | ~27 assets | ~30 assets |
| Items / resources | 29 icons | 29 icons |
| Effects | 7 effects | ~14 frames |
| **P0 TOTAL** | **~108 unique assets** | **~721 individual files** |

---

### PRIORITY 1 -- Alpha (deliver 4-6 weeks after P0)

This covers the remaining characters, all 7 additional biomes, base structures, and circuit components. Needed for the full 60-day campaign.

---

#### P1-A: Characters (32x48 pixels each)

##### Wren (NPC -- Circuits Teacher)

**Description:** Stocky, muscular woman. Expedition 3 survivor, has been living underground for 5 years. Wearing a cut-down, shortened version of an old expedition suit in blue-grey (sleeves ripped off at elbows, legs cut to knee-length). Welding goggles pushed up onto forehead (NOT over eyes -- she uses them for close work). Heavy leather tool belt with wrenches, wire cutters, and a soldering iron holstered. A visible scar running from left cheekbone to jaw. Short-cropped dark hair, practical. Bare forearms show burn marks from soldering. Sturdy boots caked with cave mineral dust (blue-white).

**Color notes:** Blue-grey suit, dark leather belt (`#5C3C20`), skin slightly paler than Kade (less sun, lives underground), goggles brass/copper colored.

**Animations (south and east directions only -- NPC, doesn't need full 4-dir):**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| idle (tinkering) | 4 | 8 | Standing at workbench, hands moving over a circuit. Head occasionally glances up |
| talk | 4 | 8 | Mouth moves (1-2px shift in face area), hands gesture. Gruff energy |
| trade | 3 | 8 | Extends hand forward with an item. Other hand on hip |

**Total Wren frames: 2 directions x (4+4+3) = 22 frames**

##### Rootknot (Alien Organism)

**Size: 48x32 pixels** (wider than tall -- it is a sessile, rooted organism, NOT humanoid)

**Description:** A gnarled, organic mass fused into red rock. Part crystalline (thaline veins running through it), part fungal (fibrous, root-like tendrils spreading outward into the ground). NOT a creature with a face. Three thaline crystals clustered near the top serve as "eyes" -- they pulse with a soft purple-blue glow when Rootknot communicates. The body looks like a cross between a coral formation and a knotted tree root, but mineral, not plant. Color is iron-red rock with thaline purple veins and dark fungal brown roots.

**Color notes:** Iron oxide red (palette red), thaline purple-blue (palette accent), dark brown roots, grey-black rock base.

**Animations (single direction only -- it does not move):**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| idle (pulse + sway) | 4 | 4 | Thaline crystals pulse glow slowly (bright-dim-bright-dim). Root tendrils shift 1px left-right |
| talk (faster pulse) | 4 | 8 | Same as idle but crystal pulse is faster and brighter. Slight vibration in the whole mass (1px shake) |

**Total Rootknot frames: 1 direction x (4+4) = 8 frames**

##### Cass (AI Drone NPC)

**Size: 16x16 pixels**

**Description:** A small, battered military drone chassis -- boxy, angular, with dented panels and scratch marks. Originally dark olive/military grey, now faded and weatherworn. Has a small LCD screen on the front that serves as a "face" -- the screen shows ASCII expressions (`:)` when happy, `:/` when confused, `X_X` when crashing). Tiny sparks occasionally emit from a cracked panel on the right side. Hovers 2-3 pixels above the ground (small shadow beneath). Single antenna wire sticking up, bent at an angle.

**Color notes:** Dark grey-olive body, LCD screen glows pale green or amber, sparks are yellow-white.

**Animations (south and east directions only):**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| hover bob | 4 | 8 | Bobs up 1px and down 1px in a gentle sine wave. Baseline idle |
| talk | 4 | 8 | LCD screen cycles through 2-3 ASCII expressions. Antenna twitches |
| crash/reboot | 4 | 12 | Screen goes to static (random pixels), body drops 1px (loses hover), then screen boots back up with a `:)`, body rises back up |
| spin | 3 | 12 | Rotates 360 degrees (shows all 4 sides in 3 frames). Used when excited |

**Total Cass frames: 2 directions x (4+4+4+3) = 30 frames**

##### Mira (Holographic AI)

**Size: 32x48 pixels**

**Description:** A holographic projection of a woman. Translucent -- you can subtly see background through her (use palette colors at lower alpha, or dithered transparency). Entirely in shades of cyan (`#4CF0F0`) and white. Visible horizontal scan lines running through her form (1px lines every 4-6 pixels that slowly scroll upward). Minimal facial features -- suggestion of eyes and mouth, not detailed. Wearing a lab coat silhouette (coat shape, not detailed fabric). Standing on a small hexagonal pedestal base that projects her (the pedestal is physical/opaque: dark grey with cyan light ring on top).

**Color notes:** Body entirely cyan/white palette. Pedestal is dark grey physical object. Scan lines are slightly darker cyan.

**Animations (south direction only -- hologram, always faces the player):**

| Animation | Frames | FPS | Notes |
|---|---|---|---|
| idle (shimmer) | 4 | 4 | Scan lines scroll upward 1px per frame. Occasional pixel flicker (1-2 random pixels appear/disappear) |
| talk | 4 | 8 | Mouth area shifts 1px. Hands gesture (one hand rises, palm up). Scan lines continue |
| appear | 4 | 12 | Pedestal glows, then body materializes from bottom-up (line by line reveal over 4 frames) |
| disappear | 4 | 12 | Reverse of appear. Top-down dissolve, pedestal dims |
| data_display | 3 | 8 | Hands extend forward, a small holographic chart/graph appears in front of her (4x4 pixel block with lines -- suggesting data) |

**Total Mira frames: 1 direction x (4+4+4+4+3) = 19 frames**

**P1-A Character total: 79 frames**

---

#### P1-B: Tilesets -- Remaining 7 Biomes (16x16 per tile)

Each biome needs the following tile categories. I list biome-specific details for each.

**Standard per-biome set:**
- Ground tiles: 4 variants
- Walkable path: 2 variants
- Wall/obstacle tiles: 3-4 variants
- Transition edges (ground-to-wall): 8 autotile pieces
- Decorative (non-collision): 3-4 variants
- Unique biome feature: 1-2 special tiles

##### Biome 2: Brine Hollows

**Theme:** Underground cavern. Luminescent blue mineral veins. Shallow acidic pools. Stalactites.

| Category | Tiles | Description |
|---|---|---|
| Ground: cave floor | 4 | Dark grey-brown stone. Uneven texture. Occasional blue mineral fleck |
| Ground: path (worn) | 2 | Smoother stone, lighter -- Wren's foot traffic over 5 years |
| Wall: cave wall | 3 | Dark stone with blue luminescent vein running through (1-2px bright blue line per tile variant) |
| Wall: stalactite | 2 | 16x32 (1x2 tile), pointing downward from ceiling. Dark stone with blue drip at tip |
| Obstacle: acid pool | 3 | Bright yellow-green liquid tile. Slightly transparent look. Bubbles (1px dots) in variant 3 |
| Transition: floor-to-wall | 8 | Standard autotile edges |
| Transition: floor-to-acid | 4 | N, S, E, W edges where stone meets acid pool |
| Decorative: mineral clusters | 3 | Small blue-white crystal formations on ground. Non-interactive eye candy |
| Decorative: dripping water | 2 (animated, 3f each) | 1px bright blue dot that falls from ceiling to floor in 3 frames |
| Unique: Wren's workbench | 1 | 32x16 (2x1 tile), cluttered workbench with tiny circuit parts, tools, a glowing LED |

**Brine Hollows total: ~32 tiles + 6 animated frames**

##### Biome 3: Ferric Badlands

**Theme:** Rust-red iron oxide mesas. Deep canyons. Magnetic haze.

| Category | Tiles | Description |
|---|---|---|
| Ground: red earth | 4 | Rich rust-red oxidized soil. Iron flecks visible (tiny darker red dots) |
| Ground: canyon floor | 2 | Darker red-brown, shadowed. Used for the bottom of canyon paths |
| Wall: mesa cliff | 4 | Layered red-orange sedimentary rock. Horizontal stratification lines visible. Tall -- consider 16x32 for 2 variants |
| Wall: iron boulder | 2 | Dark, dense iron-rich rocks. Almost black-red with metallic highlight |
| Transition: earth-to-cliff | 8 | Standard autotile |
| Decorative: magnetic particles | 2 (animated, 2f) | Tiny dark specks that shift position between frames (floating in the magnetic field) |
| Decorative: Expedition 1 campsite debris | 3 | Old tent pole (fallen), scattered data pad (dark rectangle with dead screen), weathered flag scrap |
| Unique: thaline vein (surface) | 2 | Ground tile with visible purple vein running through the red earth. Faint glow |

**Ferric Badlands total: ~29 tiles + 4 animated frames**

##### Biome 4: Spore Marshes

**Theme:** Turquoise bioluminescent wetlands. Massive fungal trees. Mist. Alien insects.

| Category | Tiles | Description |
|---|---|---|
| Ground: marsh floor | 4 | Dark turquoise-brown mud. Wet, reflective-looking (subtle highlight pixel) |
| Ground: shallow water | 2 | Darker, translucent turquoise. 1px ripple highlights |
| Wall: fungal tree trunk | 3 | 16x32 (1x2 tile). Thick, bioluminescent trunks. Dark brown-green with turquoise glowing spots. Fibrous texture |
| Wall: fungal tree cap | 2 | 32x16 (2x1 tile). Wide mushroom caps above the trunks. Turquoise with pulsing glow spots |
| Obstacle: quickmud | 2 | Brownish marsh tile that looks subtly different from normal ground -- slightly darker, wetter. A trap for robots |
| Transition: marsh-to-water | 8 | Standard autotile edges |
| Decorative: phosphor spore cluster | 2 (animated, 3f) | Tiny turquoise-green glowing particles that drift upward |
| Decorative: alien insect | 2 (animated, 2f) | Tiny 3-4px flying dot with 1px wings. Harmless, phototropic (moves toward light sources) |
| Decorative: mist patch | 2 | Semi-transparent white-turquoise fog overlay tile |
| Unique: gas pocket vent | 1 (animated, 2f) | Small hole in ground with yellowish-green gas puff rising from it periodically |

**Spore Marshes total: ~28 tiles + 12 animated frames**

##### Biome 5: Glass Dunes

**Theme:** Translucent silica sand dunes. Prismatic light refraction. Shifting terrain.

| Category | Tiles | Description |
|---|---|---|
| Ground: glass sand | 4 | Pale amber-white sand with a glassy sheen. Tiny prismatic highlights (1px rainbow dots) in 2 variants |
| Ground: compacted glass | 2 | Darker, more solid version. Where dunes have compressed |
| Wall: glass dune crest | 3 | 16x32. Translucent sand ridges. Light passes through -- top edge has a bright highlight, body has subtle dither for translucency |
| Wall: silica formation | 2 | Crystallized glass pillars. Amber-clear with prismatic edge highlights |
| Transition: sand-to-formation | 8 | Standard autotile |
| Decorative: prismatic light ray | 2 | Diagonal 1px bright lines in rainbow palette order. Overlay tile suggesting light refraction |
| Decorative: sand ripple | 2 | Subtle wavy lines in the sand. Wind-carved patterns |
| Unique: thaline deposit | 1 | Ground tile with exposed thaline crystal cluster. Purple-blue glow in amber sand. Minable node |

**Glass Dunes total: ~26 tiles**

##### Biome 6: Resonance Peaks

**Theme:** Jagged obsidian mountains. Glowing thaline veins. Electromagnetic arcs.

| Category | Tiles | Description |
|---|---|---|
| Ground: obsidian floor | 4 | Black-dark grey glassy rock. Sharp edges. Reflective highlights (1px bright spots) |
| Ground: thaline-veined ground | 2 | Black obsidian with visible purple-blue glowing veins running through (2-3px bright lines) |
| Wall: obsidian cliff | 3 | 16x32. Jagged, angular black rock formations. Sharp, geometric, crystalline fracture patterns |
| Wall: thaline pillar | 2 | 16x32. Tall crystalline formations, mostly thaline. Bright purple-blue glow, pulsing |
| Transition: obsidian-to-cliff | 8 | Standard autotile |
| Decorative: lightning arc | 2 (animated, 3f each) | Bright white-cyan electrical arc between two points. Zigzag pattern. Appears and disappears over 3 frames |
| Decorative: thaline dust | 2 | Tiny purple glowing particles floating near ground |
| Unique: Dr. Venn's data core | 1 | 16x16. Small technological artifact half-buried in obsidian. Dark metal with one cyan light (Mira's home) |
| Unique: Deep Signal Array base | 2 | 32x32 (2x2 tiles). Large metal platform with antenna mounting points. Endgame structure location |

**Resonance Peaks total: ~28 tiles + 6 animated frames**

##### Biome 7: Polar Sink

**Theme:** Frozen methane lake. Ice cliffs. Aurora effects. Permanent twilight.

| Category | Tiles | Description |
|---|---|---|
| Ground: frozen methane | 4 | Pale blue-white ice surface. Semi-translucent look. Crack lines in 2 variants |
| Ground: safe ice (thicker) | 2 | Whiter, more opaque. Visually distinct from thin ice (player safety cue) |
| Ground: thin ice (dangerous) | 2 | More translucent, darker -- you can "see" dark water beneath. Subtle visual warning |
| Wall: ice cliff | 3 | 16x32. Blue-white ice walls. Layered horizontal ice strata. Icicles at base |
| Wall: ice boulder | 2 | Rounded ice rocks. Pale blue with white highlights |
| Transition: ice-to-cliff | 8 | Standard autotile |
| Decorative: aurora glow | 2 (animated, 4f each) | Overlay tile with green-cyan-purple shifting light bands. Very subtle, atmospheric |
| Decorative: methane geyser | 1 (animated, 3f) | Small vent in ice that periodically shoots a white-blue gas plume upward |
| Decorative: frost pattern | 2 | Delicate crystalline frost overlay patterns on ice tiles |
| Unique: frozen ship hull | 2 | 32x32. Expedition 2's ship visible through ice. Dark shadow shape beneath translucent surface. Eerie |

**Polar Sink total: ~30 tiles + 11 animated frames**

##### Biome 8: Magma Veins

**Theme:** Subterranean lava tube network. Molten rivers. Black basalt. Cathedral-like alien architecture.

| Category | Tiles | Description |
|---|---|---|
| Ground: basalt floor | 4 | Black-dark grey hexagonal/columnar basalt pattern. Warm red ambient light reflection on edges |
| Ground: cooled lava | 2 | Darker than basalt, rougher texture. Rope-like pahoehoe lava patterns |
| Liquid: magma/lava | 3 (animated, 3f each) | Bright red-orange-yellow molten rock. Flowing animation -- bright spots shift position. NOT walkable |
| Wall: basalt column | 3 | 16x32. Tall hexagonal basalt pillars. Black with warm red light on one side (lava illumination) |
| Wall: lava tube wall | 2 | Curved cave wall. Dark with reddish ambient glow from nearby lava |
| Transition: basalt-to-lava | 8 | Autotile edges. Basalt crumbles into molten rock at edges |
| Decorative: heat shimmer | 2 (animated, 2f) | Wavy transparent overlay suggesting heat distortion rising from hot surfaces |
| Decorative: ember particles | 2 (animated, 2f) | Tiny red-orange dots floating upward |
| Unique: geothermal vent | 1 | Active volcanic vent. Steam/lava glow. Where geothermal tap structure connects |
| Unique: magma-refined metal deposit | 1 | Bright metallic vein in basalt wall. Ultra-pure metal source. Mirror-bright highlight |

**Magma Veins total: ~30 tiles + 13 animated frames**

**P1-B Tileset total: ~203 tiles + ~52 animated frames**

---

#### P1-C: Base Building Structures (16x16 or 16x32 per structure)

Each structure needs TWO states:
1. **Built** -- fully constructed, operational appearance
2. **Ghost/Blueprint** -- semi-transparent or wireframe version shown during placement preview. Use the built sprite at ~50% opacity or a cyan-tinted wireframe outline

All structures snap to the 16x16 grid. Most are 1x1 tile (16x16). Larger ones noted.

| # | Structure | Size | Built Description | Notes |
|---|---|---|---|---|
| 1 | Shelter | 32x32 (2x2) | Makeshift hab from ship hull panels. Orange-grey metal walls, small window with warm interior glow. Door on south face | Player's home base. Should look cobbled-together but cozy |
| 2 | Salvage Bench | 16x16 | Flat workbench surface with scattered scrap, a small vice, and a hand tool | T1 crafting station |
| 3 | Solar Panel | 16x16 | Flat dark blue panel angled toward top-left (light source). Thin metal frame. Silver mounting bracket | Tilted at ~30 degrees, catching light |
| 4 | Battery Bank | 16x16 | Stack of 2-3 cylindrical batteries in a metal rack. LED status light on top (green = charged, red = low) | Provide 2 variants: charged (green dot) and depleted (red dot) |
| 5 | O2 Recycler | 16x16 | Boxy machine with visible intake vent on one side and exhaust on other. Blue accent pipe. Subtle hum (animated 2f: vent flap open/closed) | Critical life support |
| 6 | Refinery | 16x32 (1x2) | Tall industrial unit. Intake hopper on top, output chute at bottom. Pipe connections. Steam vent | Processes raw materials |
| 7 | Engineering Table | 16x16 | Cleaner than Salvage Bench. Magnifying lamp arm, organized component trays, blueprint paper | T2 crafting |
| 8 | Fabricator | 16x16 | Enclosed machine with a glass window showing interior blue glow. Input slot on side. Digital display (1-2px) | T3 crafting. Sleeker, more advanced |
| 9 | Synthesis Lab | 16x32 (1x2) | Most advanced workstation. Glowing containment chamber, holographic display (cyan), bubbling fluid tubes | T4 crafting. Visually impressive |
| 10 | Charging Station | 16x16 | Platform with contact pads and a battery-shaped cradle. Cable coil. Amber charging LED | Where robots recharge |
| 11 | Storage Crate | 16x16 | Simple metal crate with visible latch. Slightly open lid showing dark interior | Basic storage |
| 12 | Wall Segment | 16x16 | Metal wall panel. Riveted edges. Should seamlessly tile with adjacent walls | Auto-connects visually. Provide: straight, corner (inner), corner (outer), T-junction, and end-cap = 5 variants |
| 13 | Door | 16x16 | Metal door in wall frame. Provide OPEN (slid to side) and CLOSED (filling frame) = 2 variants | Sealable |
| 14 | Heater | 16x16 | Small radiator unit with visible red-orange heating element. Warm glow | Provides heat |
| 15 | Cooler | 16x16 | Compact unit with visible frost/ice on surface. Blue cooling fins | Provides cold |
| 16 | Base Terminal | 16x16 | Computer terminal with a small screen showing text lines. Keyboard tray. Warm amber screen glow | Player's code editor access point |
| 17 | Radio Tower | 16x32 (1x2) | Tall antenna structure. Metal lattice tower. Blinking red light at top (animated 2f) | Extends robot control range |
| 18 | Greenhouse | 32x16 (2x1) | Glass-walled enclosure with visible green plants inside. Solar-grade glass panels. Condensation drops | Where bio-crops grow |
| 19 | Geothermal Tap | 16x32 (1x2) | Heavy drill/pipe mechanism going into the ground. Steam rising from connection point. Robust industrial look | Magma Veins only |
| 20 | Deep Signal Array | 32x48 (2x3) | THE endgame structure. Large antenna dish on a reinforced base. Thaline crystal elements. Glowing power conduits. Visible neural core housing. The most impressive structure in the game. Should look like a culmination of everything the player has built | Built + ghost state. Consider a subtle animated glow (2f) for the thaline elements |

**Structure count:** 20 structures x 2 states (built + ghost) = 40 base assets
**Plus variants:** Wall segment (5 variants x 2 states = 10), Door (2 states x 2 open/closed = 4), Battery Bank (2 charge states = 4)
**Plus animated:** O2 Recycler (2f), Radio Tower (2f), Deep Signal Array (2f)

**P1-C Structure total: ~58 assets + 6 animated frames**

---

#### P1-D: Circuit Components (8x8 icons each)

These appear on the breadboard UI. They must be instantly identifiable at 8x8 and follow standard electronics schematic conventions where possible (e.g., a resistor looks like a zigzag or striped rectangle, a capacitor has two parallel lines).

| # | Component | 8x8 Visual Description |
|---|---|---|
| 1 | Wire | Straight line segment (horizontal). Copper-orange color. 1-2px thick |
| 2 | Resistor | Small rectangle with colored stripes (classic through-hole resistor look), or zigzag line. Tan/brown body |
| 3 | LED | Tiny dome/circle shape. Provide in 3 colors: red, green, blue (3 variants) |
| 4 | Battery cell | Small vertical rectangle. Dark body, bright positive terminal on top. "+" symbol if room |
| 5 | Capacitor | Two parallel vertical lines with lead wires extending top and bottom. Blue or brown body |
| 6 | Transistor | Three-pin component. Small D-shaped or rectangular body with 3 wire legs |
| 7 | Relay | Small box with a switch symbol on it. Mechanical look. Two coil pins, two switch pins |
| 8 | Temp sensor | Small chip with a thermometer icon or "T" label. Red accent |
| 9 | Gas sensor | Small chip with a vent/grid icon. Yellow accent |
| 10 | Pressure sensor | Small chip with a gauge/dial icon. Blue accent |
| 11 | Servo motor | Small cylinder with a protruding arm/horn on top. Grey body |
| 12 | Oscillator | Small rectangular can (like a real crystal oscillator). Silver metal body with 2 pins |
| 13 | Voltage regulator | Three-pin IC package. Black body with heatsink tab. "REG" label if room |
| 14 | Microcontroller | Larger chip (might fill 7x7 of the 8x8). Black body with tiny pin dots on sides. Small dot on pin 1 |
| 15 | NAND gate | Standard logic gate shape (curved front, flat back, 2 inputs, 1 output with bubble). Simplified to 8x8 |
| 16 | Op-amp | Triangle shape pointing right with +/- inputs and one output. Standard schematic look |
| 17 | Piezo transducer | Small circular disc with 2 wire leads. Gold/brass colored |

**P1-D Circuit total: 19 icons (17 components + 3 LED color variants - 1)**

---

#### P1 Summary

| Category | Asset Count | Frame Count |
|---|---|---|
| NPC characters (4) | 4 characters | 79 frames |
| Tilesets (7 biomes) | ~203 tiles | ~203 tiles + ~52 animated |
| Base structures (20) | ~58 assets | ~58 assets + 6 animated |
| Circuit components (17) | 19 icons | 19 icons |
| **P1 TOTAL** | **~284 unique assets** | **~417 individual files** |

---

### PRIORITY 2 -- Polish (deliver before launch, timeline flexible)

#### P2-A: Kade Suit Degradation Variants

Three versions of the full Kade sprite set reflecting wear over time. Only the idle and walk animations need degradation variants -- the engine will use the appropriate base sprite and the wear is mostly about the static appearance.

| Variant | In-Game Trigger | Visual Changes |
|---|---|---|
| Day 1 (clean) | Days 1-15 | THIS IS THE DEFAULT (already done in P0). Clean-ish suit, minimal wear |
| Day 30 (scuffed) | Days 16-40 | Suit color slightly darker/dirtier. Additional scuffs (dark pixels on knees, elbows). Helmet has a crack (1px dark line). Backpack strap frayed. Tool belt has more items |
| Day 50 (patched) | Days 41-60 | Visible patches on suit (different-colored 2x3px rectangles on chest and leg). Helmet crack patched with tape (lighter pixel strip over the crack). Boots worn down. Belt is fully loaded. Looks like a veteran survivor |

**Only need idle (4f) and walk south (6f) per variant = 10 frames x 2 new variants = 20 frames**

#### P2-B: Weather Effects

All weather effects are overlay particles or screen effects, NOT tied to specific sprites.

| Effect | Size | Frames | FPS | Description |
|---|---|---|---|---|
| Dust storm particles | 8x8 (tiled across screen) | 4 | 12 | Brown-orange particle streaks moving right-to-left. Semi-transparent. Layer multiple for density |
| Toxic fog | 16x16 (tiled) | 3 | 4 | Slow-moving green-yellow semi-transparent cloud patches. Drifting, not blowing |
| EMP lightning | Screen-width overlay | 3 | 12 | Bright white-cyan flash frame, then jagged lightning bolt (2-3px wide zigzag across top portion of screen), then afterglow/fade |
| Snow/ice particles | 8x8 (tiled) | 4 | 8 | White dots falling downward. Vary size (1px and 2px mix). Slower than dust storm |
| Lava ambient glow | Screen overlay | 2 | 4 | Warm red-orange tint overlay that subtly pulses. Very subtle -- just shifts the overall color temperature |
| Rain | 8x8 (tiled) | 3 | 12 | Diagonal thin blue lines falling. For Spore Marshes. Can overlap with fog |

**P2-B total: 6 effects, ~19 frames**

#### P2-C: Title Screen Art

| Asset | Size | Description |
|---|---|---|
| Title screen background | 320x180 | Full-viewport pixel art scene. Kade sitting on the Haldane's cracked hull, looking at the burnt-orange sky. The Alkaline Flats stretch behind. A few robots (Scuttle, Ohm) are working in the mid-ground. A faint purple thaline glow on the distant peaks. Terminal text floating near Kade's hand. Warm, hopeful, slightly melancholy. This is the first thing players see -- it must sell the tone |
| Title logo | 160x40 | "ASTROCODE" in pixel art lettering. Warm colors (orange, white, cyan accents). The "O" in CODE could be a visor/helmet motif. Clean, readable, memorable |
| Menu selector | 8x8 | Small animated cursor for menu navigation. Cyan glow, 2-frame blink |

**P2-C total: 3 assets**

#### P2-D: Steam Store Assets

These follow Steam's required dimensions. They are NOT pixel art at native resolution -- they should be the pixel art style upscaled and composited at the required resolution with clean integer scaling and no filtering.

| Asset | Size (px) | Description |
|---|---|---|
| Header capsule | 460x215 | Game logo + Kade + one robot + alien landscape. Must be readable at small sizes on Steam storefront |
| Small capsule | 231x87 | Simplified: logo + Kade silhouette. Must pop against Steam's dark background |
| Library hero | 3840x1240 | Wide banner. Full biome panorama left-to-right: Alkaline Flats transitioning through biomes to Resonance Peaks. Kade and robots at center. Can be a scaled-up pixel art composition |
| Library logo | 600x900 | Vertical logo + key art. Kade in a heroic engineer pose (holding a circuit board, not a weapon) |

**P2-D total: 4 assets**

#### P2-E: Achievement Icons (if applicable)

If we ship with Steam achievements, each needs a 64x64 icon (pixel art upscaled from a 16x16 or 32x32 source). Estimated 15-20 achievements. Content TBD -- we will provide a list of achievement names and descriptions when ready.

**P2-E total: ~15-20 icons (deferred)**

#### P2 Summary

| Category | Asset Count |
|---|---|
| Kade degradation variants | 20 frames |
| Weather effects | 6 effects, ~19 frames |
| Title screen | 3 assets |
| Steam capsule images | 4 assets |
| Achievement icons | ~15-20 icons (deferred) |
| **P2 TOTAL** | **~50-55 assets** |

---

### Grand Total (All Priorities)

| Priority | Unique Assets | Individual Files (approx.) |
|---|---|---|
| P0 (Prototype) | ~108 | ~721 |
| P1 (Alpha) | ~284 | ~417 |
| P2 (Polish) | ~50-55 | ~100 |
| **GRAND TOTAL** | **~447** | **~1,238 files** |

---

## 4. Style Guide

### Anchor Reference: Kade Maren

All art in the game must look like it belongs in the same world as Kade. Kade's existing sprites establish:
- **Proportions:** Roughly 1:2 head-to-body ratio. Not chibi (no oversized head). Grounded, realistic proportions scaled down to pixel art
- **Detail density:** Medium. Enough detail to convey personality (tool belt, knee pad, visor) but not so much that the sprite is noisy at 320x180
- **Color usage:** 8 colors for a single character. Rich, warm. No pure black outlines; instead uses the darkest palette value (`#282828`) sparingly

### Outlines

**NO black outlines.** Characters and objects are defined by color contrast against the background, not drawn outlines. If edge definition is needed, use a 1px border in the darkest shade of the object's own color (e.g., Kade's suit edge is `#A85520`, not `#000000`). This is the Hyper Light Drifter approach.

Be consistent: if you use a self-colored dark border on one character, use it on all characters. If a robot type reads better without any border (relying on background contrast), that is acceptable too, but keep the robot roster consistent.

### Dithering

**Minimal.** Dithering is only acceptable for:
- Gradients on large surfaces (dune tiles, lava glow, sky backgrounds)
- Translucency effects (Mira's hologram, ghost/blueprint structures, fog overlays)

Do NOT dither character sprites, robot sprites, UI elements, or item icons. At 16x16 and 32x48, dithering creates visual noise that reduces readability.

### Sub-Pixel Animation

**YES -- use it.** Sub-pixel animation is when a 1px element shifts by less than a full pixel between frames, creating the illusion of smoother motion. Use this technique for:
- Walk cycles (foot placement)
- Hair movement (Kade's hair bounce)
- Hover effects (Cass, Pip)
- Scan lines (Mira)

This is a hallmark of high-quality pixel art animation (reference: Celeste's character movement).

### Light Source

**Top-left, consistent across ALL assets.** Every sprite, tile, structure, and icon is lit from the top-left. This means:
- Highlights on the top and left edges of objects
- Shadows on the bottom and right edges
- Ground shadows cast toward the bottom-right

The top-left convention applies universally -- never change light direction for a specific biome. Biome-specific lighting (lava glow, bioluminescence) is expressed as fill light / ambient color shifts, NOT as directional light source changes.

### Shadows

- **Characters and robots:** 1px drop shadow directly beneath, cast slightly to the bottom-right (top-left light source). Shadow color is 30-40% darker than the ground they stand on. The shadow is rendered as part of the sprite (NOT a separate asset)
- **Structures:** 1-2px shadow on the ground to the right and below the structure
- **Items on ground:** No shadow (too small -- would be noise)
- **Hovering entities (Cass, Pip):** Small 2-3px oval shadow on the ground beneath them, separate from the sprite (shows the hover gap)

### Color Rules

1. **Never use pure black (#000000)** except in the absolute darkest shadow inside a cave or a powered-off screen. The darkest general value is `#282828`
2. **Never use pure white (#FFFFFF).** The lightest value is `#E8E8E0` or slightly warm-shifted
3. **Warm bias overall.** Even cold biomes (Polar Sink) should have a faint warm undertone in their shadows -- not clinical blue. The game's tone is warm
4. **Saturation discipline.** Colors are rich but NOT neon. Saturated accents (visor cyan, thaline purple, lava orange) are reserved for glowing/emissive elements. Base material colors (stone, metal, cloth) should be slightly desaturated earth tones
5. **Glowing elements** (visor, thaline, lava, LEDs, holograms) are the ONLY elements allowed to use the brightest, most saturated palette values. This creates visual hierarchy -- glowing things pop; everything else is grounded

### Character Design Principles

- **Silhouette test:** Every character and robot must be instantly recognizable from silhouette alone at 16x16 or 32x48. If two robots look the same in solid black, one needs a redesign
- **Personality through posture:** Since expressions are 2-3 pixels, personality comes from body shape and movement. Scuttle is low and scurrying (nervous energy). Mule is tall and slow (patient strength). Kade stands with slightly bent knees (ready, alert, not military-stiff)
- **No symmetry for worn items:** Kade has ONE knee pad. Atlas has a chest core off-center. Wren has a scar on ONE cheek. Asymmetry = character

---

## 5. Delivery Format

### File Organization

Deliver all assets in the following folder structure:

```
delivery/
  characters/
    kade/
      char_kade_south_idle_01.png
      char_kade_south_idle_02.png
      ...
    wren/
      char_wren_south_idle_01.png
      ...
    rootknot/
      char_rootknot_south_idle_01.png
      ...
    cass/
      char_cass_south_hover_01.png
      ...
    mira/
      char_mira_south_idle_01.png
      ...
  robots/
    scuttle/
      robot_scuttle_south_idle_01.png
      ...
    ohm/
    welder/
    plow/
    drift/
    mule/
    pip/
    atlas/
  tilesets/
    alkaline_flats/
      tile_alkaline_ground_v1.png
      ...
    brine_hollows/
    ferric_badlands/
    spore_marshes/
    glass_dunes/
    resonance_peaks/
    polar_sink/
    magma_veins/
  ui/
    bars/
    inventory/
    buttons/
    code_editor/
    circuit_builder/
    dialog/
    minimap/
  items/
    item_scrap_metal.png
    item_copper_wire.png
    ...
  effects/
    fx_gather_sparkle_01.png
    ...
  structures/
    struct_shelter_built.png
    struct_shelter_ghost.png
    ...
  circuits/
    circuit_wire.png
    circuit_resistor.png
    ...
  palette/
    astrocode_palette_32.png   (32x1 swatch)
    astrocode_palette_32.ase   (Adobe Swatch Exchange, optional)
```

### Delivery Schedule

| Batch | Contents | Delivery Target |
|---|---|---|
| Batch 1 | P0 complete (Kade, all 8 robots, Alkaline Flats tileset, UI, items, effects) + 32-color palette | Week 3 |
| Batch 2 | P1-A (4 NPC characters) + P1-B first 3 biomes (Brine Hollows, Ferric Badlands, Spore Marshes) | Week 7 |
| Batch 3 | P1-B remaining 4 biomes + P1-C (base structures) + P1-D (circuit components) | Week 10 |
| Batch 4 | P2 complete (degradation variants, weather effects, title screen, Steam assets) | Week 14 |

### Revision Policy

- **2 revision rounds per batch** included in the quoted price
- A "revision" is defined as adjustments to existing delivered assets (color tweaks, animation timing, proportion changes), NOT new assets
- Revisions must be requested within 5 business days of batch delivery
- Major redesigns (changing a character's fundamental appearance after approval) count as new work and will be scoped separately

### Communication

- Weekly progress check-in (screenshot of WIP, 5-minute async update)
- Use the naming convention from the start -- do not deliver with temporary names to be renamed later
- If you are unsure about any design detail, refer to this document first. If the answer is not here, ask before drawing

---

## 6. Budget Guidance

### Asset Count Recap

| Category | Count |
|---|---|
| Character animation frames (Kade + 4 NPCs) | ~211 frames |
| Robot animation frames (8 types) | ~480 frames |
| Tileset tiles (8 biomes) | ~239 tiles |
| Animated tile frames | ~58 frames |
| UI elements | ~27 assets |
| Item/resource icons | 29 icons |
| Effects | ~33 frames |
| Base structures (built + ghost) | ~58 assets |
| Circuit component icons | 19 icons |
| Degradation variants | 20 frames |
| Weather effects | ~19 frames |
| Title screen + logo | 3 assets |
| Steam capsule images | 4 assets |
| **GRAND TOTAL** | **~1,200 individual deliverables** |

### Typical Pixel Art Rates (2025-2026 market research)

| Artist Tier | Per-Frame Rate (character anim) | Per-Tile Rate (tileset) | Per-Icon Rate |
|---|---|---|---|
| Junior (portfolio < 2 years) | $2-5 | $3-8 | $3-5 |
| Mid-level (solid portfolio, game shipped) | $5-12 | $8-15 | $5-10 |
| Senior (professional, multiple shipped titles) | $12-25 | $15-30 | $10-20 |

**Note:** Rates vary significantly by region and experience. These ranges reflect Fiverr/Upwork market rates for pixel art specifically (not general illustration). Batch pricing and ongoing relationship typically yield 15-25% savings vs. per-asset pricing.

### Suggested Budget Range

| Scenario | Estimated Total | Notes |
|---|---|---|
| Budget-friendly (skilled junior artist) | $3,500 - $6,000 | Higher revision risk. May need more art direction |
| Recommended (mid-level artist) | $6,000 - $12,000 | Best value. Experienced enough to interpret briefs independently |
| Premium (senior specialist) | $12,000 - $20,000 | Lowest revision risk. May contribute to art direction |

### Recommended Payment Structure

| Milestone | % of Total | Trigger |
|---|---|---|
| Deposit (project start) | 20% | Contract signed, work begins |
| Batch 1 delivered and approved (P0) | 30% | P0 assets accepted after revisions |
| Batch 2 delivered and approved | 20% | NPC characters + first 3 biomes accepted |
| Batch 3 delivered and approved | 20% | Remaining biomes + structures + circuits accepted |
| Batch 4 delivered and approved (final) | 10% | Polish assets + Steam capsules accepted. Project complete |

**Escrow recommended.** Use the platform's built-in escrow/milestone system (Fiverr milestones or Upwork fixed-price milestones). No upfront payment outside escrow.

---

## 7. Reference Image Board

Below are specific visual references. Do NOT copy these games' art. Study the specific quality listed for each reference.

### Reference 1: Stardew Valley -- Character Proportions and Tile Density

**What to study:** Look at how Stardew Valley's characters (farmer, NPCs) fit within the tile grid. They are roughly 1 tile wide and 1.5-2 tiles tall. Body proportions are readable (you can see the hat, shirt, pants as distinct zones). Tool belt items are 1-2 pixels but convey function. Farm tiles are dense but not cluttered -- each tile has 4-6 pixels of meaningful detail, not 16x16 of noise.

**Screenshot keywords to search:** "Stardew Valley character sprites" and "Stardew Valley farm screenshot"

### Reference 2: Hyper Light Drifter -- Palette Richness and Environmental Color

**What to study:** HLD uses a limited palette with extraordinary range. Its ruins biome uses 6-7 colors but every tile feels rich because of careful value distribution (lights, mids, darks all covered). Its characters have NO outlines -- they are defined by color contrast against the background. The game's palette shifts dramatically per biome (teal forests, pink crystal caves, red lava wastelands) while maintaining a unified "feel." THIS is our color target.

**Screenshot keywords to search:** "Hyper Light Drifter ruins," "Hyper Light Drifter east biome palette," "Hyper Light Drifter character sprites"

### Reference 3: Celeste -- Sub-Pixel Animation and Pixel Clarity

**What to study:** Celeste's character animation is among the best in pixel art games. Madeline's walk cycle uses sub-pixel rendering -- her hair shifts by half-pixels between frames, creating silky-smooth motion at very low resolution. Each frame of animation is clean (no muddy dithering in the character). Items, collectibles, and effects use simple shapes with 1-2 highlight pixels that make them pop.

**Screenshot keywords to search:** "Celeste Madeline sprite animation frames" and "Celeste strawberry collectible pixel art"

### Reference 4: Eastward -- World Detail and NPC Character Design

**What to study:** Eastward's pixel art NPCs have incredible personality in 32-pixel-tall sprites. Each NPC has a distinct silhouette, a unique color pair (one primary, one accent), and personality conveyed through posture alone. Its interiors are dense with environmental storytelling -- every surface has objects that tell a story. Our base structures and Wren's workshop should aim for this level of narrative detail in tile-sized spaces.

**Screenshot keywords to search:** "Eastward NPC sprites" and "Eastward interior pixel art"

### Reference 5: Cassette Beasts -- Monster/Creature Design in Pixel Art

**What to study:** Cassette Beasts designs non-humanoid creatures at pixel scale with remarkable visual clarity. Each creature has a strong color scheme (2-3 colors max) and a unique silhouette. Rootknot (our alien organism) and our robots should have this same instant-readability -- you know what they are from shape alone. Study how Cassette Beasts gives creatures "weight" (heavy = wide+low, fast = narrow+tall).

**Screenshot keywords to search:** "Cassette Beasts monster sprites" and "Cassette Beasts battle pixel art"

### Reference 6: Noita -- Particle Effects and Environmental FX in Pixel Art

**What to study:** Noita's particle systems (fire, water, explosions, dust) show how effective 1-2 pixel particles are when animated with physics-based movement. Our weather effects (dust storms, snow, embers, spore clouds) should study Noita's approach: many tiny particles, each only 1-2px, moving in naturalistic patterns. The key is the MOVEMENT pattern, not the individual particle detail.

**Screenshot keywords to search:** "Noita fire pixel art" and "Noita environmental effects"

### Reference 7: Astroneer -- Alien Planet Color Palette Variety

**What to study:** While NOT pixel art, Astroneer's biome color design shows how to make 7+ alien biomes feel distinct yet unified. Each planet has a strong dominant color (red, teal, purple, yellow) with complementary accents. The atmosphere tints everything. Study the COLOR RELATIONSHIPS between biomes, not the rendering style. Our 8 biomes need this same bold differentiation.

**Screenshot keywords to search:** "Astroneer all planets comparison" and "Astroneer biome color palette"

### Reference 8: The Farmer Was Replaced -- In-Game Code Terminal UI

**What to study:** This is the closest comparison to our code editor. Study how The Farmer Was Replaced frames its terminal (dark background, monospace text, border style). Note how it balances game viewport + code editor on screen simultaneously without either feeling cramped. Our code editor and circuit builder UI frames should be at LEAST this clean and readable.

**Screenshot keywords to search:** "The Farmer Was Replaced code editor screenshot" and "The Farmer Was Replaced gameplay terminal"

---

## Appendix A: Full Color Palette

The final 32-color palette will be co-developed with the artist. Below is the starting point -- the 8 locked Kade colors plus 16 proposed additions. The artist may adjust the proposed colors and add the remaining 8 to reach 32, subject to art director approval.

### Locked (8 colors)

| # | Name | Hex | Primary Use |
|---|---|---|---|
| 1 | Suit orange | `#D4742C` | Kade suit, warm accents |
| 2 | Suit shadow | `#A85520` | Warm dark, wood, leather shadow |
| 3 | Helmet white | `#E8E8E0` | Light metals, clean surfaces |
| 4 | Visor cyan | `#4CF0F0` | Glow, holograms, UI highlights |
| 5 | Skin tone | `#C08860` | Skin, warm natural surfaces |
| 6 | Hair black | `#282828` | Deepest shadow, dark value |
| 7 | Gloves grey | `#484848` | Dark machinery, heavy equipment |
| 8 | Belt brown | `#5C3C20` | Leather, wood, dark organic |

### Proposed (16 colors -- subject to refinement)

| # | Name | Proposed Hex | Primary Use |
|---|---|---|---|
| 9 | Salt white | `#D8D0C8` | Alkaline Flats ground |
| 10 | Cave blue | `#3868A8` | Brine Hollows veins, water |
| 11 | Biolume cyan | `#40C8B0` | Spore Marshes glow, life |
| 12 | Iron red | `#A83020` | Ferric Badlands, rust |
| 13 | Magma orange | `#E85820` | Lava, fire, hot surfaces |
| 14 | Magma gold | `#F0A830` | Lava highlight, warm glow |
| 15 | Thaline purple | `#8048C0` | Thaline crystals, Resonance |
| 16 | Ice blue | `#88C8E8` | Polar Sink, frost, cold |
| 17 | Grass green | `#48A048` | Plow, plants, hunger bar, bio |
| 18 | Glass amber | `#C8A868` | Glass Dunes, sand |
| 19 | HP red | `#D03030` | Health bar, danger indicators |
| 20 | Energy yellow | `#E8C840` | Energy bar, power, Pip, LEDs |
| 21 | O2 blue | `#4088D0` | Oxygen bar |
| 22 | Dark earth | `#383020` | Deep shadow ground, cave floor |
| 23 | Mid grey | `#787070` | Metal, machinery, neutral surfaces |
| 24 | Warm highlight | `#F0E0B0` | Top-light highlight on surfaces |

### Remaining (8 slots reserved for artist)

Slots 25-32 are reserved for the artist to fill based on production needs. These might include: additional biome accent colors, intermediate shadow values, special effect colors (aurora, EMP lightning), or UI state colors (disabled grey, selected border).

---

## Appendix B: Kade Maren Reference Description

This is the full character description used to generate the existing Kade sprite. All new art must be consistent with this description.

> **Kade Maren** -- 16-bit top-down pixel art character sprite, 32x48 pixels, chibi proportions (1:2 head-to-body ratio), Stardew Valley style.
>
> Southeast Asian male astronaut, 28 years old. Medium-brown skin. Messy black hair, medium length, pushed to one side, sticking out from under helmet.
>
> White open-face half-helmet (climbing helmet style, not full bubble), scuffed and scratched. Small rectangular cyan-glowing flip-up visor above eyes. Tiny yellow headlamp on right side.
>
> Burnt orange work jumpsuit -- NOT sleek sci-fi, more like a mechanic's coveralls. Small white mission patch on chest (2x2px). Faded red-white flag patch on left shoulder. Visible scuffs and one patched tear on left knee. Dark grey collar ring where helmet meets suit.
>
> Dark brown tool belt with small multi-tool on right hip and wire spool on left hip. Chunky dark grey work gloves, slightly oversized. Heavy dark grey flat-sole boots, slightly oversized, giving a grounded planted stance. Single grey knee pad on left knee only (asymmetric).
>
> Small dark grey rectangular backpack with orange strap, visible from side and back views.
>
> No weapons -- never holds weapons. Holds tools, wires, terminals. He is an engineer, not a soldier.
>
> Visor always glows cyan -- acts as player beacon in darkness.
>
> Color palette: suit `#D4742C`, suit shadow `#A85520`, helmet `#E8E8E0`, visor `#4CF0F0`, skin `#C08860`, hair `#282828`, gloves/boots `#484848`, belt `#5C3C20`.
>
> Style reference: Stardew Valley character proportions with Hyper Light Drifter color richness. Warm, grounded, worn -- this person has been surviving, not posing.

---

## End of Brief

This document is the single source of truth for all pixel art production on AstroCode. If a specification is not covered here, ask the art director before beginning work. Do not improvise on sizes, frame counts, or naming conventions.

We are looking for a long-term creative partner, not a one-off order. If the prototype batch goes well, this becomes a 14-week engagement with potential expansion into DLC content and Steam marketing assets beyond what is scoped here.

Good luck, and welcome to Thyra-7.

-- Art Director, AstroCode
