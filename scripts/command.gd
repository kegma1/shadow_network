@icon("res://icons/command.png")
extends Node
class_name Command

enum ArgumentType {
	FLOAT,
	INT,
	STRING
}

@export var argument_names: Array[String] = []
@export var argument_types: Array[ArgumentType] = []

@export var help: String

var callback: String: set = _callback_set, get = _callback_get
func _callback_set(string):
	callback = "on_command_" + string
func _callback_get():
	return callback
	
func _ready():
	assert(argument_types.size() == argument_names.size())
	assert(name.find(" ") == -1)
	name = name.to_lower()
	
func parse_arguments(args: String):
	var arg_array = []
	var segmented = args.split(" ", false)
	var grouped = []
	
	var quoted = false
	for segment in segmented:
		if segment.begins_with("\""):
			quoted = true
			segment.erase(0,1)
		if segment.ends_with("\""):
			quoted = false
			segment.erase(segment.length() - 1, 1)
			grouped.push_back(segment)
			segment = " ".join(grouped)
			grouped = [] 
			
		if quoted:
			grouped.push_back(segment)
		else:
			arg_array.push_back(segment)
		
	if grouped.size() != 0:
		return "Invalid argument format (Incomplete quote): " + " ".join(grouped)
		
	if  arg_array.size() != argument_types.size():
		return "Invalid number of arguments (Expected: %s, Recived: %s)." % [
			str(argument_types.size()),
			str(arg_array.size())
		]
	
	for i in range(argument_types.size()):
		match (argument_types[i]):
			ArgumentType.FLOAT:
				arg_array[i] = float(arg_array[i])
			ArgumentType.INT:
				arg_array[i] = int(arg_array[i])
	
	return arg_array
		

func get_usage():
	var usage = "Usage: %s " % name
	for i in range(argument_types.size()):
		var arg_type = ArgumentType.keys()[argument_types[i]]
		var arg_name = argument_names[i]
		arg_type = arg_type.to_lower()
		arg_name = arg_name.to_lower()
		
		usage += "<%s: %s> " % [arg_name, arg_type]
		
	return usage
		
func get_namespace_to(target: Node):
	var ns: Array[String] = []
	var node = self
	while node != target:
		ns.insert(0, node.name)
		node = node.get_parent()
	
	return ns
