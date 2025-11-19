extends CanvasLayer
class_name PlayerUI

#var upgradeCards : Array[UpgradeCard]

func _ready() -> void:
	Game.playerDead.connect(onPlayerDeath)
	for c : UpgradeCard in %Upgrades.get_children():
		c.playerUI = self
		c.setup()
		#upgradeCards.append(c)

func _process(_delta: float) -> void:
	%FuelLabel.text = "Gather Fuel : " + str(Game.amountOfFuel) + " / " + str(Game.amoundOfFuelNeeded)
	if Game.amountOfFuel > Game.amoundOfFuelNeeded:
		%FuelLabel.visible = false
		#%FuelLabel.text = "Fuel Full"

func cardFocus(texture : Texture2D, text : String):
	%DisplayIcon.texture = texture
	%DisplayLabel.text = text
	$AnimationPlayer.play("Show")

func cardUnFocused():
	$AnimationPlayer.play("Hide")

func onPlayerDeath():
	visible = false
