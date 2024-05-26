class_name C_StateWallContact extends C_State

@export var sprite_x_offset:float = -4
@export var fall_speed:float = 60

var sprite_x_offset_backup:float
var fall_speed_backup:float
var air_kinematic:C_KinematicAir

func _ready():
	super()

	if machine.kinematics.nodes.has(C_KinematicNode.E_Type.Air):
		air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir;

func can_enter() -> bool:
	return is_instance_valid(air_kinematic)

func enter():
	super()
	set_sprite_animation()

	sprite_x_offset_backup = machine.sprite.offset.x
	machine.sprite.offset.x = sprite_x_offset

	fall_speed_backup = air_kinematic.maximum_speed
	air_kinematic.maximum_speed = fall_speed

func undo_state():
	air_kinematic.maximum_speed = fall_speed_backup
	machine.sprite.offset.x = sprite_x_offset_backup

func check_status(_delta:float):
	if is_over():
		if machine.kinematics.is_grounded:
			undo_state()
			machine.change_state("Idle")
		else:
			if machine.obstacle_detector.is_colliding() and (machine.obstacle_detector.get_collider() is TileMap):
				machine.change_state("Wall Sliding")
			else:
				undo_state()
				machine.change_state("Flying")
	elif machine.can_read_inputs:
		if GameInputs.is_just_pressed("jump"):
			undo_state()
			machine.change_state("Wall Jumping")

func _physics_process(delta):
	air_kinematic.update(delta)
	super(delta)

