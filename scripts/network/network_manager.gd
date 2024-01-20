@tool
extends Node

var queue := []

var test_device = preload("res://sceans/network/abstract/test_device.tscn")

func register_device(dev: PhysicalDevice):
	if dev not in queue:
		queue.append(dev)
	
