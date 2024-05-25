class_name C_Character extends CharacterBody2D

enum E_State { Free = 0, Rooted = 1, Stunned = 2, Freezed = 3 }
var state:E_State = E_State.Free

var inventory:C_Inventory
var attributes:Dictionary

var _is_facing_right:bool = true
var is_facing_right:bool:
    get:
        return _is_facing_right;
    set (value):
        if state < 2 and _is_facing_right != value:
            _is_facing_right = value
            scale.x = -scale.x

var forward_direction:float:
    set (value):
        pass
    get:
        return 1 if _is_facing_right else -1

func _ready():
    if has_node("Inventory"):
        inventory = get_node("Inventory") as C_Inventory

    attributes = {}
    if has_node("Attributes"):
        for node in get_node("Attributes").get_children():
            if node is C_Attribute:
                attributes[(node as C_Attribute).type] = node as C_Attribute

func has_attribute(type:C_Attribute.E_Type) -> bool:
    return attributes.keys().has(type)

func flip():
    is_facing_right = not is_facing_right

func take_damage(type:C_Attribute.E_Type, amount:float, from:Node2D, repel_force:float):
    (attributes[type] as C_Attribute).modify(-amount, from, repel_force)

func _physics_process(_delta):
    move_and_slide()

func dispose():
    queue_free()