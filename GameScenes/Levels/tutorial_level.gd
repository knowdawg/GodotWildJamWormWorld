extends Level

signal dialogFunctionCallFinished
signal onDialogFinished(dialog : DialogResource)

@export_group("Dialog")
@export var dialogs : Array[DialogResource] = []
var curDialogIndex : int = 0

var inDialog : bool = false
var curDialog : DialogResource


enum STATES{
	WAKE_UP,
	CAVE_IN,
	DARK_CORRIDOR,
	EARTHQUAKE
}
var curState : STATES = STATES.WAKE_UP


func _ready() -> void:
	Game.inTutorial = true
	super._ready()
	PlayerStats.resetPlayerStats()
	%Dialog.visible = false
	onDialogFinished.connect(dialogFinished)
	$CanvasModulate.visible = true
	
	#$DarknessLayer.visible = true
	#await get_tree().create_timer(2.0).timeout
	#
	#nextDialog()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		if inDialog and %RichTextLabel.readyToProceed():
			continueDialog()
	
	#if Input.is_action_just_pressed("Glowstick") and !inDialog:
		#nextDialog()




func nextDialog():
	if curDialogIndex < dialogs.size():
		createDialog(dialogs[curDialogIndex])
		curDialogIndex += 1

func createDialog(dialog : DialogResource):
	curDialog = dialog
	if !inDialog:
		inDialog = true
		%Player.enterDialog()
		%Dialog.visible = true
	
	updateLabel(dialog.text)

func updateLabel(text : String):
	%RichTextLabel.setTest(text)

func continueDialog():
	if curDialog == null:
		return
	
	if curDialog.progressType == DialogResource.ON_PROGRESS.FUNCTION_CALL:
		if call(curDialog.functionCallName):
			%Dialog.visible = false
			%RichTextLabel.clearText()
			await dialogFunctionCallFinished
			%Dialog.visible = true
		else:
			printerr("Dialog Function: ", curDialog.functionCallName, " Not Found")
	
	if curDialog.progressType == DialogResource.ON_PROGRESS.EXIT_DIALOG:
		killDialog()
		return
	
	var next : DialogResource = curDialog.getNextDialog()
	if next == null:
		killDialog()
		return
	createDialog(next)
	return

func killDialog():
	inDialog = false
	%Player.exitDialog()
	%Dialog.visible = false
	onDialogFinished.emit(curDialog)
	curDialog = null
	
	updateLabel("")

func dialogFinished(d : DialogResource):
	if d.identifier == "WakeUpEnd":
		pass
		#$TutorialMusic.play()

func _on_dark_corridor_trigger_body_entered(_body: Node2D) -> void:
	$DialogTriggers/DarkCorridorTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %DarkCorridorSpawnPos.global_position
	nextDialog()

func _on_cave_in_trigger_body_entered(_body: Node2D) -> void:
	$DialogTriggers/CaveInTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %CaveInSpawn.global_position
	nextDialog()

func _on_earth_quake_trigger_body_entered(_body: Node2D) -> void:
	$DialogTriggers/EarthQuakeTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %EarthquakeSpawn.global_position
	nextDialog()

func shakeScreen():
	Game.camera.setMinimumShake(20.0)
	await get_tree().create_timer(2.0).timeout
	
	dialogFunctionCallFinished.emit()
	

func playerWakeUp():
	%Player.layDown()
	
	var t = create_tween()
	t.tween_property(%Darkness, "modulate", Color(0.0, 0.0, 0.0, 0.0), 3.0)
	await t.finished
	
	dialogFunctionCallFinished.emit()

func playerSitUp():
	await get_tree().create_timer(1.0).timeout
	
	%Player.sitUp()
	await get_tree().create_timer(1.0).timeout
	
	dialogFunctionCallFinished.emit()

func sirWalk():
	%Sir.walk(1.5)
	await get_tree().create_timer(1.5).timeout
	
	dialogFunctionCallFinished.emit()
