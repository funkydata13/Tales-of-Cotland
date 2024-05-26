class_name C_AIBoarStateIdle extends C_StateIdle

func _ready():
    super()
    animation_name_override = "Idle"

func check_status(delta:float):
    if not machine.ai.is_player_visible:
        super(delta)
    else:
        machine.change_state("AI Searching")

    