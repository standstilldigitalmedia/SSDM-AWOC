@tool
class_name SSDMMenuBase
extends Node

@export var remove_on_close: bool = false
@export var animation_speed: float = 0.25
@export var hide_close_button: bool = true

@export_group("Controls")
@export var clip_wrapper: Control 
@export var menu_button_wrapper: Control
@export var panel_container: PanelContainer
@export var content_container: VBoxContainer
@export var close_button: Button
@export var menu_button: Button

var tween: Tween
var is_open: bool = false
var final_size: float
var tween_property: String


func set_tween() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	
func _on_slide_open_finished() -> void:
	#can be overridden in child class if needed
	pass
	
	
func destroy_panel() -> void:
	queue_free()
	
	
func _on_slide_close_finished() -> void:
	if remove_on_close:
		set_tween()
		menu_button_wrapper.clip_contents = true
		tween.tween_property(menu_button_wrapper, tween_property, 0, animation_speed)
		tween.finished.connect(destroy_panel)
		
	
func slide_open() -> void:
	set_tween()
	tween.tween_property(clip_wrapper, tween_property, final_size, animation_speed)
	tween.finished.connect(_on_slide_open_finished)


func slide_closed() -> void:
	set_tween()
	tween.tween_property(clip_wrapper, tween_property, 0.0, animation_speed)
	tween.finished.connect(_on_slide_close_finished)
	
		
func _on_close_button_pressed() -> void:
	remove_on_close = true
	slide_closed()
	
			
func _ready() -> void:
	if hide_close_button:
		close_button.hide()
	clip_wrapper.clip_contents = true
	menu_button_wrapper.clip_contents = true
	clip_wrapper.show()
	panel_container.show()
	menu_button_wrapper.show()
	await get_tree().process_frame
	if not is_inside_tree():
		return
	await get_tree().process_frame
	if not is_inside_tree():
		return
