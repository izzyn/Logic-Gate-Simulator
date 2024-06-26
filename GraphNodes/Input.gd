extends GraphNode
class_name Input_Node

var gate : Gate

@export
var type = "Input"

func update_input():
	var color : Color
	var button : CheckButton = get_node("CheckButton")
	if button.button_pressed:
		color = Globals.enable_color
	else:
		color = Globals.disable_color
	if gate: 
		gate.next_output = button.button_pressed
	set_slot(0,false,0,Color(0,0,0,0),true, 0,color)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	update_input()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
