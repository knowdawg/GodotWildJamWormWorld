extends RigidBody2D
class_name Dynamite

var explodeRadius : int = 64

var exploded : bool = false
func _ready() -> void:
	$AnimationPlayer.play("Charge")
	$AnimationPlayer.queue("Blow")
	
	var cs : CircleShape2D = $Hazard/CollisionShape2D.shape
	cs.radius = explodeRadius

func explode():
	exploded = true
	gravity_scale = 0.0
	$DynamiteSprite.visible = false
	var detroyedTiles : Dictionary[int, int] = TerrainDestruction.addTileRadius(global_position, -1, explodeRadius, TerrainRendering.LAYER_TYPE.FOREGROUND)
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
		draw_circle(Vector2.ZERO, explodeRadius, Color.RED, false, 1.0)
		draw_circle(Vector2.ZERO, explodeRadius, Color(1.0, 0.0, 0.0, 0.2), true)
