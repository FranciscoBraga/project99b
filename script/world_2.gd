extends Node2D

@onready var animoLayer = $worloperingcutscene/AnimationPlayer
@onready var camera = $worloperingcutscene/Path2D/PathFollow2D/Camera2D

var is_openingcutScene = false

var has_player_entered_area = false
var player = null

var smoke_has_happened = false
var smoke_is_happening = false

var is_pathfollowing = false

func _physics_process(delta: float) -> void:
	if is_openingcutScene:
		var pathfollower = $worloperingcutscene/Path2D/PathFollow2D
		
		if is_pathfollowing:
			if !smoke_is_happening:
				pathfollower.progress_ratio += 0.001
			
			if pathfollower.progress_ratio >= 1:
				cutesceneending()
				
			if !smoke_has_happened and pathfollower.progress_ratio >= 0.78 and !smoke_is_happening:
				smoke_is_happening = true
				toggle_smoke()
				await get_tree().create_timer(1).timeout
				$"worloperingcutscene/TileMapLayer-default".visible = true
				$"worloperingcutscene/TileMapLayer-trees".visible = false
				toggle_smoke()
				await get_tree().create_timer(0.5).timeout
				smoke_has_happened = true
				smoke_is_happening = false
				

func _on_player_decection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		if !has_player_entered_area:
			print("estou aqui")
			has_player_entered_area = true
			cutesceneopening()
			

func cutesceneopening():
	is_openingcutScene = true
	animoLayer.play("cover_fade")
	player.camera.enabled = false	
	camera.enabled = true
	is_pathfollowing = true
	
	
func cutesceneending():
	is_pathfollowing  = false
	is_openingcutScene = false
	camera.enabled = false
	player.camera.enabled = true
	$worloperingcutscene.visible = true
	$world2main.visible = true
	
	
func toggle_smoke():
	var smoke1 =  $worloperingcutscene/smokerParticles1
	smoke1.emitting = false
	await  get_tree().create_timer(1).timeout
	smoke1.emitting = true
	await  get_tree().create_timer(1).timeout
	smoke1.emitting = false
	
	
	
