class_name C_StateHitted extends C_State

@export var attribute:C_Attribute
@export var friction_factor:float = 0.25

var owner_character:C_Character
var owner_previous_state:C_Character.E_State
var hit_from:Node2D
var hit_force:float

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
		push_error("Pas de C_Attribute défini pour le C_StateHitted")
	else:
		attribute.changed.connect(on_attribute_changed)

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func enter():
	super()
	set_sprite_animation(name)
	if is_character:
		owner_previous_state = owner_character.state
		owner_character.state = C_Character.E_State.Stunned

func exit():
	super()
	if is_character:
		owner_character.state = owner_previous_state

func on_attribute_changed(changed_amout:float, changed_value:float, changed_by:Node2D, force_applied:float):
	if changed_amout < 0 and changed_value > 0:
		hit_from = changed_by
		hit_force = force_applied
		machine.change_state("Hitted", true)

func check_status(_delta:float):
	if exit_by_stopwatch():
		return

func _physics_process(delta):
	if trigger:
		trigger = false
		machine.kinematics.repel(hit_from, hit_force, hit_force)
		hit_from = null
		hit_force = 0
	else:
		if machine.kinematics.is_grounded:
			ground_kinematic.update(delta, friction_factor)
		else:
			air_kinematic.update(delta)

	super(delta)