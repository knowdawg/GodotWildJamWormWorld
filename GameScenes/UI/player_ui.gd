extends CanvasLayer
class_name PlayerUI

func _ready() -> void:
	Game.cardPicked.connect(addUpgradeCard)
	Game.playerDead.connect(onPlayerDeath)
	for c : UpgradeCard in %Upgrades.get_children():
		c.playerUI = self
		await get_tree().create_timer(0.5).timeout
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
