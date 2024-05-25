class_name C_Door extends C_ActivableBody

@export var activated_position_offset:Vector2
@export var transition_duration:float = 3

var time_left:float
var position_backup:Vector2
var target_position:Vector2

func _ready():
    super()
    target_position = global_position + activated_position_offset

func activate():
    if state == E_State.Pending:
        time_left = transition_duration
        position_backup = global_position
        state = E_State.Activating
        set_physics_process(true)
    elif state == E_State.Activated:
        time_left = transition_duration
        state = E_State.Desactivating
        set_physics_process(true)

func _physics_process(delta):
    if state == E_State.Activating:
        if time_left > 0:
            time_left -= delta
            global_position = lerp(position_backup, target_position, 1.0 - (time_left / transition_duration))
        else:
            time_left = 0
            state = E_State.Activated
            global_position = target_position
            set_physics_process(false)
    elif state == E_State.Desactivating:
        if time_left > 0:
            time_left -= delta
            global_position = lerp(target_position, position_backup, 1.0 - (time_left / transition_duration))
        else:
            time_left = 0
            state = E_State.Pending
            global_position = position_backup
            set_physics_process(false)