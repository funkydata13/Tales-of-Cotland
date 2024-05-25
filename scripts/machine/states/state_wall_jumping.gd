class_name C_StateWallJumping extends C_State

@export var jump_factor:float = 1
@export var lateral_impulse:float = 150

var jump_kinematic:C_KinematicJump

func _ready():
	super()

	if machine.kinematics.nodes.has(C_KinematicNode.E_Type.Ground):
		if machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes.has(C_KinematicNode.E_Type.Jump):
			jump_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes[C_KinematicNode.E_Type.Jump] as C_KinematicJump

func can_enter() -> bool:
	return is_instance_valid(jump_kinematic)

func enter():
	super()
	set_sprite_animation(name)

func check_status(_delta:float):
	if is_over():
		machine.change_state("Flying")

func _physics_process(delta):
	if trigger:
		trigger = false
		machine.kinematics.push(lateral_impulse, false, false, true)
		jump_kinematic.update(delta, jump_factor)
		
	super(delta)