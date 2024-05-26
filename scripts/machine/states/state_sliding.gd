class_name C_StateSliding extends C_State

@export var start_sliding_state:C_StateSlidingStart
var friction_factor_delta:float
var run_speed:float

var air_kinematic:C_KinematicAir
var ground_kinematic:C_KinematicGround

func _ready():
	super()

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func enter():
	super()
	set_sprite_animation()

	var f:float

	if start_sliding_state.is_breaked:
		f = start_sliding_state.friction_factor_on_break
	else:
		f = start_sliding_state.slide_kinematic.friction / ground_kinematic.friction

	friction_factor_delta = f
	run_speed = ground_kinematic.nodes[C_KinematicNode.E_Type.Run].speed

func check_status(_delta:float):
	if machine.kinematics.is_direction_just_changed or not machine.kinematics.is_grounded or start_sliding_state.slide_kinematic.is_break:
		machine.change_state("Sliding End")
	elif machine.can_read_inputs:
		if GameInputs.direction.y > 0 or (GameInputs.direction.x != 0 and absf(machine.kinematics.velocity.x) <= run_speed):
			machine.change_state("Sliding End")

func _physics_process(delta):
	if (is_instance_valid(machine.ledge_detector) and not machine.ledge_detector.is_colliding()) or (is_instance_valid(machine.obstacle_detector) and machine.obstacle_detector.is_colliding()):
		start_sliding_state.is_breaked = true
		friction_factor_delta = start_sliding_state.friction_factor_on_break

	if machine.kinematics.is_grounded:
		ground_kinematic.update(delta, friction_factor_delta)
	else:
		air_kinematic.update(delta)

	super(delta)