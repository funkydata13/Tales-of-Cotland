class_name C_StateDeath extends C_State

@export var attribute:C_Attribute
@export var friction_factor:float = 5

var owner_character:C_Character
var air_kinematic:C_KinematicAir
var ground_kinematic:C_KinematicGround

var is_character:bool:
	set (value):
		pass
	get:
		return owner_character != null

func _ready():
	super()

	if owner is C_Character:
		owner_character = owner as C_Character

	if not is_instance_valid(attribute):
		push_error("Pas de C_Attribute défini pour le C_StateDeath")
	else:
		attribute.depleted.connect(on_attribute_depleted)

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func enter():
	super()
	set_sprite_animation(name)
	if is_character:
		owner_character.state = C_Character.E_State.Freezed

func on_attribute_depleted(_depleted_by:Node2D):
	machine.change_state("Death")

func check_status(_delta:float):
	if is_over() and trigger:
		trigger = false
		if owner.has_method("dispose"):
			owner.dispose()

func _physics_process(delta):
	if machine.kinematics.is_grounded:
		ground_kinematic.update(delta, friction_factor)
	else:
		air_kinematic.update(delta, friction_factor)

	super(delta)
