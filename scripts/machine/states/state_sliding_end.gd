class_name C_StateSlidingEnd extends C_State

@export var disable_ledge_detector_onexit:bool = false
@export var start_sliding_state:C_StateSlidingStart

var air_kinematic:C_KinematicAir
var ground_kinematic:C_KinematicGround

func _ready():
	super()

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func enter():
	super()
	set_sprite_animation(name)

func exit():
	super()
	
	if is_instance_valid(machine.ledge_detector):
		if disable_ledge_detector_onexit:
			machine.ledge_detector.enabled = false
			
		machine.ledge_detector.target_position.y = start_sliding_state.ledge_detector_previous_position

func check_status(_delta:float):
	if is_over():
		machine.change_state("Idle" if machine.kinematics.is_grounded else "Flying")

func _physics_process(delta):
	if start_sliding_state.is_breaked:
		if machine.kinematics.is_grounded:
			ground_kinematic.update(delta, start_sliding_state.friction_factor_on_break)
		else:
			air_kinematic.update(delta)

	super(delta)
