extends VBoxContainer

var selected_nodes = {}
var gates : Array = []

@onready
var Parts = preload("res://base_gate.tscn").instantiate()

func _ready():
	Parts.hide()
	pass

func compile(graph_name):
	var list = get_node(graph_name).get_children()
	for item in list:

		var gate = BufferGate.new()
		if item is NOT_Node:
			gate = NOT_Gate.new()
		
		item.gate = gate
		if item is Input_Node:
			gate.next_output = item.get_node("CheckButton").button_pressed
			gate.current_output = gate.next_output
			gate.active = false
			
		gates.append(gate)
	

	for con in get_node(graph_name).get_connection_list():
		var node_to = get_node(graph_name).get_node(str(con.to_node))
		var node_from = get_node(graph_name).get_node(str(con.from_node))
		if node_to is NOT_Node or node_to is IDENTITY_Node:
			print(node_to.gate)
			node_to.gate.inputs.append(node_from.gate)
	pass

func add_part(node_name: String):
	var part: GraphNode = Parts.get_node(node_name).duplicate()
	get_node("Graph").add_child(part, true) # Use a friendly node name to help with save/load later
	part.position_offset.x = get_viewport().get_mouse_position().x
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for gate in gates:
		if gate.active:
			gate.process()
	for gate in gates:
		gate.update()
	pass


func _on_graph_connection_request(from_node, from_port, to_node, to_port):
	get_node("Graph").connect_node(from_node, from_port, to_node, to_port)
	compile("Graph")
	pass # Replace with function body.


func _on_graph_disconnection_request(from_node, from_port, to_node, to_port):
	get_node("Graph").disconnect_node(from_node, from_port, to_node, to_port)
	compile("Graph")
	pass # Replace with function body.


func _on_graph_node_deselected(node):
	selected_nodes[node] = false
	pass # Replace with function body.


func _on_graph_node_selected(node):
	selected_nodes[node] = true
	pass # Replace with function body.


func remove_connections_to_node(node):
	for con in get_node("Graph").get_connection_list():
		print(con)
		if con.to_node == node.name or con.from_node == node.name:
			get_node("Graph").disconnect_node(con.from_node, con.from_port, con.to_node, con.to_port)
			compile("Graph")
	pass

func _on_graph_delete_nodes_request(nodes):
	for node in selected_nodes.keys():
		if selected_nodes[node]:
			remove_connections_to_node(node)
			node.queue_free()
	selected_nodes = {}
	pass # Replace with function body.

func _on_line_edit_text_submitted(file_name):
	var graph_data = GraphData.new()
	graph_data.connections = $Graph.get_connection_list()
	for node in $Graph.get_children():
		if node is GraphNode:
			var node_data = NodeData.new()
			node_data.name = node.name
			node_data.type = node.type
			node_data.offset = node.position_offset
			#node_data.data = node.data
			graph_data.nodes.append(node_data)
	
	print("res://Nodes/"+file_name)
	print(ResourceSaver.save(graph_data, "res://Nodes/" + file_name + ".tres"))

	pass # Replace with function body.

func init_graph(graph_data: GraphData):
	clear_graph()
	for node in graph_data.nodes:
		# Get new node from factory autoload (singleton)
		var gnode = Parts.get_node(node.type).duplicate()
		gnode.position_offset = node.offset
		gnode.name = node.name
		get_node("Graph").add_child(gnode, true)
	
	for con in graph_data.connections:
		var _e = get_node("Graph").connect_node(con.from_node, con.from_port, con.to_node, con.to_port)
	compile("Graph")

func clear_graph():
	get_node("Graph").clear_connections()
	var nodes = get_node("Graph").get_children()
	for node in nodes:
		if node is GraphNode:
			node.queue_free()

func _on_popup_menu_index_pressed(index):
	var menu = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/MenuButton/PopupMenu")
	var file_name = menu.get_item_text(index)
	if ResourceLoader.exists("res://Nodes/"+file_name):
		var graph_data = ResourceLoader.load("res://Nodes/" + file_name)
		if graph_data is GraphData:
			init_graph(graph_data)
		else:
			# Error loading data
			pass
	else:
		# File not found
		pass


