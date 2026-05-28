# AstroCode — Game Design Document

**Version:** 0.1 | **Date:** 2026-05-25 | **Status:** Concept

---

## 1. Elevator Pitch

You are an astronaut stranded on an alien planet with nothing but a broken ship and a Python terminal. Survive by writing real code to program robots, wiring circuits to power your base, and teaching your machines to think — progressing from blinking an LED to training neural networks. AstroCode is the first game that makes you a real programmer, electrical engineer, and AI practitioner because your survival depends on it.

---

## 2. Genre & References

**Genre:** Top-down pixel art survival / automation / educational programming

| Reference | Borrowed Mechanic | Adapted How |
|---|---|---|
| Stardew Valley (30M+ copies) | Day/night cycle, stamina, seasonal farming loop, NPC relationships | Alien seasons affect resource spawns; "farming" is growing bio-fuel crops via automated irrigators you code yourself |
| The Farmer Was Replaced (400K copies, 96% Steam) | Python-like scripting as THE core mechanic | Expanded from crop-only to full survival: robots, circuits, sensors, AI. Same "code replaces grind" dopamine loop |
| Shenzhen I/O (500K+ copies, 96% Steam) | Visual circuit board design, assembly-level constraints | Simplified to breadboard-style wiring with real component analogs (resistors, capacitors, microcontrollers) |
| Turing Complete (200K+ copies, 97% Steam) | Logic gates to CPU progression | Late-game tier: build a processor from NAND gates to run your robot fleet's central brain |
| Astroneer (5M+ copies) | Alien planet exploration, no-combat survival, terrain/resource focus | Planet biomes with unique resources; no enemies — the planet itself is the antagonist (storms, toxic atmosphere, quakes) |
| while True: learn() (1M+ copies) | ML/AI concepts as visual puzzles | Endgame robots use decision trees, then neural nets you design to handle ambiguous tasks |
| Bitburner | "Automate the game itself" meta-loop | Your code literally replaces manual actions — gathering, building, exploring. The game rewards laziness-through-engineering |

---

## 3. Core Loop

**30-second loop:** Write 3-5 lines of code or place a circuit component. Run it. Watch your robot execute (or fail). Fix the bug. Dopamine hit on success.

**5-minute loop:** Complete a survival task. Example: oxygen is dropping. Open the code terminal. Write a function that reads the O2 sensor, triggers the electrolyzer when levels drop below 18%, and logs output to your base monitor. Wire the sensor to the microcontroller on your breadboard. Deploy. Breathe.

**30-minute loop (session arc):** Unlock a new tier of technology. Early game: you hand-gather resources and write sequential scripts. Mid game: you build robot fleets with event-driven code and circuit-powered sensor networks. Late game: you design ML models that let robots autonomously explore, classify alien specimens, and optimize your base. Each session ends with your colony visibly more automated than when you started.

---

## 4. Unique Selling Points

1. **Real code, real stakes.** You write actual Python-like syntax (not visual blocks). Your code runs in a sandboxed interpreter with real error messages. Debugging is gameplay, not punishment.
2. **Full-stack progression.** No other game goes from `print("hello")` to wiring circuits to training a neural network in one continuous survival narrative. The learning curve IS the difficulty curve.
3. **Zero lectures.** Every concept is introduced by a survival problem. You learn Ohm's law because your battery exploded. You learn PID controllers because your greenhouse overheated. The planet is the teacher.
4. **Automation-as-progression.** The game gets EASIER as you get smarter. Early game is manual and desperate. Late game is watching your robot army run code you wrote while you explore. This inverts the typical difficulty escalation and rewards mastery.
5. **Transferable skills.** Players leave with real Python fluency, circuit literacy, and ML intuition. Portfolios built in-game (code files, circuit designs) are exportable.

---

## 5. Target Audience

| Segment | Description | Size Signal |
|---|---|---|
| **Primary** | Gamers aged 15-30 who are curious about programming but bounced off tutorials. They play Factorio, Stardew, Minecraft redstone. | The Farmer Was Replaced sold 400K in months with zero marketing budget. This audience is proven and underserved. |
| **Secondary** | CS students (years 1-2) and self-taught developers who want a fun way to solidify fundamentals. | Bitburner has 40K concurrent players on Steam; coding-as-game is a validated retention mechanic. |
| **Tertiary** | Educators and bootcamps looking for supplementary tools. | While True: learn() is used in 200+ universities. Classroom-friendly design unlocks institutional sales. |

**Age rating:** PEGI 7 / ESRB E10+ (no violence, no combat, mild sci-fi peril)

---

## 6. Platform & Engine

**Engine:** Godot 4.3+

**Rationale:**
- Open source, zero royalties — critical for a small studio's margins
- GDScript is Python-like, reducing context-switching between engine code and the in-game scripting language
- Built-in tilemap system handles top-down pixel art natively
- Lightweight enough to run the sandboxed Python interpreter alongside the game without performance issues
- Export targets: Windows, Linux, Mac, Steam Deck (day 1). Switch port feasible post-launch via third-party tooling

**In-game scripting engine:** Custom sandboxed Python subset interpreter written in GDScript/C#. Supports: variables, functions, loops, conditionals, lists, dicts, classes, imports (game-provided modules only). Does NOT support: file I/O, networking, os/sys access. Syntax errors produce in-game "compiler error" messages on the robot's screen.

**Target specs:** 2D pixel art at 320x180 native resolution, scaled to display. 60 FPS on integrated graphics (Intel UHD 620+). RAM: under 1 GB.

---

## 7. Scope Estimate

**Team:** 4-5 people (1 game designer/producer, 1 engine programmer, 1 interpreter/tools programmer, 1 pixel artist/animator, 1 sound designer at 50%)

**Timeline: 24 months total**

| Phase | Duration | Deliverable |
|---|---|---|
| Pre-production | 3 months | GDD final, art style locked, interpreter prototype, 1 playable puzzle |
| Vertical Slice | 4 months | First 3 in-game days playable: basic coding, one robot, one circuit, day/night cycle, base building shell |
| Alpha (MVP) | 6 months | 15 in-game days, 5 robot types, full circuit builder, 30 coding challenges, save/load, Steam page live |
| Beta | 5 months | Full 60-day campaign, all 8 biomes, ML tier, balancing, localization (EN/ID/ZH/JA), Steam Next Fest demo |
| Polish & Launch | 4 months | Bug fixing, accessibility, tutorial refinement, launch marketing, community beta |
| Post-launch | 2 months | Patch cycle, workshop/mod support for user-created puzzles |

**MVP scope (Alpha):** Player can survive 15 in-game days. Core systems: code terminal, breadboard circuit builder, 5 robot types (gatherer, builder, scout, farmer, defender-drone), resource chain (water, oxygen, power, bio-fuel, metals), base building (8 structures), day/night cycle with alien weather.

**Budget estimate:** $250K-350K for 24 months with a 4-person team in a mid-cost region. Achievable with savings + a small publisher advance or Kickstarter ($50K target).

---

## 8. Monetization

**Model:** Premium, one-time purchase. $19.99 USD at launch. No microtransactions. No DLC planned for year 1.

**Rationale:** The Farmer Was Replaced proved $15-20 is the sweet spot for coding games. Premium aligns with the educational trust factor — parents and educators reject MTX. A $19.99 price at 100K units (conservative for the niche) yields ~$1.4M gross revenue after Steam's 30% cut.

**Post-year-1 DLC possibility:** "Advanced Systems" expansion ($9.99) adding: networking/distributed systems tier, multiplayer base-sharing, and a robotics competition mode.

---

## 9. Key Features

### 9.1 Programming System
- In-game terminal with syntax highlighting, auto-indent, and error messages
- Python-like language ("AstroScript") with 1:1 syntax mapping to real Python
- Game-provided API: `robot.move()`, `sensor.read("O2")`, `base.build("solar_panel")`, `radio.scan()`
- 60+ scripted challenges, plus freeform sandbox coding
- Code runs in real-time: you watch robots execute your instructions with visible state (LED indicators, console output)
- Built-in debugger: step-through execution, variable inspector, breakpoints

### 9.2 Circuit Builder
- Breadboard-style visual editor with drag-and-drop components
- Components: resistors, capacitors, LEDs, transistors, microcontrollers, sensors (temp, light, pressure, gas), motors, relays
- Circuits power and connect robot sensors/actuators to your code
- Failure states: short circuits blow fuses (resource cost), overvoltage damages components
- Progression: passive components (day 1) to digital logic (day 10) to custom microcontrollers (day 30) to full CPU design (day 50+)

### 9.3 Robot System
- 8 robot types, each with unique chassis, sensor slots, and actuator capabilities
- Robots are inert hardware until you write their control code
- Robots have energy budgets (battery life), sensor range limits, and cargo capacity — all tunable via better circuits
- Fleet management: assign robots to tasks, monitor via base terminal, debug remotely
- Late-game: robots share a mesh network you design, enabling swarm behaviors

### 9.4 AI & Machine Learning Tier (Late Game)
- Unlocks at day 40+, after mastering programming and circuits
- Decision trees: classify alien flora as edible/toxic based on sensor data you collected
- Regression: predict storm timing from atmospheric pressure history
- Neural networks: visual node editor where you set layer sizes, activation functions, learning rate
- Training uses in-game data your robots gathered — the dataset quality depends on YOUR sensor placement and code
- Final challenge: fully autonomous base that survives without player input for 10 in-game days

### 9.5 Survival & World
- 8 biomes with distinct resources, hazards, and weather patterns
- No combat. Threats are environmental: toxic gas pockets, electromagnetic storms (fry unshielded circuits), quakes (collapse poorly-built structures), temperature extremes
- Base building: modular structures snapped to grid. Power routing, oxygen piping, thermal insulation — all affect gameplay
- Alien flora/fauna are non-hostile but require study (data collection quests) to utilize
- 60 in-game day campaign with emergent replayability via different automation strategies

---

## 10. Risks & Mitigations

| # | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| 1 | **Interpreter performance tanks with complex user code** | High | High | Budget 3 months for interpreter optimization. Impose execution step limits per tick (10K steps). Profile early with worst-case scripts. Fallback: compile AstroScript to bytecode instead of tree-walking. |
| 2 | **Learning curve too steep — players quit before the fun starts** | High | Critical | First 3 in-game days are pure survival with guided coding (fix a broken O2 script, not write from scratch). Adaptive hint system that detects stuck players. Built-in code snippets library. Playtest with non-programmers monthly from month 4. |
| 3 | **Scope creep from combining 4 educational domains** | Medium | High | MVP locks to programming + basic circuits only. ML tier and advanced electronics are Alpha-exit gates — if they slip, they ship in a free update, not delay launch. Each domain has a hard content cap in the GDD (60 coding challenges, 20 circuit puzzles, 10 ML exercises). |
| 4 | **"Educational" label kills commercial appeal** | Medium | Medium | Never use the word "educational" in marketing. Position as "automation survival" (like Factorio). Let streamers and reviews discover the learning angle organically. The Farmer Was Replaced and Turing Complete both avoided the edu label and sold massively. |
| 5 | **Small team burnout over 24-month dev cycle** | Medium | High | Enforce 4-day work weeks. Vertical slice at month 7 is the go/no-go gate — if it's not fun, pivot or stop before sunk cost deepens. Monthly public devlogs create accountability and community momentum. |
