class_name C_KinematicMove extends C_KinematicNode

@export var speed:float = 110
@export var friction:float = 20
var maximum_speed:float = 500

func _init():
    type = E_Type.Move

func update(_delta:float, factor:float = 1):
    if type != E_Type.Move:
        character.velocity.x = clampf(move_toward(character.velocity.x, character.forward_direction * speed * factor, friction * factor), -maximum_speed, maximum_speed)