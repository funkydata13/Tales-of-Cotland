class_name C_Item extends RigidBody2D

enum E_State { Idle, Dropping, Pending, Picking }
enum E_Type { Key, Coin, Vitality, Stamina, Magic }

@export var initial_state:E_State = E_State.Idle

var _type:E_Type
var state:E_State

var inventory:C_Inventory
var sprite:Sprite2D
var anim_player:AnimationPlayer

func _ready():
    state = initial_state

    sprite = get_node("Sprite") as Sprite2D
    if not is_instance_valid(sprite):
        push_error("Pas de Sprite2D trouvé pour le C_Item !")
    
    anim_player = get_node("Sprite/Animation Player") as AnimationPlayer
    if not is_instance_valid(anim_player):
        push_error("Pas d'AnimationPlayer trouvé pour le C_Item !")

func get_type() -> E_Type:
    return _type

func drop(drop_position:Vector2):
    if state != E_State.Idle:
        return

    randomize()

    state = E_State.Dropping
    global_position = drop_position
    linear_velocity = Vector2(randf_range(-0.25, 0.25), -1) * 200
    anim_player.play("item_animations/pop", -1, -2, true)
    visible = true

func pick(_pick_position:Vector2, target_inventory:C_Inventory = null):
    if state != E_State.Pending:
        return

    state = E_State.Picking
    inventory = target_inventory
    linear_velocity = Vector2(0, -1) * 200
    anim_player.play("item_animations/pop", -1, 2)

func _physics_process(_delta):
    if is_instance_valid(anim_player) and not anim_player.is_playing():
        if state == E_State.Dropping:
            state = E_State.Pending
        elif state == E_State.Picking:
            if is_instance_valid(inventory):
                inventory.append(get_type(), 1)
            queue_free()