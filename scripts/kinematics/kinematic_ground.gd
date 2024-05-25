class_name C_KinematicGround extends C_KinematicNode

@export var maximum_speed:float = 500
@export var friction:float = 20

func _init():
    type = E_Type.Ground

func update(_delta:float, factor:float = 1):
    character.velocity.x = clampf(move_toward(character.velocity.x, 0, friction * factor), -maximum_speed, maximum_speed)