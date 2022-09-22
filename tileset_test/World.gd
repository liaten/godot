extends Node2D

const WIDTH = 500
const HEIGHT = 500

const TILES = {
	'empty': 0,
	'isle': 1
}

var open_simplex_noise

func _ready():
	randomize()
	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	
	open_simplex_noise.octaves = 4
	open_simplex_noise.period = 20
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 0.75
	
	_generate_world()
	
func _generate_world():
	for x in WIDTH:
		for y in HEIGHT:
			$TileMap.set_cellv(
				Vector2(
					x - WIDTH / 2,
					y - HEIGHT / 2
					),
				_get_tile_index(
					open_simplex_noise.get_noise_2d(
						float(x),
						float(y)
					)
				)
			)
	$TileMap.update_bitmask_region()

func _get_tile_index(noise_sample):
	print(noise_sample)
	if noise_sample < 0:
		return TILES.empty
	return TILES.isle
