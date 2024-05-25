class_name C_Camera extends Camera2D

@export var is_tracking_player:bool = false
@export var view_offset:Vector2 = Vector2(50, -30)
@export var offset_with_player:bool = false

var tracked_node:Node2D
var current_offset:Vector2
var previous_offset:Vector2

func _ready():
    set_process(false)
    set_physics_process(true)

func set_target(target:Node2D):
    if is_instance_valid(target):
        tracked_node = target
        current_offset = view_offset
        previous_offset = view_offset

func update():
    var updated:bool = false

    if GameInputs.camera_direction.x != 0:
        current_offset.x = view_offset.x if GameInputs.camera_direction.x > 0 else -view_offset.x
        updated = true

    if not updated and offset_with_player and GameInputs.direction.x != 0 and is_instance_valid(Game.player):
        current_offset.x = view_offset.x if GameInputs.direction.x > 0 else -view_offset.x
        previous_offset = current_offset
        updated = true

    if not updated:
        current_offset.x = previous_offset.x

    if GameInputs.camera_direction.y != 0:
        current_offset.y = -view_offset.y * 2.0 if GameInputs.camera_direction.y > 0 else view_offset.y * 2.0
    else:
        current_offset.y = view_offset.y

func _physics_process(_delta):
    if not is_instance_valid(tracked_node) and is_tracking_player and is_instance_valid(Game.player):
        set_target(Game.player)

    if is_instance_valid(tracked_node):
        update()
        global_position = tracked_node.global_position + current_offset