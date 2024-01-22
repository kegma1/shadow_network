extends PanelContainer

@onready var console_prompt = $VBoxContainer/ConsolePrompt
@onready var console_display = $VBoxContainer/ConsoleContainer/ConsoleText

@export var message_buffer_limit = 100

@export var application_screen_target: NodePath

var message_buffer = []
var command_modules: Array = []
var application_screen

func _ready():
	assert(application_screen_target)
	var application_screen = get_node(application_screen_target)
	print(application_screen)

func add_command_module(module: CommandModule):
	module.console = self
	command_modules.push_back(module)

func push_message(msg):
	message_buffer.push_back(msg)
	if message_buffer.size() > message_buffer_limit:
		message_buffer.remove_at(0)
	
	console_display.text = "\n".join(message_buffer)
	
func clear_output():
	message_buffer = []
	console_display.text = ""

func parse_input(input):
	var tokenized = input.split(" ", false, 1)
	if tokenized.size() == 0:
		return
	
	var command = tokenized[0].to_lower()
	var command_module = null
	for module in command_modules:
		if module.has_command(command):
			command_module = module
			break
	
	if command_module == null:
		push_message("Command not found: " + command)
		return
	
	var args = ""
	if tokenized.size() > 1:
		args = tokenized[1]
	
	command_module.command_entered(command, args)


func _on_console_prompt_text_submitted(input):
	console_prompt.clear()
	if input.length() == 0:
		return
		
	parse_input(input)
	console_display.scroll_to_line(console_display.get_line_count()-1)
