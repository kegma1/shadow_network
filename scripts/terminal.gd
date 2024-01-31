extends PanelContainer
class_name Terminal

@onready var console_prompt = $VBoxContainer/ConsolePrompt
@onready var console_display = $VBoxContainer/ConsoleContainer/ConsoleText


@export var message_buffer_limit = 100

@export var application_screen_target: NodePath

var message_buffer = []
var command_modules: Array = []
var _application_screen

var current_port: NetworkDevice = null
var cyberdeck

func _ready():
	assert(application_screen_target)
	var _application_screen = get_node(application_screen_target)
	
	cyberdeck = find_parent("Cyberdeck")

	
	cyberdeck.connect_to_port.connect(_on_connect_to_port)
	cyberdeck.disconnect_from_port.connect(_on_disconnect_from_port)
	cyberdeck.take_focus.connect(func(): console_prompt.grab_focus())
	
	RefStore.current_terminal = self
	
func _on_connect_to_port(port):
	# may change this later if vpns or simiular gets added 🤷‍♂️
	if current_port:
		return
	
	current_port = port
	
	
	push_message("Succsessfully connected with address <%s>" % port.address)
	
	
func _on_disconnect_from_port():
	if current_port:
		push_message("Disconnecting from address<%s>" % current_port.address)
	current_port = null
	

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

