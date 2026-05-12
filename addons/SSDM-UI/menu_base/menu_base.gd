@tool
class_name SSDMMenuBase
extends Node

@export var animation_speed: float = 0.25

@export_group("Controls")
@export var animate_container: Control
@export var outer_panel_container: PanelContainer


var panel_tween: Tween
var is_open: bool = false
var final_size: float
var tween_property: String


func set_panel_tween() -> void:
	if panel_tween and panel_tween.is_valid():
		panel_tween.kill()
	panel_tween = create_tween()
	panel_tween.set_ease(Tween.EASE_OUT)
	panel_tween.set_trans(Tween.TRANS_CUBIC)
	
	
func _on_slide_open_finished() -> void:
	#can be overridden in child class if needed
	pass
	
	
func _on_slide_close_finished() -> void:
	pass
		
	
func slide_open() -> void:
	set_panel_tween()
	panel_tween.tween_property(animate_container, tween_property, final_size, animation_speed)
	panel_tween.finished.connect(_on_slide_open_finished)


func slide_closed() -> void:
	set_panel_tween()
	panel_tween.tween_property(animate_container, tween_property, 0.0, animation_speed)
	panel_tween.finished.connect(_on_slide_close_finished)
	
	
func _on_menu_button_toggled(toggled_on: bool) -> void:
	is_open = toggled_on
	if toggled_on:
		slide_open()
	else:
		slide_closed()
		
					
func _ready() -> void:
	animate_container.clip_contents = true
	"""await get_tree().process_frame
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_inside_tree():
		return"""
