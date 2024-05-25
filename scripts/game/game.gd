class_name C_Game extends Node

var level:C_Level
var player:C_Player
var player_scene:PackedScene

func _ready():
    if player_scene == null:
        player_scene = ResourceLoader.load("res://scenes/characters/player.tscn") as PackedScene