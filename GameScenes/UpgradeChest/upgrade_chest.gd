extends RigidBody2D
class_name UpgradeChest

var destoryed : bool = false

func _ready() -> void:
	$AnimationPlayer.play("Idle")
	Game.chest.append(self)

func _process(_delta: float) -> void:
	if is_instance_valid(PlayerStats.player):
		var dis : float = global_position.distance_to(PlayerStats.player.global_position)
		dis = 50.0 - clamp(dis, 0.0, 50.0)
		dis *= 0.01
		
		$PointLight2D.energy = clamp(dis * 5.0, 0.0, 2.0)


func _physics_process(_delta: float) -> void:
	if TerrainRendering.isPositionLoaded(global_position):
		freeze = false
	else:
		freeze = true

func _on_area_2d_area_entered(_area: Area2D) -> void:
	destroy()

func destroy():
	if !destoryed:
		destoryed = true
		Game.chest.erase(self)
		Game.createCardUpgrade.emit()
		$IdleParticles.emitting = false
		$DeathParticles.emitting = true
		$PointLight2D.visible = false
		$Sprite2D.visible = false
		$ChestBreak.play()
