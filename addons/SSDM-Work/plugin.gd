@tool
@abstract class_name SSDMPlugin
extends EditorPlugin

static var config: SSDMPluginConfig = null
static var dock: EditorDock = null
static var work_manager: SSDMWorkManager = null
var main_ui: Control


@abstract func get_plugin_name()->String
@abstract func get_config_path()->String

func load_from_config() -> void:
	dock = null
	config = load(get_config_path())
	if !config:
		push_error("SSDMResource: Main configuration could not be loaded.")
		return
	if !work_manager:
		work_manager = SSDMWorkManager.new()
		add_child(work_manager)
	if config.dock_scene:
		main_ui = config.dock_scene.instantiate()
		main_ui.name = get_plugin_name()
		main_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
		main_ui.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		main_ui.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
			EditorInterface.get_editor_main_screen().add_child(main_ui)
			main_ui.hide()
		else:
			dock = EditorDock.new()
			dock.add_child(main_ui)	
			dock.title = get_plugin_name()
			dock.default_slot = config.dock_slot
			dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
			add_dock(dock)	
	else:
		push_error("SSDMResource: UI is enabled in UI configuration but main_ui_scene has not been specified")
			
			
func has_main_screen_config(configure_path: String) -> bool:
	config = load(configure_path)
	if !config:
		push_error("SSDMResource: Main configuration could not be loaded")
		return false
	if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
		return true
	return false
	

func _make_visible(visible):
	main_ui.visible = visible
		
			
func _get_plugin_name() -> String:
	return get_plugin_name()


func _get_plugin_icon() -> Texture2D:
	return null


func _has_main_screen() -> bool:
	return has_main_screen_config(get_config_path())
	

func _enter_tree() -> void:
	load_from_config()
			

func _exit_tree() -> void:
	config = null
	if work_manager:
		work_manager.queue_free()
		work_manager = null
	work_manager = null
	if dock:
		remove_dock(dock)
		dock.queue_free()
	dock = null
