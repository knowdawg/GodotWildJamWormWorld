extends RichTextLabel
class_name DialogBox

@export var proceedLabel : Label

var done : bool = false
func setTest(newText : String, speedPerCharectar : float = 0.015):
	done = false
	visible_characters = 0
	proceedLabel.visible = false
	text = newText
	
	var totalTime = get_total_character_count() * speedPerCharectar
	var t = create_tween()
	t.tween_property(self, "visible_characters", get_total_character_count(), totalTime)
	
	await t.finished
	
	proceedLabel.visible = true
	done = true

func readyToProceed() -> bool:
	return done

func clearText():
	done = false
	text = ""
