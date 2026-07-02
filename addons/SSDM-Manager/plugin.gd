@tool
class_name SSDMPlugin
extends EditorPlugin

static var config: SSDMPluginConfig = null
static var work_manager: SSDMWorkManager = null


func set_config_path(res_ref: SSDMResourceReference) -> void:
	res_ref.set_res_path("res://", "addons/SSDM-Manager/config", "config", ".tres")


func load_config() -> void:
	var config_ref := SSDMDiskResourceReference.new()
	set_config_path(config_ref)
	var config_result: SSDMResult = config_ref.get_resource()
	config = config_result.data
	if !config:
		config = SSDMPluginConfig.new()
		config_ref.loaded_resource = config
		config_ref.save_resource_to_disk()
		var path_result: SSDMResult = config_ref.get_res_path()
		if !path_result.is_success():
			push_error(path_result.message)
		push_error("SSDMPlugin: Configure your plugin. New config file created at: " + path_result.data)
	work_manager = SSDMWorkManager.new(config.manager_registry_entries)
			
			
func _enter_tree() -> void:
	load_config()
			

func _exit_tree() -> void:
	config = null
