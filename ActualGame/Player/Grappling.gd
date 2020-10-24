extends Node2D

export (int) var chain_speed := 50
var direction := Vector2()
var tip_global := Vector2()
var tip_pos := Vector2()

var flying := false
var hooked := false

func shoot(dir: Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip_global = self.global_position

func release() -> void:
	flying = false
	hooked = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	self.visible = flying or hooked
	if not self.visible:
		return
	self.points[1] = $Tip.position
	var tip_loc = to_local(tip_global)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	
func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		shoot( get_global_mouse_position() - global_position )
	
	
	$Tip.global_position = tip_global
	if flying:
		if $Tip.move_and_collide(direction * chain_speed):
			hooked = true
			flying = false
		tip_global = $Tip.global_position

