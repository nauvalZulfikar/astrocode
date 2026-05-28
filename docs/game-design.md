# AstroCode — Game Systems Design

**Version:** 0.1 | **Date:** 2026-05-25

---

## 1. Player Stats & Attributes

| Stat | Max | Depletion Rate | Recovery Method | Critical Threshold |
|---|---|---|---|---|
| Health | 100 HP | Damage events only (falls, heat, toxic gas: 5-25 HP per hit) | Med-kit (+40 HP), bio-salve (+15 HP), passive regen 1 HP/min above 50% food | 20 HP — screen pulses red, movement -30% |
| Oxygen | 100 units | -1/min outdoors (breathable atmo), -3/min in toxic biomes, -0/min inside sealed base | O2 recycler (auto at base), O2 canister (+30), electrolyzer circuit (+2/min when powered) | 15 units — SABLE alarm, 30s to death at 0 |
| Energy | 100 EP | -1 EP per manual action (gather, build, repair). Walking free. Running -1 EP/15s | Sleep (+80 EP), cooked meal (+25 EP), stimulant (+15 EP, -10 max HP until sleep) | 10 EP — cannot sprint, gather speed halved |
| Hunger | 100 satiety | -1/7 min (1 real minute = 1 in-game hour, see Section 7) | Raw biomass (+10), cooked meal (+35), bio-ration (+20) | 0 — energy drains 3x faster, HP -1/min |
| Temperature | Comfort zone 5-50C | Biome-dependent. Below 0C: frostbite 3 HP/min. Above 60C: heatstroke 5 HP/min | Thermal suit (extends range to -40C/80C), base heating/cooling circuits, campfire (+20C radius 3 tiles) | Outside comfort = warning. Extreme = damage |

**No XP system.** Progression is gated by crafted items, unlocked recipes, completed quests, and biome access. You don't level up — you build up.

---

## 2. Resource Economy

| Resource | Source Biome | Gather Method | Crafting Uses | Rarity | Stack |
|---|---|---|---|---|---|
| Scrap Metal | Alkaline Flats | Salvage wreckage (hand/Scuttle) | Chassis, structures, tools | Common | 50 |
| Copper Wire | Alkaline Flats, Brine Hollows | Salvage / mine copper ore | All circuits, wiring | Common | 99 |
| Salt Crystal | Alkaline Flats | Surface gather | Insulation, electrolyte, batteries | Common | 40 |
| Iron Ore | Ferric Badlands | Mine (hand/Scuttle) | Structural beams, heavy chassis, tools | Common | 40 |
| Silicon | Ferric Badlands, Glass Dunes | Mine / refine sand | Chips, circuit boards, solar cells | Uncommon | 30 |
| Quartz Crystal | Brine Hollows | Mine vein nodes | Oscillators, precision sensors | Uncommon | 20 |
| Brine Solution | Brine Hollows | Collect from pools (sealed container) | Batteries, electrolysis | Common | 20 |
| Magnetite | Ferric Badlands | Mine (requires Scuttle) | Motors, electromagnetic shields | Uncommon | 25 |
| Biomass | Spore Marshes | Harvest fungal growths (hand/Plow) | Bio-fuel, meals, bio-salve | Common | 40 |
| Enzyme Sap | Spore Marshes | Tap fungal trees (Plow) | Catalyst for batteries, bio-fuel refining | Uncommon | 15 |
| Phosphor Spores | Spore Marshes | Collect during spore bloom | Organic LEDs, signal flares | Uncommon | 20 |
| Pure Silica | Glass Dunes | Refine sand (workbench T2) | Advanced chips, solar-grade glass | Rare | 15 |
| Thaline Crystal | Glass Dunes, Resonance Peaks | Mine thaline veins (Scuttle/Atlas) | Antenna, Deep Signal Array, piezo sensors | Rare | 10 |
| Solar-Grade Glass | Glass Dunes | Refine pure silica (workbench T3) | Solar panels, sensor lenses | Rare | 10 |
| Piezoelectric Crystal | Resonance Peaks | Mine peak nodes (EMP-hardened robot) | Advanced sensors, resonance modulators | Rare | 8 |
| Rare-Earth Metals | Resonance Peaks | Mine deep veins (Scuttle) | Superconductors, advanced circuits | Rare | 10 |
| Liquid Methane | Polar Sink | Pump from methane pools (sealed Mule) | Coolant, rocket fuel, cryo-polymer input | Rare | 10 |
| Cryo-Polymer | Polar Sink | Refine methane + enzyme sap (workbench T3) | Thermal-hardened chassis, insulation | Rare | 8 |
| Superconducting Ice | Polar Sink | Harvest ice shelves (thermal-hardened robot) | Superconducting wire, Array components | Epic | 5 |
| Volcanic Glass | Magma Veins | Mine basalt walls (heat-resistant robot) | Heat shielding, advanced optics | Rare | 10 |
| Ultra-Pure Metal | Magma Veins | Collect from magma-refined deposits | Endgame circuits, Array structure | Epic | 5 |
| Circuit Board | Crafted | Workbench T1 | Robots, sensors, base electronics | — | 15 |
| Battery | Crafted | Workbench T1 | Robots, portable power, tools | — | 10 |
| Sensor Module | Crafted | Workbench T2 | Robots (sensor slot), base monitors | — | 10 |
| Motor | Crafted | Workbench T2 | Robots (actuator), mechanical structures | — | 8 |
| Microcontroller | Crafted / Wren trade | Workbench T3 | Advanced robots, smart circuits, AI tier | — | 5 |
| Bio-Fuel | Crafted | Refinery structure | Generator fuel, Plow fuel, trade currency | — | 20 |
| Solar Power | Generated | Solar Panel structure | Base power (passive) | — | — |
| Geothermal Power | Generated | Geothermal Tap (Magma Veins only) | Unlimited base power (endgame) | — | — |
| Battery Charge | Generated | Charging Station | Robot batteries, portable tools | — | — |

---

## 3. Crafting System

### Workbench Tiers

| Tier | Name | Unlock | Build Cost | Recipes Available |
|---|---|---|---|---|
| T0 | Hand Crafting | Start | — | Campfire, basic tools, O2 canister refill |
| T1 | Salvage Bench | Day 1 (tutorial) | 10 scrap metal + 5 copper wire | Circuit boards, batteries, Scuttle, basic structures |
| T2 | Engineering Table | Day 9 (Wren quest 1) | 8 iron ore + 4 circuit boards + 2 quartz crystal | Sensors, motors, Ohm, Welder, Plow, Drift, advanced circuits |
| T3 | Fabricator | Day 25 (Cass quest 2) | 6 silicon + 3 microcontrollers + 4 magnetite | Microcontrollers, Mule, Pip, refined materials, smart circuits |
| T4 | Synthesis Lab | Day 40 (Mira quest 1) | 4 thaline crystal + 2 rare-earth metals + 3 superconducting ice | Atlas, AI components, Deep Signal Array parts, neural cores |

### Key Recipes

**Components:**
- Circuit Board = 3 copper wire + 2 silicon + 1 salt crystal (T1)
- Battery = 2 brine solution + 1 copper wire + 1 salt crystal (T1)
- Sensor Module = 1 circuit board + 1 quartz crystal + 2 copper wire (T2)
- Motor = 2 iron ore + 1 magnetite + 1 copper wire (T2)
- Microcontroller = 2 circuit boards + 1 pure silica + 1 quartz crystal (T3)
- Bio-Fuel (x5) = 4 biomass + 1 enzyme sap (T1, at Refinery)
- Cryo-Polymer = 2 liquid methane + 1 enzyme sap + 1 salt crystal (T3)
- Superconducting Wire = 2 superconducting ice + 1 copper wire + 1 rare-earth metals (T4)
- Neural Core = 1 microcontroller + 2 thaline crystal + 1 pure silica (T4)
- EMP Shield = 2 magnetite + 1 iron ore + 1 circuit board (T2)

**Structures** — see Section 11.

**Robots** — see Section 4.

---

## 4. Robot System

### Robot Specs

| Robot | Default Name | Unlock Day | Build Cost | Battery (min) | Cargo | Sensor Slots | Special Ability |
|---|---|---|---|---|---|---|---|
| Gatherer | Scuttle | Day 4 | 8 scrap metal, 2 circuit boards, 1 battery, 1 motor | 45 | 6 | 1 | Auto-harvest: gathers tagged resource nodes |
| Sensor | Ohm | Day 12 | 4 iron ore, 3 circuit boards, 2 sensor modules, 1 battery | 60 | 2 | 4 | Sensor fusion: combines readings from all slots into unified data stream |
| Builder | Welder | Day 16 | 10 iron ore, 3 circuit boards, 2 motors, 1 battery | 40 | 4 | 1 | Place & repair: can build structures from blueprints and repair damaged ones |
| Farmer | Plow | Day 18 | 6 scrap metal, 2 circuit boards, 1 motor, 1 sensor module, 1 battery | 50 | 4 | 2 | Till & tend: plants, waters, and harvests bio-crops automatically |
| Scout | Drift | Day 14 | 4 scrap metal, 2 circuit boards, 2 sensor modules, 1 battery | 35 | 2 | 3 | Fast move: 2x speed, reveals fog of war, auto-maps terrain |
| Hauler | Mule | Day 26 | 12 iron ore, 2 circuit boards, 2 motors, 2 batteries | 30 | 16 | 1 | Heavy lift: can carry structures and bulk resources between bases |
| Swarm | Pip | Day 30 | 2 scrap metal, 1 circuit board, 1 microcontroller | 20 | 0 | 1 | Mesh network: shares sensor data with all Pips in range (8 tiles) |
| Autonomous | Atlas | Day 42 | 6 rare-earth metals, 2 microcontrollers, 3 sensor modules, 2 motors, 1 neural core, 2 batteries | 90 | 8 | 4 | AI-capable: can run decision trees and neural nets locally |

### Robot Upgrades (applied at Engineering Table or Fabricator)

| Upgrade | Cost | Effect | Compatible |
|---|---|---|---|
| Reinforced Chassis | 4 iron ore + 1 magnetite | +50% HP, resist acid/sand | All |
| Extended Battery | 1 battery + 1 brine solution | +20 min battery life | All |
| EMP Hardening | 1 EMP shield + 2 copper wire | Survives resonance storms | All |
| Thermal Jacket | 2 cryo-polymer + 1 volcanic glass | Operates -120C to 800C | All |
| Sealed Chassis | 3 iron ore + 2 salt crystal | Operates in acid/toxic/liquid | Scuttle, Mule, Atlas |
| Extra Cargo Bay | 3 scrap metal + 1 motor | +4 cargo slots | Scuttle, Mule, Atlas |
| Sensor Expansion | 1 sensor module + 1 circuit board | +1 sensor slot | All |
| AI Co-Processor | 1 neural core + 1 microcontroller | Enables ML model execution | Ohm, Drift, Atlas |

### Programming API (per robot type)

**All robots:** `robot.move(direction)`, `robot.move_to(x, y)`, `robot.status()`, `robot.battery()`, `robot.wait(seconds)`, `robot.log(message)`

**Scuttle adds:** `robot.gather(resource_type)`, `robot.scan_resources(radius)`, `robot.deposit()`
**Ohm adds:** `sensor.read(type)`, `sensor.read_all()`, `sensor.log_data(interval)`, `sensor.alert(condition, callback)`
**Welder adds:** `robot.build(blueprint, x, y)`, `robot.repair(target)`, `robot.deconstruct(target)`
**Plow adds:** `robot.plant(crop_type)`, `robot.water()`, `robot.harvest()`, `robot.soil_status()`
**Drift adds:** `robot.scout(direction, distance)`, `robot.map_area(radius)`, `robot.mark_poi(label)`
**Mule adds:** `robot.load(source)`, `robot.unload(destination)`, `robot.route(waypoints)`
**Pip adds:** `mesh.broadcast(data)`, `mesh.listen(callback)`, `mesh.peers()`, `mesh.relay(target, data)`
**Atlas adds:** `ai.load_model(name)`, `ai.predict(input_data)`, `ai.decide(options, context)`, `robot.autonomous(goal)`

**Fleet management:** Max 12 active robots. Each active robot drains 2 power/min from base grid. Robots beyond power budget enter sleep mode.

---

## 5. Progression System — Tech Tree

### Tier 1: Survival (Days 1-8)

**Gate:** None (starting tier).
**Unlocks:** Hand crafting, Salvage Bench, Scuttle, campfire, basic shelter, O2 canister, solar lamp.
**Code concepts:** `print()`, variables, `if/else`, basic `while` loops.
**Circuit concepts:** Battery + wire + LED (first circuit).

### Tier 2: Automation (Days 9-22)

**Gate:** Complete Wren quest 1 (repair purifier) + build 3 circuit boards + reach Brine Hollows.
**Unlocks:** Engineering Table, Ohm, Drift, Welder, Plow, sensor modules, motors, EMP shields, Refinery, solar panels.
**Code concepts:** Functions, parameters, `for` loops, lists, event callbacks.
**Circuit concepts:** Resistors, transistors, sensor wiring, voltage dividers, Ohm's law.

### Tier 3: Network (Days 23-40)

**Gate:** Complete Cass quest 2 (pathfinding) + build 5 sensor modules + reach Glass Dunes.
**Unlocks:** Fabricator, Mule, Pip, microcontrollers, mesh networking, cross-biome sensor networks, advanced circuits.
**Code concepts:** Dictionaries, classes, pathfinding, data logging, event-driven architecture.
**Circuit concepts:** Microcontroller programming, oscillators, PID controllers, PCB design.

### Tier 4: Intelligence (Days 41-60)

**Gate:** Complete Mira quest 1 (decision tree) + build 2 microcontrollers + reach Resonance Peaks.
**Unlocks:** Synthesis Lab, Atlas, neural cores, decision trees, regression, neural networks, Deep Signal Array.
**Code concepts:** ML APIs, training loops, data preprocessing, model evaluation.
**Circuit concepts:** CPU from logic gates, signal modulation, superconducting circuits.

---

## 6. Difficulty Curve

**Principle: "The game gets EASIER as you get smarter."**

| Phase | Days | Challenge Level (1-10) | Description |
|---|---|---|---|
| Panic | 1-3 | 8 | Everything is manual. O2 is ticking. No robots. High time pressure, low knowledge. |
| Foothold | 4-8 | 6 | Scuttle handles gathering. Player still codes everything line-by-line. Dust storms are annoying, not deadly. |
| Expansion | 9-15 | 5 | Circuits automate base systems. Multiple robots. Wren's quests teach, not punish. Difficulty valley — intentional breather. |
| Reach | 16-22 | 7 | Ferric Badlands punish bad wiring. EMP storms destroy unshielded gear. Spike forces circuit mastery. |
| Automation | 23-30 | 4 | Sensor networks + coded routines run the base. Player shifts from doing to designing. Lowest manual effort. |
| Revelation | 31-40 | 6 | New biomes have extreme hazards, but player has tools. Challenge is intellectual (algorithms, data), not survival. |
| Mastery | 41-50 | 5 | AI robots handle exploration. Player focuses on training models. Difficult conceptually, easy mechanically. |
| Endgame | 51-60 | 7 | Array construction is a systems integration challenge. All skills converge. Hard but satisfying, never unfair. |

**Key spikes:** Day 1 (crash survival), Day 16-18 (first EMP storm), Day 31 (Resonance Peaks entry). Each spike is preceded by a tool that makes it solvable.

**"Easier as you get smarter" mechanically:** Every robot built removes one manual task. Every circuit automated removes one thing to monitor. By Day 40, a well-coded base runs itself — the player's reward for learning is freedom to explore.

---

## 7. Day/Night & Time System

**Planet rotation:** 14 real-world hours = 1 Thyra-7 day (per world bible). Scaled for gameplay:

| Unit | Real Time | In-Game Time |
|---|---|---|
| 1 in-game hour | 1 minute | 1 hour |
| 1 in-game day | 14 minutes | 14 hours |
| Day phase (light) | 9 minutes | 9 hours |
| Night phase (dark) | 5 minutes | 5 hours |

**Night changes:**
- Temperature drops 30-50C (biome-dependent). Thermal hazards increase.
- Solar panels produce 0 power. Battery reserves are critical.
- Hostile environmental events +50% frequency (storms, gas pockets expand).
- Phosphor spores and bioluminescent resources ONLY harvestable at night.
- Robot sensor range -25% (except Ohm with night-vision sensor upgrade).

**Sleep:** Player can sleep at a bed structure. Sleeping fast-forwards to dawn (skips remaining night). Energy restores to 80. Hunger still ticks during sleep (costs ~7 satiety). Robots continue executing code during sleep — a strong incentive to automate night operations.

---

## 8. Circuit Builder Mechanics

### Component List

| Component | Unlock Tier | Cost | Function | Can Fail? |
|---|---|---|---|---|
| Wire | T1 | 1 copper wire | Connects components | No |
| Resistor | T1 | 1 salt crystal | Limits current flow | No |
| LED | T1 | 1 copper wire + 1 phosphor spore | Visual indicator | Burns at >5V |
| Battery Cell | T1 | 1 battery (crafted) | Provides 3V DC | Drains over time |
| Capacitor | T2 | 1 salt crystal + 1 copper wire | Stores/releases charge | Explodes at >2x rated V |
| Transistor | T2 | 1 silicon + 1 copper wire | Amplify/switch signals | Burns at >12V |
| Relay | T2 | 1 iron ore + 1 copper wire | Mechanical switch | Welds shut after 500 cycles |
| Temp Sensor | T2 | 1 sensor module | Reads temperature (-200 to 1000C) | No |
| Gas Sensor | T2 | 1 sensor module | Reads atmospheric composition | Corrodes in acid biomes |
| Pressure Sensor | T2 | 1 sensor module | Reads atmospheric/contact pressure | No |
| Servo Motor | T2 | 1 motor | Precise rotation (0-180 deg) | Stalls under overload |
| Oscillator | T3 | 1 quartz crystal + 1 capacitor | Generates clock signal | No |
| Voltage Regulator | T3 | 2 transistors + 1 resistor | Maintains stable output voltage | No |
| Microcontroller | T3 | 1 microcontroller (crafted) | Programmable logic, 8 I/O pins | Fries in EMP without shielding |
| Logic Gate (NAND) | T3 | 2 transistors | Boolean logic building block | No |
| Op-Amp | T3 | 3 transistors + 2 resistors | Signal amplification/comparison | No |
| Piezo Transducer | T4 | 1 piezoelectric crystal | Converts vibration to signal | Cracks at extreme amplitude |

### Breadboard Grid

- 20x12 tile grid. Components snap to grid intersections. Wires auto-route along rows/columns.
- **Power rails:** top and bottom rows. Connect battery to rail, components draw from rail.
- **Power flow:** DC only. Voltage drops across components per Ohm's law (simplified: V = I x R displayed on hover).
- **Connection:** Click component pin, drag to destination pin. Wire highlights green (valid) or red (short/overload).

### Failure States

| Failure | Cause | Consequence | Fix Cost |
|---|---|---|---|
| Short Circuit | Wire connects +V directly to ground | Fuse blows, circuit powers off | 1 copper wire (replace fuse) |
| Overvoltage | Component receives >rated voltage | Component destroyed (removed from board) | Re-craft the component |
| Component Burnout | LED/transistor exceeds spec | Component destroyed | Re-craft |
| EMP Damage | Resonance storm hits unshielded circuit | All non-shielded components destroyed | Re-craft + add EMP shield |

### Circuit-to-Game Connection

Circuits connect to robots via the robot's **sensor slots** (input) and **actuator ports** (output). A circuit board is "installed" into a robot or base structure, linking its I/O pins to the game world. Code reads sensor pins via `sensor.read()` and writes actuator pins via `robot.actuate()`.

---

## 9. Code Editor Mechanics

### AstroScript Spec by Tier

| Tier | Features Unlocked |
|---|---|
| T1 | `print()`, variables (int, float, string, bool), `if/elif/else`, `while`, basic math operators |
| T2 | `for` loops, `range()`, lists, `def` functions with params/return, `import sensor`, `import robot` |
| T3 | Dictionaries, classes, `import base`, `import radio`, `import mesh`, list comprehensions, try/except |
| T4 | `import ai`, lambda, generators, `import data` (for datasets), training API, model save/load |

### Execution Model

- **Step limit:** 10,000 steps per game tick (1 tick = 0.1 in-game hours = ~0.43 real seconds).
- **Infinite loop protection:** If step limit hit, execution pauses, SABLE warns: "Your script exceeded the step limit. Check for infinite loops."
- **Error handling:** Syntax errors shown inline with red underline + error panel. Runtime errors pause execution and highlight the offending line. SABLE offers a contextual hint (not the solution).
- **Multiple scripts:** Each robot runs its own script independently. Base systems have a shared `base_control.py` script.

### API Modules

| Module | Available | Key Functions |
|---|---|---|
| `robot` | T1 | `move()`, `move_to()`, `gather()`, `status()`, `battery()`, `log()` |
| `sensor` | T2 | `read(type)`, `read_all()`, `log_data()`, `alert()`, `calibrate()` |
| `base` | T3 | `power_status()`, `o2_level()`, `build(blueprint)`, `storage_contents()` |
| `radio` | T3 | `scan()`, `broadcast(msg)`, `listen(callback)`, `signal_strength()` |
| `mesh` | T3 | `peers()`, `broadcast(data)`, `relay()`, `listen()` |
| `ai` | T4 | `load_model()`, `predict()`, `train(dataset, config)`, `evaluate()`, `decide()` |
| `data` | T4 | `collect(source, duration)`, `clean()`, `split(ratio)`, `plot()` |

### Code Persistence

Each robot stores its script in the base computer's filesystem (visible in the terminal as `/robots/<name>.py`). Scripts persist across save/load. Player can copy scripts between robots of the same type. A `/snippets/` folder stores reusable code the player saves.

---

## 10. NPC Interaction & Quests

### Interaction

- **Trigger:** Walk within 2 tiles of NPC and press interact key (E). Speech bubble icon appears at 4 tiles.
- **Dialogue:** Branching text with 2-3 response options. No voiced lines. Character portrait + text box.
- **Quest acceptance:** Explicit accept/decline prompt. Active quest shown in journal.

### Trade System

| NPC | Sells | Wants | Currency |
|---|---|---|---|
| Wren | Transistors (2 bio-fuel), microcontrollers (8 bio-fuel), advanced circuit blueprints | Bio-fuel, biomass, copper wire | Bio-fuel is universal trade currency |
| Rootknot | Thaline vein maps, magnetite (free, 1/day), lore entries | Sensor data logs (player must place sensors and collect data for Rootknot) | Data logs |
| Cass | Expedition 2 map fragments, pathfinding algorithm blueprints, microcontroller cache (quest reward) | Batteries (to stay alive), code fixes (quest-based) | Batteries |
| Mira | ML blueprints, Expedition 1 research data, resonance harmonizer design (quest reward) | Thaline crystal (to power data core), trained models (proof of learning) | Thaline crystal |

### Quest Journal

- Tab in the base terminal UI. Lists: Active Quests, Completed, Available (discovered but not accepted).
- Each quest entry: objective checklist, NPC name, reward preview, relevant biome.
- Max 5 active quests at a time. No time limits on quests (no fail states for slowness).

### Reputation

**None.** NPCs are cooperative by design. Quest completion unlocks their next quest and better trade stock. No negative reputation. This is an educational game — no punishment for social choices.

---

## 11. Base Building

### Structures

| Structure | Cost | Function | Power Draw | Unlock |
|---|---|---|---|---|
| Shelter (starter) | 12 scrap metal | Sleeping, basic storage (20 slots) | 0 | Day 1 |
| Salvage Bench | 10 scrap metal + 5 copper wire | T1 crafting | 0 | Day 1 |
| Solar Panel | 4 silicon + 2 solar-grade glass + 3 copper wire | Generates 10 power/min (day only) | -10 (generates) | T2 |
| Battery Bank | 4 batteries + 2 iron ore | Stores 500 power units. Buffers night usage | 0 | T1 |
| O2 Recycler | 6 iron ore + 2 circuit boards + 1 sensor module | Generates O2 inside sealed rooms. +5 O2/min | 3 | Day 1 (repair quest) |
| Refinery | 8 iron ore + 3 circuit boards + 1 motor | Converts raw resources to refined materials | 4 | T2 |
| Engineering Table | 8 iron ore + 4 circuit boards + 2 quartz crystal | T2 crafting | 2 | T2 |
| Fabricator | 6 silicon + 3 microcontrollers + 4 magnetite | T3 crafting | 6 | T3 |
| Synthesis Lab | 4 thaline crystal + 2 rare-earth metals + 3 superconducting ice | T4 crafting | 10 | T4 |
| Charging Station | 4 copper wire + 2 circuit boards + 1 battery | Recharges robot batteries (1 robot at a time, 5 min full) | 5 | T1 |
| Storage Crate | 6 scrap metal | 30 item slots | 0 | T1 |
| Wall Segment | 2 iron ore OR 3 scrap metal | Room boundary. Required for O2 sealing | 0 | T1 |
| Door | 3 iron ore + 1 circuit board | Sealable entrance. Auto-close option (code-controlled) | 1 | T1 |
| Heater | 4 iron ore + 2 copper wire + 1 resistor | Raises room temp +30C | 3 | T2 |
| Cooler | 4 iron ore + 2 copper wire + 1 cryo-polymer | Lowers room temp -40C | 4 | T3 |
| Base Terminal | 4 circuit boards + 2 silicon + 1 sensor module | Fleet monitor, code editor, quest journal | 3 | Day 2 |
| Radio Tower | 6 iron ore + 3 circuit boards + 2 copper wire | Cross-biome robot control range | 5 | T2 |
| Greenhouse | 8 solar-grade glass + 4 iron ore + 2 sensor modules | Grow bio-crops indoors (controlled climate) | 4 | T2 |
| Geothermal Tap | 10 iron ore + 4 circuit boards + 2 motors + 2 volcanic glass | Generates 30 power/min (Magma Veins only, unlimited) | -30 (generates) | T4 |
| Deep Signal Array | 20 iron ore + 8 thaline crystal + 4 superconducting wire + 2 neural cores + 6 circuit boards | Endgame transmitter. Requires all skills to calibrate | 25 | T4 (endgame) |

### Power Routing

Solar panels and geothermal taps feed into battery banks. Battery banks distribute power to all structures within 15 tiles via copper wire conduits (placed like walls). If total draw exceeds supply, structures shut down in reverse build order (newest first). Power status visible on Base Terminal.

### Oxygen System

O2 Recycler generates breathable air inside **sealed rooms** — rooms fully enclosed by walls, floor, and at least one door (closed). Unsealed rooms get no O2 benefit. Pipes not required — O2 fills any sealed room within 8 tiles of a recycler. Multiple recyclers stack.

### Grid Snapping

All structures snap to a 1x1 tile grid. Structures cannot overlap. Walls auto-connect when placed adjacent. Doors can only be placed in wall segments. Preview ghost shows valid (green) or invalid (red) placement.

---

## 12. Save System

- **Autosave:** Every 2 in-game days (every ~28 real minutes). Also autosaves on biome transition and quest completion.
- **Manual save:** 5 save slots. Accessible from pause menu. Save includes: all world state, all robot scripts, all circuit designs, quest progress, inventory, base layout.
- **No permadeath.** On "death" (HP reaches 0 or O2 reaches 0), player respawns at base with 50% HP, 50 O2, and loses the contents of their personal inventory (not base storage). Robots in the field are unaffected. A 10-second respawn screen shows what went wrong (educational — "You ran out of oxygen. Your O2 recycler script had no error handling for sensor disconnection.").
- **Load time target:** Under 3 seconds.

---

## 13. Accessibility & Difficulty Options

| Option | Settings | Default |
|---|---|---|
| Code Hint Level | Off / Subtle (SABLE highlights the error area) / Explicit (SABLE shows the fix) | Subtle |
| Time Pressure | Normal (14 min days) / Relaxed (21 min days, hazard frequency halved) / Creative (no hunger, no O2 drain, no hazards) | Normal |
| Text Size | Small / Medium / Large / Extra Large | Medium |
| Colorblind Mode | Off / Deuteranopia / Protanopia / Tritanopia (recolors wires, LEDs, UI indicators) | Off |
| Screen Reader | Basic screen reader support for menus and dialogue | Off |
| Auto-Pause on Code Editor | Game pauses while typing code (so time pressure doesn't punish slow typers) | On |
| Dyslexia Font | Toggle OpenDyslexic font for all in-game text | Off |

**Design philosophy:** No difficulty setting locks content. Creative mode players see the same story, quests, and ending. The game teaches — it never gatekeeps.
