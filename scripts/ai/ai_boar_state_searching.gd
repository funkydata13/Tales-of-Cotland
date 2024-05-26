class_name C_AIBoarStateSearching extends C_StateIdle

@export var transition_duration:float = 1
var time_left:float = 0

func _ready():
    super()
    animation_name_override = "Idle"

func enter():
    super()
    if not machine.previous_state.name == "AI Resting":
        time_left = transition_duration
    else:
        time_left = 0

func check_status(delta:float):
    if not machine.ai.is_player_visible:
        # Le chrono determine le temps avant de lacher l'affaire, le faire pointer vers un walking
        if exit_by_stopwatch():
            return
    else:
        time_left -=  delta
        if time_left <= 0 and (owner as C_Character).state == C_Character.E_State.Free:
            machine.change_state("AI Running")

    