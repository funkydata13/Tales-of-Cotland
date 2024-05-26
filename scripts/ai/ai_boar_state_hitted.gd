class_name C_AIBoarStateHitted extends C_StateHitted

func _ready():
	super()
	animation_name_override = "Hitted"

func check_status(_delta:float):
	if is_instance_valid(stopwatch):
		if stopwatch.is_over:
			machine.change_state("AI Running" if machine.ai.is_player_visible else "AI Searching")
	else:
		machine.change_state("AI Searching")
	