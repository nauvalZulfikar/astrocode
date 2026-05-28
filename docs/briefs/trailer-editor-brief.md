# AstroCode — Trailer Editor Brief

**Document version:** 1.0 | **Date:** 2026-05-25
**Prepared by:** Marketing Lead, AstroCode
**Deliverable:** 60-second gameplay trailer for Steam store page

---

## 1. Project Overview

**Game:** AstroCode
**Genre:** Top-down pixel art survival / automation / programming
**Engine:** Godot 4.3+
**Platform:** Steam (Windows, Linux, Mac, Steam Deck)
**Price:** $19.99 USD, premium one-time purchase
**Age rating:** ESRB E10+ / PEGI 7 (no violence, no combat, mild sci-fi peril)

**Elevator pitch:** You are an astronaut stranded on an alien planet with nothing but a broken ship and a Python terminal. Survive by writing real code to program robots, wiring circuits to power your base, and teaching your machines to think.

**Target audience:**
- Primary: Gamers aged 15-30 who are curious about programming but bounced off tutorials. Fans of Stardew Valley, Factorio, Minecraft redstone, The Farmer Was Replaced, Shenzhen I/O.
- Secondary: CS students and self-taught developers looking for a fun way to practice fundamentals.
- Tertiary: Educators and coding bootcamps (but we NEVER market to them directly).

**Trailer purpose:**
- Hero video on the Steam store page (autoplay, muted by default, first 5 seconds must hook without audio)
- Social media distribution (Twitter/X, YouTube, Reddit, TikTok)
- Press outreach to indie game journalists and YouTubers

**Critical marketing rule:** We NEVER use the word "educational." This is a survival game that happens to teach real skills. Position as "automation survival," not "learning tool." Let reviewers and streamers discover the learning angle organically.

---

## 2. Trailer Specs

| Parameter | Specification |
|-----------|---------------|
| Duration | 60 seconds (hard limit — Steam autoplay caps at 60s) |
| Native resolution | 320x180 pixel art |
| Delivery resolution | 1920x1080 (upscaled with **nearest-neighbor interpolation** — NO bilinear/bicubic smoothing, pixels must remain sharp and crispy) |
| Framerate | 60 fps |
| Audio | Game soundtrack (provided) + in-game SFX (provided). No voiceover. |
| Text overlays | Yes — see Section 4 for exact copy |
| Voiceover | None |
| Format (primary) | MP4, H.264, 1080p60 |
| Format (archival) | Apple ProRes 4444, 1080p60 |
| Rating card | ESRB E10+ and PEGI 7 logos — displayed for minimum 3 seconds at end |

**Pixel art scaling — critical:**
The game runs at 320x180 and is upscaled to 1920x1080 (exact 6x integer scale). ALL upscaling MUST use nearest-neighbor. If your editing software defaults to bilinear or Lanczos, override it. Blurry pixels will result in a revision request. When zooming in on UI elements (terminal, breadboard), maintain nearest-neighbor — the blocky look IS the aesthetic.

---

## 3. Shot List / Script

All gameplay footage will be provided as raw captured video. Your job is editing, pacing, text overlays, transitions, and audio sync. Below is the second-by-second script.

### ACT 1 — HOOK (0:00 - 0:05)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:00 - 0:02 | Black screen. Tiny white stars fade in, slowly drifting. A faint orange glow appears at the top of frame — Thyra-7's atmosphere. | Silence. Then: a single, low ambient hum fading in. | None |
| 0:02 - 0:04 | Sudden flash. The Haldane (player's ship) streaks across the screen trailing fire and sparks. Camera shake. Screen whites out on impact. | **CRASH SFX** — metallic screech, explosion, glass shattering. Sharp and loud against the preceding silence. | None |
| 0:04 - 0:05 | Cut to black. Beat of silence. Then: a cursor blinking on a dark terminal screen. One character at a time: `> SABLE v2.1 ... rebooting` | Quiet electronic boot-up chirp. Terminal keystroke sounds. | None |

**Editor notes:** The first 5 seconds must work WITHOUT audio (Steam mutes autoplay). The visual contrast — serene stars, violent crash, eerie terminal — must hook on visuals alone. No text overlays yet; let the crash do the work.

---

### ACT 2 — SURVIVAL (0:05 - 0:12)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:05 - 0:07 | Wide shot: the Haldane's wreckage on the Alkaline Flats. Cracked white-grey salt plains, burnt-orange sky, dust particles drifting. The ship is the only structure visible. Player character (Kade) climbs out of the cockpit. | Ambient: wind across salt flats. Creaking metal. | None |
| 0:07 - 0:09 | HUD appears. **O2 bar is dropping visibly** — from 34% toward critical. Red warning flash on the O2 indicator. Close-up of the player opening the in-game terminal. | Warning beep (O2 low). Terminal open SFX. | **"Oxygen critical."** (appears as in-game HUD text, not an overlay — use whatever the game displays) |
| 0:09 - 0:11 | **Close-up of the in-game terminal.** Player types: `if sensor.read("O2") < 18:` then `electrolyzer.activate()`. Code runs. Green checkmark. | Keyboard clacking (in-game). Code execution chime. | **"Your code keeps you alive."** (text overlay, centered, white on dark, clean pixel font) |
| 0:11 - 0:12 | Cut back to wide shot. O2 bar stabilizes. Kade exhales (idle animation). The sun sets — rapid day-to-night transition showing the 14-hour day cycle. | Music begins: quiet, sparse ambient synth. A single sustained note with slight pulsing. | None |

**Editor notes:** This section establishes the stakes. The O2 bar dropping should feel urgent. The terminal close-up is critical — the viewer must be able to READ the code on screen. Hold the code shot long enough (2 seconds) to register. The text overlay "Your code keeps you alive" is the thesis statement of the entire trailer.

---

### ACT 3 — BUILD (0:12 - 0:22)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:12 - 0:14 | Player opens the fabricator. Parts assemble into Scuttle (gatherer robot) — pixel animation of robot being built piece by piece. Robot powers on, LED eyes blink. | Fabrication SFX: mechanical assembly sounds. Robot boot-up beep. | None |
| 0:14 - 0:16 | **Close-up of terminal.** Player writes Scuttle's control code: `def gather(target):` / `robot.move_to(target)` / `robot.collect()`. Code deploys. | Keyboard SFX. Deploy chime. Music: a second layer joins — light percussion, steady rhythm. | None |
| 0:16 - 0:18 | Wide shot: Scuttle executing the code. Robot trundles across the Alkaline Flats, picks up scrap metal, returns to base. Visible cause-and-effect: code written, robot obeys. | Robot motor hum. Collection SFX. | **"Program your machines."** |
| 0:18 - 0:20 | Base building montage (3 quick cuts, ~0.7s each): (1) Solar panel placed on grid. (2) Oxygen pipe connected to shelter. (3) Interior of shelter — terminal screen glowing, workbench visible. | Construction SFX layered. Music building slightly. | None |
| 0:20 - 0:22 | **Close-up of the breadboard circuit builder.** Player drags a resistor, an LED, and a battery onto the board. Wires connect. LED lights up green. | Circuit connection clicks. LED activation buzz. | **"Wire real circuits."** |

**Editor notes:** This is the "systems showcase" section. Three core mechanics in 10 seconds: coding, robot control, circuit building. Each gets a close-up beat. Cuts are slightly faster now (1.5-2 sec per shot) — momentum is starting to build. The cause-and-effect moment (write code, watch robot execute) is the most important shot in the trailer. Give it room to breathe.

---

### ACT 4 — EXPAND (0:22 - 0:35)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:22 - 0:24 | Multiple robots active: Scuttle gathering, Ohm (sensor bot) scanning, Welder constructing a new structure. The base is growing. Day/night cycles flash past (timelapse: 2-3 full cycles in 2 seconds). | Music: drums kick in. Tempo increases. Layered synth melody appears. | None |
| 0:24 - 0:26 | **Circuit builder close-up — more complex now.** Transistors, a microcontroller, sensor wires. The breadboard is half-full. Player connects a gas sensor to a relay — the relay triggers a fan. | Circuit SFX. More intricate clicking and buzzing. | None |
| 0:26 - 0:28 | New biome reveal: Brine Hollows. Luminescent blue caverns. Shallow acidic pools glowing. Scuttle enters the cave, LED headlamp on. | Cave ambiance: dripping water, echoing footsteps. Music continues over it. | **"Explore an alien world."** |
| 0:28 - 0:30 | Quick-cut biome montage (4 shots, 0.5s each): (1) Ferric Badlands — rust-red mesas, magnetic haze. (2) Spore Marshes — turquoise bioluminescent wetlands, massive fungal trees. (3) Glass Dunes — prismatic silica dunes refracting light. (4) Resonance Peaks — obsidian mountains with glowing thaline veins, lightning arcs between peaks. | Music swells with each biome cut. Each biome gets a distinct ambient SFX stinger (metallic hum, marsh bubbling, sand whisper, electric crackle). | None |
| 0:30 - 0:32 | Sensor network visualization: top-down map view showing sensor nodes (Ohm robots) placed across multiple biomes, data lines connecting them back to base. Data flows visibly along the lines. | Data transmission SFX: soft digital pulses. | None |
| 0:32 - 0:35 | Terminal close-up — more advanced code now: `for node in sensor_network:` / `data.append(node.read())` / `if anomaly_detected(data):` / `alert(base)`. Code runs, a warning flashes on the base monitor: "STORM INCOMING." | Code execution sounds. Alert klaxon (brief). Music: building toward a peak. | **"Build systems that think."** |

**Editor notes:** This is where the trailer shifts from survival to mastery. Cuts are fast (0.5-1 sec for the biome montage). The music should be noticeably more energetic. Color palette expands dramatically — from the muted Alkaline Flats to vivid blues, reds, turquoises, and prismatic rainbows. The sensor network shot and the "storm incoming" moment show the player's code having REAL consequences across the entire planet.

---

### ACT 5 — MASTERY (0:35 - 0:48)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:35 - 0:37 | Robot fleet panorama: 6+ robots working in concert. Scuttles gathering, Ohms scanning, Mule hauling cargo, Plow tending glowing bio-fuel crops. Base is large, well-lit, humming with activity. The player stands on a ridge watching. | Music: full arrangement. Chiptune melody layered with warm synth pads. Confident, forward-moving. | None |
| 0:37 - 0:39 | **AI training screen close-up.** Neural network node editor: the player connects input nodes (sensor data), hidden layers, and output nodes. Visible: layer sizes, activation function labels, a "Train" button. | UI interaction SFX. Subtle data-processing hum. | None |
| 0:39 - 0:41 | Training montage (split screen or alternating cuts): (1) Training data bar filling up. (2) Loss curve dropping on a pixel-art graph. (3) Robot with AI module successfully navigating a hazard it previously failed — lava tube, ice crack, toxic gas pocket. | Training progress SFX: ascending chiptune notes. Success chime on navigation. | **"Teach them to learn."** |
| 0:41 - 0:44 | Advanced circuit close-up: a full custom PCB. Voltage regulators, shielded traces, a hand-built microcontroller. This is not a beginner's breadboard — this is engineering. Player adds the final component. The board powers on. All LEDs green. | Complex circuit activation: layered hums, indicator beeps, a satisfying power-on surge sound. | None |
| 0:44 - 0:46 | Autonomous base timelapse: day/night cycles fly past (4-5 cycles in 2 seconds). Robots work without player input. Resources flow. Sensors monitor. The base lives on its own. Kade is free to explore. | Music: sustained, warm, triumphant but not bombastic. The feeling of a system running smoothly. | None |
| 0:46 - 0:48 | Wide shot: Kade and Atlas (AI-driven robot) standing at the edge of Beacon Plateau, looking out over the planet. Multiple biomes visible in the distance. The sky is full of stars. Thyra Prime (gas giant) looms on the horizon. | Music dips to a single sustained note. A moment of stillness. | **"Understand the planet."** |

**Editor notes:** The mastery section should feel EARNED. The contrast with the desperate O2 scene at the start should be palpable. The autonomous base timelapse is a "wow" moment — emphasize how the player's code has created a living system. The final wide shot before the climax is a breath — 2 full seconds of quiet beauty before the finale. Color grading should be at its most vivid here: warm, saturated, confident.

---

### ACT 6 — CLIMAX (0:48 - 0:55)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:48 - 0:50 | The Deep Signal Array: a massive structure on Beacon Plateau. Thaline crystal antenna, circuit boards visible on its surface, cables running to geothermal power. Kade approaches the activation terminal. | Low rumble. Power building. Electrical hum growing louder. | None |
| 0:50 - 0:52 | Terminal close-up — final code: `signal.modulate(resonance.frequency)` / `array.transmit()`. Kade hits ENTER. | Keypress. Execution chime — but deeper, more resonant than before. | None |
| 0:52 - 0:54 | The Array fires. A beam of light erupts upward from the antenna. The Resonance responds — thaline veins across the visible landscape pulse in sync, blue-white light cascading outward from the Array like a heartbeat. The entire planet glows for a moment. Electromagnetic arcs, but harmonious now — not destructive. | **CRESCENDO.** Full musical climax: chiptune + synth + swelling strings/pads. The Resonance harmonizing SFX: a deep, beautiful, otherworldly chord. | None |
| 0:54 - 0:55 | Wide pullback: the beam of light ascending into the star field. Thyra-7 below, beautiful and alive. Hold this shot. | Music sustains at peak, then begins a slow decay. | None |

**Editor notes:** This is the emotional peak. The Array firing should feel like a culmination of everything the viewer just saw — code, circuits, robots, data, AI, all of it converging into one moment. The Resonance harmonizing is the payoff of the entire trailer's arc: the planet was hostile, and now it sings with you. Hold the final shot of the beam for a full second minimum. Let it breathe. Do NOT cut away too fast.

---

### ACT 7 — TITLE (0:55 - 0:60)

| Timestamp | Visual | Audio | Text Overlay |
|-----------|--------|-------|--------------|
| 0:55 - 0:57 | Cut to black. The AstroCode logo fades in, pixel-art style. Below it: tagline (see Section 4 for options — client will confirm which one). | Music: final notes. A quiet, clean resolution. Terminal cursor blink sound. | **AstroCode** (logo) + tagline |
| 0:57 - 0:58 | Below the logo, the release window and platform appear. | Silence except for a faint ambient hum. | **"Coming 2028 to Steam"** |
| 0:58 - 0:59 | CTA appears below. | None. | **"Wishlist Now"** (with Steam logo) |
| 0:59 - 0:60 | ESRB E10+ and PEGI 7 rating cards appear. Standard layout. | None. | Rating logos per platform requirements |

**Editor notes:** Keep the title card clean and simple. Black background, pixel font consistent with the game's UI. The logo should be the visual hero. No fancy motion graphics needed — a clean fade-in is perfect for pixel art. The "Wishlist Now" must include the Steam logo or a recognizable Steam visual cue. Rating cards must be visible for the final 1+ seconds per Steam/ESRB requirements.

---

## 4. Text Overlay Copy

All text overlays use a clean pixel-art font consistent with the game's in-game terminal aesthetic. White text on dark/semi-transparent background. All caps optional but consistent throughout.

### Tagline Options (client will select one)

1. **"Survive. Code. Evolve."**
2. **"The planet is the teacher."**
3. **"Your code is your lifeline."**

### Feature Callouts (in order of appearance)

1. **"Your code keeps you alive."** (0:09-0:11)
2. **"Program your machines."** (0:16-0:18)
3. **"Wire real circuits."** (0:20-0:22)
4. **"Explore an alien world."** (0:26-0:28)
5. **"Build systems that think."** (0:32-0:35)
6. **"Teach them to learn."** (0:39-0:41)
7. **"Understand the planet."** (0:46-0:48)

### Title Card Text

- **Line 1:** AstroCode (logo/stylized)
- **Line 2:** [Selected tagline]
- **Line 3:** Coming 2028 to Steam
- **Line 4:** Wishlist Now [Steam logo]

### Text Style Rules

- Maximum 6 words per card
- Duration on screen: 1.5-2.5 seconds per card
- Fade in / fade out (no slide, no bounce, no wipe — clean and simple)
- No drop shadows. If readability is an issue over bright gameplay, use a subtle semi-transparent black bar behind the text
- Font: pixel-art monospace. We will provide the exact font file (the same one used in the in-game terminal). If we do not provide it in time, use a clean pixel font like "Press Start 2P" or "Silkscreen" as a placeholder

---

## 5. Tone and Pacing

### Emotional Arc

| Phase | Timestamp | Emotion | Pacing |
|-------|-----------|---------|--------|
| HOOK | 0:00-0:05 | Dread, shock, curiosity | Slow build to sudden impact. 2 cuts total. |
| SURVIVAL | 0:05-0:12 | Tension, urgency, first relief | Measured. 1.5-2 sec per cut. Let the O2 crisis land. |
| BUILD | 0:12-0:22 | Discovery, growing confidence | Moderate. 1-1.5 sec per cut. Momentum building. |
| EXPAND | 0:22-0:35 | Excitement, wonder, scale | Fast. 0.5-1 sec per cut. The biome montage is rapid-fire. |
| MASTERY | 0:35-0:48 | Pride, awe, earned satisfaction | Mixed. Fast cuts for the AI training, then a slow 2-sec hold for the panorama. |
| CLIMAX | 0:48-0:55 | Crescendo, triumph, beauty | Slow. 2-3 sec per shot. Let the Array firing BREATHE. |
| TITLE | 0:55-0:60 | Calm confidence, invitation | Static. Logo hold. Clean and professional. |

### Color Grading

- **0:00-0:12 (Hook + Survival):** Slightly desaturated. Muted oranges and greys. The world feels hostile and bleak. Shadows are deep.
- **0:12-0:22 (Build):** Saturation begins to return. Warmer tones. The base's lights provide contrast against the bleak exterior.
- **0:22-0:35 (Expand):** Full color. Each biome has a distinct palette (blue caverns, red mesas, turquoise marshes, prismatic dunes, obsidian peaks). Let them pop.
- **0:35-0:55 (Mastery + Climax):** Vivid and warm. The base glows. The Array firing is the most colorful moment in the trailer — thaline blue-white light against the night sky.
- **0:55-0:60 (Title):** Black background. The logo and text are the only light source.

### Transitions

- Hard cuts only for gameplay-to-gameplay transitions. No dissolves, no wipes.
- Exception: fade to black for the crash (0:04) and the title card (0:55).
- Exception: fade in from black for the opening stars (0:00) and the logo (0:55).
- The crash whiteout (0:03-0:04) is a flash, not a dissolve — instantaneous peak brightness, then hard cut to black.

---

## 6. Reference Trailers

Study these trailers for pacing, tone, and technique. Do not copy them — use them as calibration points.

### 1. The Farmer Was Replaced — Launch Trailer

**Search:** `"The Farmer Was Replaced" Steam launch trailer`
**What works:** Shows code being written and immediately executed on screen. The cause-and-effect (type code, watch farm automate) is the entire hook. Clean, minimal text overlays. Lets the gameplay speak.
**Study specifically:** How they frame the in-game code editor so the text is readable. Their text overlay timing and font choice. (Full trailer, especially the first 15 seconds.)

### 2. Stardew Valley — Official Trailer

**Search:** `"Stardew Valley" official launch trailer Steam`
**What works:** Emotional arc from small and lonely to large and thriving. The pixel art is given room to shine without overproduction. Music drives the pacing perfectly — quiet start, warm crescendo. Cozy but with stakes.
**Study specifically:** How they pace the seasonal montage. How the music syncs to activity on screen. The title card simplicity. (0:00-0:30 for tone, final 10 seconds for title card.)

### 3. Shenzhen I/O — Launch Trailer

**Search:** `"Shenzhen I/O" Steam launch trailer Zachtronics`
**What works:** Shows complex systems (circuit boards, assembly code) without making them look intimidating. The pacing says "this is satisfying," not "this is hard." Close-ups of the board being wired are deeply compelling.
**Study specifically:** Their close-up framing of circuit boards. How they show complexity scaling (simple circuit, then complex circuit). (0:15-0:40 for circuit showcase pacing.)

### 4. Astroneer — Launch Trailer

**Search:** `"Astroneer" official launch trailer 2019`
**What works:** Alien planet exploration with a sense of wonder, not threat. Colorful, inviting, but the environment IS the challenge. No enemies, no combat — the planet itself is the experience. Shows progression from small shelter to sprawling base.
**Study specifically:** How they convey "alien world" through color and environment design in a stylized (non-photorealistic) art style. Wide shots that establish scale. (0:20-0:50 for world-building montage.)

### 5. Turing Complete — Release Trailer

**Search:** `"Turing Complete" Steam trailer`
**What works:** Shows logic gates building into CPUs — technical content made visually satisfying. Progression from simple to complex is clear and exciting. Proves that "building a computer from scratch" can be compelling as a trailer hook.
**Study specifically:** How they show the complexity ramp without losing non-technical viewers. The satisfaction of a system activating. (Full trailer for overall approach.)

---

## 7. Music Direction

### Provided Assets

We will provide:
- The full game soundtrack as separate stems (melody, bass, drums, ambient pads)
- In-game SFX library (terminal sounds, robot motors, circuit connections, environmental ambiance, etc.)

### Track Mapping to Trailer Sections

| Trailer Section | Soundtrack Direction | Notes |
|-----------------|---------------------|-------|
| 0:00-0:05 (Hook) | Near-silence. A single low ambient drone. | We will provide an ambient pad stem. Use sparingly — most of this section is SFX only. |
| 0:05-0:12 (Survival) | Sparse ambient synth. One sustained note with gentle pulsing. | Starts at 0:11 under the day/night transition. Should feel lonely, not hopeful yet. |
| 0:12-0:22 (Build) | Light percussion enters. A simple rhythmic pattern. | The beat should sync with the robot's movement and the base-building cuts. |
| 0:22-0:35 (Expand) | Full drum kit + synth melody. Energy ramping. | The biome montage (0:28-0:30) should hit on a musical accent — each biome cut lands on a beat. |
| 0:35-0:48 (Mastery) | Peak arrangement. Chiptune melody + warm synth pads + confident rhythm. | This is the "everything is working" feeling. The music should sound like systems running in harmony. |
| 0:48-0:55 (Climax) | Musical crescendo into sustained peak. Add a reverb tail or harmonic swell on the Array firing. | The Resonance harmonizing moment (0:52-0:54) should be the loudest, most beautiful moment in the audio. |
| 0:55-0:60 (Title) | Music resolves to a final chord. Slow decay. Terminal cursor blink as the last sound. | Clean resolution. No abrupt cutoff — let the final note ring out. |

### If Custom Trailer Music is Needed

If the game soundtrack does not contain segments that fit the above mapping, we may commission custom trailer music. Style brief for the composer:

- **Genre:** Chiptune / synthwave hybrid
- **Instruments:** 8-bit/16-bit chip sounds (pulse wave, triangle, noise) layered with modern analog synth pads, arpeggiated bass, and light orchestral elements (strings only, no brass)
- **BPM:** Starts at ~70 (ambient), builds to ~120 (climax)
- **Key:** Minor key for the opening (tension), modulates to relative major for the climax (triumph)
- **Vibe:** Imagine if C418 (Minecraft) and Disasterpeace (Hyper Light Drifter) scored a NASA documentary together
- **Duration:** 60 seconds, mixed in stereo, delivered as stems

---

## 8. Delivery Requirements

### Primary Deliverables

| # | Format | Resolution | Framerate | Codec | Use Case |
|---|--------|-----------|-----------|-------|----------|
| 1 | MP4 | 1920x1080 | 60 fps | H.264, High Profile, ~20 Mbps VBR | Steam store page, YouTube, press |
| 2 | MP4 | 1080x1920 (9:16 vertical) | 60 fps | H.264, ~15 Mbps VBR | TikTok, Instagram Reels, YouTube Shorts |
| 3 | MOV | 1920x1080 | 60 fps | Apple ProRes 4444 | Archival master, future re-edits |

### Vertical Crop Notes (Deliverable #2)

The vertical version is NOT a simple crop of the horizontal trailer. You will need to:
- Re-frame shots to center the most important visual element (terminal text, robot action, circuit close-up)
- Text overlays must be repositioned for vertical safe zones
- The shot list order and timing remain the same, but compositions must be adjusted
- Gameplay footage will be provided in 16:9 — the vertical reframe is part of the editorial scope

### Audio Specs

- Stereo, 48 kHz, 16-bit minimum (24-bit preferred for ProRes)
- Peak loudness: -1 dBFS
- Integrated loudness: -14 LUFS (Steam recommendation)
- No clipping on the crash SFX — compress/limit the transient if needed

### File Naming Convention

```
astrocode_trailer_v[X]_[format]_[orientation].[ext]

Examples:
astrocode_trailer_v1_h264_landscape.mp4
astrocode_trailer_v1_h264_portrait.mp4
astrocode_trailer_v1_prores_landscape.mov
```

### Revision Process

- **2 revision rounds included** in the base fee
- Round 1: Full rough cut with placeholder text timing. We review pacing, shot order, and audio sync.
- Round 2: Final polish after our feedback. Text overlays finalized, audio mixed, color grading locked.
- Additional revision rounds billed at an agreed hourly rate (see Section 9).
- Feedback will be provided via timestamped comments (Google Doc or Frame.io — your preference).

### Timeline

| Milestone | Deadline |
|-----------|----------|
| Receive gameplay footage + audio assets from us | Day 0 |
| Rough cut v1 (landscape only) | Day 0 + 5 business days |
| Client feedback on rough cut | Day 0 + 7 business days |
| Revised cut v2 + vertical version | Day 0 + 10 business days |
| Client feedback on v2 | Day 0 + 12 business days |
| Final delivery (all 3 formats) | Day 0 + 14 business days |

Total timeline: **2 weeks from receiving footage.**

---

## 9. Budget

### Expected Rate Range

We understand that rates vary by experience and region. Our budget range for this project:

| Tier | Rate | What We Expect |
|------|------|----------------|
| Mid-range | $400-700 USD | Clean editing, text overlays, audio sync, color grading, 2 format deliveries (landscape + portrait). No custom motion graphics. |
| Senior | $700-1,200 USD | All of the above + refined title animation, polished text overlay transitions, precise audio ducking/mixing, ProRes delivery. |

### What is Included in the Base Fee

- Editing and assembly from provided footage
- Text overlay design and placement (using provided or agreed-upon pixel font)
- Basic color grading (desaturated-to-vivid arc described in Section 5)
- Audio sync and basic mixing (using provided soundtrack + SFX)
- 1920x1080 landscape delivery (MP4 H.264)
- 1080x1920 vertical re-frame delivery (MP4 H.264)
- ProRes 4444 archival delivery
- 2 revision rounds

### What Costs Extra (if needed)

| Add-On | Estimated Cost |
|--------|---------------|
| Custom title animation / logo reveal (beyond simple fade-in) | +$100-200 |
| Custom motion graphics (particle effects, HUD overlays not in footage) | +$150-300 |
| Additional revision rounds (beyond the included 2) | +$50-100 per round |
| 15-second or 30-second cut-down edits for ads | +$75-150 per cut |
| Subtitle/caption track (for accessibility) | +$50-75 |

### Payment Terms

- 50% upfront upon agreeing to the project
- 50% upon final delivery approval
- Payment via Fiverr/Upwork escrow (preferred) or PayPal invoice

---

## 10. How to Apply / What to Include

If you are reading this on Fiverr or Upwork, please include the following in your proposal:

1. **Portfolio link** with at least 1 game trailer you have edited (indie game trailers preferred; pixel art experience is a strong plus)
2. **Your rate** for this specific project (within or above our stated range is fine if justified)
3. **Estimated turnaround** for the rough cut
4. **Software you use** (DaVinci Resolve, Premiere Pro, After Effects, Final Cut — all acceptable)
5. **One sentence** on how you would handle the nearest-neighbor pixel scaling requirement (this tells us you read the brief)

We do NOT need:
- A cover letter
- Your life story
- A link to every project you have ever done

Short, specific, relevant. We will respond within 48 hours.

---

## Appendix A: Asset List (What We Provide)

You will receive a shared drive link containing:

| Asset | Format | Notes |
|-------|--------|-------|
| Raw gameplay footage | MP4 1920x1080 60fps (pre-scaled nearest-neighbor from 320x180) | ~20-30 minutes of captured gameplay covering all trailer moments |
| Gameplay footage — annotated | Google Sheet or text file | Timestamps mapped to this shot list so you can find each moment quickly |
| Game soundtrack | WAV stems (melody, bass, drums, pads) + full mix | 48 kHz / 24-bit |
| SFX library | Individual WAV files, named by sound (crash.wav, terminal_open.wav, robot_boot.wav, etc.) | ~50-80 files |
| Game logo | PNG with transparency, multiple sizes | Vector SVG also available if needed |
| Pixel font file | TTF/OTF | The exact font used in the in-game terminal |
| ESRB / PEGI rating assets | PNG with transparency | Official rating card images per platform guidelines |
| This brief | PDF + Markdown | You are reading it |

---

## Appendix B: Do's and Don'ts

### DO

- Show real gameplay — every frame should be something a player will actually see
- Show code being typed on the in-game terminal (close-up, readable)
- Show circuits being wired on the in-game breadboard (close-up, components visible)
- Show the cause-and-effect loop: write code, then watch the robot execute it
- Use the pixel art aesthetic as a strength — crisp, colorful, nostalgic
- Let the biome diversity sell the world — each biome should look distinct
- Make the Array firing feel like a "chills" moment
- Keep text overlays minimal and punchy

### DON'T

- Use the word "educational," "learning," "teach yourself," or "study" in any text overlay
- Use pre-rendered cutscenes or footage not from actual gameplay
- Apply bilinear/bicubic scaling to the pixel art (nearest-neighbor ONLY)
- Add camera shake effects to pixel art (it looks terrible — the pixels smear)
- Use flashy transitions (star wipes, page turns, glitch effects) — hard cuts and fades only
- Add a voiceover or narration
- Show any UI that is not part of the actual game
- Make it look like a mobile game
- Rush the climax — the Array firing needs 5-7 seconds of screen time
- Put more than 6 words on any text card

---

*End of brief. Questions? Contact us via the platform messaging system. We typically respond within 24 hours.*
