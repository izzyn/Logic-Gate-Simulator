extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_popup().connect("id_pressed", item_pressed)
	pass # Replace with function body.

func item_pressed(id):
	var item_name = get_popup().get_item_text(id)
	match item_name:
		"Load Graph":
			var popup : PopupMenu = get_node("PopupMenu")
			var main = get_tree().get_root().get_node_or_null("Main")
			var dir = DirAccess.open("res://Nodes")

			if len(dir.get_files()) > 0:
				popup.visible = true
				popup.clear()
				popup.position = get_viewport().get_mouse_position()
				for node in range(len(dir.get_files())):
					popup.add_item(str(dir.get_files()[node]), node)
		"Save Graph":

			get_node("LineEdit").visible = true
			get_node("LineEdit").grab_focus()
			#main.get_node("Graphs")
		"Quit":
			get_tree().quit()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


