@tool
class_name C_Rune extends C_ActivableArea

@export_range(1,26) var variant:int = 1:
	get:
		return variant
	set (value):
		if variant != value:
			variant = value
			update_sprite()

@export var pending_color:Color = Color(0.3, 0.3, 0.3, 1.0)
@export var activated_color:Color = Color.WHITE
@export var transition_duration:float = 1

var time_left:float

func update_sprite():
	if sprite != null:
		sprite.animation = "runes"
		sprite.frame = variant - 1
		sprite.self_modulate = activated_color if state == E_State.Activated else pending_color

func activate():
	super()
	time_left = transition_duration
	set_physics_process(true)

func reset():
	super()
	time_left = 0
	set_physics_process(true)

func _physics_process(delta):
	if state == E_State.Activating:
		if time_left > 0:
			time_left -= delta
			sprite.self_modulate = lerp(pending_color, activated_color, 1.0 - (time_left / transition_duration))
		else:
			time_left = 0
			state = E_State.Activated
			monitorable = false
			sprite.self_modulate = activated_color
			set_physics_process(false)
