class_name C_UIPotionsMenu extends Control

const ITEMS_INDEX_OFFSET:int = 2
const POTION_RECOVERY_FACTOR:float = 0.5

var panels:Dictionary
var labels:Dictionary
var textures:Dictionary
var styleboxes:Array[StyleBoxTexture]

var exit_flag:bool
var selected_index:int = 0:
	get:
		return selected_index
	set (value):
		if value >= 0:
			panels[selected_index + ITEMS_INDEX_OFFSET].add_theme_stylebox_override("panel", styleboxes[0])
			selected_index = value
			panels[selected_index + ITEMS_INDEX_OFFSET].add_theme_stylebox_override("panel", styleboxes[1])

func _ready():
	panels = {
		C_Item.E_Type.Vitality: get_node("Grid/Vitality") as PanelContainer,
		C_Item.E_Type.Stamina: get_node("Grid/Stamina") as PanelContainer,
		C_Item.E_Type.Magic: get_node("Grid/Magic") as PanelContainer
	}

	labels = {
		C_Item.E_Type.Vitality: get_node("Grid/Vitality/Container/Label") as Label,
		C_Item.E_Type.Stamina: get_node("Grid/Stamina/Container/Label") as Label,
		C_Item.E_Type.Magic: get_node("Grid/Magic/Container/Label") as Label
	}

	textures = {
		C_Item.E_Type.Vitality: get_node("Grid/Vitality/Container/Texture") as TextureRect,
		C_Item.E_Type.Stamina: get_node("Grid/Stamina/Container/Texture") as TextureRect,
		C_Item.E_Type.Magic: get_node("Grid/Magic/Container/Texture") as TextureRect
	}

	styleboxes = []
	styleboxes.append((panels[C_Item.E_Type.Vitality] as PanelContainer).get_theme_stylebox("panel"))
	styleboxes.append(styleboxes[0].duplicate())
	styleboxes[1].set("modulate_color", Color(0.6, 0.6, 0.6))

	selected_index = 0

	visible = false
	set_physics_process(false)

func bound_index(index:int) -> int:
	if index < 0:
		return ITEMS_INDEX_OFFSET
	elif index > ITEMS_INDEX_OFFSET:
		return 0
	else:
		return index

func is_selection_valid(index:int) -> bool:
	if index < 0:
		return false
	else:
		return int((labels[index + ITEMS_INDEX_OFFSET] as Label).text.replace("x", "")) > 0

func set_next_valid_selection(offset:int):
	var index:int  = bound_index(selected_index + offset)
	var max_tests:int = 2

	while max_tests >= 0 and not is_selection_valid(index):
		index = bound_index(index + offset)
		max_tests -= 1

	if max_tests != -1:
		selected_index = index
	else:
		selected_index = -1

func activate_potion():
	Game.player.attributes[selected_index].modify(Game.player.attributes[selected_index].maximum_value * POTION_RECOVERY_FACTOR, null, 0)
	Game.player.inventory.remove(selected_index + ITEMS_INDEX_OFFSET)

func update():
	if is_instance_valid(Game.player):
		(labels[C_Item.E_Type.Vitality] as Label).text = "x" + str(Game.player.inventory.items[C_Item.E_Type.Vitality]);
		(textures[C_Item.E_Type.Vitality] as TextureRect).texture = GameItems.get_texture(C_Item.E_Type.Vitality) if Game.player.inventory.items[C_Item.E_Type.Vitality] > 0 else GameItems.empty_potion_texture

		(labels[C_Item.E_Type.Stamina] as Label).text = "x" + str(Game.player.inventory.items[C_Item.E_Type.Stamina]);
		(textures[C_Item.E_Type.Stamina] as TextureRect).texture = GameItems.get_texture(C_Item.E_Type.Stamina) if Game.player.inventory.items[C_Item.E_Type.Stamina] > 0 else GameItems.empty_potion_texture

		(labels[C_Item.E_Type.Magic] as Label).text = "x" + str(Game.player.inventory.items[C_Item.E_Type.Magic]);
		(textures[C_Item.E_Type.Magic] as TextureRect).texture = GameItems.get_texture(C_Item.E_Type.Magic) if Game.player.inventory.items[C_Item.E_Type.Magic] > 0 else GameItems.empty_potion_texture

func _input(_event):
	if GameInputs.can_listen_inputs(GameInputs.E_InputListener.UI) and not exit_flag:
		if not visible and GameInputs.is_just_pressed("inventory"):
			update()
			visible = true
			GameInputs.input_listener[GameInputs.E_InputListener.Player] = false
			GameInputs.input_listener[GameInputs.E_InputListener.Camera] = false
			if not is_selection_valid(selected_index):
				set_next_valid_selection(1)
		elif visible:
			if GameInputs.is_just_pressed("left"):
				set_next_valid_selection(-1)
			elif GameInputs.is_just_pressed("right"):
				set_next_valid_selection(1)
			elif selected_index != -1 and (GameInputs.is_just_pressed("jump") or GameInputs.is_just_pressed("attack")):
				activate_potion()
				exit_flag = true
			elif GameInputs.is_just_pressed("inventory") or GameInputs.is_just_pressed("action"):
				exit_flag = true

func _process(_delta):
	if exit_flag:
		visible = false
		GameInputs.input_listener[GameInputs.E_InputListener.Player] = true
		GameInputs.input_listener[GameInputs.E_InputListener.Camera] = true
		exit_flag = false