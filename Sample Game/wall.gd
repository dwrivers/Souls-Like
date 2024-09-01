extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_node("Main")
	print("HELLO HELLO")
	main.over.connect(game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over() :
	queue_free()
