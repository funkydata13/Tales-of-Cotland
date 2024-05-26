class_name C_UIMainMenu extends Control

func on_level_test_pressed():
    if is_instance_valid(Game.level):
        Game.level.change_level("level_test")

func on_level_trash_pressed():
    if is_instance_valid(Game.level):
        Game.level.change_level("level_test_trash")