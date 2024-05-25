class_name C_Level extends Node2D

const levels_path:String = "res://levels/$.tscn"

enum E_PlayerState { Null, Defeated, Dead, Live, Operationnal }
var player_state:E_PlayerState

@export var next_level:String = "main_menu"
@export var is_playable:bool = true
@export var player_spawner:C_PlayerSpawner
@export var player_respawn_delay:float = 2

var respawn_duration:float

func _ready():
	Game.level = self

	if is_playable and not is_instance_valid(player_spawner):
		push_error("Pas de C_PlayerSpawner attaché à un niveau jouable C_Level !")

	set_process(is_playable)
	set_physics_process(false)

func on_player_defeated():
	respawn_duration = player_respawn_delay
	player_state = E_PlayerState.Defeated

func to_next_level():
	if next_level != "":
		change_level(next_level)

func change_level(level_path:String):
	var next_level_path:String = levels_path.replace("$", level_path)

	if not ResourceLoader.exists(next_level_path):
		next_level_path += ".remap"

	if ResourceLoader.exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
	else:
		push_error("Le niveau " + level_path + " localisé en théorie dans " + next_level_path + " n'existe pas !")

func _process(delta):
	if not is_instance_valid(Game.player) and is_instance_valid(player_spawner) and (player_state == E_PlayerState.Null or player_state == E_PlayerState.Dead):
		player_spawner.create_instance()
		player_state = E_PlayerState.Live
	elif player_state == E_PlayerState.Live:
		Game.player.defeated.connect(on_player_defeated)
		player_state = E_PlayerState.Operationnal
	elif player_state == E_PlayerState.Defeated:
		if respawn_duration > 0:
			respawn_duration -= delta
		else:
			player_state = E_PlayerState.Dead
			Game.player.queue_free()