class_name C_Stopwatch extends Node

@export var physics_processing:bool = false
@export var fixed_duration:bool = false
@export var duration:float = 1
@export var duration_range:float = 2

var time_left:float
var is_over:bool:
    set (value):
        pass
    get:
        return time_left <= 0

func _ready():
    set_process(false)
    set_physics_process(false)

func set_process_state(enable:bool):
    if physics_processing:
        set_physics_process(enable)
    else:
        set_process(enable)

func start():
    var time:float = duration

    if not fixed_duration:
        randomize()
        time += randf() * duration_range

    time_left = time
    set_process_state(true)

func stop():
    if is_processing():
        time_left = 0
        set_process_state(false)

func update(delta:float):
    if is_over:
        time_left = 0
        set_process_state(false)
    else:
        time_left -= delta

func _process(delta):
    update(delta)

func _physics_process(delta):
    update(delta)