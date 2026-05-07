@tool
class_name SSDMHorizontalMenu
extends HBoxContainer

@export var menu_button: Button
@export var clip_wrapper: Control       # new
@export var panel_container: PanelContainer
@export var content_container: VBoxContainer

var expanded_height: float
var tween: Tween
var is_open := false

const DURATION := 0.25


func _ready() -> void:
	clip_wrapper.clip_contents = true
	clip_wrapper.show()
	panel_container.show()
	await get_tree().process_frame
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_inside_tree():
		return
	expanded_height = 400
	print("expanded_height captured: ", expanded_height)
	clip_wrapper.custom_minimum_size.x = 0
	menu_button.set_pressed_no_signal(false)


func _on_menu_button_toggled(toggled_on: bool) -> void:
	is_open = toggled_on
	if toggled_on:
		slide_open()
	else:
		slide_closed()


func slide_open() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(clip_wrapper, "custom_minimum_size:x", expanded_height, DURATION)


func slide_closed() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(clip_wrapper, "custom_minimum_size:x", 0.0, DURATION)
