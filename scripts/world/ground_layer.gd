## GroundLayer — procedural Alkaline Flats ground.
## Builds a 4-variant salt-plain tile atlas in code (no external art needed) and
## fills a region around the origin with randomised tiles. Replaces the flat
## ColorRect background with textured ground. Sits below gameplay entities.
extends TileMapLayer

const TILE: int = 16
const VARIANTS: int = 4
## Half-extent of the filled ground region, in tiles.
const REGION: Vector2i = Vector2i(40, 30)

# Alkaline Flats: cracked white-grey salt plains (within the locked palette range).
const BASE: Color = Color("c9c2b4")
const CRACK: Color = Color("a89e8a")


func _ready() -> void:
	_build_tileset()
	_fill()


## Generate the ground atlas image + TileSet entirely in code.
func _build_tileset() -> void:
	var img: Image = Image.create(TILE * VARIANTS, TILE, false, Image.FORMAT_RGBA8)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 1337

	for v in range(VARIANTS):
		var ox: int = v * TILE
		# Base fill with subtle speckle so it doesn't look flat.
		for y in range(TILE):
			for x in range(TILE):
				var c: Color = BASE
				var n: float = rng.randf()
				if n < 0.12:
					c = BASE.darkened(0.10)
				elif n > 0.90:
					c = BASE.lightened(0.06)
				img.set_pixel(ox + x, y, c)
		# A couple of thin cracks per variant for the salt-plain look.
		var cracks: int = rng.randi_range(1, 2)
		for _i in range(cracks):
			var cx: int = rng.randi_range(2, TILE - 3)
			var cy: int = rng.randi_range(2, TILE - 3)
			var steps: int = rng.randi_range(4, 8)
			for _s in range(steps):
				if cx >= 0 and cx < TILE and cy >= 0 and cy < TILE:
					img.set_pixel(ox + cx, cy, CRACK)
				cx += rng.randi_range(-1, 1)
				cy += rng.randi_range(0, 1)

	var tex: ImageTexture = ImageTexture.create_from_image(img)

	var ts: TileSet = TileSet.new()
	ts.tile_size = Vector2i(TILE, TILE)
	var src: TileSetAtlasSource = TileSetAtlasSource.new()
	src.texture = tex
	src.texture_region_size = Vector2i(TILE, TILE)
	for v in range(VARIANTS):
		src.create_tile(Vector2i(v, 0))
	ts.add_source(src, 0)
	tile_set = ts


## Paint the ground region with randomised tile variants.
func _fill() -> void:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 99
	for ty in range(-REGION.y, REGION.y):
		for tx in range(-REGION.x, REGION.x):
			var v: int = rng.randi() % VARIANTS
			set_cell(Vector2i(tx, ty), 0, Vector2i(v, 0))
