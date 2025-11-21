extends CanvasLayer
class_name CardUpgradeUI

var upgrades : Array[UpgradeResource]

var commonUpgrades : Array[UpgradeResource]
var uncommonUpgrades : Array[UpgradeResource]
var rareUpgrades : Array[UpgradeResource]
var mythicUpgrades : Array[UpgradeResource]

var upgradeFilePath : String = "res://UpgradeCards/"

var inSelection : bool = false

var commonFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/CommonFrame.tres")
var uncommonFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/UncommonFrame.tres")
var rareFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/RareFrame.tres")
var mythicFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/MythicFrame.tres")

func _ready() -> void:
	Game.createCardUpgrade.connect(queueCardSelection)
	
	var dir : DirAccess = DirAccess.open(upgradeFilePath)
	
	for path : String in dir.get_files():
		var up : UpgradeResource = ResourceLoader.load(upgradeFilePath + path)
		upgrades.append(up)
		
		match up.rarity:
			UpgradeResource.RARITY.COMMON:
				commonUpgrades.append(up)
			UpgradeResource.RARITY.UNCOMMON:
				uncommonUpgrades.append(up)
			UpgradeResource.RARITY.RARE:
				rareUpgrades.append(up)
			UpgradeResource.RARITY.MYTHIC:
				mythicUpgrades.append(up)
	
	print("Num of Upgrades: ", upgrades.size())
	print("Num of Common Upgrades: ", commonUpgrades.size())
	print("Num of Uncommon Upgrades: ", uncommonUpgrades.size())
	print("Num of Rare Upgrades: ", rareUpgrades.size())
	print("Num of Mythic Upgrades: ", mythicUpgrades.size())

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("CreateSelection"):
		queueCardSelection()


var cardSelectionsQueued : int = 0

func queueCardSelection():
	cardSelectionsQueued += 1

func cardPicked(card : CardOption):
	Game.resumeGame()
	Game.cardPicked.emit(card.upgrade)
	
	if card.upgrade.unique:
		upgrades.erase(card.upgrade)
		match card.upgrade.rarity:
			UpgradeResource.RARITY.COMMON:
				commonUpgrades.erase(card.upgrade)
			UpgradeResource.RARITY.UNCOMMON:
				uncommonUpgrades.erase(card.upgrade)
			UpgradeResource.RARITY.RARE:
				rareUpgrades.erase(card.upgrade)
			UpgradeResource.RARITY.MYTHIC:
				mythicUpgrades.erase(card.upgrade)
	
	$AnimationPlayer.play("HideCards")
	inSelection = false
	$CardPicked.play()

func createCardSelection():
	inSelection = true
	
	if upgrades.size() < 3:
		printerr("Not enough upgrades to create a Selection")
		return
	
	Game.pauseGame()
	
	
	var rarity1 : float = randf()
	var rarity2 : float = randf()
	var rarity3 : float = randf()
	
	var rarityArray1 : Array[UpgradeResource] = getRarityArray(rarity1)
	var rarityArray2 : Array[UpgradeResource] = getRarityArray(rarity2)
	var rarityArray3 : Array[UpgradeResource] = getRarityArray(rarity3)
	
	var rand1 : int = randi_range(0, rarityArray1.size() - 1)
	var rand2 : int = randi_range(0, rarityArray2.size() - 1)
	var rand3 : int = randi_range(0, rarityArray3.size() - 1)
	
	%Option1.setUpgrade(rarityArray1[rand1])
	%Option1.add_theme_stylebox_override("panel", getRarityFrame(rarity1))
	%Option2.setUpgrade(rarityArray2[rand2])
	%Option2.add_theme_stylebox_override("panel", getRarityFrame(rarity2))
	%Option3.setUpgrade(rarityArray3[rand3])
	%Option3.add_theme_stylebox_override("panel", getRarityFrame(rarity3))
	
	$AnimationPlayer.play("ShowCards")

func getRarityArray(rarity : float) -> Array[UpgradeResource]:
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.COMMON] and commonUpgrades.size() > 0:
		#print("Common :(")
		return commonUpgrades;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.UNCOMMON] and uncommonUpgrades.size() > 0:
		#print("Uncommon :)")
		return uncommonUpgrades;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.RARE] and rareUpgrades.size() > 0:
		#print("Rare!")
		return rareUpgrades;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.MYTHIC] and mythicUpgrades.size() > 0:
		#print("MYTHIC!!!")
		return mythicUpgrades;
	
	#print("Common :(")
	return commonUpgrades;

func getRarityFrame(rarity : float) -> StyleBoxFlat:
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.COMMON] and commonUpgrades.size() > 0:
		return commonFrame;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.UNCOMMON] and uncommonUpgrades.size() > 0:
		return uncommonFrame;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.RARE] and rareUpgrades.size() > 0:
		return rareFrame;
	if rarity < UpgradeResource.rareityRate[UpgradeResource.RARITY.MYTHIC] and mythicUpgrades.size() > 0:
		return mythicFrame;
	
	return commonFrame;

func _on_card_selection_queue_timer_timeout() -> void:
	if !inSelection:
		if cardSelectionsQueued > 0:
			cardSelectionsQueued -= 1
			createCardSelection()
