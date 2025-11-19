extends Panel
class_name CardOption

@export var UI : CardUpgradeUI

var upgrade : UpgradeResource

var initPos : Vector2
func _ready() -> void:
	mouse_entered.connect(hover)
	mouse_exited.connect(unHover)
	gui_input.connect(onInput)
	
	initPos = position
	modulate = Color(0.8, 0.8, 0.8, 1.0)

var t = 0.0
func _process(delta: float) -> void:
	if Rect2(Vector2(0.0, 0.0), Vector2(160.0, 240.0)).has_point(get_local_mouse_position()):
		t -= delta
	else:
		t = 0.0
	
	position.y = initPos.y + (sin(t * 2.0) * 5.0)

func hover():
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func unHover():
	modulate = Color(0.8, 0.8, 0.8, 1.0)

func onInput(event : InputEvent):
	if event.is_action_pressed("Use"):
		UI.cardPicked(self)

func setUpgrade(up: UpgradeResource):
	upgrade = up
	updateUpgrade()

func updateUpgrade():
	if upgrade:
		$MarginContainer/VBoxContainer/UpgradeIcon.texture = upgrade.tex
		$MarginContainer/VBoxContainer/Label.text = upgrade.text
