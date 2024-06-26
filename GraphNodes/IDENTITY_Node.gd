extends GraphNode
class_name IDENTITY_Node

var gate : BufferGate

@export
var type = "ID"

func update_node():
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gate:
		set_slot(0,true,0,Globals.enable_color if gate.input else Globals.disable_color,is_slot_enabled_right(0),0, Globals.enable_color if gate.current_output else Globals.disable_color)
	pass


func _on_slot_updated(slot_index):
	pass # Replace with function body.

