@tool
class_name PhysicalDevice
extends Node3D

@export var properties: Dictionary = {} : 
	set(value):
		properties = value

@export var abstract_device: NetworkDevice


var ip_address: String: 
	get:
		return abstract_device.address
