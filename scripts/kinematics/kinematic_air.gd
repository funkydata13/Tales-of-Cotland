class_name C_KinematicAir extends C_KinematicNode

@export var base_fall_gravity:float = 980
@export var base_raise_gravity:float = 980
@export var maximum_speed:float = 500
@export var maximum_fall_height:float = 120

var current_fall_gravity:float = 980
var current_raise_gravity:float = 980
var peek_height:float = 99999999999

var is_high_fall:bool:
    set (value):
        pass
    get:
        return abs(character.global_position.y - peek_height) > maximum_fall_height

var current_gravity:float:
    set (value):
        pass
    get:
        return current_fall_gravity if is_falling else current_raise_gravity

func reset_gravity():
    current_fall_gravity = base_fall_gravity
    current_raise_gravity = base_raise_gravity

func reset_node():
    reset_gravity()
    peek_height = 9999999999

func _init():
    type = E_Type.Air

func _ready():
    super()
    reset_gravity()

func update(delta:float, factor:float = 1):
    if peek_height > character.global_position.y:
        peek_height = character.global_position.y

    character.velocity.y = clampf(character.velocity.y + (current_gravity * factor * delta), -maximum_speed, maximum_speed)