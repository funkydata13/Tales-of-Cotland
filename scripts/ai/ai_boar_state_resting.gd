class_name C_AIBoarStateResting extends C_StateIdle

func _ready():
    super()
    animation_name_override = "Idle"

func check_status(_delta:float):
    if is_over():
        if machine.ai.is_player_in_range:
            machine.change_state("AI Running")
        else:
            machine.change_state("AI Searching")