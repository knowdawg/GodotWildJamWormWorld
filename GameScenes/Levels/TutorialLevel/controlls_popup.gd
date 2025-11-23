extends CanvasLayer
class_name ControllsPopup

enum TEXT{
	CONTROLS,
	FLARE,
	MINE
}

@export_multiline var controls : String
@export_multiline var flare : String
@export_multiline var mine : String

func showControlls(text : TEXT):
	match text:
		TEXT.CONTROLS:
			$MarginContainer/ControllsLabel.text = controls
		TEXT.FLARE:
			$MarginContainer/ControllsLabel.text = flare
		TEXT.MINE:
			$MarginContainer/ControllsLabel.text = mine
	
	$ShowAnimator.play("ShowText")
	visible = true
	


func hideControlls():
	visible = false
	$MarginContainer/ControllsLabel.text = ""
