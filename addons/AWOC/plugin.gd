@tool
class_name AWOCPlugin
extends EditorPlugin


static var dock: EditorDock = null
var main_ui: Control
var main_ui_scene: PackedScene = preload("res://addons/AWOC/editor/ui/dock/dock.tscn")
var dock_slot: EditorDock.DockSlot = EditorDock.DockSlot.DOCK_SLOT_MAX


func load_ui() -> void:
	dock = null
	main_ui = main_ui_scene.instantiate()
	main_ui.name = _get_plugin_name()
	main_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_ui.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
	main_ui.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
	if dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
		EditorInterface.get_editor_main_screen().add_child(main_ui)
		main_ui.hide()
	else:
		dock = EditorDock.new()
		dock.add_child(main_ui)	
		dock.title = _get_plugin_name()
		dock.default_slot = dock_slot
		dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
		add_dock(dock)	
	
			
func _make_visible(visible):
	if main_ui:
		main_ui.visible = visible
		
			
func _get_plugin_name() -> String:
	return "AWOC"


func _get_plugin_icon() -> Texture2D:
	return null


func _has_main_screen() -> bool:
	if dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
		return true
	return false	
	

func _enter_tree() -> void:
	var editor_interface = get_editor_interface()
	while !editor_interface.is_plugin_enabled("res://addons/SSDM-Manager/plugin.cfg"):
		await get_tree().process_frame
	load_ui()
			

func _exit_tree() -> void:
	if dock:
		remove_dock(dock)
		dock.queue_free()
	dock = null
