class_name C_Inventory extends Node

signal changed(type:C_Item.E_Type, quantity:int)
signal dropped()

@export var max_potions:int = 3
@export var max_coins:int = 9999
@export var max_keys:int = 10

var items:Dictionary
var items_capacity:Dictionary

func _ready():
	items = {
		C_Item.E_Type.Key: 0,
		C_Item.E_Type.Coin: 0,
		C_Item.E_Type.Vitality: 0,
		C_Item.E_Type.Stamina: 0,
		C_Item.E_Type.Magic: 0
	}
	items_capacity = {
		C_Item.E_Type.Key: max_keys,
		C_Item.E_Type.Coin: max_coins,
		C_Item.E_Type.Vitality: max_potions,
		C_Item.E_Type.Stamina: max_potions,
		C_Item.E_Type.Magic: max_potions
	}

func get_capacity(type:C_Item.E_Type) -> int:
	return items_capacity[type]

func get_random_index(proba_data:String) -> int:
	randomize()

	var p:int = 0
	var value:int = -1
	var rnd:int = randi_range(0, 100)
	var p_list:Array = proba_data.split("-")

	for i in range(p_list.size()):
		p += int(p_list[i])
		if rnd <= p:
			value = i
			break

	if value == -1:
		return p_list.size() - 1
	else:
		return value

func generate(generation_data:String):
	var pipes:Array = generation_data.split("|")
	var type:int = int(pipes[0])

	var quantities:Array = pipes[1].split("-")
	var quantity:int = int(quantities[get_random_index(pipes[2])])

	if quantity > 0:
		if type <= 10:
			append(type, quantity)
		else:
			for i in range(quantity):
				var potion_type:int = get_random_index(pipes[3]) + 2
				append(potion_type, quantity)

func append(type:C_Item.E_Type, quantity:int = 1):
	var initial_quantity:int = items[type]
	items[type] += quantity
	items[type] = clampi(items[type], 0, items_capacity[type])

	if items[type] != initial_quantity:
		changed.emit(type, items[type])

func remove(type:C_Item.E_Type, quantity:int = 1):
	append(type, -quantity)

func drop():
	for type in items.keys():
		if items[type] > 0:
			for i in range(items[type]):
				var item:C_Item = GameItems.get_item(type)
				item.visible = false
				item.state = C_Item.E_State.Idle
				owner.get_parent().add_child(item)
				item.drop((owner as Node2D).global_position)

			items[type] = 0

	dropped.emit()