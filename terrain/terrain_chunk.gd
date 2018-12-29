extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
const CHUNK_WIDTH = 240
const CHUNK_DEPTH = 240
const MAX_HEIGHT = 300
var zone_x = 0
var zone_y = 0
var chunk_x = 0
var chunk_y = 0
var seed_value = 0
onready var rnd = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()
func _ready():
	rnd.seed = seed_value
	noise.seed = seed_value
	if mesh is PlaneMesh:
		var arrays = mesh.get_mesh_arrays()
		var amesh = ArrayMesh.new()
		amesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		amesh.surface_set_material(0, mesh.surface_get_material(0))
		mesh = amesh
	update()
func update():
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	print(mdt.get_vertex_count())
	var count = mdt.get_vertex_count()
	for k in range(count):
		var v = mdt.get_vertex(k)
		var h = noise.get_noise_2d(v.x, v.z) * MAX_HEIGHT
		v.y = h
		mdt.set_vertex(k, v)
	mesh.surface_remove(0)
	mdt.commit_to_surface(mesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
