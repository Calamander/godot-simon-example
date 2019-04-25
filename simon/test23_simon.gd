extends Control

export var HIGHLIGHT_TIME = 0.5
export var GAP_TIME = 0.25

var level = 0
var element = 0
var sequence = []
var isHighlighting = false

signal pause_input

onready var n = $buttons.get_child_count()
onready var b = $buttons.get_children()

func _ready():
	randomize()

func _on_button_pressed(button_index):
	if sequence[element] == button_index:
		if element+1 >= sequence.size():
			nextLevel()
		else:
			element += 1
	else:
		level = 0
		$Label.text = "Game Over :("
		emit_signal("pause_input", true)

func highlightButton(button, highlight = true):
	var type
	if highlight:
		type = button.HIGHLIGHT_CLICK
	else:
		type = button.HIGHLIGHT_NONE
	button.highlight(type)

func nextLevel():
	emit_signal("pause_input", true)
	level += 1
	$Label.text = "Level " + String(level)
	sequence.append(randi()%n)
	isHighlighting = false
	element = -1
	$Timer.start(GAP_TIME)
	
func _on_Start_pressed():
	level = 0
	sequence = []
	nextLevel()

func _on_Timer_timeout():
	print("finished ",isHighlighting)
	if isHighlighting:
		highlightButton(b[sequence[element]], false)
		if element == sequence.size()-1:
			element = 0
			emit_signal("pause_input", false)
		else:
			$Timer.start(GAP_TIME)
	else:
		element += 1
		highlightButton(b[sequence[element]])
		$Timer.start(HIGHLIGHT_TIME)
	isHighlighting = !isHighlighting