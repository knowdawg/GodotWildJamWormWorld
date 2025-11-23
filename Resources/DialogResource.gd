extends Resource
class_name DialogResource

enum ON_PROGRESS{
	EXIT_DIALOG,
	NEXT_DIALOG,
	FUNCTION_CALL
}

enum ICONS{
	SIR,
	GRACE
}

@export_multiline var text : String = ""
@export var progressType : ON_PROGRESS = ON_PROGRESS.EXIT_DIALOG

@export var nextDialog : DialogResource

@export var functionCallName : String

@export var identifier : String

@export var icon : ICONS = ICONS.SIR

func getNextDialog() -> DialogResource:
	if !nextDialog or progressType == ON_PROGRESS.EXIT_DIALOG:
		return null
	return nextDialog
