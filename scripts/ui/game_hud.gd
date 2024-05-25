class_name C_GameHUD extends Control

var player:C_Player
var bars:Dictionary
var labels:Dictionary
var textures:Dictionary

func _ready():
	bars = {
		C_Attribute.E_Type.Vitality: get_node("Margin/Status/Vitality") as TextureProgressBar,
		C_Attribute.E_Type.Stamina: get_node("Margin/Status/Stamina") as TextureProgressBar,
		C_Attribute.E_Type.Magic: get_node("Margin/Status/Magic") as TextureProgressBar
	}

	labels = {
		C_Item.E_Type.Key: get_node("Margin/Items/Key/Label") as Label,
		C_Item.E_Type.Coin: get_node("Margin/Items/Coin/Label") as Label,
		C_Item.E_Type.Vitality: get_node("Margin/Potions/Vitality/Label") as Label,
		C_Item.E_Type.Stamina: get_node("Margin/Potions/Stamina/Label") as Label,
		C_Item.E_Type.Magic: get_node("Margin/Potions/Magic/Label") as Label
	}

	textures = {
		C_Item.E_Type.Vitality: get_node("Margin/Potions/Vitality/Texture") as TextureRect,
		C_Item.E_Type.Stamina: get_node("Margin/Potions/Stamina/Texture") as TextureRect,
		C_Item.E_Type.Magic: get_node("Margin/Potions/Magic/Texture") as TextureRect
	}

	(get_node("Margin/Debug/Respawn") as Button).pressed.connect(on_respawn_pressed)
	(get_node("Margin/Debug/Main Menu") as Button).pressed.connect(on_mainmenu_pressed)

	set_physics_process(false)

func update_attribute_bar(type:C_Attribute.E_Type):
	bars[type].max_value = (player.attributes[type] as C_Attribute).maximum_value
	bars[type].value = (player.attributes[type] as C_Attribute).value

func check_player_instance():
	if is_instance_valid(Game.player):
		player = Game.player
		
		update_attribute_bar(C_Attribute.E_Type.Vitality)
		(player.attributes[C_Attribute.E_Type.Vitality] as C_Attribute).changed.connect(on_vitality_changed)

		update_attribute_bar(C_Attribute.E_Type.Stamina)
		(player.attributes[C_Attribute.E_Type.Stamina] as C_Attribute).changed.connect(on_stamina_changed)

		update_attribute_bar(C_Attribute.E_Type.Magic)
		(player.attributes[C_Attribute.E_Type.Magic] as C_Attribute).changed.connect(on_magic_changed)

		player.inventory.changed.connect(on_inventory_changed)

func on_vitality_changed(_changed_amout:float, _changed_value:float, _changed_by:Node2D, _force_applied:float):
	update_attribute_bar(C_Attribute.E_Type.Vitality)

func on_stamina_changed(_changed_amout:float, _changed_value:float, _changed_by:Node2D, _force_applied:float):
	update_attribute_bar(C_Attribute.E_Type.Stamina)

func on_magic_changed(_changed_amout:float, _changed_value:float, _changed_by:Node2D, _force_applied:float):
	update_attribute_bar(C_Attribute.E_Type.Magic)

func on_inventory_changed(type:C_Item.E_Type, quantity:int):
	(labels[type] as Label).text = "x" + str(quantity);

	if textures.has(type):
		if quantity > 0:
			(textures[type] as TextureRect).texture = GameItems.get_texture(type)
		else:
			(textures[type] as TextureRect).texture = GameItems.empty_potion_texture

func _process(_delta):
	if not is_instance_valid(player):
		check_player_instance()

func on_respawn_pressed():
	if is_instance_valid(player):
		player.take_damage(C_Attribute.E_Type.Vitality, 1000, null, 0)

func on_mainmenu_pressed():
	if is_instance_valid(Game.level):
		Game.level.change_level("level_main_menu")
