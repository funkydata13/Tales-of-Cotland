class_name C_StateWallSliding extends C_State

@export var wall_contact_state:C_StateWallContact
var air_kinematic:C_KinematicAir

func _ready():
	super()

	if machine.kinematics.nodes.has(C_KinematicNode.E_Type.Air):
		air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir;

func enter():
	super()
	set_sprite_animation(name)

func exit():
	super()
	wall_contact_state.undo_state()

func check_status(_delta:float):
	
	if machine.kinematics.is_grounded:
		machine.change_state("Idle")
	elif not machine.obstacle_detector.is_colliding() or not (machine.obstacle_detector.get_collider() is TileMap):
		machine.change_state("Flying")
	elif machine.can_read_inputs:
		if GameInputs.is_just_pressed("jump"):
			machine.change_state("Wall Jumping")

func _physics_process(delta):
	air_kinematic.update(delta)
	super(delta)
