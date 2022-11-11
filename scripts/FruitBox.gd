extends StaticBody2D
export(Array, PackedScene)var fruits
export(int, 1, 3)var type = 1

func _ready():
	var box_path = str("res://Pixel Adventure 1/Free/Items/Boxes/Box",type,"/")
	$Sprite.texture = load(str(box_path,"Idle"))
	pass
