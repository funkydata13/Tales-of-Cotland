class_name C_StateJump extends C_State

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
	set_sprite_animation()

func check_status(_delta:float):
	if is_over():
		machine.change_state("Flying")

func _physics_process(delta):
	if trigger:
		trigger = false
		jump_kinematic.update(delta)
		
	super(delta)
