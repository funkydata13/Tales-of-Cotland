class_name C_StateRunning extends C_State

var move_kinematic:C_KinematicMove

func _ready():
	super()

	if machine.kinematics.nodes.has(C_KinematicNode.E_Type.Ground):
		if machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes.has(C_KinematicNode.E_Type.Run):
			move_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground].nodes[C_KinematicNode.E_Type.Run] as C_KinematicMove

func can_enter() -> bool:
	if is_instance_valid(machine.obstacle_detector) and machine.obstacle_detector.is_colliding():
		return false
	else:
		return is_instance_valid(move_kinematic)

func enter():
	super()
	set_sprite_animation(name)

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
		elif GameInputs.is_just_pressed("slide"):
			machine.change_state("Sliding Start")
		elif GameInputs.direction.x == 0 || (is_instance_valid(machine.obstacle_detector) and machine.obstacle_detector.is_colliding()):
			machine.change_state("Idle")
		elif GameInputs.is_pressed("slow"):
			machine.change_state("Walking")

func _physics_process(delta):
	move_kinematic.update(delta)
	super(delta)