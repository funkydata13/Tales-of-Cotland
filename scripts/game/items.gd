class_name C_Items extends Node

var initialized:bool = false
var scenes:Dictionary
var textures:Dictionary
var empty_potion_texture:Texture2D

func get_scene(type:C_Item.E_Type) -> PackedScene:
    return scenes[type] as PackedScene

func get_item(type:C_Item.E_Type) -> C_Item:
    match type:
        C_Item.E_Type.Key:
            return (scenes[type] as PackedScene).instantiate() as C_ItemKey
        C_Item.E_Type.Coin:
            return (scenes[type] as PackedScene).instantiate() as C_ItemCoin
        _:
            var potion:C_ItemPotion = (scenes[type] as PackedScene).instantiate() as C_ItemPotion
            if type == C_Item.E_Type.Vitality:
                potion.attribute = C_Attribute.E_Type.Vitality
            elif type == C_Item.E_Type.Stamina:
                potion.attribute = C_Attribute.E_Type.Stamina
            elif type == C_Item.E_Type.Magic:
                potion.attribute = C_Attribute.E_Type.Magic
            return potion

func get_texture(type:C_Item.E_Type) -> Texture2D:
    return textures[type]

func _ready():
    textures = {
        C_Item.E_Type.Key: ResourceLoader.load("res://assets/sprites/key.png") as Texture2D,
        C_Item.E_Type.Coin: ResourceLoader.load("res://assets/sprites/coin.png") as Texture2D,
        C_Item.E_Type.Vitality: ResourceLoader.load("res://assets/sprites/potion_vitality_full.png") as Texture2D,
        C_Item.E_Type.Stamina: ResourceLoader.load("res://assets/sprites/potion_stamina_full.png") as Texture2D,
        C_Item.E_Type.Magic: ResourceLoader.load("res://assets/sprites/potion_magic_full.png") as Texture2D
    }

    empty_potion_texture = ResourceLoader.load("res://assets/sprites/potion_empty.png") as Texture2D

    scenes = {
        C_Item.E_Type.Key: ResourceLoader.load("res://scenes/items/key.tscn") as PackedScene,
        C_Item.E_Type.Coin: ResourceLoader.load("res://scenes/items/coin.tscn") as PackedScene,
        C_Item.E_Type.Vitality: ResourceLoader.load("res://scenes/items/potion.tscn") as PackedScene,
        C_Item.E_Type.Stamina: ResourceLoader.load("res://scenes/items/potion.tscn") as PackedScene,
        C_Item.E_Type.Magic: ResourceLoader.load("res://scenes/items/potion.tscn") as PackedScene
    }
