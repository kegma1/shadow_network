extends Node

func _ready():
	get_parent().add_command_module($Console)

func on_command_cls(console, args):
	console.clear_output()

func on_command_echo(console, args):
	console.push_message(args[0])

func on_command_help(console, args):
	var msg = "----HELP------------------------------------\n"
	msg += "Using the console: \n"
	msg += "	Enter a command followed by space-separated arguments.\n"
	
	for module in console.command_modules:
		msg += module.generate_help_string()
	
	console.push_message(msg)
