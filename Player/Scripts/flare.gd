extends Node2D
class_name Flare

var moveVec : Vector2
var initPos : Vector2

var t : float = 0.5

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.0 / PlayerStats.flareTime
	$AnimationPlayer.play("Travel")
	
	var cs : CircleShape2D = $Hazard/CollisionShape2D.shape
	cs.radius = PlayerStats.flareExplosionRadius

func setup(direciton : Vector2, force : float, origin : Vector2):
	moveVec = direciton * force
	$Sprite2D.rotation = moveVec.normalized().angle()
	initPos = origin

func _physics_process(delta: float) -> void:
	t -= delta
	
	if $Sprite2D/RayCast2D.is_colliding():
		#global_position = $Sprite2D/RayCast2D.get_collision_point() - (moveVec.normalized() * 3.0)
		position += $Sprite2D/RayCast2D.get_closest_collision_safe_fraction() * $Sprite2D/RayCast2D.target_position.length() * moveVec.normalized()
		$AnimationPlayer.play("Glow")
		
		if PlayerStats.flareExplosionRadius > 0:
			await get_tree().physics_frame
			explode()
			await get_tree().physics_frame
			position += $Sprite2D/RayCast2D.get_closest_collision_safe_fraction() * $Sprite2D/RayCast2D.target_position.length() * moveVec.normalized()
		
		moveVec = Vector2.ZERO
		$Sprite2D/RayCast2D.set_deferred("enabled", false)
		$Hazard/CollisionShape2D.set_deferred("disabled", true)



func explode():
	$BoomSound.play()
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(global_position, -1, PlayerStats.flareExplosionRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
	Game.amountOfFuel += detroyedTiles[2]
	
	$Hazard/CollisionShape2D.set_deferred("disabled", false)
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(10.0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Glow":
		queue_free()

func _process(_delta: float) -> void:
	$GlowLight.texture_scale = PlayerStats.flareTextureScale
	$GlowLight.energy = PlayerStats.flareLightEnergy
	queue_redraw()

func _draw() -> void:
	draw_line(initPos - position, Vector2.ZERO, Color(1.0, 0.0, 0.0, t * 2.0), t * 5.0)
	
	if $Hazard/CollisionShape2D.disabled == false:
		draw_circle(Vector2.ZERO, PlayerStats.flareExplosionRadius, Color(1.0, 0.0, 0.0, 1.0), true)
