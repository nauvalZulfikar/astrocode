# Higgsfield Packet — AstroCode (non-tech, copy-paste ready)

This is the "what to generate in Higgsfield" sheet. Each block below is a prompt you
can paste straight into Higgsfield. No coding needed — generate, download, drop the file
into the folder noted under each section.

---

## ⚠️ Read this first — what Higgsfield is good for here

Higgsfield is a **cinematic image + video** generator. It is **excellent** for:
- Biome **backgrounds / establishing key-art** (parallax skies, splash screens)
- The **launch trailer** (Fase 5)
- **Steam capsule / marketing** images

Higgsfield is the **wrong tool** for the in-game **sprites** (Kade, robots, items, tiles).
Those must be **32×48 / 16×16 pixel-perfect** on a locked **32-color palette** — AI
cinematic generators can't hit that spec consistently. For sprites use a pixel tool
(Aseprite) or a pixel-specialized model, following `pixel-artist-brief.md`.
The protagonist **Kade is already done** and wired into the game (8 directions).

So this packet covers the parts Higgsfield genuinely nails: **backgrounds + trailer + marketing.**

---

## Locked palette (paste into every prompt to keep cohesion)

Use ONLY these anchor colors (the game is a strict 32-color palette; these 8 are locked):

```
#D4742C suit orange   #A85520 suit shadow   #C08860 skin/warm wood
#3868A8 deep blue     #40C8B0 turquoise     #E8C840 warm yellow
#E8E8E0 off-white     #282828 near-black
```

Append to any prompt: `restricted muted retro palette, oranges/teals/warm earth tones, no neon, no pure saturated colors`.

---

## SECTION 1 — Biome background key-art (8 images)

**Use for:** biome intro splash screens, parallax sky layers, Steam screenshots.
**Style suffix for ALL 8** (paste at end of each): `wide cinematic establishing shot, painterly sci-fi concept art, no characters, no text, no UI, atmospheric, 16:9, retro muted palette`
**Save to:** `assets/backgrounds/<biome>.png`

1. **Alkaline Flats** — `Cracked white-grey salt plains stretching to the horizon under a burnt-orange alien sky, a single crashed spaceship wreck as the only vertical structure, dust haze, harsh sunlight.`
2. **Brine Hollows** — `Underground cavern network, glowing luminescent blue mineral veins, shallow acidic pools reflecting light, dripping stalactites, damp and cold.`
3. **Ferric Badlands** — `Rust-red iron-oxide mesas and deep canyons, perpetual haze of metallic particles, distant electromagnetic micro-storm crackling on the horizon.`
4. **Spore Marshes** — `Turquoise bioluminescent wetland, massive fungal trees with softly pulsing caps, thick mist, faint floating spores, eerie calm.`
5. **Glass Dunes** — `Translucent silica sand dunes refracting light into prismatic rainbows, shifting terrain, intense solar glare, vast and alien.`
6. **Resonance Peaks** — `Jagged black obsidian mountains laced with glowing veins, visible electromagnetic arcs leaping between peaks, humming charged air.`
7. **Polar Sink** — `Frozen methane lake ringed by ice cliffs, permanent twilight, aurora displays overhead, sub-zero desolation.`
8. **Magma Veins** — `Subterranean lava-tube network, molten rivers of magma casting red-gold light, black basalt cathedral-like rock formations.`

---

## SECTION 2 — Title / splash screen (1 image)  ✅ SLOT IS LIVE

**Use for:** main menu background.
**Save to:** `assets/ui/title_bg.png` — **already wired.** The title screen
(`scenes/ui/title_screen.tscn`, the game's main scene) auto-loads this file. A
procedural placeholder is in place now; just overwrite `assets/ui/title_bg.png`
with your Higgsfield image (320x180 or any 16:9) and reopen the game — it shows
immediately, no code needed. Prompt:

```
Lone astronaut in burnt-orange coveralls and a white open-face helmet standing beside a
crashed spaceship on cracked white salt plains, burnt-orange alien sky, vast empty horizon,
sense of isolation and quiet determination, cinematic wide shot, painterly retro sci-fi,
no text, no logo, 16:9, restricted muted palette of oranges/teals/warm earth tones.
```

---

## SECTION 3 — Launch trailer (Fase 5 — video)

**Use for:** Steam page + social. Follow `trailer-editor-brief.md` for the full beat sheet.
Generate these **shots** in Higgsfield (image-to-video, 3–5s each), then cut together:

1. `Spaceship streaking down through an orange alien sky, trailing smoke, electromagnetic storm flashes, crash-landing on white salt plains — cinematic, dramatic.`
2. `Close on a cracked cockpit, a flickering green terminal screen booting up in the dark, sparks.`
3. `Astronaut in orange coveralls steps out onto alien salt flats, looks up at two moons, slow push-in.`
4. `Time-lapse: a small base of solar panels and machines lighting up one by one across the plains as night falls.`
5. `Wide hero shot: robots moving in formation across a turquoise bioluminescent marsh at dusk.`

**Trailer style suffix:** `cinematic game trailer, retro sci-fi, muted palette, dramatic lighting, no on-screen text`.
Overlay text + music are added in your editor afterward (see trailer brief for the script).

---

## SECTION 4 — Steam capsule / marketing (3 images)

**Save to:** `docs/marketing/`

- **Hero capsule (header, 16:9):** `Astronaut in orange coveralls at a glowing code terminal, robots and circuits around him, crashed ship and orange alien sky behind, dynamic hero composition, leaves clear empty space on the left for a logo, cinematic key-art, muted retro palette, no text.`
- **Small capsule (square):** crop/regenerate the hero, tight on the astronaut + terminal glow.
- **Background (vertical):** `Atmospheric alien salt plain at dusk under an orange sky, crashed ship silhouette, very subtle, designed to sit behind a store page, no focal subject, no text.`

---

## Workflow recap (non-tech)
1. Open Higgsfield → paste a block above → generate → pick the best → download.
2. Save into the folder noted under each section (create it if missing).
3. Backgrounds/title: tell me when they're in — I wire them into the menu/biome screens.
4. Sprites are NOT here on purpose — those go through the pixel pipeline (`pixel-artist-brief.md`).
