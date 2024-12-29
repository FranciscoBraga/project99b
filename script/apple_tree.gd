extends Node2D

var state = "no apples"
var player_in_area = false

var apple = preload("res://scene/apple_collectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == "no apples":
		$growth_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "no apples":
		$AnimatedSprite2D.play("no apples")
	if state == "apples":
		$AnimatedSprite2D.play("apples")
		if player_in_area:
			if Input.is_action_just_pressed("E"):
				print("estou na area")
				state = "no apples"
				drop_apple()
		


func _on_pickapple_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true


func _on_pickapple_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false


func _on_growth_timer_timeout() -> void:
	if state == "no apples": 
		state = "apples"

func drop_apple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = $Marker2D.global_position
	get_parent().add_child(apple_instance)
	
	await  get_tree().create_timer(3).timeout
	$growth_timer.start()
	