class_name C_AnimationNode extends Node

@export var player:AnimationPlayer
@export var play_count:int = 1
@export var play_speed:int = 1
@export var ping_pong:bool = false

var animation_name:String = ""
var doing_pong:bool = false
var count:int = 0

func _ready():
    reset()
    if player == null:
        push_error("Pas d'AnimationPlayer attaché au C_AnimationNode !")

    set_process(false)
    set_physics_process(false)

func reset():
    if player.is_playing():
        player.stop(false)

    count = play_count
    doing_pong = false

func play(reset_animation:bool) -> bool:
    if reset_animation:
        reset()

    if count <= 0:
        return false

    if ping_pong:
        if not doing_pong:
            count -= 1
            doing_pong = true
            player.play(animation_name, -1, -play_speed, true)
            return true
        else:
            player.play(animation_name, -1, play_speed)
            return true
    else:
        count -= 1
        player.play(animation_name, -1, play_speed)
        return true