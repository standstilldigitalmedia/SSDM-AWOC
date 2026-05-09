@tool
class_name SSDMMenuBase
extends Node

@export var remove_on_close: bool = false
@export var animation_speed: float = 0.25
@export var hide_close_button: bool = true

@export_group("Controls")
@export var outer_panel_container: PanelContainer
@export var animate_container: Control
@export var menu_button_wrapper: Control
@export var close_button: Button
@export var menu_button: Button

var panel_tween: Tween
var button_tween: Tween
var is_open: bool = false
var final_size: float
var tween_property: String


func set_panel_tween() -> void:
	if panel_tween and panel_tween.is_valid():
		panel_tween.kill()
	panel_tween = create_tween()
	panel_tween.set_ease(Tween.EASE_OUT)
	panel_tween.set_trans(Tween.TRANS_CUBIC)
	
	
func set_button_tween() -> void:
	if button_tween and button_tween.is_valid():
		button_tween.kill()
	button_tween = create_tween()
	button_tween.set_ease(Tween.EASE_OUT)
	button_tween.set_trans(Tween.TRANS_CUBIC)
	
	
func _on_slide_open_finished() -> void:
	#can be overridden in child class if needed
	pass
	
	
func _on_slide_close_finished() -> void:
	if remove_on_close:
		queue_free()
		
	
func slide_open() -> void:
	set_panel_tween()
	panel_tween.tween_property(animate_container, tween_property, final_size, animation_speed)
	panel_tween.finished.connect(_on_slide_open_finished)


func slide_closed() -> void:
	set_panel_tween()
	if remove_on_close:
		set_button_tween()
		button_tween.tween_property(menu_button_wrapper, tween_property, 0, animation_speed)
	panel_tween.tween_property(animate_container, tween_property, 0.0, animation_speed)
	panel_tween.finished.connect(_on_slide_close_finished)
	
		
func _on_close_button_pressed() -> void:
	remove_on_close = true
	slide_closed()
	
	
func _on_menu_button_toggled(toggled_on: bool) -> void:
	is_open = toggled_on
	if toggled_on:
		slide_open()
	else:
		slide_closed()
		
					
func _ready() -> void:
	if hide_close_button:
		close_button.hide()
	else:
		close_button.show()
	animate_container.clip_contents = true
	menu_button_wrapper.clip_contents = true
	#clip_wrapper.show()
	menu_button_wrapper.show()
	await get_tree().process_frame
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_inside_tree():
		return
