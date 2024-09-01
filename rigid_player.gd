extends CharacterBody2D

signal hit
signal shake

@export var speed = 200;
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	$Area2D.body_entered.connect(body_did_enter)
	
	hide()

func start(pos) :
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vel = Vector2.ZERO
	if Input.is_action_pressed("move_up"): vel.y = -1
	if Input.is_action_pressed("move_down"): vel.y = 1
	if Input.is_action_pressed("move_left"): vel.x = -1
	if Input.is_action_pressed("move_right"): vel.x = 1
	
	
	if vel.length() > 0 : 
		vel = vel.normalized() * speed
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
		
	if vel.x != 0 :
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = vel.x < 0
	elif vel.y != 0 :
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_v = vel.y > 0
		
		
	#position += vel * delta
	velocity = vel * speed * delta;
	move_and_slide()
	#position = position.clamp(Vector2.ZERO, screen_size)
	

func body_did_enter(body) :
	if (body.is_in_group("enemy")) :
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		print("hit" + body.name)
	else : 
		print("WHAT")
		print(body.name)
		shake.emit();

