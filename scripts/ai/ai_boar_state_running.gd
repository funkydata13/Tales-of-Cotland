class_name C_AIBoarStateRunning extends C_StateRunning

func _ready():
    super()
    animation_name_override = "Running"

func enter():
    super()

func check_status(_delta:float):
    # Timer pour la fatigue vers AI Resting
    if exit_by_stopwatch():
        return

    if not machine.ai.is_player_visible or machine.ai.is_player_hitted:
        machine.change_state("AI Searching")