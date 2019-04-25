extends TextureRect

const COLORS = [Color.red, Color.green, Color.blue, Color.orange]
enum COLOR_NAME {red, green, blue, orange}
export (COLOR_NAME) var color = COLOR_NAME.red
enum {HIGHLIGHT_NONE, HIGHLIGHT_HOVER, HIGHLIGHT_CLICK}
var active = false
var paused = true
var highlight = 0
signal button_pressed

func _ready():
	var main = $"/root/Main/"
	connect("gui_input",self,"_on_button_gui_input")
	connect("mouse_entered",self,"_on_button_mouse_entered")
	connect("mouse_exited",self,"_on_button_mouse_exited")
	connect("button_pressed",main,"_on_button_pressed")
	main.connect("pause_input",self,"pauseInput")
	modulate = COLORS[color]
	highlight()

func pauseInput(pause):
	paused = pause
	if pause:
		highlight()
	elif active:
		highlight(HIGHLIGHT_HOVER)

func highlight(type = HIGHLIGHT_NONE):
	highlight = type
	match type:
		HIGHLIGHT_NONE:
			modulate.a = 0.5
		HIGHLIGHT_HOVER:
			modulate.a = 0.6
		HIGHLIGHT_CLICK:
			modulate.a = 1

func _on_button_mouse_entered():
	if !paused:
		highlight(HIGHLIGHT_HOVER)
	active = true
func _on_button_mouse_exited():
	if !paused:
		highlight()
	active = false
	
func _on_button_gui_input(event):
	if !paused and event is InputEventMouseButton:
		if event.pressed: 
			highlight(HIGHLIGHT_CLICK)
		else:
			emit_signal("button_pressed", get_index())
