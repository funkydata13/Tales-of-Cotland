class_name C_StateIdle extends C_State

var ground_kinematic:C_KinematicGround

func _ready():
	super()
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func can_enter() -> bool:
	return is_instance_valid(ground_kinematic)

func enter():
	super()
	set_sprite_animation()

func check_status(_delta:float):
	if exit_by_stopwatch():
		return

	if not machine.kinematics.is_grounded:
		machine.change_state("Flying")
	elif machine.can_read_inputs:
		if GameInputs.is_just_pressed("jump"):
			machine.change_state("Jumping")
		elif GameInputs.is_just_pressed("attack"):
			machine.change_state("Attacking 1")
		elif GameInputs.direction.x != 0:
			machine.change_state("Walking" if GameInputs.is_pressed("slow") else "Running")

func _physics_process(delta):
	ground_kinematic.update(delta)
	super(delta)
