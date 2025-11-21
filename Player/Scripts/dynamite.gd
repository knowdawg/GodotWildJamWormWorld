extends RigidBody2D
class_name Dynamite

var exploded : bool = false
func _ready() -> void:
	$AnimationPlayer.speed_scale = PlayerStats.dynamiteExplosionSpeedScale
	$AnimationPlayer.play("Charge")
	$AnimationPlayer.queue("Blow")
	
	var cs : CircleShape2D = $Hazard/CollisionShape2D.shape
	cs.radius = PlayerStats.dynamiteExplosionRadius
	
	if PlayerStats.balloon:
		gravity_scale = -0.1
		$Balloon.visible = true
	
	if PlayerStats.stickyDynamite:
		contact_monitor = true
		max_contacts_reported = 1
		
		modulate = Color(0.3, 0.3, 10.0, 1.0)

func explode():
	exploded = true
	gravity_scale = 0.0
	$DynamiteSprite.visible = false
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(global_position, -1, PlayerStats.dynamiteExplosionRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += detroyedTiles[2]
	print(Game.amountOfFuel)
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(30.0)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Blow":
		queue_free()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if !exploded:
		draw_circle(Vector2.ZERO, PlayerStats.dynamiteExplosionRadius, Color.RED, false, 1.0)
		draw_circle(Vector2.ZERO, PlayerStats.dynamiteExplosionRadius, Color(1.0, 0.0, 0.0, 0.2), true)


func _on_body_entered(_body: Node) -> void:
	if PlayerStats.stickyDynamite:
		sleeping = true
