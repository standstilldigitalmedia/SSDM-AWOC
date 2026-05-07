@tool
class_name SSDMMenuBase
extends Node

@export var remove_on_close: bool = false
@export var animation_speed: float = 0.25

@export_group("Controls")
@export var menu_button: Button
@export var clip_wrapper: Control       # new
@export var panel_container: PanelContainer
@export var content_container: VBoxContainer

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
	
	
func slide_open() -> void:
	set_tween()
	tween.tween_property(clip_wrapper, tween_property, final_size, animation_speed)


func slide_closed() -> void:
	set_tween()
	tween.tween_property(clip_wrapper, tween_property, 0.0, animation_speed)
	tween.finished.connect(_on_panel_closed)
	
	
func _on_panel_closed() -> void:
	if remove_on_close:
		queue_free()
		
		
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
	menu_button.set_pressed_no_signal(false)
