class_name C_PlayerSpawner extends Area2D

func _ready():
    body_entered.connect(on_body_enter)

func on_body_enter(body):
    if body is C_Player and is_instance_valid(Game.level):
        Game.level.player_spawner = self as C_PlayerSpawner

func create_instance() -> C_Player:
    var new_player:C_Player = Game.player_scene.instantiate() as C_Player
    new_player.global_position = global_position
    get_parent().add_child(new_player)
    return new_player