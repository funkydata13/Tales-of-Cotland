@tool
class_name C_Chest extends C_ActivableArea

@export_range(1,2) var variant:int = 1:
	get:
		return variant
	set (value):
		if variant != value:
			variant = value
			update_sprite()

@export_range(0,3) var keys_needed_to_open:int = 1

var inventory:C_Inventory
var stopwatch:C_Stopwatch
var target_inventory:C_Inventory

func _ready():
	super()

	stopwatch = get_node("Stopwatch") as C_Stopwatch
	inventory = get_node("Inventory") as C_Inventory

	if not Engine.is_editor_hint():
		for s in GameLootTables.chest_loot_table[keys_needed_to_open]:
			inventory.generate(s as String)

func update_sprite():
	if not is_instance_valid(sprite):
		return

	var anim_name:String = str(variant - 1) + "_"

	if state < 3:
		sprite.play(anim_name + str(state))
	else:
		anim_name += "1" if state == E_State.Activated else "0"
		sprite.animation = anim_name
		sprite.frame = sprite.sprite_frames.get_frame_count(anim_name) - 1 if state == E_State.Activated else 0

func can_activate(actor:Node2D) -> bool:
	if not super(actor):
		return false
	
	if keys_needed_to_open == 0:
		target_inventory = null
		return true
	
	if "inventory" in actor and actor.inventory.items[C_Item.E_Type.Key] >= keys_needed_to_open:
		target_inventory = actor.inventory as C_Inventory
		return true
	else:
		target_inventory = null
		return false

func activate():
	super()
	if is_instance_valid(target_inventory):
		target_inventory.remove(C_Item.E_Type.Key, keys_needed_to_open)
	set_physics_process(true)

func reset():
	super()
	monitorable = true
	set_physics_process(true)

func _physics_process(_delta):
	if is_instance_valid(sprite) and not sprite.is_playing():
		if state == E_State.Activating:
			state = E_State.Activated
			inventory.drop()
			stopwatch.start()
		elif state == E_State.Activated:
			if stopwatch.is_over:
				state = E_State.Desactivating
		elif state == E_State.Desactivating:
			state = E_State.Desactivated
			monitorable = false
			set_physics_process(false)
	