extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const SNEAK_SPEED = 2.5
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004
const CROUCH_SPEED = 20

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

const STANDING_HEIGHT := 2
const SNEAKINT_HEIGHT := 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Rig
@onready var camera = $Rig/Camera3D
@onready var gun_camera = $Rig/Camera3D/SubViewportContainer/SubViewport/GunCam
@onready var stairs_below = $StairsBelow

@onready var collision_shape = $Shape

@onready var animation_player = $AnimationPlayer
@onready var cyberdeck = $Rig/Camera3D/Cyberdeck

@onready var light_detection = $LightViewPort/LightDetection

@onready var light_view_port = $LightViewPort
@onready var debug_color_rect = $test_ui/ColorRect
@onready var light_level = $ui/TextureProgressBar
@onready var debug_texture_rect = $test_ui/TextureRect


var cyberdeck_focus = false : 
	set(new_value):
		if cyberdeck_focus == new_value:
			return
		
		if not new_value:
			animation_player.play("switch_from_cyberdeck")
			cyberdeck_focus = false
			cyberdeck.emit_signal("disconnect_from_port")
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			$Rig/Camera3D/lookray.enabled = true
			$ui/TextureRect.show()
			
		else:
			animation_player.play("switch_to_cyberdeck")
			cyberdeck_focus = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			$Rig/Camera3D/lookray.enabled = false
			$ui/TextureRect.hide()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion and !cyberdeck_focus:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_frame = false

func _snap_down_to_stairs_check():
	var did_snap = false
	if not is_on_floor() and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_frame) and stairs_below.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0, max_step_down, 0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
			
	
	_was_on_floor_last_frame = is_on_floor()
	_snapped_to_stairs_last_frame = did_snap


func _physics_process(delta):
	if Input.is_action_just_pressed("exit") :
		get_tree().quit()
	
	if Input.is_action_just_pressed("switch_cyberdeck") :
		cyberdeck_focus = not cyberdeck_focus
		#if cyberdeck_focus:
			#animation_player.play("switch_from_cyberdeck")
			#cyberdeck_focus = false
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#else:
			#animation_player.play("switch_to_cyberdeck")
			#cyberdeck_focus = true
			#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	speed = WALK_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !cyberdeck_focus:
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint") and !cyberdeck_focus:
		speed = SPRINT_SPEED
		
	if Input.is_action_pressed("sneak") and !cyberdeck_focus:
		speed = SNEAK_SPEED
		collision_shape.shape.height = SNEAKINT_HEIGHT
	else:
		collision_shape.shape.height = STANDING_HEIGHT

	#collision_shape.shape.height = clamp(collision_shape.shape.height, SNEAKINT_HEIGHT, STANDING_HEIGHT)

	# Get the input direction and handle the movement/deceleration.
	var direction = Vector3.ZERO
	if !cyberdeck_focus:
		var input_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
		direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	_snap_down_to_stairs_check()


func _process(delta):
	gun_camera.global_transform = camera.global_transform
	
	light_detection.global_position = global_position
	var texture = light_view_port.get_texture()
	debug_texture_rect.texture = texture
	var color = get_average_color(texture)
	debug_color_rect.color = color
	light_level.value = color.get_luminance()
	light_level.tint_progress.a = color.get_luminance()

func get_average_color(texture:ViewportTexture) -> Color:
	var image = texture.get_image()
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	return image.get_pixel(0, 0)
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func connect_to(device: PhysicalDevice):
	# this should not be possible in normal gameplay
	if cyberdeck_focus:
		return
	
	var abstract_device = device.abstract_device
	cyberdeck.emit_signal("connect_to_port", abstract_device)
	cyberdeck_focus = true
	
	

