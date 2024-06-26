extends Object
class_name Gate


var input : bool
var inputs : Array[Gate]


func process():
	input = inputs.map(func(item): return item.current_output).has(true)
	pass
	
