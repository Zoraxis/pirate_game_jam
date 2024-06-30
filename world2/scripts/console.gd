extends Label

func _ready():
	Global.console = self

func log(newText):
	text += str("\n") + str(newText)
