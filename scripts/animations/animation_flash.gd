class_name C_AnimationFlash extends C_AnimationNode

@export var canvas:CanvasItem
@export var color:Color = Color.WHITE

func _ready():
    if not is_instance_valid(canvas):
        push_error("CanvasItem non renseigné dans un C_AnimationFlash")

    animation_name = "sprite_animation/flash"

func play(reset_animation:bool) -> bool:
    canvas.material.set("shader_parameter/flash_color", color)
    return super(reset_animation)