extends CanvasLayer
class_name PlayerUI

func _process(_delta: float) -> void:
	%FlightProgressBar.value = Game.flightPercentage
	%FuelLabel.text = "Fuel : " + str(Game.amountOfFuel) + " / 500"
