extends Node
class_name NetworkDevice

@export var address: String
@export var type: String

func ping() -> String:
	return address
