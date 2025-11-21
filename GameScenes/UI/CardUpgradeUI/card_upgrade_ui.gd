extends CanvasLayer
class_name CardUpgradeUI

var upgrades : Array[UpgradeResource]

var commonUpgrades : Array[UpgradeResource]
var uncommonUpgrades : Array[UpgradeResource]
var rareUpgrades : Array[UpgradeResource]
var mythicUpgrades : Array[UpgradeResource]


var inSelection : bool = false

var commonFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/CommonFrame.tres")
var uncommonFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/UncommonFrame.tres")
var rareFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/RareFrame.tres")
var mythicFrame : StyleBoxFlat = preload("res://GameScenes/UI/CardUpgradeUI/CardFrames/MythicFrame.tres")

var upgradeFilePath : String = "res://UpgradeCards/"
func _ready() -> void:
	Game.createCardUpgrade.connect(queueCardSelection)
	
	var dir : DirAccess = DirAccess.open(upgradeFilePath)
	
	for path : String in dir.get_files():
		if path.ends_with(".import"):
			continue
		
		var up : UpgradeResource = ResourceLoader.load(upgradeFilePath + path)
		
		if up == null:
			printerr("Failed to load resource : ", upgradeFilePath + path)
		
		upgrades.append(up) #in the end, upgrades's size is 1
		
		match up.rarity: #Hits an error, cant get rarity in non existant 'up'
			UpgradeResource.RARITY.COMMON:
				commonUpgrades.append(up)
			UpgradeResource.RARITY.UNCOMMON:
				uncommonUpgrades.append(up)
			UpgradeResource.RARITY.RARE:
				rareUpgrades.append(up)
			UpgradeResource.RARITY.MYTHIC:
				mythicUpgrades.append(up)
	
	#All this code still runs
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

var curSelectedCard : CardOption
func cardPicked(card : CardOption):
	if $AnimationPlayer.current_animation == "ShowCards":
		#if $AnimationPlayer.current_animation_position < 0.5:
		return
	
	curSelectedCard = card
	cardConfirmed()
	
	if curSelectedCard == null:
		curSelectedCard = card
		curSelectedCard.click()
		return
	
	curSelectedCard.unclick()
	if curSelectedCard == card:
		curSelectedCard = null
		return
	
	curSelectedCard = card
	curSelectedCard.click()
	
	


func cardConfirmed():
	if curSelectedCard == null:
		return
	
	Game.resumeGame()
	Game.cardPicked.emit(curSelectedCard.upgrade)
	
	if curSelectedCard.upgrade.unique:
		upgrades.erase(curSelectedCard.upgrade)
		match curSelectedCard.upgrade.rarity:
			UpgradeResource.RARITY.COMMON:
				commonUpgrades.erase(curSelectedCard.upgrade)
			UpgradeResource.RARITY.UNCOMMON:
				uncommonUpgrades.erase(curSelectedCard.upgrade)
			UpgradeResource.RARITY.RARE:
				rareUpgrades.erase(curSelectedCard.upgrade)
			UpgradeResource.RARITY.MYTHIC:
				mythicUpgrades.erase(curSelectedCard.upgrade)
	
	curSelectedCard.unclick()
	curSelectedCard = null
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
