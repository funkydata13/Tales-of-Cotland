@tool
class_name C_ItemPotion extends C_Item

var textures:Dictionary = {
    C_Item.E_Type.Vitality: ResourceLoader.load("res://assets/sprites/potion_vitality_full.png") as Texture2D,
    C_Item.E_Type.Stamina: ResourceLoader.load("res://assets/sprites/potion_stamina_full.png") as Texture2D,
    C_Item.E_Type.Magic: ResourceLoader.load("res://assets/sprites/potion_magic_full.png") as Texture2D
}

@export var attribute:C_Attribute.E_Type = C_Attribute.E_Type.Vitality:
    get:
        return attribute
    set (value):
        if attribute != value:
            attribute = value
            update_sprite()

func get_type() -> E_Type:
    match attribute:
        C_Attribute.E_Type.Stamina:
            return E_Type.Stamina
        C_Attribute.E_Type.Magic:
            return E_Type.Magic
        _:
            return E_Type.Vitality

func update_sprite():
    if is_instance_valid(sprite):
        sprite.texture = textures[get_type()] as Texture2D

func _ready():
    super()
    update_sprite()