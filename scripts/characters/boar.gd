class_name C_Boar extends C_Character

func _ready():
    super()

    inventory.generate("1|0-1-2|30-60-10")
    inventory.generate("100|0-1|30-70|70-30-0")

func dispose():
    inventory.drop()
    super()
