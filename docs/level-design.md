# AstroCode — Level Design Document

**Version:** 0.1 | **Date:** 2026-05-25

---

## World Map Overview

```
                        [BEACON PLATEAU]
                              |
              [RESONANCE PEAKS]---[POLAR SINK]
               /         |              \
        [GLASS DUNES]    |         [MAGMA VEINS]
              \           |              /
          [SPORE MARSHES]-+-------------+
                |
          [FERRIC BADLANDS]
                |
          [ALKALINE FLATS] <-- CRASH SITE
                |
          [BRINE HOLLOWS]

  PROGRESSION GATES
  ==================
  Flats->Hollows   : Explore Flats edge (Day 4+)
  Flats->Badlands  : Build Scuttle (Day 8+)
  Hollows->Marshes : Complete Wren Q1 + build Ohm (Day 15+)
  Badlands->Dunes  : Complete Cass Q2 + terrain-analysis robot (Day 23+)
  Marshes->Peaks   : EMP-hardened robots + sensor network (Day 31+)
  Peaks->Sink      : Thermal-hardened robots + AI nav (Day 41+)
  Peaks->Veins     : Heat-resistant robots + Atlas (Day 44+)
  Peaks->Beacon    : Complete Array components (Day 51+)
```

---

## Zone 1: Alkaline Flats (Crash Site)

**Unlock:** Starting zone | **Biome:** Salt desert | **Size:** 40x30 | **Difficulty:** 4/10 (resource pressure, not combat) | **Time:** 60-90 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W....R.....H.........R..............R..W
W..........H............................W
W...R....[===HALDANE===]....R...........W
W.........[B  cockpit  B]..............W
W..........[===========]......R........W
W....R..............................R...W
W...........R.....P1...................W
W..H................................R..W
W.......R.............R................W
W.....................................DW->Ferric Badlands
W...........R......P2.......R.........W
W....H..........N1....................W
W..R........R.................R.......W
W.........................................W
W...R...........H..........R...........W
W......R..P3...........................W
W...R...............................R..W
W.........R.................R..........W
DW->Brine Hollows (tunnel entrance)....W
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

Legend: B=base/ship, R=resource, P=puzzle, N=NPC marker,
        H=hazard(dust storm path), D=door/exit, W=wall
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Scrap Metal | 18 | No | Scattered around Haldane wreckage |
| Copper Wire | 12 | No | Ship interior salvage nodes |
| Salt Crystal | 20 | Yes (3-day) | Surface deposits, zone edges |
| Biomass (sparse) | 4 | Yes (5-day) | Isolated patches near tunnel entrance |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| SABLE | Ship AI / hint system | Tutorial quests (Lessons P1-P8, C1-C3) | Haldane cockpit terminal |
| Expedition 3 Drone (wreck) | Lore object | Examine only (lore fragment) | Northeast quadrant |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Fix O2 Recycler | Code: `print()`, variables | 1 | O2 stable, SABLE online | Prog #1-2 |
| P2: Auto-close shelter door | Code: `if/else`, comparison | 2 | Auto-door system | Prog #3-4 |
| P3: Scuttle battery return logic | Code: `while` loop, boolean | 3 | Scuttle auto-returns | Prog #5-7 |
| C1: Wire first LED lamp | Circuit: battery+wire+LED | 1 | Night lighting | Circ #1 |
| C2: Resistor sizing for LED panel | Circuit: Ohm's law | 2 | 3-LED status panel | Circ #2-3 |
| M1: Scuttle round-trip calc | Math: d=st | 2 | Efficient robot dispatch | Math #1-2 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Dust storm | Visibility + corrosion | Every 3-4 days, crosses mid-zone | Yes (shelter/auto-door code) |
| Temperature swing | Cold damage at night (-5C) | Nightfall | Yes (campfire, shelter) |
| Alkaline dust corrosion | Gradual circuit damage | Exposed circuits left outside | Yes (insulation, shelter) |

### Pacing Notes
**Arc: Panic -> Foothold.** Player wakes mid-crisis (O2 ticking). First 10 minutes are high tension with no tools. Each solved puzzle visibly reduces pressure: O2 stabilizes, lights come on, Scuttle starts gathering. By zone end, the crash site feels like a scrappy home. The dust storms are annoying but survivable, teaching that automation solves recurring problems. Emotional tone shifts from "I might die" to "I've got this."

---

## Zone 2: Brine Hollows

**Unlock:** Explore Flats southern edge (Day 4+) | **Biome:** Underground cavern | **Size:** 35x40 | **Difficulty:** 5/10 | **Time:** 60-80 min

### Layout
```
    WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
    W.....R......H(acid)....R.........W
DW<-Alkaline Flats....R..............W
    W...R.....[N:WREN workshop].......W
    W..........[  B  trade  B]........W
    W....H......R.....P1..............W
    W..R.....R........R......R........W
    W.......P2.......H(acid)..........W
    W...R......R..............R.......W
    W........R.....P3......R..........W
    W...H(cave-in)..............R.....W
    W....R.......R..........R.........W
    W...........P4....................W
    W..R..........R..........R........W
    W.....R...........H(acid)........DW->Spore Marshes
    WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Copper Ore | 10 | Yes (4-day) | Vein nodes along cavern walls |
| Brine Solution | 15 | Yes (2-day) | Shallow pools throughout |
| Quartz Crystal | 6 | No | Deep vein clusters, south half |
| Salt Crystal | 8 | Yes (3-day) | Stalactite deposits |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| Wren | Circuit teacher, component merchant | 3 quests | Workshop alcove, north-center |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Repair Wren's purifier | Code: `for` loops; Circuit: voltage divider | 3 | Engineering Table unlock, Wren trades | Prog #9, Circ #4, Math #5 |
| P2: Build seismic sensor | Circuit: capacitor smoothing + sensor wiring | 4 | Cave-in prediction | Circ #5 |
| P3: Wren's Memorial Beacon | Code+Circuit convergence: relay + callback | 4 | Wren's trust, advanced components | Circ #7, Prog #12, Math #3 |
| P4: Map cavern passages | Code: lists, `append`, `len` | 3 | Full Hollows map, Marshes exit | Prog #10-11 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Acid pools | Robot damage (unsealed chassis) | Contact with pool tiles | Yes (sealed chassis upgrade, path choice) |
| Cave-in | Path blockage | Random, every 4-5 days | Yes (seismic sensor after P2) |
| Condensation shorting | Circuit failure | Uninsulated circuits in humid air | Yes (insulation with salt crystal) |

### Pacing Notes
**Arc: Descent -> Partnership.** The shift underground feels intimate and slightly claustrophobic after the open Flats. Meeting Wren is the first human contact and a relief. Her gruff teaching style sets the circuit-learning tone: hands-on, no lectures. The memorial beacon quest is an emotional peak -- building something not for survival but for someone else. Player exits feeling competent with basic circuits and functions.

---

## Zone 3: Ferric Badlands

**Unlock:** Build Scuttle + explore Flats east edge (Day 8+) | **Biome:** Iron oxide mesa/canyon | **Size:** 45x35 | **Difficulty:** 7/10 | **Time:** 70-90 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W.R.....H(mag)........R.........R...........W
DW<-Alkaline Flats.....R..........R..........W
W......R.....P1[magnetometer]....R..........W
W...R.........H(mag)......N:ROOTKNOT........W
W........R.......R.....[rooted in mesa]......W
W..H(rockslide)....R..........R.............W
W....R.......P2[EMP shield]......R...........W
W.R........R.........H(EMP storm path)......W
W.......R.....[EXPEDITION 1 CAMP]...........W
W.........R...P3[sensor network]...R........W
W..R.......R.........R..............R.......W
W.....H(rockslide)......R.......P4..........W
W..R......R.......R..........................W
W........R.....R.......R..........R.......DW->Glass Dunes
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Iron Ore | 20 | Yes (3-day) | Mesa walls and canyon floor |
| Magnetite | 8 | Yes (5-day) | Anomaly zones (hazard-adjacent) |
| Silicon | 6 | No | Deep canyon deposits |
| Scrap Metal | 5 | No | Expedition 1 camp salvage |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| Rootknot | Physics/sensor quest-giver, lore source | 3 quests (spans Badlands + Peaks) | Embedded in mesa, center zone |
| Dr. Venn's Journal | Lore object | Examine only | Expedition 1 camp |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Magnetometer array | Code: functions w/ params + return | 5 | Badlands anomaly map | Prog #13-14 |
| P2: EMP shield wiring | Circuit: transistor switch + shielding | 5 | Robots survive EMP storms | Circ #6, Prog #15 |
| P3: Cross-biome sensor net | Code: `import sensor`, nested loops | 5 | IoT network (Rootknot Q2) | Prog #16-17 |
| P4: Solar tracker | Circuit+Math: servo + trig | 6 | Triple solar output | Circ #9, Math #4 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Magnetic anomaly | Sensor scrambling | Proximity to anomaly zones | Yes (calibration function code) |
| EMP micro-storm | Circuit destruction | Every 2 days | Yes (EMP shield after P2) |
| Rockslide | Path blockage + damage | Canyon traversal, random | Partially (seismic sensor) |

### Pacing Notes
**Arc: Difficulty spike -> Earned mastery.** This zone punishes naive approaches: unshielded circuits fry, uncalibrated sensors lie. The EMP storm that destroys the player's first unshielded robot is a deliberate shock moment. But every hazard has a buildable solution. Finding Expedition 1's camp and reading Dr. Venn's journal shifts the narrative from survival to mystery. Meeting Rootknot opens the planetary-scale story. Player exits respecting the planet.

---

## Zone 4: Spore Marshes

**Unlock:** Complete Wren Q1 + Ohm built + Hollows south exit (Day 15+) | **Biome:** Bioluminescent wetland | **Size:** 40x35 | **Difficulty:** 5/10 | **Time:** 60-80 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W....R..H(gas)......R.........R.......W
DW<-Brine Hollows.......R..............W
W..R......[N:CASS drone chassis].......W
W.......R.....P1[debug Cass]...........W
W...R........R.......H(gas)....R......W
W......H(quickmud)....R...............W
W..R.....R.....P2[gas warning net]....W
W.......R........R.....R..............W
W...R.....P3[pathfinding]....R........W
W......R........H(quickmud)...........W
W..R.........R.......R......R.........W
W.....R....[GREENHOUSE SITE]..........W
W..R......R......P4[bio-fuel]...R.....W
W.....R.........R....................DW->Resonance Peaks
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Biomass | 25 | Yes (2-day) | Fungal growths throughout |
| Enzyme Sap | 8 | Yes (4-day) | Fungal tree tap points |
| Phosphor Spores | 10 | Yes (spore bloom, 5-day) | Night-only harvest, scattered |
| Copper Wire | 5 | No | Expedition 2 drone salvage |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| Cass | Coding teacher, automation quests | 3 quests | Wandering drone, north-center |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Debug Cass's memory | Code: dictionaries, debugging | 5 | Cass online, map data partial | Prog #18 |
| P2: Gas early warning | Code+Circuit: `try/except`, gas sensor wiring | 5 | Safe marsh exploration | Prog #19, Circ #8 |
| P3: Pathfinding for Cass | Code: BFS algorithm | 6 | Cass navigates, biome reveals | Prog #21 |
| P4: Bio-fuel pipeline | Code: classes, automation | 5 | Permanent food + fuel | Prog #20, AI #1 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Toxic gas pocket (H2S) | Lethal without sensor | Proximity, invisible | Yes (gas sensor after P2) |
| Quickmud | Robot trap | Entering mud tiles without terrain scan | Yes (pathfinding after P3) |
| Spore bloom | 80% sensor range reduction | Every 5 days | Reduce impact (event callbacks) |

### Pacing Notes
**Arc: Breather -> Automation payoff.** After the Badlands' intensity, the Marshes feel lush and curious. Cass provides comic relief with glitchy enthusiasm. The challenge is intellectual (algorithms, data structures) rather than survival. By the end, the player's base runs itself: bio-fuel feeds hunger, sensor networks handle hazards, robots execute code autonomously. The reward for learning is freedom.

---

## Zone 5: Glass Dunes

**Unlock:** Complete Cass Q2 + terrain-analysis robot (Day 23+) | **Biome:** Shifting silica desert | **Size:** 50x30 | **Difficulty:** 6/10 | **Time:** 50-70 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W....R......H(shifting)......R..........R..........W
DW<-Ferric Badlands.........R.......R..............W
W..R.......P1[pathfinding deploy]......R...........W
W.......R.........H(sandstorm)..R...........R......W
W...R.......R...........R.......P2[oscillator].....W
W......H(shifting)......R..........R...............W
W..R.............R..P3[voltage reg].....R..........W
W.......R....[THALINE VEIN]....R.......R...........W
W..R..R......R..........H(sandstorm).....R.........W
W............R........R..........R.................W
W.R..........R.......R.......................R....DW->Resonance Peaks
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Pure Silica | 8 | Yes (5-day) | Refined from sand at workbench T2 |
| Thaline Crystal | 4 | No | Central vein (requires pathfinding) |
| Solar-Grade Glass | 3 | No (crafted from silica) | Refinery output |
| Silicon | 6 | Yes (4-day) | Sand deposits, zone edges |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| (None resident) | — | — | — |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Drift pathfinding deploy | Code: BFS/A* on shifting grid | 6 | Autonomous dune navigation | Prog #21 |
| P2: Oscillator for Pip mesh | Circuit: quartz oscillator | 6 | Synchronized swarm comms | Circ #10 |
| P3: Voltage regulator | Circuit: stable 5V for Fabricator | 5 | Reliable T3 crafting | Circ #11 |
| M1: Probability risk calc | Math: sandstorm probability | 5 | Informed expedition planning | Math #7 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Shifting terrain | Hard-coded paths break daily | Every dawn, dune reconfiguration | Yes (pathfinding algorithm) |
| Sandstorm | Chassis stripping | Every 3-4 days | Partially (reinforced chassis) |
| Solar radiation | Sensor damage (day) | Daytime exposure | Yes (shielded sensor housings) |

### Pacing Notes
**Arc: Open wonder -> Algorithmic thinking.** The prismatic dunes are the most visually striking zone. The shifting terrain is a natural motivation for pathfinding -- hard-coded solutions literally break overnight. No resident NPC keeps the zone feeling wild and remote. First thaline crystal discovery raises the stakes: this is what Earth needs. The zone teaches that elegant algorithms beat brute-force memorization.

---

## Zone 6: Resonance Peaks

**Unlock:** EMP-hardened robots + sensor network operational (Day 31+) | **Biome:** Obsidian mountains | **Size:** 45x40 | **Difficulty:** 7/10 | **Time:** 80-100 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W.R......H(EMP)........R.........R...........W
DW<-Glass Dunes.........R..........R..........W
DW<-Spore Marshes.......R.......R.............W
W..R.....P1[data logging].......R.............W
W.......R.......[N:MIRA data core]............W
W...R.........R........P2[decision tree]......W
W......H(EMP storm arc)....R.........R........W
W..R..........R........R..........R...........W
W.....R..P3[regression model]......R..........W
W..R......R...[ROOTKNOT NODE]........R........W
W.........R.P4[logic gates]......R............W
W...R.........R.......H(low O2)...............W
W......R..........R.........R....R............W
W..R.....[BEACON PLATEAU]....................DW->Polar Sink
W.........[  ARRAY SITE  ]....................W
W...R........R........R............R........DW->Magma Veins
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Thaline Crystal | 10 | Yes (6-day) | Peak vein nodes (deep, mesh-relay needed) |
| Rare-Earth Metals | 6 | No | Deep vein deposits |
| Piezoelectric Crystal | 5 | No | Peak summit nodes |
| Magnetite | 4 | Yes (5-day) | Lower slopes |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| Mira | AI/ML teacher, endgame quests | 3 quests | Data core, upper-center |
| Rootknot Node | Relay target | Part of Rootknot Q3 | Mid-zone east |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Multi-biome data logging | Code: `sensor.log_data`, aggregation | 6 | Atmospheric dataset begins | Prog #22-23 |
| P2: Thaline purity classifier | AI: decision tree (manual + trained) | 7 | Thaline sorting automated | AI #2-3 |
| P3: Storm prediction model | AI+Math: regression + statistics | 7 | Storm ETA within 45 min | AI #6-7, Math #6 |
| P4: Logic gate shelter door | Circuit: NAND-based combinational logic | 7 | Smart auto-shelter | Circ #12 |
| P5: Op-amp signal boost | Circuit: Rootknot relay chain | 6 | Thaline vein map (Rootknot Q3) | Circ #13 |
| P6: Pip mesh relay chain | Code: mesh networking | 6 | Deep mining access | Prog #24, Math #8 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Resonance storm (EMP) | Total electronics destruction | Every 3 days, predictable with model | Yes (shelter + prediction after P3) |
| Low O2 (altitude) | O2 drain x3 | Above certain elevation | Yes (pressurized robot chassis) |
| EM arcs | Localized circuit damage | Storm precursor, between peaks | Yes (EMP shielding + avoidance) |

### Pacing Notes
**Arc: Revelation -> Intellectual challenge.** Activating Mira and learning the truth about the Resonance is the story's biggest twist. The zone is dense with puzzles but the player arrives well-equipped. Challenge shifts from survival to data science: logging, cleaning, modeling. The storm prediction model is transformative -- the Peaks go from death zone to workplace. Beacon Plateau visible in the south creates forward pull toward the endgame.

---

## Zone 7: Polar Sink

**Unlock:** Thermal-hardened robots + AI-assisted navigation (Day 41+) | **Biome:** Frozen methane lake | **Size:** 35x30 | **Difficulty:** 6/10 | **Time:** 50-70 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W....R.....H(cold)......R..........W
DW<-Resonance Peaks........R.......W
W..R.....P1[data cleaning]........W
W.......R......H(geyser)....R.....W
W..R.........R.......R.............W
W.....H(thin ice)......R..........W
W..R.....P2[ice classifier].......W
W.......R....[METHANE LAKE].......W
W...R......R.....H(geyser)........W
W..R....P3[vector math]....R......W
W.......R....[EXP 2 SHIP]..R......W
W..R.......R........R..............W
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Liquid Methane | 8 | Yes (4-day) | Methane pools (sealed Mule required) |
| Cryo-Polymer | 4 | No (crafted) | Refinery output |
| Superconducting Ice | 5 | No | Ice shelf harvest (thermal robot) |
| Exp 2 Data Core | 1 | No | Frozen ship (side quest) |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| (None resident) | — | — | — |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Data preprocessing | AI: clean, normalize, remove outliers | 6 | Clean dataset, accuracy jump | AI #4 |
| P2: Ice patch classifier | AI: k-NN/decision tree classification | 7 | Safe Polar Sink navigation | AI #5 |
| P3: Neural net math check | Math: vectors, dot products | 7 | Debug AI model manually | Math #9 |
| S1: Ghost in the Machine | Code+exploration: find Exp 2 ship | 5 | Earth comm protocols for Array | Side quest |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Extreme cold (-120C) | Battery freeze, 3 HP/min | Constant ambient | Yes (thermal jacket upgrade) |
| Methane geyser | Explosive if ignition near | Proximity to geyser vents | Yes (ice classifier after P2) |
| Thin ice | Robot/player falls through | Walking on unclassified ice | Yes (AI classifier model) |
| Ice quake | Surface cracks, path changes | Every 4-5 days | Partially (seismic sensors) |

### Pacing Notes
**Arc: Quiet mastery.** The Polar Sink is eerily beautiful -- aurora displays, twilight, crystalline silence. No resident NPC reinforces the isolation of late-game. The challenge is purely intellectual: data cleaning and classification feel like real data science work. The frozen Expedition 2 ship discovery is optional but emotionally resonant (the crew died here). Player exits with functional AI models and critical Array components.

---

## Zone 8: Magma Veins

**Unlock:** Heat-resistant robots + Atlas built (Day 44+) | **Biome:** Subterranean lava tubes | **Size:** 40x35 | **Difficulty:** 8/10 | **Time:** 60-80 min

### Layout
```
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
W...R.....H(lava flow).......R........W
DW<-Resonance Peaks........R..........W
W..R.......P1[neural net arch]........W
W.......R..........H(fumes)....R......W
W...R........R......R.................W
W.....H(lava flow)........R...........W
W..R......P2[training loop].....R.....W
W.......R.....[GEOTHERMAL TAP SITE]..W
W..R.........R.......H(eruption)......W
W.....R..P3[4-bit CPU build].........W
W..R......R.......R.........R.........W
W.......R.......H(lava flow)..........W
W..R...R...........R.........R........W
WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
```

### Resources

| Resource | Count | Respawn? | Location |
|---|---|---|---|
| Volcanic Glass | 8 | Yes (4-day) | Basalt wall deposits |
| Ultra-Pure Metal | 5 | No | Magma-refined deposit nodes |
| Geothermal Energy | Unlimited | N/A | Geothermal Tap structure |
| Iron Ore | 10 | Yes (3-day) | Tube walls, common |

### NPCs

| NPC | Role | Quest? | Location |
|---|---|---|---|
| (None resident) | — | — | — |

### Puzzles / Challenges

| Puzzle | Subject | Diff | Reward | Curriculum |
|---|---|---|---|---|
| P1: Neural net architecture | AI: visual layer editor (6-8-4) | 8 | Lava flow prediction model | AI #8 |
| P2: Training loop tuning | AI: epochs, LR, loss curve | 8 | Robot navigates lava tubes | AI #9, Math #10 |
| P3: 4-bit CPU from NAND gates | Circuit: ALU + registers + clock | 9 | Atlas runs ML locally | Circ #15 |

### Hazards

| Hazard | Type | Trigger | Avoidable? |
|---|---|---|---|
| Extreme heat (800C+) | Instant robot destruction | Proximity to lava flows | Yes (thermal jacket, AI pathfinding) |
| Toxic fumes | HP drain, sensor corrosion | Certain chambers | Yes (sealed chassis, gas sensor) |
| Lava flow path change | Route invalidation | Seismic tremors, unpredictable | Yes (neural net prediction after P1-P2) |
| Eruption | Massive area damage | Rare, seismic precursor | Yes (sensor network + evacuation code) |

### Pacing Notes
**Arc: Cathedral of fire -> Peak engineering.** The visual grandeur of the lava tubes (cathedral-like basalt, molten gold light) contrasts with the extreme danger. This is the hardest zone technically: neural networks and CPU design from logic gates. But the player is at peak competence. Building a CPU from NAND gates is the circuit track's crowning achievement. The geothermal tap provides unlimited power, solving energy constraints permanently. Player exits ready to build the Array.

---

## Critical Path (Days 1-60)

The minimum sequence to complete the game. Estimated 10-12 hours.

```
DAY  ZONE              KEY ACTIONS                           HOURS
---  ----              -----------                           -----
1-3  Alkaline Flats    Fix O2 (P#1-2), build shelter,        1.5
                       wire LED lamp (C#1-2)
4-8  Alkaline Flats    Build Scuttle, code gather loop        1.0
                       (P#3-7), build status panel (C#3)
9-13 Brine Hollows     Meet Wren, repair purifier (P#9,      1.5
                       C#4-5), build Ohm, learn functions
14-15 Brine Hollows    Complete memorial beacon (C#7),        0.5
                       map passages, find Marshes exit
16-22 Ferric Badlands  Meet Rootknot, build EMP shields      1.5
                       (C#6), sensor network (P#13-17),
                       solar tracker (C#9)
23-28 Spore Marshes    Meet Cass, debug code (P#18-19),      1.0
                       gas warning net (C#8), build
                       Fabricator
29-30 Spore Marshes    Pathfinding (P#21), bio-fuel          0.5
                       pipeline, classes (P#20)
31-38 Resonance Peaks  Activate Mira, data logging (P#22),   1.5
      + Glass Dunes    decision tree (AI#2-3), storm
                       model (AI#6-7), mesh relay, logic
                       gates (C#12), oscillator (C#10)
39-40 Glass Dunes      Voltage regulator (C#11),             0.5
                       Pip swarm deploy
41-45 Polar Sink       Data cleaning (AI#4), ice             1.0
                       classifier (AI#5), vector math
46-50 Magma Veins      Neural net (AI#8-9), training         1.0
                       loop, CPU build (C#15), geothermal
                       tap
51-55 Beacon Plateau   Build Deep Signal Array structure,     1.0
                       wire piezo transducer (C#14),
                       assemble full pipeline
56-60 Beacon Plateau   Train final neural net (AI#10),       0.5
                       calibrate Array, fire signal
                                                       TOTAL: ~12h
```

### Gate Requirements Summary

| Gate | From -> To | Requirements |
|---|---|---|
| G1 | Flats -> Hollows | Explore south edge (Day 4+) |
| G2 | Flats -> Badlands | Scuttle built + east edge explored (Day 8+) |
| G3 | Hollows -> Marshes | Wren Q1 complete + Ohm built (Day 15+) |
| G4 | Badlands -> Dunes | Cass Q2 complete + terrain robot (Day 23+) |
| G5 | Marshes/Dunes -> Peaks | EMP-hardened robots + sensor network (Day 31+) |
| G6 | Peaks -> Sink | Thermal-hardened robots + AI nav (Day 41+) |
| G7 | Peaks -> Veins | Heat-resistant robots + Atlas (Day 44+) |
| G8 | Peaks -> Beacon | All Array components gathered (Day 51+) |

---

## Optional Content Map

### Side Quests (5 total, ~3 hours combined)

| Quest | Zone | Trigger | Reward | Est. Time |
|---|---|---|---|---|
| Wren's Memorial | Brine Hollows | Complete Wren Q1 | Advanced soldering components | 20 min |
| The Wandering Drone | Spore Marshes | Meet Cass | Cache of microcontrollers | 25 min |
| Rootknot's Chorus | Badlands -> Peaks | Complete Rootknot Q2 | Thaline vein map (mining efficiency) | 30 min |
| Dr. Venn's Last Experiment | Resonance Peaks | Activate Mira | Array power req -40% blueprint | 30 min |
| Ghost in the Machine | Polar Sink | Detect faint signal | Earth comm protocols for Array | 25 min |

### Hidden Areas (3 total)

| Area | Parent Zone | Discovery Method | Content |
|---|---|---|---|
| Expedition 3 Cache | Alkaline Flats NE | Follow drone wreckage trail | Pre-fab circuit boards (x4), lore logs |
| Crystal Grotto | Brine Hollows deep | Mine collapsed tunnel (Welder) | Dense quartz vein (x8), bioluminescent vista |
| Obsidian Library | Resonance Peaks summit | Climb with pressurized Atlas | Dr. Venn's complete research notes, thaline lore |

### Bonus Challenges (4 total, post-critical-path or for advanced players)

| Challenge | Zone | Subject | Reward |
|---|---|---|---|
| Optimize Scuttle's gather route | Alkaline Flats | Traveling salesman heuristic | 2x gather speed permanently |
| Build a weather station | Ferric Badlands | Full sensor suite + dashboard code | 24-hour forecast on Base Terminal |
| Pip swarm formation flying | Glass Dunes | Swarm coordination algorithms | Pips auto-map any zone in 1 day |
| Train a model on all biome data | Beacon Plateau | Neural net on 60-day multi-biome dataset | Array fires with 99% efficiency (cosmetic ending upgrade) |
