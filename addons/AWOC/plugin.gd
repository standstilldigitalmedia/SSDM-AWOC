@tool
class_name AWOCPlugin
extends EditorPlugin

static var config: AWOCConfig = null
static var dock: EditorDock = null
var main_ui: Control
const AWOC_CONFIG_PATH: String = "res://addons/AWOC/editor/config/config.tres"
const AWOC_PLUGIN_NAME: String = "AWOC"


func load_from_config(config_path: String, ui_name: String) -> void:
	dock = null
	config = load(config_path)
	if !config:
		push_error("SSDMResource: Main configuration could not be loaded.")
		return
	"""if !work_manager:
		work_manager = SSDMWorkManager.new()
		add_child(work_manager)"""
	if config.dock_scene:
		main_ui = config.dock_scene.instantiate()
		main_ui.name = ui_name
		main_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
		main_ui.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		main_ui.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
			EditorInterface.get_editor_main_screen().add_child(main_ui)
			main_ui.hide()
		else:
			dock = EditorDock.new()
			dock.add_child(main_ui)	
			dock.title = ui_name
			dock.default_slot = config.dock_slot
			dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
			add_dock(dock)	
	else:
		push_error("SSDMResource: UI is enabled in UI configuration but main_ui_scene has not been specified")
			
			
func has_main_screen_config(config_path: String) -> bool:
	config = load(config_path)
	if !config:
		push_error("SSDMResource: Main configuration could not be loaded")
		return false
	if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
		return true
	return false
	

func _make_visible(visible):
	main_ui.visible = visible
		
			
func _get_plugin_name() -> String:
	return AWOC_PLUGIN_NAME


func _get_plugin_icon() -> Texture2D:
	return null


func _has_main_screen() -> bool:
	return has_main_screen_config(AWOC_CONFIG_PATH)
	

func _enter_tree() -> void:
	load_from_config(AWOC_CONFIG_PATH, AWOC_PLUGIN_NAME)
			

func _exit_tree() -> void:
	config = null
	"""if work_manager:
		work_manager.queue_free()
		work_manager = null
	work_manager = null"""
	if dock:
		remove_dock(dock)
		dock.queue_free()
	dock = null

"""
static var work_manager: SSDMWorkManager = null

"""
