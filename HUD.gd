extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	var messageTimer = get_node("MessageTimer")
	messageTimer.timeout.connect(message_timer_timeout)
	
	var startButton = get_node("StartButton")
	startButton.pressed.connect(start_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text) :
	$Message.text = text;
	$Message.show()
	$MessageTimer.start()
	
	
func show_game_over() :
	show_message("Game Over");
	
	await $MessageTimer.timeout;
	
	#reset game
	$Message.text = "Dodge"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score) :
	$ScoreLabel.text = str(score)
	
func message_timer_timeout() :
	$Message.hide()

func start_button_pressed():
	$StartButton.hide()
	start_game.emit();
