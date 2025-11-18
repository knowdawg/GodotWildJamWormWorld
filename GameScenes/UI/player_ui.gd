extends CanvasLayer
class_name PlayerUI

func _process(_delta: float) -> void:
	%FlightProgressBar.value = Game.flightPercentage
	%FuelLabel.text = "Gather Fuel : " + str(Game.amountOfFuel) + " / " + str(Game.amoundOfFuelNeeded)
