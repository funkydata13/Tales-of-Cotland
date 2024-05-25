class_name C_Inputs extends Node

enum E_InputListener { Player = 0, Camera = 1, UI = 2 }
var input_listener:Array = [true, true, true]
var direction:Vector2
var camera_direction:Vector2
var ui_direction:Vector2

func is_pressed(action:String) -> bool:
    return Input.is_action_pressed(action);

func is_just_pressed(action:String) -> bool:
    return Input.is_action_just_pressed(action);

func can_listen_inputs(listener:E_InputListener) -> bool:
    return input_listener[listener];

func _input(_event):
    var d:Vector2 = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"));

    if input_listener[0] and not Input.is_action_pressed("camera"):
        direction = d;
    else:
        direction = Vector2.ZERO;

    if input_listener[1] and Input.is_action_pressed("camera"):
        camera_direction = d;
    else:
        camera_direction = Vector2.ZERO;

    if input_listener[2]:
        ui_direction = d;
    else:
        ui_direction = Vector2.ZERO;
