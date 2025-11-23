extends Node2D

var manager : WormManager

var head : Sprite2D
var parts : Array[Sprite2D] = []

var partDistance : float = 10.0
var angleOffset = ((11.0 * PI) / 4.0)
var speed : float = 100.0
var numOfSegments : int = 20

var bodyTex = preload("res://Sprites/WormParts.png")

var lightingMaterial : ShaderMaterial = preload("res://Shaders/raycast_lighting.tres")

func _ready() -> void:
	
	for p in $Parts.get_children():
		if p.name == "Head":
			head = p
		parts.append(p)
	
	for i in numOfSegments:
		var s : Sprite2D = Sprite2D.new()
		s.texture = bodyTex
		s.hframes = 2
		s.frame = 1
		s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		#s.material = lightingMaterial
		s.material = $Parts/Head.material
		parts.append(s)
		$Parts.add_child(s)
	
	if Game.inTutorial:
		return
	$AnimationPlayer.speed_scale = randf_range(0.8, 1.2)
	$AnimationPlayer.play("Dig")
	$AnimationPlayer.seek(randf_range(0.0, 2.0))
	
	scale.x = -1.0 if randi_range(0, 1) == 0 else 1.0

func _process(delta: float) -> void:
	updateParts(delta)
	
	if Game.inTutorial:
		TerrainDestruction.addTileRadius(head.global_position, -1, 10, TerrainRendering.LAYER_TYPE.FOREGROUND, true)

var prevHeadPos : Vector2 = Vector2.ZERO
func updateParts(_delta):
	#var dirVec := -(head.global_position - get_global_mouse_position()).normalized()
	head.rotation = (head.position - prevHeadPos).angle() + angleOffset
	prevHeadPos = head.position
	#head.position += dirVec * speed * delta
	
	for i in parts.size():
		var part : Sprite2D = parts[i]
		if part.name == "Head":
			continue
		var nextPart : Sprite2D = parts[i - 1]
		
		var distanceToNextPart : float = part.position.distance_to(nextPart.position)
		var dirToNextPart : Vector2 = part.position.direction_to(nextPart.position)
		
		var vecToTravel : Vector2 = dirToNextPart * (distanceToNextPart - partDistance)
		
		#print(vecToTravel)
		
		part.position += vecToTravel
		part.rotation = vecToTravel.angle() + angleOffset
		

func resetWormPosition():
	if manager:
		position = manager.getNewPosition()


func _on_terrain_destroy_timer_timeout() -> void:
	if Game.inTutorial:
		return
	var curTime = $AnimationPlayer.current_animation_position
	if curTime > 0.7 and curTime < 1.3:
		TerrainDestruction.addTileRadius(head.global_position, -1, 10, TerrainRendering.LAYER_TYPE.FOREGROUND, true)
