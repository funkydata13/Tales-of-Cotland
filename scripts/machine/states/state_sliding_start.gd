class_name C_StateSlidingStart extends C_State

@export var ledge_minimal_height:float = 30
@export var friction_factor_on_break:float = 4

var is_breaked:bool = false
var obstacle_detector_previous_position:float
var ledge_detector_previous_position:float

var slide_kinematic:C_KinematicSlide

func _ready():
	super()

	if machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes.has(C_KinematicNode.E_Type.Slide):
		slide_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes[C_KinematicNode.E_Type.Slide] as C_KinematicSlide

func can_enter() -> bool:
	return is_instance_valid(slide_kinematic)

func enter():
	super()
	set_sprite_animation(name)

	is_breaked = false

	if is_instance_valid(machine.ledge_detector):
		if not machine.ledge_detector.enabled:
			machine.ledge_detector.enabled = true

		ledge_detector_previous_position = machine.ledge_detector.target_position.y
		machine.ledge_detector.target_position.y = ledge_minimal_height

func check_status(_delta:float):
	if is_over():
		machine.change_state("Sliding")
	elif (is_instance_valid(machine.ledge_detector) and not machine.ledge_detector.is_colliding()) or (is_instance_valid(machine.obstacle_detector) and machine.obstacle_detector.is_colliding()):
		is_breaked = true;
		machine.change_state("Sliding")

func _physics_process(delta):
	if trigger:
		trigger = false
		slide_kinematic.update(delta, friction_factor_on_break if is_breaked else 1.0)

	super(delta)