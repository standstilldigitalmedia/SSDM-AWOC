@tool
class_name AWOCPlugin
extends SSDMPlugin


func set_config_path(res_ref: SSDMResourceReference) -> void:
	res_ref.set_res_path("res://", "addons/AWOC/editor/config/", "config", ".tres")
	
	
func _get_plugin_name() -> String:
	return "AWOC"
