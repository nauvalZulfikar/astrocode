# AstroCode -- Composer & Sound Designer Hiring Brief

**Document version:** 1.0 | **Date:** 2026-05-25
**Contact:** nauval.saga@gmail.com
**Role:** Freelance Composer / Sound Designer (full game audio package)

---

## 1. Project Overview

### The Game

**Title:** AstroCode
**Genre:** Top-down pixel art survival / automation / educational programming
**Engine:** Godot 4.3+
**Platforms:** Windows, Linux, Mac, Steam Deck (day one)
**Price:** $19.99 USD premium (no microtransactions)
**ESRB/PEGI:** E10+ / PEGI 7 -- no combat, no violence, mild sci-fi peril
**Visual style:** Pixel art, 320x180 native resolution scaled up. Think Stardew Valley meets Hyper Light Drifter in an alien landscape.
**Team size:** 4-5 people. You are the sole audio creator.

### Setting

The year is 2214. The player is Kade Maren, an engineer stranded on **Thyra-7** -- a tidally locked alien planet orbiting a red dwarf star. The planet has a 14-hour day, extreme tidal geology, and an atmosphere that oscillates between breathable and lethal. There are no enemies and no combat. The planet itself is the antagonist: toxic gas pockets, electromagnetic storms that fry circuits, temperature extremes, quakes, and corrosive dust.

The player survives by writing real Python-like code to program robots, wiring circuits on breadboards to power their base, and eventually training machine learning models. The game teaches real engineering skills through survival pressure -- you learn Ohm's law because your battery exploded, not because a textbook told you to.

There are 8 biomes, each with a distinct visual and atmospheric identity. Four NPCs are encountered across the 60-day campaign. A ship AI called SABLE serves as the player's companion, rebooting in fragments as the player restores ship systems.

### Audio Identity

**One line:** "Lo-fi chiptune meets ambient space synth." Warm, not cold. Hopeful, not bleak.

The sound should feel like a campfire inside a storm -- cozy tension. The planet is alien and vast, but Kade is building something. Every beep of a robot booting up, every hum of a circuit powering on, every wind gust across the salt flats should feel *handmade* and *intimate*, not orchestral or cinematic.

Think of the warmth of a soldering iron, the click of a mechanical keyboard, the satisfaction of a green LED turning on after debugging a circuit. The audio should reward the player's competence. Early game sounds desperate and sparse. Late game sounds rich, layered, alive with automation.

**Key descriptors:** Cozy-tense. Grounded wonder. Campfire-in-a-storm. The loneliness of a lighthouse keeper who is slowly building a city.

### Emotional Arc of the Game

The music must track this emotional progression across the 60-day campaign:

| Phase | Days | Emotional State | Audio Implication |
|---|---|---|---|
| Panic | 1-3 | Desperate, alone, everything is breaking | Sparse, tense, minimal instrumentation. Silence is used as a tool. |
| Foothold | 4-8 | Scrappy competence, first robot built | Motifs begin to emerge. A hint of warmth under tension. |
| Expansion | 9-15 | Growing confidence, meeting allies | Fuller arrangements, circuits-as-instruments aesthetic appears. |
| Reach | 16-22 | Harsh environment punishes mistakes | Tension spikes in Ferric Badlands. Magnetic hum as a musical element. |
| Automation | 23-30 | Player's base runs itself, pride | Layered, busy, almost cozy. The sound of a working workshop. |
| Revelation | 31-40 | Discovery of the Resonance, awe | Wonder. The planet's electromagnetic heartbeat becomes musical. |
| Mastery | 41-50 | AI-capable, designing intelligence | Cerebral, focused, complex textures. Neural nets as sonic metaphor. |
| Endgame | 51-60 | All skills converge, final signal fires | Culmination. All motifs woven together. Earned triumph, not bombast. |

### Reference Games for Audio Style

| Game | What to borrow |
|---|---|
| **Stardew Valley** (ConcernedApe) | The daytime warmth. Gentle, melodic, makes you want to stay in the world. Base interior should feel this warm. |
| **FTL: Faster Than Light** (Ben Prunty) | Tension layering. How the same track shifts from calm to urgent. Danger tracks and low-resource moments. |
| **Celeste** (Lena Raine) | Emotional synth work. How electronic instruments convey feeling -- loneliness, determination, triumph. The catharsis of summit themes. |
| **Outer Wilds** (Andrew Prahlow) | Wonder and exploration. The feeling of discovering something ancient and vast. Resonance Peaks and the Deep Signal Array should evoke this. |
| **Hyper Light Drifter** (Disasterpeace) | Atmosphere and texture. How ambient sound design and music blur together. The feeling of exploring alien ruins. |

---

## 2. Technical Specifications

### Audio Formats

| Type | Format | Sample Rate | Bit Depth | Channels | Notes |
|---|---|---|---|---|---|
| Music tracks | OGG Vorbis | 44.1 kHz | Quality 6+ (VBR) | Stereo | Must loop seamlessly |
| Sound effects | WAV | 44.1 kHz | 16-bit | Mono | No compression |
| Ambient loops | OGG Vorbis | 44.1 kHz | Quality 6+ (VBR) | Stereo | Must loop seamlessly |
| Stingers/fanfares | OGG Vorbis | 44.1 kHz | Quality 6+ (VBR) | Stereo | One-shot, no loop |

### Loudness Targets

| Type | Target | Metering |
|---|---|---|
| Music | -14 LUFS integrated | EBU R128 |
| SFX peaks | -10 LUFS peak | True peak |
| Ambient | -20 LUFS integrated (sits under music) | EBU R128 |
| UI sounds | -16 LUFS peak | True peak |

### Engine Integration

- **Engine:** Godot 4.3+ using native **AudioStreamPlayer**, **AudioStreamPlayer2D** (for positional SFX), and **AudioStreamPlayer3D** (not used -- game is 2D).
- **No middleware.** We are NOT using FMOD or Wwise. All playback is handled through Godot's built-in audio system.
- **Audio bus layout:**

```
Master
 +-- Music        (volume adjustable in settings)
 +-- SFX          (volume adjustable in settings)
 +-- Ambient      (volume adjustable in settings)
 +-- UI           (volume adjustable in settings)
```

- **Looping:** Godot's OGG importer supports seamless looping via the `loop` property. For each music and ambient track, you must provide a **loop metadata file** (see Delivery section) specifying the exact sample-accurate loop start and loop end points. If the track loops from the very beginning, state "loop_start: 0". If there is an intro section that should only play once, specify the loop_start sample after the intro.

### Music Looping Requirements

- All music tracks must loop seamlessly with no audible click, pop, or gap.
- Tracks with intros: the intro plays once, then the loop body repeats indefinitely. You must mark the loop_start point at the first sample of the repeating section.
- Crossfade-compatible: tracks may be crossfaded with other tracks at any point. Avoid placing critical musical moments at the very start or end of the loop body, as they may be cut off during transitions.
- Test all loops by playing them back-to-back at least 3 times. The seam must be inaudible.

---

## 3. MUSIC -- Complete Track List

### Motif System

Before composing, establish these recurring motifs:

| Motif | Description | Usage |
|---|---|---|
| **Kade's Theme** | A simple, human melody -- something someone might hum while working. Piano or acoustic instrument feel, even if synthesized. | Title screen, base interior, dawn transitions, credits. |
| **The Resonance** | A deep, pulsing electromagnetic drone that evolves from threatening (early game) to majestic (endgame). Built from processed sine waves and sub-bass. | Resonance Peaks biome, storm sequences, Deep Signal Array, endgame. |
| **Circuit Motif** | A short, rhythmic pattern made from electronic clicks, beeps, and processed mechanical sounds. Sounds like a working circuit board. | Circuit builder, code editor, robot themes, tech unlocks. |
| **Thyra's Voice** | An alien, non-human texture -- not a melody but a feeling. Wind through crystal, resonance harmonics, piezoelectric shimmer. | Biome ambients, discovery moments, Rootknot's theme. |

These motifs should be woven through different tracks so the soundtrack feels unified. The endgame track should incorporate all four motifs simultaneously.

---

### P0 -- Prototype (8 tracks, needed first)

These 8 tracks are required for the vertical slice demo. Deliver these as the first milestone.

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 1 | `mus_title` | Title screen / main menu | Wonder, invitation, slight melancholy | 80-90 | 2:00-2:30 | Yes (with intro) | Opens with Kade's Theme on a warm synth pad. Builds gently with arpeggiated chiptune elements. Should make the player feel like an adventure is about to begin. The intro (first 15-20 seconds) plays once; the rest loops. Reference: Outer Wilds main menu feel, but with chiptune warmth. |
| 2 | `mus_alkaline_day` | Alkaline Flats biome, daytime | Desolate but determined. Dry heat. Vast emptiness with purpose. | 95-105 | 2:30-3:00 | Yes | The first music the player hears in-game. Sparse arrangement -- a lone melodic line (Kade's Theme fragment) over a dusty, warm pad. Light percussive elements that sound like boots on salt crust. Subtle wind texture woven in. Should feel lonely but not hopeless. Think: the quiet dignity of working alone in a harsh place. |
| 3 | `mus_alkaline_night` | Alkaline Flats biome, nighttime | Colder, more exposed, uneasy quiet | 85-95 | 2:30-3:00 | Yes | Darker variant of `mus_alkaline_day`. Same motifs, lower register, reduced instrumentation. Add subtle crystalline tones (temperature dropping). The warmth retreats; tension creeps in. The player should feel the temperature change through the music. Stars-and-silence energy. |
| 4 | `mus_base_interior` | Inside sealed base rooms | Cozy, productive, safe. A workshop at night. | 85-95 | 2:30-3:00 | Yes | The "home" track. This is where the player feels safe. Warm lo-fi beat with soft electronic textures. Kade's Theme woven gently through the arrangement. Sounds like: a humming ventilation system, the glow of LED monitors, coffee brewing if coffee existed on Thyra-7. Reference: Stardew Valley indoor coziness, but with an electronic/space station flavor. Gentle Circuit Motif elements in the rhythm. |
| 5 | `mus_code_editor` | Code terminal is open and active | Focused, minimal, non-distracting. Flow state. | 75-85 | 3:00-4:00 | Yes | Lo-fi focus music. This track plays while the player is writing code, so it MUST be non-intrusive. No strong melodic hooks -- instead, gentle pads, very soft arpeggios, and subtle rhythmic pulses. Think: lo-fi hip-hop study beats, but with a space-station filter. Light Circuit Motif in the background. The player should be able to listen to this for 30 minutes without fatigue. Longer loop to reduce repetition during coding sessions. |
| 6 | `mus_circuit_builder` | Circuit breadboard editor is open | Focused but with more energy than code editor. Constructive. | 85-95 | 3:00-4:00 | Yes | Similar purpose to the code editor track (background focus music) but with more electronic texture. Incorporate sounds that evoke circuitry: filtered clicks, soft square-wave arpeggios, capacitor-charge swooshes. Slightly more rhythmic than the code editor track. The player is building physical things here -- the music should have a tactile, constructive feel. |
| 7 | `mus_danger` | Low HP (<20), low O2 (<15 units), or active environmental hazard | Urgent, tense, adrenaline | 120-140 | 0:30-0:45 | Yes (tight loop) | Short, intense loop. Driving pulse, dissonant stabs, alarm-like tones. This plays when the player is about to die. It should create urgency without being annoying (since the player may need to debug code under this pressure). Not a full arrangement -- more of a rhythmic tension bed. Cuts immediately when danger passes (crossfade to previous track). |
| 8 | `mus_discovery` | Tech tier unlock, quest complete, major milestone | Triumph, satisfaction, earned pride | Free | 0:05-0:10 | No (one-shot stinger) | A short fanfare/stinger that plays over whatever music is active. Must work when layered on top of any other track. Kade's Theme fragment, ascending, resolving on a major chord. Chiptune + warm synth. The feeling of: "I built that. It works." Should make the player smile. 3 variants needed: small discovery (item found), medium (quest complete), large (tech tier unlocked). |

---

### P1 -- Alpha (18+ tracks)

These tracks are needed for the full alpha build. Deliver as the second milestone.

#### Biome Themes (Day Variants) -- 7 tracks

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 9 | `mus_brine_day` | Brine Hollows (underground caverns) | Mysterious, dripping, echoing, hidden beauty | 70-80 | 2:30-3:00 | Yes | Underground. Reverb is a compositional tool here -- everything should sound like it's bouncing off wet cave walls. Slow, dripping rhythmic elements. Bioluminescent blue mood. Sparse melody that echoes and fades. Use delay effects to simulate cave acoustics. Occasional deep sub-bass rumble (geological). This is where the player meets Wren and learns circuits, so weave in faint Circuit Motif hints. Contemplative, not threatening. |
| 10 | `mus_ferric_day` | Ferric Badlands (rust-red iron mesas) | Harsh, exposed, magnetically charged | 100-110 | 2:30-3:00 | Yes | Aggressive terrain, aggressive sound. A low magnetic hum sits under the entire track as a drone (processed sine wave, slightly detuned). Percussion sounds metallic -- struck iron, rust scraping. Melody is angular, in a minor key, but with moments of awe (these canyons are vast). The Resonance Motif appears here for the first time as a distant, ominous undercurrent. This biome has EMP storms -- the music should feel like the air is charged. |
| 11 | `mus_spore_day` | Spore Marshes (bioluminescent wetlands) | Organic, alien, lush, wonder | 80-90 | 2:30-3:00 | Yes | The most "alive" biome. Music should feel biological -- pulsing, breathing, growing. Use organic-sounding synths (filtered saw waves that sound like insect wings, bubbly arpeggios). Bioluminescent turquoise mood. Thyra's Voice motif is prominent here -- this is where the planet feels least hostile. Gentle and curious. Think: David Attenborough documentary scoring, but synthesized and alien. This is the biome where Cass lives -- a dying AI drone -- so there's an undercurrent of digital fragility. |
| 12 | `mus_glass_day` | Glass Dunes (translucent silica dunes) | Shimmering, refractive, beautiful but dangerous | 90-100 | 2:30-3:00 | Yes | Light and glass. Use high-register crystalline tones -- processed bells, glass harmonica textures, prismatic arpeggios that shimmer. The terrain shifts constantly, so the music should feel unstable but beautiful. Rhythmic sand-shifting sounds woven into the percussion. Solar radiation is intense here -- brightness in the mix. This biome requires pathfinding algorithms, so there's a puzzle-solving energy. Complex but alluring. |
| 13 | `mus_resonance_day` | Resonance Peaks (obsidian mountains, thaline veins) | Awe, electromagnetic tension, the planet's heartbeat | 75-85 | 3:00-3:30 | Yes | **This is the most important biome track.** The Resonance Motif is fully realized here. The planet's electromagnetic nervous system is audible -- deep, pulsing, alive. Sub-bass heartbeat. Thaline crystal harmonics (high, shimmering overtones). Visible electromagnetic arcs between peaks should be reflected in occasional crackling synth textures. The mood is: standing before something vast and ancient that is not hostile but could destroy you if you're careless. Cathedral-scale awe. Mira is found here -- her theme weaves in subtly. |
| 14 | `mus_polar_day` | Polar Sink (frozen methane lake, permanent twilight) | Vast emptiness, crystalline cold, aurora | 65-75 | 2:30-3:00 | Yes | Cold. Space. Silence used deliberately. Long sustained notes that shimmer like ice. Aurora-inspired textures -- slow, undulating, colorful-but-cold pads. Crystalline percussion (ice tapping, frozen metal). The melody should feel fragile, like it might shatter. Sub-zero solitude. This biome is about classification and decision-making (ice stability analysis), so there's a cerebral, analytical undertone. Minimal but haunting. |
| 15 | `mus_magma_day` | Magma Veins (subterranean lava tubes) | Deep, rumbling, intense, cathedral-like | 85-95 | 3:00-3:30 | Yes | Massive. The deepest biome, both physically and musically. Low-frequency rumble as a constant foundation. Molten textures -- distorted bass, thermal shimmer in the high end. But also grandeur: this is described as "cathedral-like" in the game docs. The architecture is alien and awe-inspiring. Brass-like synth swells. This is where neural networks and CPU design happen -- the most complex engineering. The music should feel like forging something in a planetary furnace. Powerful, not threatening. |

#### NPC Themes -- 4 tracks

Short character motifs that play during dialogue with each NPC. Each should be distinct and reflective of the character's personality.

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 16 | `mus_npc_wren` | Dialogue with Wren (circuit teacher, Brine Hollows) | Gruff, competent, bittersweet. Hardware pragmatist. | 80-90 | 0:20-0:30 | Yes (short loop) | Wren survived alone for 5 years using only analog circuits -- no code. She's gruff and impatient but deeply skilled. Her motif should sound handmade -- like a circuit she'd build. Warm analog synth, slightly rough-edged. A minor-key melody that resolves warmly, reflecting her tough exterior and caring interior. She lost her partner Lao -- there's grief underneath. Instrumentation: analog-sounding synth, maybe a bit of static or hum, like old radio equipment. |
| 17 | `mus_npc_rootknot` | Dialogue with Rootknot (alien organism, Ferric Badlands) | Ancient, patient, geological. Thinks in millennia. | 55-65 | 0:20-0:30 | Yes (short loop) | Rootknot is a sessile alien organism -- part fungal network, part mineral lattice. It communicates through electromagnetic pulses. Its theme should sound inhuman but not threatening. Deep, slow, resonant tones. Thyra's Voice motif is central here. Think: the sound of tectonic plates shifting, slowed down 1000x and made musical. Geological patience. No percussion -- only sustained, evolving textures. |
| 18 | `mus_npc_cass` | Dialogue with Cass (degrading AI in a drone chassis, Spore Marshes) | Enthusiastic, glitchy, manic, fragile | 110-120 | 0:20-0:30 | Yes (short loop) | Cass is an AI personality whose code is degrading. It's enthusiastic and talks in programming metaphors but crashes mid-sentence. The motif should be energetic and digital -- chiptune-forward, fast arpeggios -- but with intentional glitches. Bit-crushing, buffer stutters, notes that skip or repeat unexpectedly. The music itself has bugs. Underneath the glitches, there's a genuine, hopeful melody trying to get through. Circuit Motif is prominent. |
| 19 | `mus_npc_mira` | Dialogue with Mira (holographic AI, Resonance Peaks) | Calm, analytical, quietly awed | 70-80 | 0:20-0:30 | Yes (short loop) | Mira is a research AI who studied the Resonance for years before going dormant. She's calm and analytical but expresses something close to wonder. Her theme should be clean, precise, and beautiful -- like a perfectly solved equation. Crystalline digital tones, precise timing, mathematical intervals. The Resonance Motif appears refined and tamed in her theme -- she understood it before anyone else. A hint of Kade's Theme suggests human-AI connection. |

#### Weather & Event Tracks -- 3 tracks

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 20 | `mus_storm_approach` | Storm detected, 30-60 seconds before arrival | Building tension, pressure dropping | 100-110 | 0:45-1:00 | Yes | Tension builder. Low rumble crescendo. Wind picking up. Electromagnetic crackle increasing in frequency. This track crossfades INTO the current biome music over 30 seconds (the biome music ducks, this fades in). It should work when layered over any biome track. Builds but never resolves -- the resolution is the storm hitting. |
| 21 | `mus_storm_active` | Active electromagnetic/dust storm | Chaotic, overwhelming, EMP crackle | 130-140 | 1:00-1:30 | Yes | Full storm. This is the most intense track in the game. Chaotic but still musical -- not noise. Electromagnetic crackle, distorted bass swells, wind howling through processed reverb. The Resonance Motif, distorted and aggressive. The player must either shelter or risk their circuits frying. This should feel like being inside a washing machine made of lightning. Urgent but not panic -- the player has tools if they've prepared. |
| 22 | `mus_dawn` | Night-to-day transition | Hope, relief, new beginning | Free | 0:08-0:12 | No (stinger) | A brief musical phrase that plays during the dawn transition. Ascending, resolving, warm. Kade's Theme fragment in a major key. The feeling of: "I survived the night. Time to build." Played over the biome music transition (night variant crossfading to day variant). |

#### Endgame -- 1 track

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 23 | `mus_deep_signal` | Deep Signal Array construction and final calibration (Days 51-60) | Culmination, earned wonder, all motifs converge | 80-90, building | 3:30-4:00 | Yes (with extended intro) | **The most emotionally important track in the game.** This plays during the final sequence where the player activates the Deep Signal Array -- the transmitter that sends a rescue signal across 82 light-years by harmonizing with the planet's electromagnetic Resonance. All four motifs must appear: Kade's Theme (humanity, perseverance), The Resonance (the planet's voice), Circuit Motif (everything the player built), Thyra's Voice (the alien world). Start sparse and build. The intro section (60-90 seconds, plays once) accompanies the final calibration -- tension, neural network readings, will it work? Then the loop body: the signal fires. Human technology and planetary system singing together. This is not a victory march -- it's a moment of harmony. The player's 60 days of learning have led to this. Reference: the emotional weight of Celeste's summit theme or Outer Wilds' final moments. Earned catharsis. |

---

### P2 -- Polish (16+ tracks)

These tracks are needed for the beta/launch build. Deliver as the third and final milestone.

#### Night Variants for All Biomes -- 7 tracks

Each biome has a night variant that is a darker, quieter reinterpretation of the day theme. Same motifs, lower register, reduced instrumentation, increased ambient texture. The night variant must crossfade seamlessly with the day variant over the 1-minute dusk/dawn transition period.

| # | Track ID | Base Track | Notes |
|---|---|---|---|
| 24 | `mus_brine_night` | `mus_brine_day` | Even more echo, slower drips, deeper sub-bass. Near-silent stretches. |
| 25 | `mus_ferric_night` | `mus_ferric_day` | Magnetic hum more prominent, melody recedes, metallic percussion becomes sparse. |
| 26 | `mus_spore_night` | `mus_spore_day` | Bioluminescence intensifies at night -- the music should glow more. Phosphorescent textures, softer rhythm. |
| 27 | `mus_glass_night` | `mus_glass_day` | Freezing nights in Glass Dunes. Crystalline shimmer cools to ice. Temperature drop audible in the tonal shift. |
| 28 | `mus_resonance_night` | `mus_resonance_day` | Electromagnetic arcs more visible at night. The Resonance Motif is more exposed, more raw. Haunting. |
| 29 | `mus_polar_night` | `mus_polar_day` | Permanent twilight means night is barely different -- but aurora intensifies. More undulating color-pads. |
| 30 | `mus_magma_night` | `mus_magma_day` | Underground, so day/night is about surface seismicity. Night: calmer lava, deeper rumble, more meditative. |

#### Credits & Trailer -- 2 tracks

| # | Track ID | Context | Mood | Tempo (BPM) | Duration | Loop? | Description |
|---|---|---|---|---|---|---|---|
| 31 | `mus_credits` | End credits scroll | Reflective, warm, journey's end | 85-95 | 2:30-3:00 | No | A composed piece (not a loop) that plays during the credits. References all major motifs in sequence: Circuit Motif (early game memories), Thyra's Voice (the planet), The Resonance (the challenge), and resolves on Kade's Theme (the human who survived). Should feel like flipping through a photo album of the adventure. Ends quietly. |
| 32 | `mus_trailer` | Marketing trailer (60 seconds) | Dramatic arc: quiet discovery to urgent survival to triumphant engineering | Varies (60-140) | 0:55-1:05 | No | Three-act structure in 60 seconds. ACT 1 (0-15s): Quiet. A lone synth note. Wind. Kade's Theme, fragile. ACT 2 (15-40s): Building. Circuit Motif enters. Percussion kicks in. Storm sounds. Danger. Quick cuts musically. ACT 3 (40-60s): Payoff. The Resonance Motif harmonized. Full arrangement. Triumphant resolution. Final hit. Silence. Title card. This must work as a standalone piece for a Steam trailer. |

---

## 4. SFX -- Complete Sound Effects List

All sound effects must be delivered as WAV, 44.1 kHz, 16-bit, mono. Where multiple variants are specified, each variant must be sonically distinct (not just pitch-shifted copies -- re-record/re-synthesize).

**Total estimated SFX count: 128 individual files** (see breakdown below).

---

### 4.1 Player (16 SFX)

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 1-3 | `sfx_player_step_salt_01/02/03` | Footstep on salt/alkaline flat surface | 3 | Crunchy, dry, crystalline. Like walking on compacted road salt. |
| 4-6 | `sfx_player_step_stone_01/02/03` | Footstep on cave/stone surface | 3 | Hard, echoey, solid. Brine Hollows and Magma Veins. |
| 7-9 | `sfx_player_step_marsh_01/02/03` | Footstep on wet/marshy ground | 3 | Squelchy, organic, damp. Spore Marshes. |
| 10-12 | `sfx_player_step_sand_01/02/03` | Footstep on sand/silica | 3 | Soft, shifting, granular. Glass Dunes. |
| 13-15 | `sfx_player_step_metal_01/02/03` | Footstep on metal base flooring | 3 | Metallic, hollow, indoor. Inside the base and Haldane wreckage. |
| 16 | `sfx_player_sprint_breath` | Heavy breathing during sprint | 1 | Loopable. Rhythmic panting. Subtle -- not overpowering. Fades in when sprinting, fades out when stopping. |
| 17 | `sfx_player_gather` | Pick up a resource item | 1 | A satisfying short grab/collect sound. Tactile, not magical. |
| 18-19 | `sfx_player_hurt_01/02` | Player takes damage | 2 | Short grunt/gasp of pain. Gender-neutral. No screaming. |
| 20 | `sfx_player_death` | Player HP reaches 0 | 1 | Collapse sound. Body hitting ground + brief silence. Not dramatic -- matter-of-fact. |
| 21 | `sfx_player_heal` | Player heals (eat food / use med-kit) | 1 | Warm, restorative. A soft chime + organic crunch (eating) combined. |
| 22 | `sfx_player_o2_alarm` | Low oxygen warning (<15 units) | 1 | Loopable. Urgent beeping -- rhythmic, impossible to ignore. SABLE-style alarm. Should create anxiety but not be physically unpleasant. Medium-high pitch. |
| 23 | `sfx_player_heartbeat` | Low HP warning (<20 HP) | 1 | Loopable. Heartbeat pulse, slightly distorted. Layered under the danger music. Slow enough to not be frantic -- dread, not panic. |

### 4.2 Robots (22 SFX)

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 24 | `sfx_robot_boot` | Robot powers on / initializes | 1 | Electronic whir building to a confirming beep. Like a computer POST but smaller, cuter. 1-2 seconds. |
| 25 | `sfx_robot_shutdown` | Robot powers down | 1 | Power-down whine -- descending pitch, systems going quiet. Brief. Slightly sad. |
| 26-31 | `sfx_robot_move_scuttle` / `_ohm` / `_welder` / `_plow` / `_drift` / `_mule` | Robot movement loop, one per type | 6 | Each robot type needs a distinct locomotion sound. Scuttle: skittering metal legs. Ohm: quiet wheeled hum (sensor bot, stealthy). Welder: heavy treads. Plow: grinding soil contact. Drift: fast, light hover/wheels (scout, 2x speed). Mule: heavy, lumbering, cargo rattling. All loopable. |
| 32 | `sfx_robot_move_pip` | Pip (swarm micro-drone) hover | 1 | Tiny buzz. Like a small quadcopter. Very soft. Loopable. Almost cute. |
| 33 | `sfx_robot_move_atlas` | Atlas (autonomous AI robot) movement | 1 | Smooth, confident, mechanical. The most "premium" sounding robot. Servo whirs + subtle hydraulics. Loopable. |
| 34 | `sfx_robot_gather` | Robot grabs/collects a resource | 1 | Mechanical claw grab. Click + grip. Satisfying. |
| 35 | `sfx_robot_build` | Robot constructing/welding | 1 | Welding arc + metal joining. Loopable. Plays while Welder builds a structure. |
| 36 | `sfx_robot_error` | Robot encounters an error (code bug, blocked path) | 1 | Error buzz + descending beep. Not harsh -- informative. The player made a mistake, not the robot. |
| 37 | `sfx_robot_low_battery` | Robot battery low warning | 1 | Gentle, rhythmic beep. Slower than O2 alarm. Polite warning, not urgent panic. |
| 38 | `sfx_robot_charge` | Robot docking at charging station | 1 | Electronic connection snap + soft rising hum (charging). One-shot trigger on dock. |
| 39 | `sfx_atlas_process` | Atlas AI running a computation | 1 | Subtle data-crunch sound. Digital processing texture. Brief (1-2 seconds). Plays when Atlas runs `ai.predict()` or `ai.decide()`. Think: a hard drive seeking, but synthesized and clean. |

### 4.3 Circuits (12 SFX)

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 40 | `sfx_circuit_wire_connect` | Wire snaps into place on breadboard | 1 | Precise click/snap. Tactile. Satisfying. |
| 41 | `sfx_circuit_component_place` | Component placed on breadboard | 1 | Soft mechanical thud. Component seating into pin holes. |
| 42 | `sfx_circuit_power_on` | Circuit board receives power | 1 | Low electric hum fading in. A circuit waking up. 1-2 seconds. |
| 43 | `sfx_circuit_short` | Short circuit (wire connects +V to ground) | 1 | Spark + zap. Brief, sharp. Not explosion-level -- a blown fuse. |
| 44 | `sfx_circuit_burnout` | Component destroyed by overvoltage | 1 | Fizzle + pop + brief smoke sizzle. The component is gone. Slightly comical -- not devastating. |
| 45 | `sfx_circuit_emp` | EMP storm hits unshielded circuit | 1 | Massive electromagnetic crackle + abrupt silence. The biggest circuit failure. Dramatic. Everything goes dark for a beat, then ambient sound returns. 2-3 seconds total. |
| 46 | `sfx_circuit_led_on` | LED component lights up | 1 | Tiny tick/click. Almost inaudible on its own, but satisfying when wiring your first circuit. |
| 47 | `sfx_circuit_servo` | Servo motor activating | 1 | Short mechanical whir. Like a hobby servo moving to position. |
| 48 | `sfx_circuit_oscillator` | Oscillator generating clock signal | 1 | Rhythmic tick at adjustable speed. Loopable. Very electronic. |
| 49 | `sfx_circuit_relay` | Relay clicking on/off | 1 | Mechanical click. Old-school relay sound. |
| 50 | `sfx_circuit_capacitor_charge` | Capacitor charging up | 1 | Rising whine that plateaus. Short. |
| 51 | `sfx_circuit_capacitor_discharge` | Capacitor discharging | 1 | Quick descending zap. Complement to charge sound. |

### 4.4 Code Editor (8 SFX)

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 52-54 | `sfx_code_key_01/02/03` | Keystroke in code editor | 3 | Soft mechanical keyboard press. Not clacky-loud -- subtle, like a quality low-profile mech keyboard. Each variant slightly different. Played on every character typed. Must be pleasant at high frequency (fast typing). |
| 55 | `sfx_code_run` | Player executes their code (Run button) | 1 | Confirm beep + brief processing sound. "Your code is being compiled." Satisfying. Electronic. |
| 56 | `sfx_code_error` | Code has a syntax/runtime error | 1 | Error buzz. Brief, informative. Not punishing -- the player will hear this a lot and shouldn't dread it. More "hmm, try again" than "WRONG." |
| 57 | `sfx_code_success` | Code executes without errors | 1 | Satisfying chime. The most important SFX for player retention. This sound means "your code works." It should trigger a tiny dopamine hit every time. Bright, clean, resolving upward. |
| 58 | `sfx_code_sable_ping` | SABLE (ship AI) sends a message/hint | 1 | Soft notification ping. Gentle, non-intrusive. Like a gentle tap on the shoulder. SABLE is helpful, not nagging. |
| 59 | `sfx_code_terminal_open` | Terminal/code editor opens | 1 | CRT power-on sound. Brief static burst into clean hum. Retro-tech. |
| 60 | `sfx_code_terminal_close` | Terminal/code editor closes | 1 | CRT power-off sound. Descending whine to silence. The inverse of the open sound. |

### 4.5 UI (12 SFX)

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 61 | `sfx_ui_navigate` | Menu cursor moves to next item | 1 | Soft tick. Very short. Non-intrusive. Played frequently during menu navigation. |
| 62 | `sfx_ui_select` | Menu item selected/confirmed | 1 | Confirm click. Slightly more substantial than navigate. Clear "yes" feeling. |
| 63 | `sfx_ui_back` | Menu back / cancel | 1 | Soft descending tone. Gentle "no" or "back." Not negative -- just navigational. |
| 64 | `sfx_ui_inventory_open` | Inventory panel opens | 1 | Slide/drawer opening. Mechanical, smooth. |
| 65 | `sfx_ui_inventory_close` | Inventory panel closes | 1 | Slide/drawer closing. Complement to open. |
| 66 | `sfx_ui_item_pickup` | Resource/item added to inventory (notification) | 1 | Soft bling. Brief, pleasant. Player hears this constantly while gathering. Must not be annoying at high frequency. |
| 67 | `sfx_ui_quest_accept` | New quest accepted | 1 | Short ascending fanfare. 1-2 seconds. "Adventure awaits" energy. Distinct from discovery stinger -- this is a commitment, not an achievement. |
| 68 | `sfx_ui_quest_complete` | Quest objective completed | 1 | Longer fanfare. 2-3 seconds. More celebratory than quest accept. Resolves satisfyingly. Distinct from `mus_discovery` stinger. |
| 69 | `sfx_ui_day_transition` | Dawn arrives (day counter increments) | 1 | Soft, warm chime. A new day. Gentle. Plays alongside `mus_dawn` stinger. |
| 70 | `sfx_ui_night_transition` | Night falls | 1 | Lower tone chime. Same timbre family as day transition, but darker and more subdued. A shift, not a warning. |
| 71 | `sfx_ui_save` | Game saved (autosave or manual) | 1 | Brief electronic confirmation. Subtle -- should not break immersion. |
| 72 | `sfx_ui_notification` | Generic notification (non-SABLE) | 1 | Soft pop. Even gentler than SABLE ping. For system messages. |

### 4.6 Environment (15 SFX)

These are one-shot or short sound effects triggered by environmental events. They are distinct from the ambient loops (Section 4.7) which play continuously.

| # | SFX ID | Description | Variants | Notes |
|---|---|---|---|---|
| 73 | `sfx_env_wind_gust` | Wind gust (Alkaline Flats, Ferric Badlands) | 1 | A single wind gust. 2-3 seconds. Used for punctuation, not constant play. |
| 74-75 | `sfx_env_drip_01/02` | Water dripping (Brine Hollows) | 2 | Individual drip sounds at random intervals. Vary pitch and timing between variants. Echoey. |
| 76 | `sfx_env_magnetic_pulse` | Magnetic anomaly pulse (Ferric Badlands) | 1 | A brief, low electromagnetic thrum. Plays when near magnetic anomalies. Unsettling but not loud. |
| 77 | `sfx_env_spore_pop` | Spore popping (Spore Marshes) | 1 | Organic pop. Like a small soap bubble, but wetter. |
| 78 | `sfx_env_sand_shift` | Sand dune shifting (Glass Dunes) | 1 | Granular sliding sound. 1-2 seconds. Sand moving underfoot or nearby. |
| 79 | `sfx_env_arc_crackle` | Electromagnetic arc between peaks (Resonance Peaks) | 1 | Electrical arc. Brief, sharp, impressive. Like a small lightning strike between obsidian towers. |
| 80 | `sfx_env_ice_crack` | Ice cracking (Polar Sink) | 1 | Deep, resonant crack. Ominous. Sounds structural -- like the ground is unstable. |
| 81 | `sfx_env_lava_bubble` | Lava bubble bursting (Magma Veins) | 1 | Deep, wet pop. Intense heat implied. |
| 82 | `sfx_env_storm_wind` | Storm wind building | 1 | Loopable wind that builds in intensity. Used for dust storms and resonance storms. Layers over ambient. |
| 83 | `sfx_env_storm_crackle` | EMP crackle during resonance storm | 1 | Electromagnetic static and crackle. Loopable. Layered during active storms. |
| 84 | `sfx_env_quake_rumble` | Seismic tremor / earthquake | 1 | Deep rumble. 3-5 seconds. Screen shake accompanies this. Felt more than heard. |
| 85 | `sfx_env_explosion_small` | Small explosion (capacitor blow, minor structural failure) | 1 | Contained pop/bang. Not military -- more like a pressure vessel release. |
| 86 | `sfx_env_gas_hiss` | Toxic gas pocket release (Spore Marshes) | 1 | Pressurized hiss. 1-2 seconds. Warning sound -- the player should learn to fear this. |
| 87 | `sfx_env_cave_in` | Cave-in / rockfall (Brine Hollows) | 1 | Crumbling stone, falling debris. 2-3 seconds. Dramatic but contained. |

### 4.7 Ambient Loops (9 loops)

Continuous background ambient soundscapes, one per biome plus the base interior. These play on the Ambient audio bus, under the music, at -20 LUFS. They provide the environmental "bed" that the music sits on top of. All must loop seamlessly.

| # | Track ID | Biome | Duration | Description |
|---|---|---|---|---|
| 88 | `amb_alkaline` | Alkaline Flats | 1:30-2:00 | Persistent dry wind + distant metallic creaks from the Haldane wreckage + occasional grit/sand patter. Vast, open, dry. Lonely wind. |
| 89 | `amb_brine` | Brine Hollows | 1:30-2:00 | Dripping water at random intervals + cave echo (natural reverb character) + faint mineral resonance (a barely audible crystalline hum from the luminescent veins). Damp, enclosed, mysterious. |
| 90 | `amb_ferric` | Ferric Badlands | 1:30-2:00 | Low magnetic drone (constant, subtle, felt more than heard) + wind gusts through canyons + distant metallic scraping. Charged, tense, open. |
| 91 | `amb_spore` | Spore Marshes | 1:30-2:00 | Alien insect-like chirps (phototropic, rhythmic) + gentle bubbling from marsh pools + occasional spore pops (organic, wet). Alive, organic, teeming. The most sonically rich ambient. |
| 92 | `amb_glass` | Glass Dunes | 1:30-2:00 | Sand whisper (granular, constant, like white noise but warmer) + prismatic shimmer (subtle high-frequency harmonics, as if light refracting through glass could be heard). Bright, shifting, unstable. |
| 93 | `amb_resonance` | Resonance Peaks | 1:30-2:00 | Deep planetary hum (the Resonance itself -- sub-bass, pulsing slowly like a heartbeat) + distant electrical arc crackle (sporadic) + wind through obsidian crevices. Immense, alive, ancient. |
| 94 | `amb_polar` | Polar Sink | 1:30-2:00 | Ice expansion groans (slow, deep, structural) + methane whistle (thin, eerie, wind through geysers) + crystalline tinkling (ice particles). Cold, vast, lonely. Silence is a feature -- leave breathing room. |
| 95 | `amb_magma` | Magma Veins | 1:30-2:00 | Deep subterranean rumble (constant, felt in the chest) + lava flow (thick, viscous movement) + heat shimmer (high-frequency hiss, like air above a furnace). Powerful, enclosed, hot. |
| 96 | `amb_base` | Base interior | 1:30-2:00 | Ventilation hum (steady, soothing white noise) + electronics buzz (soft, intermittent, like a server room) + O2 recycler rhythm (a gentle mechanical breathing pattern -- in, process, out). Safe, familiar, homey. This ambient should feel comforting -- the sonic equivalent of being indoors during a storm. |

---

## 5. Adaptive Audio Rules

The game uses Godot's AudioStreamPlayer with crossfading logic handled in GDScript. You do not need to implement the audio system -- just ensure your deliverables support these behaviors.

### 5.1 Music Transitions

| Trigger | Behavior | Duration |
|---|---|---|
| Biome transition (walk between biomes) | Current biome track crossfades to new biome track | 2 seconds |
| Day-to-night transition | Day variant crossfades to night variant | 60 seconds (the full dusk period) |
| Night-to-day transition | Night variant crossfades to day variant + `mus_dawn` stinger plays | 60 seconds (the full dawn period) |
| Enter sealed base room | Outdoor music fades out, `mus_base_interior` fades in | 1.5 seconds |
| Exit sealed base room | `mus_base_interior` fades out, current biome track fades in | 1.5 seconds |
| Open code editor | Current music ducks -6 dB, `mus_code_editor` fades in on top | 1 second |
| Close code editor | `mus_code_editor` fades out, current music returns to full volume | 1 second |
| Open circuit builder | Current music ducks -6 dB, `mus_circuit_builder` fades in on top | 1 second |
| Close circuit builder | `mus_circuit_builder` fades out, current music returns to full volume | 1 second |
| Player HP drops below 20 | Current music ducks -6 dB, `mus_danger` fades in | 0.5 seconds |
| Player HP restored above 30 | `mus_danger` fades out, current music returns to full volume | 1 second |
| Storm approaching | Current music crossfades to `mus_storm_approach`, then to `mus_storm_active` | 30 seconds (approach phase) |
| Storm ends | `mus_storm_active` crossfades back to current biome track | 5 seconds |
| Discovery/milestone event | `mus_discovery` stinger plays layered over current music | N/A (one-shot) |
| NPC dialogue begins | Current music ducks -8 dB, NPC theme fades in | 0.5 seconds |
| NPC dialogue ends | NPC theme fades out, music returns to full volume | 0.5 seconds |
| Deep Signal Array sequence | All other music fades out, `mus_deep_signal` plays exclusively | 3 seconds |

### 5.2 Ambient Behavior

- Ambient loops play continuously under music, always on the Ambient bus.
- When transitioning between biomes, ambient loops crossfade over 3 seconds.
- When entering a sealed base room, outdoor ambient fades out over 1.5 seconds, `amb_base` fades in.
- Ambient volume is constant and not affected by music ducking events.
- Environmental SFX (Section 4.6) play on the SFX bus, on top of ambient, triggered by game events.

### 5.3 Implications for Composition

Because tracks will be crossfaded at arbitrary points:
- **Avoid hard transients at loop seams.** If one track ends on a cymbal crash and the next begins with silence, the crossfade will sound broken.
- **Keep consistent energy levels within a loop.** Dramatic builds and drops within a looping track make crossfades unpredictable.
- **Use similar tonal centers within related tracks.** Day and night variants of the same biome should share a key center (or compatible keys) so the 60-second crossfade between them sounds intentional.
- **Code editor and circuit builder tracks must work when layered -6 dB under any biome music.** Avoid frequency clashes -- keep the focus tracks in the mid range, leave space for the biome music's bass and highs.

---

## 6. Delivery Format & Naming

### File Naming Convention

All files must follow this exact naming scheme. No spaces, all lowercase, underscores only.

| Type | Pattern | Example |
|---|---|---|
| Music | `mus_<context>.ogg` | `mus_alkaline_day.ogg` |
| SFX | `sfx_<category>_<name>_<variant>.wav` | `sfx_player_step_salt_01.wav` |
| Ambient | `amb_<biome>.ogg` | `amb_resonance.ogg` |
| Stinger | `mus_<context>.ogg` | `mus_discovery_large.ogg` |

### Folder Structure

Deliver files organized in this exact folder structure:

```
audio/
  music/
    mus_title.ogg
    mus_alkaline_day.ogg
    mus_alkaline_night.ogg
    mus_base_interior.ogg
    mus_code_editor.ogg
    mus_circuit_builder.ogg
    mus_danger.ogg
    mus_discovery_small.ogg
    mus_discovery_medium.ogg
    mus_discovery_large.ogg
    mus_brine_day.ogg
    mus_brine_night.ogg
    ... (all music tracks)
  sfx/
    player/
      sfx_player_step_salt_01.wav
      sfx_player_step_salt_02.wav
      ... (all player SFX)
    robot/
      sfx_robot_boot.wav
      sfx_robot_move_scuttle.wav
      ... (all robot SFX)
    circuit/
      sfx_circuit_wire_connect.wav
      ... (all circuit SFX)
    code/
      sfx_code_key_01.wav
      ... (all code editor SFX)
    ui/
      sfx_ui_navigate.wav
      ... (all UI SFX)
    environment/
      sfx_env_wind_gust.wav
      ... (all environment SFX)
  ambient/
    amb_alkaline.ogg
    amb_brine.ogg
    ... (all ambient loops)
  metadata/
    loop_points.json
```

### Loop Points Metadata File

Deliver a `loop_points.json` file with this format for every looping track:

```json
{
  "mus_title": {
    "loop": true,
    "loop_start_samples": 882000,
    "loop_end_samples": 6615000,
    "sample_rate": 44100,
    "notes": "Intro plays once (first 20 seconds), then loops from bar 9."
  },
  "mus_alkaline_day": {
    "loop": true,
    "loop_start_samples": 0,
    "loop_end_samples": 7938000,
    "sample_rate": 44100,
    "notes": "Full track loops from the beginning."
  },
  "mus_discovery_small": {
    "loop": false,
    "notes": "One-shot stinger, 5 seconds."
  }
}
```

### Batch Delivery Schedule

| Milestone | Contents | Deadline (relative to contract start) |
|---|---|---|
| **M1: Prototype** | P0 music (8 tracks) + all player SFX (23 files) + all UI SFX (12 files) + `amb_alkaline` + `amb_base` | Week 4 |
| **M2: Alpha** | P1 music (15 tracks) + all robot SFX (16 files) + all circuit SFX (12 files) + all code SFX (8 files) + remaining 7 ambient loops | Week 10 |
| **M3: Polish** | P2 music (9 tracks) + all environment SFX (15 files) + final polish pass on all previous deliverables | Week 14 |

### Revision Policy

- **2 revision rounds per batch.** Each round consists of written feedback from us, followed by your revisions.
- A "revision" is a change to the creative direction, mix, or feel of a deliverable. Bug fixes (clicks, pops, incorrect format) are not counted as revision rounds.
- If we request changes beyond 2 revision rounds, we will discuss additional compensation.

---

## 7. Budget Guidance

### Asset Count Summary

| Category | Count |
|---|---|
| Music tracks (P0) | 10 (8 tracks, with discovery having 3 sub-variants) |
| Music tracks (P1) | 15 |
| Music tracks (P2) | 9 |
| **Total music tracks** | **34** |
| SFX files | **86** |
| Ambient loops | **9** |
| **Total audio assets** | **129** |

### Typical Market Rates (2026, Fiverr/Upwork mid-tier)

These are reference ranges. We are open to discussing your rates.

| Asset Type | Per-unit Rate Range (USD) | Notes |
|---|---|---|
| Music track (2-4 min, loopable) | $150 - $400 | Higher end for complex tracks like `mus_deep_signal` and `mus_resonance_day`. Lower end for night variants derived from day tracks. |
| Music stinger (5-15 sec) | $40 - $100 | Short cues: discovery stingers, dawn transition. |
| NPC theme (20-30 sec, loopable) | $60 - $150 | Character motifs. |
| SFX (single sound) | $10 - $30 | Batch pricing typically brings this to the lower end. |
| Ambient loop (1.5-2 min) | $80 - $200 | Complex layered soundscapes on the higher end. |

### Estimated Total Budget Range

| Tier | Estimated Total | Notes |
|---|---|---|
| **Budget** | $3,000 - $5,000 | Newer composer building portfolio. Night variants heavily derived from day tracks. SFX batch-priced low. |
| **Mid-range** | $5,000 - $9,000 | Experienced freelancer with game audio credits. Original night variants. High-quality SFX. |
| **Premium** | $9,000 - $15,000 | Established game composer. Fully original compositions. Custom-recorded foley for SFX. |

We expect to land in the mid-range tier. Please provide an itemized quote with your proposal.

### Payment Schedule

| Milestone | % of Total | Trigger |
|---|---|---|
| Contract signing + creative brief approved | 20% | Signed agreement |
| M1 delivered and approved (P0 batch) | 30% | All P0 assets accepted after revisions |
| M2 delivered and approved (P1 batch) | 30% | All P1 assets accepted after revisions |
| M3 delivered and approved (P2 batch) | 20% | All P2 assets accepted after revisions |

---

## 8. Reference Tracks

Listen to these specific tracks. For each, we describe exactly what element we want you to internalize and bring to AstroCode.

### 8.1 ConcernedApe -- "Spring (It's a Big World Outside)" (Stardew Valley)

**Listen for:** The woodwind melody over gentle guitar and the immediate sense of warmth and invitation. Notice how it makes you want to *stay* in the game world. This warmth is what `mus_base_interior` should feel like -- a place you've built that feels like home. Translate the acoustic warmth into synth warmth.

**Link:** Stardew Valley OST, Track 1.

### 8.2 Ben Prunty -- "MilkyWay (Explore)" (FTL: Faster Than Light)

**Listen for:** The layered tension. The track is calm on the surface but has an undercurrent of "something could go wrong." Notice how the same melodic material shifts mood with arrangement changes. This is the template for `mus_alkaline_day` -- lonely, functional, quietly tense. Also study how FTL's battle themes layer on top of explore themes. Our `mus_danger` should work similarly.

**Link:** FTL OST, Track 3.

### 8.3 Lena Raine -- "Resurrections" (Celeste)

**Listen for:** The emotional arc within a single track. How it starts quiet and builds to catharsis using primarily synthesized instruments. The way electronic sounds convey genuine human emotion -- determination, struggle, triumph. This emotional sincerity is what `mus_deep_signal` (our endgame track) must achieve. No irony, no distance -- earned feeling.

**Link:** Celeste OST, Chapter 6.

### 8.4 Andrew Prahlow -- "Travelers" (Outer Wilds)

**Listen for:** The banjo/acoustic guitar creating intimacy against the vastness of space. The sense of being a tiny, curious person in an enormous, ancient universe. This is the feeling for Resonance Peaks and the discovery moments. Also note how Outer Wilds uses silence -- not every moment needs music. Our ambient loops should carry some moments on their own.

**Link:** Outer Wilds OST, Track 1.

### 8.5 Disasterpeace -- "The Sentients" (Hyper Light Drifter)

**Listen for:** The blur between ambient sound design and music. How atmosphere IS the composition. The sense of exploring something ancient and not fully understood. This textural approach is ideal for `mus_brine_day` (underground caves) and `mus_resonance_day` (obsidian mountains). The music should feel like it's part of the environment, not laid on top.

**Link:** Hyper Light Drifter OST, Track 7.

### 8.6 C418 -- "Minecraft" (Minecraft Volume Alpha)

**Listen for:** The simplicity and emotional directness of a piano melody over ambient pads. How a few notes can evoke vast loneliness and contentment simultaneously. This is the energy for `mus_polar_day` -- frozen, minimal, beautiful. Also study how Minecraft's music appears and disappears organically. Space between tracks matters.

**Link:** Minecraft Volume Alpha, Track 1.

### 8.7 Lena Raine -- "Pigstep" (Minecraft)

**Listen for:** How a lo-fi beat with heavy electronic processing can feel both retro and modern. The rhythm and energy. This specific track is less about mood and more about demonstrating that lo-fi electronic production CAN have groove and personality. Our `mus_circuit_builder` should have this kind of understated cool -- not just wallpaper, but something that makes building circuits feel stylish.

**Link:** Minecraft, Music Disc "Pigstep."

### 8.8 Andrew Prahlow -- "End Times" (Outer Wilds)

**Listen for:** How urgency is created without aggression. The ticking-clock tension built from acoustic and electronic elements. The emotional weight of "time is running out, but there is still beauty." This is the energy for `mus_storm_approach` and also the overall arc of the danger/survival moments. Tension should feel existential, not violent. There is nothing to fight -- only problems to solve before time runs out.

**Link:** Outer Wilds OST, Track 11.

---

## 9. Application Instructions

To apply for this role, please include:

1. **Portfolio:** 3-5 tracks demonstrating your range across ambient, lo-fi electronic, and emotionally driven synth music. Game audio credits are a plus but not required.
2. **SFX demo reel:** 30-60 seconds of sound effects you have designed. Electronic/sci-fi/mechanical sounds are most relevant.
3. **Style test (optional but strongly recommended):** Compose a 30-60 second sketch inspired by the `mus_alkaline_day` brief above. This is the single best way to demonstrate fit. We will compensate selected candidates $50 for style tests regardless of hiring outcome.
4. **Itemized quote:** Break down your pricing per track category (full music track, stinger, NPC motif, SFX batch, ambient loop).
5. **Availability:** Confirm you can commit to the 14-week delivery timeline with the milestone schedule above.
6. **Tools:** List your DAW, primary synths/samplers, and monitoring setup. We do not require specific tools -- quality matters, not brand names.

### What We Value Most

- **Musical storytelling.** Can you make someone feel "alone on an alien planet but building something hopeful" in 30 seconds of audio?
- **Looping craftsmanship.** Seamless loops are non-negotiable. If your loops click, pop, or feel repetitive after 3 plays, it's a dealbreaker.
- **Cohesion.** The 34 music tracks must feel like one soundtrack, not 34 unrelated songs. Motif usage is how we achieve this.
- **Genre fit.** "Lo-fi chiptune meets ambient space synth" is specific. We are not looking for orchestral, metal, or purely acoustic styles.
- **Communication.** You will be the only audio person on a small team. We need clear, proactive communication about progress, blockers, and creative decisions.

---

## 10. Quick Reference -- Full Asset Inventory

### Music (34 tracks)

| # | Track ID | Priority | Type |
|---|---|---|---|
| 1 | `mus_title` | P0 | Full track with intro |
| 2 | `mus_alkaline_day` | P0 | Biome loop |
| 3 | `mus_alkaline_night` | P0 | Biome loop (night) |
| 4 | `mus_base_interior` | P0 | Location loop |
| 5 | `mus_code_editor` | P0 | Activity loop |
| 6 | `mus_circuit_builder` | P0 | Activity loop |
| 7 | `mus_danger` | P0 | Short tension loop |
| 8 | `mus_discovery_small` | P0 | Stinger |
| 9 | `mus_discovery_medium` | P0 | Stinger |
| 10 | `mus_discovery_large` | P0 | Stinger |
| 11 | `mus_brine_day` | P1 | Biome loop |
| 12 | `mus_ferric_day` | P1 | Biome loop |
| 13 | `mus_spore_day` | P1 | Biome loop |
| 14 | `mus_glass_day` | P1 | Biome loop |
| 15 | `mus_resonance_day` | P1 | Biome loop |
| 16 | `mus_polar_day` | P1 | Biome loop |
| 17 | `mus_magma_day` | P1 | Biome loop |
| 18 | `mus_npc_wren` | P1 | NPC motif loop |
| 19 | `mus_npc_rootknot` | P1 | NPC motif loop |
| 20 | `mus_npc_cass` | P1 | NPC motif loop |
| 21 | `mus_npc_mira` | P1 | NPC motif loop |
| 22 | `mus_storm_approach` | P1 | Event loop |
| 23 | `mus_storm_active` | P1 | Event loop |
| 24 | `mus_dawn` | P1 | Stinger |
| 25 | `mus_deep_signal` | P1 | Endgame track with intro |
| 26 | `mus_brine_night` | P2 | Biome loop (night) |
| 27 | `mus_ferric_night` | P2 | Biome loop (night) |
| 28 | `mus_spore_night` | P2 | Biome loop (night) |
| 29 | `mus_glass_night` | P2 | Biome loop (night) |
| 30 | `mus_resonance_night` | P2 | Biome loop (night) |
| 31 | `mus_polar_night` | P2 | Biome loop (night) |
| 32 | `mus_magma_night` | P2 | Biome loop (night) |
| 33 | `mus_credits` | P2 | Composed piece |
| 34 | `mus_trailer` | P2 | Composed piece |

### SFX (86 files)

| Category | Count |
|---|---|
| Player | 23 |
| Robot | 16 |
| Circuit | 12 |
| Code Editor | 8 |
| UI | 12 |
| Environment | 15 |
| **Total SFX** | **86** |

### Ambient Loops (9 files)

| # | Track ID |
|---|---|
| 1 | `amb_alkaline` |
| 2 | `amb_brine` |
| 3 | `amb_ferric` |
| 4 | `amb_spore` |
| 5 | `amb_glass` |
| 6 | `amb_resonance` |
| 7 | `amb_polar` |
| 8 | `amb_magma` |
| 9 | `amb_base` |

---

**Grand total: 129 audio assets (34 music + 86 SFX + 9 ambient)**

---

*This document is the complete audio specification for AstroCode. If anything is unclear, ask before composing -- but everything you need to deliver the full audio package should be here. We look forward to hearing your vision for Thyra-7.*

**Contact:** nauval.saga@gmail.com
**Project:** AstroCode
**Studio:** Independent (4-5 person team)
