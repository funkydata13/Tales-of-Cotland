class_name C_ActivableBody extends RigidBody2D

enum E_State { Pending, Activating, Desactivating, Activated, Desactivated }
var state:E_State:
    get:
        return state
    set (value):
        if state != value:
            state = value
            update_sprite()

@export var activation_childs:Array[Node2D] = []
var sprite:C_Sprite

var is_switching:bool:
    set (value):
        pass
    get:
        return state == E_State.Activating || state == E_State.Desactivating

var has_switched:bool:
    set (value):
        pass
    get:
        return state == E_State.Activated || state == E_State.Desactivated

func _ready():
    sprite = get_node("Sprite") as C_Sprite
    update_sprite()

func update_sprite():
    pass

func can_activate(_actor:Node2D) -> bool:
    return state == E_State.Pending

func activate():
    if state == E_State.Pending:
        state = E_State.Activating
    elif state == E_State.Activated:
        state = E_State.Desactivating
    else:
        return

    for child in activation_childs:
        if child.has_method("activate"):
            child.activate()

func reset():
    state = E_State.Pending
    update_sprite()