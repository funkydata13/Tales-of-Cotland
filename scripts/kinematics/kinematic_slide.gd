class_name C_KinematicSlide extends C_KinematicNode

@export var speed:float = 200
@export var friction:float = 5
@export var break_factor:float = 0.2

var is_break:bool:
    set (value):
        pass
    get:
        return absf(character.velocity.x) <= speed * break_factor

func _init():
    type = E_Type.Slide

func update(_delta:float, factor:float = 1):
    character.velocity.x = speed * character.forward_direction * factor