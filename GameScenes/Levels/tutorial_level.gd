extends Level
class_name TutorialLevel

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
	
	$DarknessLayer.visible = true
	await get_tree().process_frame
	
	nextDialog()


func _process(_delta: float) -> void:
	if inDialog and %RichTextLabel.readyToProceed():
		if Input.is_action_just_pressed("Jump"):
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
	
	if curDialog.icon == DialogResource.ICONS.SIR:
		$Dialog/SirIcon.visible = true
		$Dialog/RadioIcon.visible = false
	else:
		$Dialog/SirIcon.visible = false
		$Dialog/RadioIcon.visible = true
	
	updateLabel(dialog.text)

func updateLabel(text : String):
	%RichTextLabel.setTest(text)

func continueDialog():
	if curDialog == null:
		return
	
	if curDialog.progressType == DialogResource.ON_PROGRESS.FUNCTION_CALL:
		call(curDialog.functionCallName)
		%Dialog.visible = false
		%RichTextLabel.clearText()
		await dialogFunctionCallFinished
		%Dialog.visible = true
	
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
	%Dialog.visible = false
	onDialogFinished.emit(curDialog)
	curDialog = null
	
	updateLabel("")

func dialogFinished(d : DialogResource):
	if d.identifier == "WakeUpEnd":
		%Player.jumpUp()
		$ControllsPopup.showControlls(ControllsPopup.TEXT.CONTROLS)
		$TutorialMusic.play()
	
	if d.identifier == "DarkCorridorEnd":
		%Player.exitDialog()
		$ControllsPopup.showControlls(ControllsPopup.TEXT.FLARE)
	
	if d.identifier == "CaveInEnd":
		%Player.exitDialog()
		$ControllsPopup.showControlls(ControllsPopup.TEXT.MINE)
	
	if d.identifier == "earthquakeOver":
		%Player.enterEscapePod()
		$Particles/WormParticles.emitting = true
		$EarthquakeCutsceneAnimator.play("Cutscene")

func _on_dark_corridor_trigger_body_entered(_body: Node2D) -> void:
	$ControllsPopup.hideControlls()
	$DialogTriggers/DarkCorridorTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %DarkCorridorSpawnPos.global_position
	nextDialog()

func _on_cave_in_trigger_body_entered(_body: Node2D) -> void:
	$ControllsPopup.hideControlls()
	$DialogTriggers/CaveInTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %CaveInSpawn.global_position
	nextDialog()

func _on_earth_quake_trigger_body_entered(_body: Node2D) -> void:
	$ControllsPopup.hideControlls()
	$DialogTriggers/EarthQuakeTrigger/CollisionShape2D.set_deferred("disabled", true)
	
	%Sir.global_position = %EarthquakeSpawn.global_position
	%Player.enterDialog()
	
	%Sir.walkToPoint(%EarthquakeEndPos.global_position)
	await %Sir.gotToTargetPos
	
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(30.0)
	$Particles/WormParticles.emitting = true
	$EarthquakeTimer.start()
	$TutorialMusic.stop()
	$Sounds/Earthquake.play()
	$Sounds/Impact.play()
	
	await get_tree().create_timer(2.0).timeout
	
	nextDialog()


func _on_earthquake_timer_timeout() -> void:
	if is_instance_valid(Game.camera):
		Game.camera.setMinimumShake(randf_range(5.0, 15.0))
	$Sounds/Impact.play()
	$EarthquakeTimer.start(randf_range(1.0, 3.0))
	

func shakeScreen():
	Game.camera.setMinimumShake(20.0)

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

func silenceAudio():
	$Sounds/Earthquake.stop()
	$Sounds/Impact.stop()
	$Sounds/Puncture.stop()
	$EarthquakeTimer.stop()

var mainLevelPath : String = "res://GameScenes/Levels/random_gen_level.tscn"
func _on_earthquake_cutscene_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Cutscene":
		$EarthquakeCutsceneAnimator.play("Text")
	if anim_name == "Text":
		Game.inTutorial = false
		Game.gameManager.switchScene(mainLevelPath, 1.0, true)
