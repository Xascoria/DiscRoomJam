extends Node2D

export (int) var chain_speed := 50
var direction := Vector2()
var tip_global := Vector2()
var tip_pos := Vector2()

var flying := false
var hooked := false
var on_cooldown := false
onready var cooldown := $Cooldown

func shoot(dir: Vector2) -> void:
	if not on_cooldown:
		direction = dir.normalized()
		flying = true
		tip_global = self.global_position
		$Timer.start()

func release() -> void:
	flying = false
	hooked = false
	on_cooldown = true
	cooldown.start()

func _ready():
	pass # Replace with function body.

func _process(delta):
	self.visible = (flying or hooked) and not on_cooldown
	if not self.visible:
		return
	self.points[1] = $Tip.position
	var tip_loc = to_local(tip_global)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip_global
	
	if flying:
		var collision_res : KinematicCollision2D = $Tip.move_and_collide(direction * chain_speed)
		if collision_res:
			if collision_res.collider.get_collision_layer_bit(6):
				hooked = true
				flying = false
		tip_global = $Tip.global_position

func _on_Timer_timeout():
	if self.flying:
		self.release()

func _on_Cooldown_timeout():
	on_cooldown = false
