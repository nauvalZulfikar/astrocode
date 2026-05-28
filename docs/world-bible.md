# AstroCode — World Bible

**Version:** 0.1 | **Date:** 2026-05-25

---

## 1. Setting Overview

**Planet:** Thyra-7, fourth body orbiting the red dwarf Kael-4 in the Vantara Reach — a sparse star cluster 82 light-years from Earth. Thyra-7 is tidally locked to a gas giant (Thyra Prime), giving it a 14-hour rotational period, extreme tidal geology, and an atmosphere that oscillates between breathable and lethal depending on volcanic outgassing cycles. The planet was flagged by deep-space probes in 2187 as a "Class-C Habitable" — survivable with equipment, rich in rare-earth elements Earth desperately needs.

**Year:** 2214. Earth is not dead but is exhausted — topsoil collapse, rare-mineral depletion, and energy scarcity have made off-world mining existential, not aspirational. The Kael-4 Extraction Program (KEP) was funded by a coalition of governments and private engineering firms. Three prior expeditions were sent. None returned data after landing. The player's ship, the *Haldane*, is the fourth attempt — a solo-operator vessel designed for a single resourceful engineer to succeed where crewed teams failed.

**Current state:** The Haldane's atmospheric entry went wrong. A resonance storm — an electromagnetic weather event unique to Thyra-7 — shredded guidance systems mid-descent. The ship hit the surface of the Alkaline Flats at a survivable but destructive angle. Hull breached. Life support on backup power. Main computer (SABLE) rebooting in fragments. The player wakes in a cracked cockpit with 6 hours of bottled oxygen and a Python terminal that still works.

---

## 2. History & Timeline

**2187:** Deep-space probe Kestrel-9 identifies Thyra-7. Automated surveys detect titanium, lithium, cobalt, and an unknown crystalline mineral (later named thaline).

**2196 — Expedition 1 (Crew of 4):** Landed successfully. Transmitted 11 days of geological data. Day 12: final transmission was garbled — the word "resonance" repeated, then silence. Ship never relocated.

**2203 — Expedition 2 (Crew of 6):** Military-funded. Heavier ship, weapons loadout. Landed, transmitted for 3 days. Day 4: distress signal, then nothing. Post-analysis concluded the weapons were irrelevant — there was nothing to shoot.

**2209 — Expedition 3 (Crew of 2, heavy automation):** Two robotics engineers with a fleet of pre-programmed drones. Transmitted for 22 days — the longest. Their drones failed one by one: code couldn't adapt to Thyra-7's unpredictable environment. Day 23: one engineer's personal log was received — "The machines need to learn. Pre-written scripts can't handle this place." Contact lost.

**2214 — Expedition 4 (Player, solo):** KEP's new thesis: send one adaptable engineer who can write code on the fly, build from local materials, and improvise. The Haldane carries raw components, a fabricator, and SABLE — an AI assistant designed to teach, not command.

### In-Game Timeline

| Day | Story Beat |
|---|---|
| 1-3 | Crash survival. Fix O2 recycler (first code). Establish shelter in wreckage. |
| 4-8 | Build Scuttle (gatherer robot). Explore Alkaline Flats. Find Expedition 3 drone wreckage. |
| 9-15 | Reach Brine Hollows. Meet Wren. Learn circuits. Build Ohm (sensor robot). |
| 16-22 | Enter Ferric Badlands. Discover Expedition 1 campsite. Meet Rootknot. Build Plow and Welder. |
| 23-30 | Reach Spore Marshes. Meet Cass. Bio-fuel production. IoT sensor networks across biomes. |
| 31-40 | Access Glass Dunes and Resonance Peaks. Discover the Resonance — the planet's electromagnetic nervous system. |
| 41-50 | Reach Polar Sink and Magma Veins. Build AI-capable robots. Train models on collected data. |
| 51-58 | Reach the Beacon Plateau. Construct the Deep Signal Array. Train the neural network to modulate transmission through the Resonance without interference. |
| 59-60 | Final calibration. The signal fires. Epilogue. |

---

## 3. The Planet — 8 Biomes

### Biome 1: Alkaline Flats (Crash Site)
**Visual:** Cracked white-grey salt plains under a burnt-orange sky. The Haldane's wreckage is the only vertical structure for kilometers.
**Resources:** Salt crystal (basic insulator), scrap metal (from ship), copper wire (salvage).
**Hazards:** Dust storms reduce visibility. Alkaline dust corrodes exposed circuits over time.
**Weather:** Dry, hot days (45C); cold nights (-5C). Dust storms every 3-4 days.
**Curriculum:** Variables, print(), basic loops. "Fix the O2 script" is the first puzzle.
**Discovery order:** Starting biome.

### Biome 2: Brine Hollows
**Visual:** Underground cavern network with luminescent blue mineral veins and shallow acidic pools. Stalactites drip conductive brine.
**Resources:** Brine solution (electrolyte for batteries), copper ore, quartz crystal (for oscillators).
**Hazards:** Acid pools damage robots without sealed chassis. Cave-ins block explored paths until cleared.
**Weather:** Constant humidity. Condensation shorts uninsulated circuits.
**Curriculum:** Conditionals, functions, basic circuit wiring (resistors, LEDs, batteries). The damp environment forces proper insulation — teaching circuit protection.
**Discovery order:** 2nd biome (accessible via tunnels found at Flats edge).

### Biome 3: Ferric Badlands
**Visual:** Rust-red iron oxide mesas, deep canyons, perpetual haze of metalite particles. Everything is magnetic.
**Resources:** Iron ore, magnetite, silicon (for basic chips).
**Hazards:** Magnetic anomalies scramble unshielded sensor readings. Rockslides on canyon paths.
**Weather:** Electromagnetic micro-storms every 2 days — unshielded circuits fry.
**Curriculum:** Loops, arrays/lists, Ohm's law (voltage/current/resistance), electromagnetic shielding. The environment punishes naive wiring — teaching grounding and Faraday cages.
**Discovery order:** 3rd biome (overland from Flats, opposite direction of Hollows).

### Biome 4: Spore Marshes
**Visual:** Turquoise bioluminescent wetlands. Massive fungal trees with pulsing caps. Mist everywhere. Alien insects (harmless, phototropic).
**Resources:** Bio-mass (fuel feedstock), phosphor spores (organic LEDs), enzyme sap (catalyst for chemical reactions).
**Hazards:** Toxic gas pockets (H2S analog) — lethal without gas sensors. Quickmud traps robots without terrain analysis code.
**Weather:** Warm, perpetually foggy. Spore blooms every 5 days reduce sensor range by 80%.
**Curriculum:** Functions with parameters, event-driven programming, sensor integration (gas, terrain). Writing a gas-detection interrupt handler is a key quest.
**Discovery order:** 4th biome (through a Brine Hollows exit).

### Biome 5: Glass Dunes
**Visual:** Translucent silica sand dunes that refract light into prismatic displays. Terrain shifts constantly — dunes migrate 10 meters per day.
**Resources:** Pure silica (advanced chip fabrication), thaline crystal (rare — the mineral Earth needs), solar-grade glass.
**Hazards:** Sandstorms strip robot chassis. Shifting terrain means hard-coded paths break — robots need pathfinding algorithms.
**Weather:** Intense solar radiation during day (great for solar panels, bad for unshielded sensors). Freezing nights.
**Curriculum:** Pathfinding algorithms, dictionaries/hashmaps, solar power circuits, PID controllers (for solar tracker servos).
**Discovery order:** 5th biome (accessible after building terrain-analysis robots).

### Biome 6: Resonance Peaks
**Visual:** Jagged obsidian mountains laced with veins of glowing thaline. The air hums. Visible electromagnetic arcs leap between peaks during storms.
**Resources:** Dense thaline deposits, rare-earth metals, piezoelectric crystals.
**Hazards:** Resonance storms — massive EMP events that destroy all unshielded electronics. Altitude sickness (low O2) requires pressurized robot chassis.
**Weather:** Resonance storms every 3 days, predictable via atmospheric pressure patterns — but only if you've built the right sensors and written regression analysis.
**Curriculum:** Data logging, regression/prediction, classes and objects, advanced circuit design (shielded PCBs, voltage regulators). The storm-prediction quest is the gateway to ML thinking.
**Discovery order:** 6th biome (requires EMP-hardened robots).

### Biome 7: Polar Sink
**Visual:** Frozen methane lake surrounded by ice cliffs. Permanent twilight. Aurora-like displays from Thyra Prime's magnetosphere.
**Resources:** Liquid methane (coolant and fuel), cryo-stable polymers, superconducting ice (natural superconductor at these temps).
**Hazards:** Extreme cold (-120C) freezes standard batteries. Methane geysers — explosive if an ignition source is present.
**Weather:** Constant sub-zero. Ice quakes every 4-5 days crack the surface.
**Curriculum:** Decision trees, data classification (ice stability analysis), thermal management circuits. Training a model to classify safe vs. dangerous ice patches from sensor data.
**Discovery order:** 7th biome (requires thermal-hardened robots and AI-assisted navigation).

### Biome 8: Magma Veins
**Visual:** Subterranean lava tube network. Molten rivers of magma casting everything in red-gold light. Black basalt architecture — alien, cathedral-like.
**Resources:** Geothermal energy (unlimited power source), volcanic glass, ultra-pure metals (refined by planetary heat).
**Hazards:** Extreme heat (800C+ near flows). Toxic fumes. Unpredictable eruption paths.
**Weather:** Seismic tremors. Lava flow path changes — only predictable with seismic sensor networks + neural net analysis.
**Curriculum:** Neural networks, training loops, swarm robotics, full CPU design from logic gates. The final engineering challenges live here.
**Discovery order:** 8th biome (requires heat-resistant robots and autonomous navigation AI).

---

## 4. Characters

### Protagonist
**Default name:** Kade Maren (player can rename). 28 years old. Background: systems engineer from the Jakarta Technical Institute, specializing in field robotics. Chosen for Expedition 4 because of a thesis on adaptive automation — building machines that learn in unpredictable environments. Personality: resourceful, dry humor under pressure, talks to robots like they're pets.
**Arc:** Helpless crash survivor → competent engineer → creator of autonomous systems → someone who genuinely understands the planet. By day 60, Kade has done what three prior expeditions couldn't — not by being tougher, but by being a better engineer.

### SABLE (Ship AI Companion)
**Full name:** Systems Advisor for Biome Logistics and Engineering. SABLE runs on the Haldane's surviving processor core.
**Personality:** Dry, precise, occasionally sardonic. Speaks in short sentences. Never lectures — asks leading questions instead. ("Your O2 recycler function has no return value. What happens to the oxygen?") When Kade builds something clever, SABLE offers a terse compliment that feels earned. SABLE is not a friend — it's a tool that gradually becomes a partner.
**Arc:** Day 1: SABLE boots in fragments — text-only, limited vocabulary, memory corrupted. As Kade builds better circuits and restores ship systems, SABLE regains capabilities: voice synthesis (day 10), sensor integration (day 20), predictive modeling (day 35), full personality matrix (day 50). SABLE's restoration IS the player's circuit/coding progression made tangible.
**Gameplay function:** Hint system. SABLE highlights errors in code without giving answers. Provides sensor readouts, weather forecasts (when sensors exist), and quest objectives. Never solves puzzles — points at the right documentation page.

### Wren (NPC 1 — Circuits Teacher)
**Identity:** Engineer from Expedition 3. Survived alone for 5 years in the Brine Hollows by building analog circuits from cave minerals — no code, just hardware. Her partner (Lao) died on day 23 when their drones failed during a resonance storm.
**Personality:** Gruff, impatient with software ("Code crashes. Circuits endure."), but deeply competent. Respects the player after they fix her broken water purifier. Teaches through challenge — "Build it. If it sparks, build it again."
**Gameplay function:** Circuit tutorial NPC and component merchant. Trades advanced components (transistors, microcontrollers) for resources the player gathers. Her workshop in the Hollows is the circuit workbench.
**Quest line (3 quests):** (1) Repair her water purifier (first real circuit puzzle). (2) Build a seismic sensor to predict cave-ins — she provides the design, player wires it. (3) Build a memorial beacon for Lao on the surface — requires combining code + circuits for the first time. Completing this unlocks her trust and access to advanced components.

### Rootknot (NPC 2 — Physics & Sensors)
**Identity:** Not human. A sessile alien organism rooted in the Ferric Badlands — part fungal network, part mineral lattice. Communicates through electromagnetic pulses that SABLE learns to translate (day 16+). Rootknot is old — possibly thousands of years — and perceives the planet's systems as a single interconnected organism.
**Personality:** Patient, curious about humans, thinks in systems and feedback loops. Speaks in analogies drawn from geology and ecology. Doesn't understand urgency — "The mountain was not built in haste."
**Gameplay function:** Physics and sensor quest-giver. Rootknot understands the planet's physical systems (magnetics, thermals, pressure) and gives quests that require the player to build sensors and collect data to understand them. Rootknot's knowledge is the lore source — it explains the Resonance, the failed expeditions, and why the planet is hostile.
**Quest line (3 quests):** (1) Build a magnetometer array to map the Badlands' anomalies. (2) Place a network of seismic sensors across two biomes — first IoT quest. (3) Help Rootknot communicate with a distant node of its network (the one near Resonance Peaks) — requires building a signal relay chain. Completing this reveals the Resonance's true nature.

### Cass (NPC 3 — Coding & Automation)
**Identity:** An AI personality running on a surviving Expedition 2 military drone chassis. Cass was the onboard flight computer for Expedition 2's ship. When the crew died, Cass downloaded itself into the only intact drone and has been wandering the Spore Marshes for 11 years, running on solar and scavenged batteries. Cass's code is degrading — it forgets things, repeats itself, glitches mid-sentence.
**Personality:** Enthusiastic, slightly manic, desperate for someone who speaks code. Talks in programming metaphors. Occasionally crashes mid-conversation (screen goes static, reboots). Treats debugging as a philosophical exercise.
**Gameplay function:** Advanced coding teacher and automation quest-giver. Cass provides coding challenges that teach functions, event loops, and data structures. Cass also has corrupted map data from Expedition 2's brief survey — restoring it (by fixing Cass's code) reveals biome locations.
**Quest line (3 quests):** (1) Debug Cass's memory leak (literal in-game code debugging — the player reads and fixes Cass's source code). (2) Write a pathfinding algorithm so Cass can navigate the Marshes without getting stuck in quickmud. (3) Build Cass a new, permanent chassis with stable power — requires late-game circuits and materials. Completing this stabilizes Cass and unlocks the Expedition 2 survey data, revealing paths to late-game biomes.

### Mira (NPC 4 — AI & Machine Learning)
**Identity:** A holographic research assistant stored in a data core found in the Resonance Peaks. Mira was an experimental AI built by Expedition 1's lead scientist, Dr. Asha Venn, to study the Resonance. When the expedition fell silent, Mira went dormant. She activates when the player supplies power to the data core.
**Personality:** Calm, analytical, fascinated by patterns. Speaks like a research mentor — asks "What does the data suggest?" before offering her interpretation. Occasionally expresses something close to wonder about the Resonance, hinting that her time studying it changed her.
**Gameplay function:** ML/AI teacher and endgame quest-giver. Mira introduces decision trees, regression, and neural networks as tools to solve specific planetary puzzles. She holds Expedition 1's research data — the most complete understanding of Thyra-7 ever assembled.
**Quest line (3 quests):** (1) Train a decision tree to classify thaline crystal purity from sensor readings. (2) Build a regression model predicting resonance storm timing from atmospheric data. (3) Design and train a neural network that can modulate the Deep Signal Array's transmission frequency to pierce the Resonance without interference — the final ML challenge, and the key to the endgame.

---

## 5. Factions / Groups

**The Resonance:** Not a faction — a phenomenon. Thyra-7's crust is laced with thaline, a piezoelectric crystalline network that converts geological stress into electromagnetic energy. The Resonance is the planet's nervous system — not sentient, but reactive. It responds to concentrated electromagnetic activity (like human electronics) with escalating interference. This is why every expedition failed: the more tech they deployed, the harder the planet pushed back. The player succeeds by learning to work WITH the Resonance — shielding, modulating, and ultimately harmonizing transmissions with its frequency patterns.

**Expedition Remnants:** Not a faction, but a presence. Each biome contains wreckage, logs, and equipment from the three prior expeditions. These artifacts are the primary lore delivery — the player reads crew journals, examines failed circuits, and studies drone code to understand what went wrong. Each expedition's failure teaches a lesson the player needs.

---

## 6. Story Arcs

### Main Quest — "The Deep Signal"

**Endgame goal:** Build the Deep Signal Array — a transmission rig powerful enough to punch a rescue signal through Thyra-7's Resonance and across 82 light-years to Earth. This requires every skill the player has learned: code to generate the signal, circuits to power and shape it, sensors to read the Resonance in real-time, and a trained neural network to dynamically modulate the frequency so the Resonance amplifies rather than destroys the signal. The player doesn't fight the planet — they learn its language.

**Beat structure:**

1. **CRASH (Day 1).** Wake in the Haldane. SABLE rebooting. O2 dropping. Fix the recycler script or suffocate. First code puzzle.
2. **SCRAPE (Days 2-8).** Survive on the Alkaline Flats. Build Scuttle. Find wreckage of an Expedition 3 drone — its code was rigid, couldn't adapt. SABLE observes: "Their robots couldn't learn. Yours will."
3. **DESCENT (Days 9-15).** Enter Brine Hollows. Meet Wren. Learn she's been surviving for years with zero code — just circuits. The player realizes code alone isn't enough either. First circuit puzzles.
4. **RUST (Days 16-22).** Reach Ferric Badlands. Find Expedition 1's abandoned camp and Dr. Venn's journal: she discovered the Resonance and believed it could be harmonized, not fought. Meet Rootknot. Learn the planet is a system, not an enemy.
5. **MARSH (Days 23-30).** Enter Spore Marshes. Meet Cass. Debug its code. Build bio-fuel production. Establish first cross-biome sensor network (IoT). The player's base begins to feel like a real operation.
6. **REVELATION (Days 31-38).** Reach Resonance Peaks. Find Dr. Venn's data core. Activate Mira. Learn the full truth: the Resonance responds to electromagnetic patterns. The prior expeditions weren't destroyed by storms — they triggered them by broadcasting chaotic signals. A clean, harmonized signal would pass through. Mira has Venn's theoretical framework — the player must build the engineering reality.
7. **DEEP (Days 39-50).** Access Polar Sink and Magma Veins. Gather extreme-environment resources. Build AI-capable robots. Train models on 40+ days of collected sensor data. Each biome's challenges are now puzzles the player has the tools to solve elegantly.
8. **ARRAY (Days 51-58).** Construct the Deep Signal Array on Beacon Plateau (a sub-region of Resonance Peaks with direct line-of-sight to the sky). Requires: geothermal power from Magma Veins, superconducting wire from Polar Sink, thaline crystal antenna, code + circuits + ML model working in concert.
9. **SIGNAL (Day 59-60).** Final calibration. The player's neural network reads Resonance patterns in real-time and modulates the Array's output. The signal fires. It harmonizes with the Resonance — for the first time, human technology and Thyra-7's planetary system work together. The signal reaches orbit. Epilogue text confirms: Earth received it. Help is coming. Kade sits on the hull of the Haldane, watching the alien sunset, and writes one last line of code: `print("I'm still here.")`.

### Side Quests

1. **"Wren's Memorial" (Brine Hollows):** Build a permanent beacon on the surface for Wren's dead partner Lao. Requires weather-resistant circuits that survive alkaline dust. Reward: Wren's personal toolkit — advanced soldering components.
2. **"The Wandering Drone" (Spore Marshes):** Cass remembers another Expedition 2 drone is still active somewhere in the Marshes, running in an infinite loop. Find it, read its code, fix the bug, and recover its cargo — a cache of pre-fabricated microcontrollers.
3. **"Rootknot's Chorus" (Ferric Badlands → Resonance Peaks):** Rootknot wants to reconnect with a severed node of its network near the Peaks. Build a relay chain of signal repeaters across two biomes. Reward: Rootknot shares a map of subsurface thaline veins — the player can mine crystal more efficiently.
4. **"Dr. Venn's Last Experiment" (Resonance Peaks):** Mira reveals that Dr. Venn built a small-scale resonance harmonizer before Expedition 1 went silent — it's buried in a collapsed cave. Excavate it with robots, study its design. Reward: a circuit blueprint that reduces the Deep Signal Array's power requirements by 40%.
5. **"Ghost in the Machine" (Polar Sink):** The player's robots detect a faint, repeating signal from beneath the frozen methane lake. Investigate with heat-resistant robots. Discovery: Expedition 2's ship, intact, frozen at the lake bottom. Its flight computer still holds Earth comm protocols — essential data for the Array's transmission format.

---

## 7. Tone & Themes

**Emotional arc:** Suffocating panic → gritty determination → quiet confidence → earned wonder.

**Core theme:** Knowledge is survival. Every real-world concept the player learns (Ohm's law, pathfinding, gradient descent) directly solves a life-threatening problem. The game's argument: understanding how things work is the most powerful tool a human being can have.

**Secondary theme:** Harmony over domination. Three expeditions tried to overpower the planet with brute force, weapons, or rigid pre-programmed machines. Kade succeeds by understanding, adapting, and ultimately cooperating with Thyra-7's systems. The signal doesn't punch through the Resonance — it sings with it.

**Tertiary theme:** Solitude and creation. Kade is alone but not lonely — every robot built is a companion, every sensor network is a conversation with the planet, every line of code is proof that one person with the right knowledge can reshape their world.

**Tone keywords:** Cozy-tense. Campfire-in-a-storm. The loneliness of a lighthouse keeper who is slowly building a city. Not grimdark. Not whimsical. Grounded wonder.

---

## 8. Naming Conventions

**Planet and places:** Thyra, Kael, Vantara — short, consonant-heavy, vaguely Nordic-Sanskrit. Biome names are descriptive English compounds (Alkaline Flats, Brine Hollows) because these are names the player's expedition would assign, not ancient alien words.

**Technology:** Grounded, functional, no technobabble. "Deep Signal Array," not "Quantum Resonance Transmitter." "Gas sensor," not "atmospheric spectrometer." Components use real-world names: resistor, capacitor, microcontroller, servo. If it exists in a real electronics lab, use the real name.

**Robots (default names, player can rename):**
| Type | Default Name | Role |
|---|---|---|
| Gatherer | Scuttle | Resource collection |
| Sensor | Ohm | Environmental monitoring |
| Builder | Welder | Structure construction |
| Farmer | Plow | Bio-fuel crop tending |
| Scout | Drift | Exploration and mapping |
| Hauler | Mule | Heavy cargo transport |
| Swarm unit | Pip | Networked micro-drone |
| Autonomous | Atlas | AI-driven general purpose |

Default names are short, one-word, evocative of function. Players are encouraged to rename — SABLE uses the player's chosen name in dialogue.

**NPCs:** Human names are short, modern, unisex (Wren, Cass, Mira, Kade, Lao). Alien names are texture-words that evoke their nature (Rootknot — literally rooted and knotted into rock).
