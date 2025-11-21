extends CanvasLayer
class_name PlayerUI

var minimapStartPos : float
var minimapFinishPos : float

func _ready() -> void:
	Game.cardPicked.connect(addUpgradeCard)
	Game.playerDead.connect(onPlayerDeath)
	Game.wormsSpeedingUp.connect(onWormsSpeedingUp)
	Game.wormsStartingToMove.connect(onWormStartMoving)
	
	minimapFinishPos = 104.0#$MarginContainer/MarginContainer3/Minimap.global_position.y
	#print(minimapFinishPos)
	minimapStartPos = 316.0#minimapFinishPos + $MarginContainer/MarginContainer3/Minimap.size.y
	#print(minimapStartPos)
	
	for c : UpgradeCard in %Upgrades.get_children():
		c.playerUI = self
		await get_tree().create_timer(0.1).timeout
		c.setup()
		
	if Game.inTutorial:
		$MarginContainer/MarginContainer2/ObjectivesContainer.hide()
		$MarginContainer/MarginContainer3/Minimap.hide()
		$EscapePodIcon.hide()
		$PlayerIcon.hide()
		$WormIcon.hide()

var upgradeCard : PackedScene = preload("uid://dbdv0k3gt74dl")
func addUpgradeCard(upgrade : UpgradeResource):
	var c : UpgradeCard = upgradeCard.instantiate()
	c.upgrade = upgrade
	c.playerUI = self
	%Upgrades.add_child(c)
	c.setup()


func _process(_delta: float) -> void:
	%FuelLabel.text = "Gather Fuel : " + str(Game.amountOfFuel) + " / " + str(Game.amoundOfFuelNeeded)
	if Game.amountOfFuel > Game.amoundOfFuelNeeded:
		%FuelLabel.visible = false
		#%FuelLabel.text = "Fuel Full"
	
	if is_instance_valid(Game.escapePod):
		updateIconPos($EscapePodIcon, Game.escapePod.global_position)
	
	if is_instance_valid(PlayerStats.player):
		updateIconPos($PlayerIcon, PlayerStats.player.global_position)
	
	updateIconPos($WormIcon, Vector2(0.0, Game.wormHight))
	
	$MarginContainer/MarginContainer3/Minimap.material.set_shader_parameter("progress", Game.wormHight / float(TerrainRendering.mapSize.y))

func updateIconPos(s : Sprite2D, worldPos : Vector2):
	var perc = worldPos.y / float(TerrainRendering.mapSize.y)
	var pos = lerp(minimapFinishPos, minimapStartPos, perc)
	s.position.y = pos

func cardFocus(texture : Texture2D, text : String):
	%DisplayIcon.texture = texture
	%DisplayLabel.text = text
	$AnimationPlayer.play("Show")
	$CardFlick.play()

func cardUnFocused():
	$AnimationPlayer.play("Hide")

func onPlayerDeath():
	visible = false

func onWormsSpeedingUp(_newSpeed : float):
	$MarginContainer/MarginContainer/WormsPSA.text = "[center][shake rate=30.0 level=10 connected=1]The Worms Are speeding up"
	$WormPSAAnimator.play("Show")

func onWormStartMoving():
	$MarginContainer/MarginContainer/WormsPSA.text = "[center][shake rate=30.0 level=10 connected=1]The Worms Are Comming"
	$WormPSAAnimator.play("Show")
