extends CanvasLayer
class_name PlayerUI

func _ready() -> void:
	Game.cardPicked.connect(addUpgradeCard)
	Game.playerDead.connect(onPlayerDeath)
	Game.wormsSpeedingUp.connect(onWormsSpeedingUp)
	Game.wormsStartingToMove.connect(onWormStartMoving)
	for c : UpgradeCard in %Upgrades.get_children():
		c.playerUI = self
		await get_tree().create_timer(0.1).timeout
		c.setup()

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
