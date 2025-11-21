extends Resource
class_name DialogResource

enum ON_PROGRESS{
	EXIT_DIALOG,
	NEXT_DIALOG
}

@export_multiline var text : String = ""
@export var progressType : ON_PROGRESS = ON_PROGRESS.EXIT_DIALOG

@export var nextDialog : DialogResource

func getNextDialog() -> DialogResource:
	if !nextDialog or progressType == ON_PROGRESS.EXIT_DIALOG:
		return null
	return nextDialog
