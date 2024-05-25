class_name C_Ai extends Node

@export var kinematics:C_KinematicNode
@export var obstacle_detector:RayCast2D
@export var ledge_detector:RayCast2D

var is_facing_obstacle:bool = false
var is_facing_ledge:bool = false

func _ready():
    set_process(false)

func _physics_process(_delta):
    is_facing_obstacle = is_instance_valid(obstacle_detector) and obstacle_detector.is_colliding()
    is_facing_ledge = is_instance_valid(ledge_detector) and not ledge_detector.is_colliding()