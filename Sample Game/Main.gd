extends Node

@export var mob_scene : PackedScene
@export var wall_scene : PackedScene
var score
var screen_size
var rmag = 0;

var noise = FastNoiseLite.new()

signal over

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().size
	
	var HUD = get_node("HUD")
	HUD.start_game.connect(new_game)
	
	var scoreTimer = get_node(("ScoreTimer"))
	scoreTimer.timeout.connect(score_timer_timeout)
	
	var startTimer = get_node("StartTimer")
	startTimer.timeout.connect(start_timer_timeout)
	
	var mobTimer = get_node("MobTimer")
	mobTimer.timeout.connect(mob_timer_timeout)
	
	var player = get_node("Player")
	player.hit.connect(game_over)
	
	player.shake.connect(_shake)
	
	
	
func _shake() :
	rmag = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var cam = get_node("Player/FollowCam")
	#if Input.is_action_pressed("jump"): rmag = 0.3
	cam.rotation = (randf() - 0.5)*rmag
	rmag *= 0.9


func game_over():
	over.emit()
	print("over")
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	

func new_game() :
	score = 0;
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	for n in 20 :
		var barrier = wall_scene.instantiate()
		barrier.add_to_group("wall")
		barrier.position = Vector2(0, n*50)
		var barrier2 = wall_scene.instantiate()
		barrier2.add_to_group("wall")
		barrier2.position = Vector2(1000, n*50)
		var barrier3 = wall_scene.instantiate()
		barrier3.add_to_group("wall")
		barrier3.position = Vector2(n*50, 0)
		var barrier4 = wall_scene.instantiate()
		barrier4.add_to_group("wall")
		barrier4.position = Vector2(n*50, 1000)
		add_child(barrier)
		add_child(barrier2)
		add_child(barrier3)
		add_child(barrier4)
	
	noise.seed = randi()	
	noise.frequency = 0.1
	for i in 20 :
		for j in 20 :
			if ((abs(i - 10) > 2 && abs(j - 10) > 2) && (noise.get_noise_2d(i, j) * 0.5 + 0.5) > 0.5) :
				var barrier = wall_scene.instantiate()
				barrier.add_to_group("wall")
				barrier.position = Vector2(i*50, j*50)
				add_child(barrier)



func score_timer_timeout():
	score += 1
	
	$HUD.update_score(score)
	
	


func start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
	


func mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = Vector2.ZERO
	var direction = randf()*PI*2
	var rad = (400 + randf()*200)
	mob_spawn_location = Vector2(rad*cos(direction + PI), rad*sin(direction + PI)) + $Player.position#Vector2(randf()*1000, randf()*1000)
	
		
	mob.position = mob_spawn_location
	direction += -0.5 + randf();
	mob.rotation = direction
	
	var speed = 150 + randf()*150
	var vel = Vector2(speed*cos(direction), speed*sin(direction))
	#mob.position += vel
	mob.linear_velocity = vel
	
	mob.add_to_group("enemy")
	
	add_child(mob)
	
