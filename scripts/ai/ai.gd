class_name C_Ai extends Node

@export var kinematics:C_KinematicNode
@export var obstacle_detector:RayCast2D
@export var ledge_detector:RayCast2D

@export var player_detection_zone:Area2D
@export var player_detector:RayCast2D
@export var player_detector_range:float = 200

var character:C_Character
var is_facing_obstacle:bool = false
var is_facing_ledge:bool = false

var is_player_hitted:bool = false
var is_player_in_range:bool = false;
var is_player_visible = false

var distance_with_player:float:
	set (value):
		pass
	get:
		return (character.global_position - Game.player.global_position).length()

func _ready():
	character = owner as C_Character

	if is_instance_valid(player_detection_zone):
		player_detection_zone.body_entered.connect(on_enemy_detector_enter)
		player_detection_zone.body_exited.connect(on_enemy_detector_exit)

	set_process(false)

func on_enemy_detector_enter(_body):
	is_player_in_range = true
	player_detector.enabled = true

func on_enemy_detector_exit(_body):
	is_player_in_range = false
	player_detector.enabled = false

func raycast_to_player():
	if not is_instance_valid(Game.player):
		return

	player_detector.target_position = (character.to_local(Game.player.global_position) - character.to_local(character.global_position)).normalized() * player_detector_range
	if player_detector.is_colliding():
		is_player_visible = player_detector.get_collider() is C_Player

func machine_state_update(_state:C_State):
	pass

func _physics_process(_delta):
	is_facing_obstacle = is_instance_valid(obstacle_detector) and obstacle_detector.is_colliding()
	is_facing_ledge = is_instance_valid(ledge_detector) and not ledge_detector.is_colliding()

	if is_player_in_range:
		raycast_to_player()
