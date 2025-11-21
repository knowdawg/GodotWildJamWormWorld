extends RigidBody2D
class_name Lantern

var initPos : Vector2


func setup(origin : Vector2):
	$AnimationPlayer.speed_scale = 1.0 / PlayerStats.flareTime
	$AnimationPlayer.play("Glow")
	initPos = origin
	
	apply_impulse(Vector2(0.0, -50.0))
	#linear_damp = 5.0
	
	var cs : CircleShape2D = $Hazard/CollisionShape2D.shape
	cs.radius = PlayerStats.flareExplosionRadius
	
	contact_monitor = true
	max_contacts_reported = 1
	
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Glow":
		queue_free()

#func _physics_process(delta: float) -> void:
	#pass

func _process(_delta: float) -> void:
	$GlowLight.texture_scale = PlayerStats.flareTextureScale
	$GlowLight.energy = PlayerStats.flareLightEnergy
	queue_redraw()


func _draw() -> void:
	if $Hazard/CollisionShape2D.disabled == false:
		draw_circle(Vector2.ZERO, PlayerStats.flareExplosionRadius, Color(1.0, 0.0, 0.0, 1.0), true)

func _on_body_entered(_body: Node) -> void:
	if PlayerStats.flareExplosionRadius > 0:
		explode()
		
		await  get_tree().physics_frame
		await  get_tree().physics_frame
		$Hazard/CollisionShape2D.set_deferred("disabled", true)


func explode():
	$BoomSound.play()
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(global_position, -1, PlayerStats.flareExplosionRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += detroyedTiles[2]
	
	$Hazard/CollisionShape2D.set_deferred("disabled", false)
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(10.0)
