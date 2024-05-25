class_name C_Attribute extends Node

signal changed(changed_amout:float, changed_value:float, changed_by:Node2D, force_applied:float)
signal depleted(depleted_by:Node2D)

enum E_Condition { Lost, Receive }
enum E_Type { Vitality, Stamina, Magic }
@export var type:E_Type

@export var maximum_value:float = 10
@export var value:float = 10
var last_value:float = 10
@export var regen_rate:float = 0
@export var regen_when_depleted:bool = true
@export var regen_signal_intervals:float = 0.25
var regen_time_left:float = 0.25

var effects:Dictionary

var is_value_changed:bool:
    set (value):
        pass
    get:
        return last_value != value

var is_depleted:bool:
    set (value):
        pass
    get:
        return value <= 0

func set_maximum_value(new_value:float):
    if maximum_value != new_value:
        maximum_value = new_value
        if value > maximum_value:
            value = maximum_value

func set_value(new_value:float):
    if value != new_value:
        value = clampf(new_value, 0, maximum_value)

func _ready():
    effects[E_Condition.Lost] = []
    effects[E_Condition.Receive] = []

    for node in get_children():
        if node is C_AnimationNode and "condition" in node:
            effects[node.condition].append(node as C_AnimationNode)

func modify(amount:float, by:Node2D, force:float):
    if amount == 0:
        return

    value += amount

    if is_value_changed:
        changed.emit(amount, value, by, force)
        if is_depleted:
            depleted.emit(by)

    var condition:E_Condition = E_Condition.Receive if amount > 0 else E_Condition.Lost
    if effects[condition].size() > 0:
        for i in range(effects[condition].size()):
            (effects[condition][i] as C_AnimationNode).play(true)

func regenerate(delta:float):
    if regen_rate == 0 or (value == 0 and not regen_when_depleted):
        return

    value += regen_rate * delta

    if is_value_changed:
        if regen_time_left <= 0:
            regen_time_left = regen_signal_intervals
            changed.emit(0, value, owner as Node2D, 0)
        else:
            regen_time_left -= delta
    else:
        if regen_time_left != regen_signal_intervals:
            regen_time_left = regen_signal_intervals
            changed.emit(0, value, owner as Node2D, 0)

func _process(delta):
    regenerate(delta)