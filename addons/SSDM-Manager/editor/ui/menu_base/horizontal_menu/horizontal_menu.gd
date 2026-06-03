@tool
class_name SSDMHorizontalMenu
extends SSDMMenuBase

@export var panel_width: int = 400
@export var remove_on_close: bool = false

@export_group("Controls")
@export var menu_button_wrapper: Control

var button_tween: Tween


func slide_closed() -> void:
	super()
	if remove_on_close:
		set_button_tween()
		button_tween.tween_property(menu_button_wrapper, tween_property, 0, animation_speed)
	
	
func set_button_tween() -> void:
	if button_tween and button_tween.is_valid():
		button_tween.kill()
	button_tween = create_tween()
	button_tween.set_ease(Tween.EASE_OUT)
	button_tween.set_trans(Tween.TRANS_CUBIC)
	
	
func _on_close_button_pressed() -> void:
	remove_on_close = true
	slide_closed()
	
	
func _on_slide_close_finished() -> void:
	if remove_on_close:
		queue_free()
	
	
func _ready() -> void:
	menu_button_wrapper.clip_contents = true
	final_size = panel_width
	animate_container.custom_minimum_size.x = 0
	tween_property = "custom_minimum_size:x"
	menu_button.set_pressed_no_signal(true)
	slide_open()
