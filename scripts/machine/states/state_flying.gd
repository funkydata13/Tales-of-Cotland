class_name C_StateFlying extends C_State

@export var animation_replacer:String = ""
var air_kinematic:C_KinematicAir
var move_kinematic:C_KinematicMove

func _ready():
	super()

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	if air_kinematic.nodes.has(C_KinematicNode.E_Type.AirMove):
		move_kinematic = air_kinematic.nodes[C_KinematicNode.E_Type.AirMove] as C_KinematicMove

func select_sprite_animation():
	if animation_replacer == "":
		set_sprite_animation_name("Flying Down" if machine.kinematics.is_falling else "Flying Up")
	else:
		set_sprite_animation_name(animation_replacer)

func can_enter() -> bool:
	return is_instance_valid(air_kinematic)

func enter():
	super()
	select_sprite_animation()

func check_status(_delta:float):
	if machine.kinematics.is_grounded:
		machine.change_state("Landing" if air_kinematic.is_high_fall else "Idle")
		air_kinematic.reset_node()
	elif is_instance_valid(machine.obstacle_detector) and machine.kinematics.is_falling and machine.obstacle_detector.is_colliding() and (machine.obstacle_detector.get_collider() is TileMap):
		machine.change_state("Wall Contact")
		air_kinematic.reset_node()
	elif machine.can_read_inputs:
		if GameInputs.is_just_pressed("jump"):
			machine.change_state("Flying Jump")
		elif GameInputs.is_just_pressed("attack"):
			machine.change_state("Attacking 1")

func _physics_process(delta):
	select_sprite_animation()
	air_kinematic.update(delta)
	if machine.can_read_inputs and is_instance_valid(move_kinematic) and GameInputs.direction.x != 0:
		move_kinematic.update(delta)

	super(delta)