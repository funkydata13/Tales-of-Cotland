class_name C_StateFlyingJump extends C_State

var air_kinematic:C_KinematicAir
var jump_kinematic:C_KinematicJump

func _ready():
	super()

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	if air_kinematic.nodes.has(C_KinematicNode.E_Type.Jump):
		jump_kinematic = air_kinematic.nodes[C_KinematicNode.E_Type.Jump] as C_KinematicJump

func can_enter() -> bool:
	return is_instance_valid(jump_kinematic) and machine.previous_state.name == "Jumping" and not air_kinematic.is_falling

func enter():
	super()
	set_sprite_animation(name)

func check_status(_delta:float):
	if is_over():
		machine.change_state("Flying")

func _physics_process(delta):
	if trigger:
		trigger = false
		jump_kinematic.update(delta)
		
	super(delta)
