class_name C_AIBoar extends C_Ai

enum E_AIState { Idle = 0, Resting = 1, Searching = 2, Charging = 3, Fleeing = 4 }
var state:E_AIState = E_AIState.Idle

@export var charge_minimal_distance:float = 60
@export var delay_between_attacks:float = 2

var run_speed:float = 100
var time_left:float = 0
var is_player_in_attack_zone:bool = false

var can_attack:bool:
	get:
		return is_player_in_attack_zone and time_left <= 0 and character.velocity.x == run_speed

func _ready():
	super()

	if kinematics.nodes.has(C_KinematicNode.E_Type.Air):
		ledge_detector.target_position.y = (kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir).maximum_fall_height - 2

	if kinematics.nodes.has(C_KinematicNode.E_Type.Ground):
		if kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes.has(C_KinematicNode.E_Type.Run):
			run_speed = (kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes[C_KinematicNode.E_Type.Run] as C_KinematicMove).speed

	(character.get_node("Attack 1") as Area2D).body_entered.connect(on_body_enter_attack_area)
	(character.get_node("Attack 1") as Area2D).body_exited.connect(on_body_exit_attack_area)

func on_body_enter_attack_area(body):
	if (body is C_Player):
		is_player_in_attack_zone = true

func on_body_exit_attack_area(body):
	if (body is C_Player):
		is_player_in_attack_zone = false

func machine_state_update(machine_state:C_State):
	#print_debug("Nouvel état : ", machine_state.name)
	if not machine_state.name.begins_with("AI "):
		state = E_AIState.Idle
	elif machine_state.name == "AI Idle":
		state = E_AIState.Idle
	elif machine_state.name == "AI Resting" or machine_state.name == "AI Hitted":
		state = E_AIState.Resting
	elif machine_state.name == "AI Searching":
		state = E_AIState.Searching
	elif machine_state.name == "AI Running":
		state = E_AIState.Charging if distance_with_player >= charge_minimal_distance else E_AIState.Fleeing

func _physics_process(delta):
	super(delta)

	if state == E_AIState.Idle:
		if is_facing_obstacle or (is_facing_ledge and kinematics.is_grounded):
			character.flip()
	elif state == E_AIState.Resting:
		if is_player_in_range:
			character.turn_to(Game.player.global_position)
	elif state == E_AIState.Searching:
		if is_facing_obstacle or (is_facing_ledge and kinematics.is_grounded):
			character.flip()
	elif state == E_AIState.Charging:
		if is_facing_obstacle or (is_facing_ledge and kinematics.is_grounded):
			character.flip()
	elif state == E_AIState.Fleeing:
		character.turn_to(Game.player.global_position, true)
		if is_facing_obstacle or (is_facing_ledge and kinematics.is_grounded):
			character.flip()
			state = E_AIState.Charging

	if state >= 3:
		if can_attack:
			is_player_hitted = true
			Game.player.take_damage(C_Attribute.E_Type.Vitality, 5, character, 250)
			time_left = delay_between_attacks
		else:
			if time_left > 0:
				time_left -= delta
			is_player_hitted = false
		