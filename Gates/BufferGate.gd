extends Gate
class_name BufferGate


var current_output: bool = false
var next_output : bool = false
var active : bool = true

func process():
	next_output = inputs.map(func(item): return item.current_output).has(true)
	input = next_output
	pass
	
func update():
	
	current_output = next_output
	pass
