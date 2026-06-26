@tool
class_name AWOCPlugin
extends EditorPlugin

static var config: SSDMPluginConfig = null
static var dock: EditorDock = null
static var work_manager: SSDMWorkManager = null
var main_ui: Control


func set_config_path(res_ref: SSDMResourceReference) -> void:
	res_ref.set_res_path("res://", "addons/AWOC/start_here", "config", ".tres")


func load_from_config() -> void:
	dock = null
	var config_ref := SSDMDiskResourceReference.new()
	set_config_path(config_ref)
	var config_result: SSDMResult = config_ref.get_resource()
	config = config_result.data
	if !config:
		config_ref.loaded_resource = SSDMPluginConfig.new()
		config_ref.save_resource_to_disk()
		var path_result: SSDMResult = config_ref.get_res_path()
		if !path_result.is_success():
			push_error(path_result.message)
		push_error("SSDMPlugin: Configure your plugin. New config file created at: " + path_result.data)
		return
	if !work_manager:
		work_manager = SSDMWorkManager.new(config)
	if config.dock_scene:
		main_ui = config.dock_scene.instantiate()
		main_ui.name = _get_plugin_name()
		main_ui.set_anchors_preset(Control.PRESET_FULL_RECT)
		main_ui.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
		main_ui.size_flags_vertical = Control.SIZE_FILL | Control.SIZE_EXPAND
		if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
			EditorInterface.get_editor_main_screen().add_child(main_ui)
			main_ui.hide()
		else:
			dock = EditorDock.new()
			dock.add_child(main_ui)	
			dock.title = _get_plugin_name()
			dock.default_slot = config.dock_slot
			dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
			add_dock(dock)	
	else:
		push_error("SSDMPlugin: UI is enabled in UI configuration but main_ui_scene has not been specified")
			
			
func has_main_screen_config() -> bool:
	var config_ref := SSDMDiskResourceReference.new()
	set_config_path(config_ref)
	var config_result: SSDMResult = config_ref.get_resource()
	if !config_result.is_success():
		return false
	config = config_result.data
	if !config:
		config_ref.loaded_resource = SSDMPluginConfig.new()
		config_ref.save_resource_to_disk()
		var path_result: SSDMResult = config_ref.get_res_path()
		if !path_result.is_success():
			return false
		push_error("Configure your plugin. New config file created at: " + path_result.data)
		return false
	if config.dock_slot == EditorDock.DockSlot.DOCK_SLOT_MAX:
		return true
	return false
	

func _make_visible(visible):
	if main_ui:
		main_ui.visible = visible
		
			
func _get_plugin_name() -> String:
	return "AWOC"


func _get_plugin_icon() -> Texture2D:
	return null


func _has_main_screen() -> bool:
	return has_main_screen_config()
	

func _enter_tree() -> void:
	load_from_config()
			

func _exit_tree() -> void:
	config = null
	work_manager = null
	if dock:
		remove_dock(dock)
		dock.queue_free()
	dock = null
