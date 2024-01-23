extends RayCast3D

@onready var text_label = $"../../../TextureRect/Label"
@onready var player = $"../../.."

func _process(delta):
	text_label.text = ""
	
	if is_colliding():
		var collided_with = get_collider().get_parent()
		if collided_with is PhysicalWallPort:
			text_label.text = "press [%s] to connect" % InputMap.action_get_events("interact")[0].as_text()
			if Input.is_action_just_pressed("interact"):
				player.connect_to(collided_with)
		
