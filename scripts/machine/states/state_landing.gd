class_name C_StateLanding extends C_State

@export var friction_factor:float = 2
var ground_kinematic:C_KinematicGround

func _ready():
	super()

	if machine.kinematics.nodes.has(C_KinematicNode.E_Type.Ground):
		ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func can_enter() -> bool:
	return is_instance_valid(ground_kinematic)

func enter():
	super()
	set_sprite_animation()

func check_status(_delta:float):
	if is_over():
		machine.change_state("Idle")

func _physics_process(delta):
	ground_kinematic.update(delta)	
	super(delta)
