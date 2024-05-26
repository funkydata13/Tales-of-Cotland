class_name C_StateAttack extends C_State

enum E_ComboState {Pending, Failure, Success }

@export_category("Attack")
@export var area:Area2D
@export var repel_force:float = 10
@export var index:int = 1
@export var combo_link:bool = false
@export var combo_frame_trigger:int = 1

@export_category("Consumption")
@export var attribute_consumed:C_Attribute.E_Type = C_Attribute.E_Type.Stamina
@export var attribute_consumption:float = 1

@export_category("Damage")
@export var attribute_targeted:C_Attribute.E_Type = C_Attribute.E_Type.Vitality
@export var attribute_damage:float = 1

var owner_node:Node2D
var consumed_attribute_instance:C_Attribute
var combo_state:E_ComboState = E_ComboState.Pending
var targets:Array = []

var air_kinematic:C_KinematicAir
var ground_kinematic:C_KinematicGround

func _ready():
	super()
	
	animation_name_override = "Attacking " + str(index)

	if is_instance_valid(area):
		area.area_entered.connect(on_area_enter)
		area.area_exited.connect(on_area_exit)
		area.body_entered.connect(on_body_enter)
		area.body_exited.connect(on_body_exit)
	else:
		push_error("Pas de Area2D attachée pour l'état C_StateAttack")

	owner_node = owner as Node2D

	air_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir
	ground_kinematic = machine.kinematics.nodes[C_KinematicNode.E_Type.Ground] as C_KinematicGround

func on_area_enter(target):
	check_detected(target)

func on_area_exit(target):
	check_lost(target)

func on_body_enter(target):
	check_detected(target)

func on_body_exit(target):
	check_lost(target)

func check_detected(target):
	if target.has_method("take_damage"):
		targets.append(target)

func check_lost(target):
	if targets.has(target):
		targets.erase(target)

func can_enter() -> bool:
	if consumed_attribute_instance == null and owner.attributes.has(attribute_consumed):
		consumed_attribute_instance = owner.attributes[attribute_consumed] as C_Attribute

	return is_instance_valid(consumed_attribute_instance) && consumed_attribute_instance.value >= attribute_consumption

func enter():
	super()
	set_sprite_animation()
	combo_state = E_ComboState.Pending if machine.kinematics.is_grounded else E_ComboState.Failure

func exit():
	super()
	if targets.size() > 0:
		for i in range(targets.size()):
			targets[i].take_damage(attribute_targeted, attribute_damage, owner_node, repel_force)
	
	consumed_attribute_instance.modify(-attribute_consumption, owner_node, 0)

func check_combo():
	if machine.can_read_inputs:
		if combo_state == E_ComboState.Pending and GameInputs.is_just_pressed("attack"):
			combo_state = E_ComboState.Success if machine.sprite.frame >= combo_frame_trigger else E_ComboState.Failure

func check_status(_delta:float):
	check_combo()

	if is_over():
		if combo_state == E_ComboState.Success:
			if machine.change_state("Attacking " + str(index + 1)):
				return
		
		machine.change_state("Idle")

func _physics_process(delta):
	if machine.kinematics.is_grounded:
		ground_kinematic.update(delta)
	else:
		air_kinematic.update(delta)

	super(delta)
