class_name C_State extends Node

var machine:C_MachineState
var stopwatch:C_MachineStopwatch

var trigger:bool
var is_animation_looping:bool
var is_animation_playing_backwards:bool
var animation_frames_count:int
var animation_name_override:String = ""

func _ready():
    machine = get_parent() as C_MachineState

    for node in get_children():
        if node is C_MachineStopwatch:
            stopwatch = node as C_MachineStopwatch
            break;

    set_process(false)
    set_physics_process(false)

func set_sprite_animation(play_backwards:bool = false):
    if animation_name_override == "":
        set_sprite_animation_name(name, play_backwards)
    else:
        set_sprite_animation_name(animation_name_override, play_backwards)

func set_sprite_animation_name(animation_name:String, play_backwards:bool = false):
    if machine.sprite.animation != animation_name:
        if play_backwards:
            machine.sprite.play_backwards(animation_name)
        else:
            machine.sprite.play(animation_name)

        is_animation_playing_backwards = play_backwards
        is_animation_looping = machine.sprite.sprite_frames.get_animation_loop(animation_name)
        animation_frames_count = machine.sprite.sprite_frames.get_frame_count(animation_name)

func is_end_frame() -> bool:
    if not machine.sprite.is_playing():
        return true
    else:
        if is_animation_playing_backwards:
            return machine.sprite.frame == 0
        else:
            return machine.sprite.frame == animation_frames_count - 1

func is_over() -> bool:
    if is_instance_valid(stopwatch):
        return stopwatch.is_over and is_end_frame()
    else:
        return is_end_frame()

func can_enter() -> bool:
    return true

func enter():
    trigger = true

    if is_instance_valid(stopwatch):
        stopwatch.start()

    set_physics_process(true)

func exit():
    trigger = false
    
    if is_instance_valid(stopwatch) && not stopwatch.is_over:
        stopwatch.stop()

    set_physics_process(false)

func exit_by_stopwatch() -> bool:
    if is_instance_valid(stopwatch) and stopwatch.is_over and stopwatch.next_state != "":
        return machine.change_state(stopwatch.next_state)
    else:
        return false

func check_status(_delta:float):
    pass

func _physics_process(delta):
    check_status(delta)