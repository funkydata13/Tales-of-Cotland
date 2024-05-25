class_name C_KinematicNode extends Node

enum E_Type { Root, Ground, Air, Move, Jump, Slide, Walk, Run, Sprint, AirMove }
@export var type:E_Type

var character:C_Character
var nodes:Dictionary

var is_grounded:bool:
    set (value):
        pass
    get:
        return character.is_on_floor()

var is_falling:bool:
    set (value):
        pass
    get:
        return character.velocity.y >= 0

var is_direction_just_changed:bool:
    set (value):
        pass
    get:
        return character.velocity.x * character.forward_direction < 0

var velocity:Vector2:
    set (value):
        pass
    get:
        return character.velocity;

func _ready():
    character = owner as C_Character

    nodes = {}
    for node in get_children():
        if node is C_KinematicNode:
            nodes[(node as C_KinematicNode).type] = node as C_KinematicNode

    set_process(false);
    set_physics_process(false);

func repel(from:Node2D, lateral_speed:float, vertical_speed:float, impulsion:bool = false):
    var force:Vector2 = Vector2.ZERO
    force.x = 1 if character.global_position.x >= from.global_position.x else -1;
    force.x *= lateral_speed
    force.y = -vertical_speed

    if impulsion:
        character.velocity += force
    else:
        character.velocity = force

func push(speed:float, forward:bool, impulsion:bool = false, auto_flip_actor:bool = false):
    var v = character.forward_direction * speed

    if not forward:
        v *= -1
        if auto_flip_actor: character.flip()

    if impulsion:
        character.velocity.x += v
    else:
        character.velocity.x = v

func update(_delta:float, _factor:float = 1):
    pass
