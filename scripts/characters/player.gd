class_name C_Player extends C_Character

signal defeated()

var loot_area:Area2D
var items:Array
var collectibles:Array
var activables:Array

func _ready():
    super()
    Game.player = self

    items = []
    collectibles = []
    activables = []

    loot_area = get_node("Loot Area") as Area2D
    loot_area.area_entered.connect(on_area_enter)
    loot_area.area_exited.connect(on_area_exit)
    loot_area.body_entered.connect(on_body_enter)
    loot_area.body_exited.connect(on_body_exit)

func on_area_enter(actor):
    if (actor is C_ActivableArea):
        activables.append(actor as C_ActivableArea)

func on_area_exit(actor):
    if (actor is C_ActivableArea):
        activables.erase(actor)

func on_body_enter(actor):
    if (actor is C_Item):
        items.append(actor as C_Item)

func on_body_exit(actor):
    if (actor is C_Item):
        items.erase(actor)
        collectibles.erase(actor)

func process_activables():
    if activables.size() == 0:
        return

    var i:int = 0
    while i < activables.size():
        if not is_instance_valid(activables[i]):
            activables.remove_at(i)
        else:
            i += 1

    i = 0
    while i < activables.size():
        if activables[i].can_activate(self):
            activables[i].activate()
            break
        else:
            i += 1

func process_collectibles() -> bool:
    var i:int

    if items.size() > 0:
        i = 0
        while i < items.size():
            if items[i].state == C_Item.E_State.Pending:
                collectibles.append(items[i])
                items.remove_at(i)
            else:
                i += 1
    
    if collectibles.size() > 0:
        i = 0
        
        while i < collectibles.size():
            if not is_instance_valid(collectibles[i]):
                collectibles.remove_at(i)
            else:
                i += 1

    if collectibles.size() > 0:
        for index in range(collectibles.size()):
            if collectibles[index].state == C_Item.E_State.Pending:
                collectibles[index].pick(global_position, inventory)
                return true

    return false

func _input(_event):
    if GameInputs.can_listen_inputs(C_Inputs.E_InputListener.Player) and GameInputs.is_just_pressed("action"):
        if not process_collectibles():
            process_activables()

func _physics_process(delta):
    if GameInputs.can_listen_inputs(C_Inputs.E_InputListener.Player) and GameInputs.direction.x * forward_direction < 0:
        flip()

    super(delta)

func dispose():
    defeated.emit()