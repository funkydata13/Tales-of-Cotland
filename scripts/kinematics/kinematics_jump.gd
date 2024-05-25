class_name C_KinematicJump extends C_KinematicNode

@export var air_node:C_KinematicAir
@export var impulsion:bool = false
@export var local_gravity:bool = false
@export var height:float = 50
@export var time_to_peak:float = 0.4
@export var time_to_descent:float = 0.25

func _init():
    type = E_Type.Jump

func _ready():
    super()

    if not is_instance_valid(air_node):
        push_error("Impossible de trouver le C_KinematicAir pour le C_KinematicJump")

func update(_delta:float, factor:float = 1):
    var jump_velocity:float = 0

    if local_gravity:
        air_node.current_fall_gravity = (-2.0 * height) / (time_to_descent * time_to_descent) * -1.0 * factor;
        air_node.current_raise_gravity = (-2.0 * height) / (time_to_peak * time_to_peak) * -1.0 * factor;
        jump_velocity = 2.0 * height / time_to_peak * -1.0 * factor;
    else:
        jump_velocity = -height

    if impulsion:
        character.velocity.y += jump_velocity
    else:
        character.velocity.y = jump_velocity