class_name C_MachineState extends Node

@export var read_inputs:bool = false
@export var default_state:String = "Idle"
@export var sprite:C_Sprite
@export var kinematics:C_KinematicNode
@export var obstacle_detector:RayCast2D
@export var ledge_detector:RayCast2D

var current_state:C_State
var previous_state:C_State

var can_read_inputs:bool

func _ready():
	if not is_instance_valid(sprite):
		push_error("C_MachineState : C_Sprite manquant !")

	if not is_instance_valid(kinematics):
		push_error("C_MachineState : C_KinematicNode manquant !")

	current_state = find_child(default_state) as C_State
	current_state.can_enter()
	current_state.enter()

	set_process(false)

func change_state(state_name:String, override:bool = false):
	if not has_node(state_name):
		return false

	if state_name == current_state.name:
		if not override:
			return false
		else:
			current_state.exit()
			current_state.enter()
			return true

	var new_state:C_State = find_child(state_name) as C_State
	if new_state.can_enter():
		current_state.exit()
		previous_state = current_state
		current_state = new_state
		current_state.enter()
		return true
	else:
		return false

func _physics_process(_delta):
	can_read_inputs = read_inputs and GameInputs.can_listen_inputs(C_Inputs.E_InputListener.Player)
