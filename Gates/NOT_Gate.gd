extends BufferGate
class_name NOT_Gate

func process():
	next_output = !inputs.map(func(item): return item.current_output).has(true)
	input = !next_output
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
