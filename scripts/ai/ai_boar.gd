class_name C_AIBoar extends C_Ai

var character:C_Boar

func _ready():
    super()

    character = owner as C_Boar

    if kinematics.nodes.has(C_KinematicNode.E_Type.Air):
        ledge_detector.target_position.y = (kinematics.nodes[C_KinematicNode.E_Type.Air] as C_KinematicAir).maximum_fall_height - 2

func _physics_process(delta):
    super(delta)
    if is_facing_obstacle or (is_facing_ledge and kinematics.is_grounded):
        character.flip()