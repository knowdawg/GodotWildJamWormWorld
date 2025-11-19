extends CanvasLayer
class_name CardUpgradeUI

var upgrades : Array[UpgradeResource]

var upgradeFilePath : String = "res://UpgradeCards/"

var inSelection : bool = false

func _ready() -> void:
	Game.createCardUpgrade.connect(queueCardSelection)
	
	var dir : DirAccess = DirAccess.open(upgradeFilePath)
	
	for path : String in dir.get_files():
		var up : UpgradeResource = ResourceLoader.load(upgradeFilePath + path)
		upgrades.append(up)

#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("CreateSelection"):
		#createCardSelection()


var cardSelectionsQueued : int = 0

func queueCardSelection():
	cardSelectionsQueued += 1

func cardPicked(card : CardOption):
	Game.resumeGame()
	Game.cardPicked.emit(card.upgrade)
	
	$AnimationPlayer.play("HideCards")
	inSelection = false

func createCardSelection():
	inSelection = true
	
	if upgrades.size() < 3:
		printerr("Not enough upgrades to create a Selection")
		return
	
	Game.pauseGame()
	
	var rand1 : int = -1
	var rand2 : int = -1
	var rand3 : int = -1
	
	rand1 = randi_range(0, upgrades.size() - 1)
	rand2 = randi_range(0, upgrades.size() - 1)
	rand3 = randi_range(0, upgrades.size() - 1)
	
	while rand2 == rand1 or rand2 == rand3:
		rand2 = randi_range(0, upgrades.size() - 1)
	while rand3 == rand1 or rand3 == rand2:
		rand3 = randi_range(0, upgrades.size() - 1)
	
	%Option1.setUpgrade(upgrades[rand1])
	%Option2.setUpgrade(upgrades[rand2])
	%Option3.setUpgrade(upgrades[rand3])
	
	$AnimationPlayer.play("ShowCards")


func _on_card_selection_queue_timer_timeout() -> void:
	if !inSelection:
		if cardSelectionsQueued > 0:
			cardSelectionsQueued -= 1
			createCardSelection()
