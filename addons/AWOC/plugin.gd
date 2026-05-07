@tool
class_name AWOCPlugin
extends SSDMPlugin

const AWOC_CONFIG_PATH: String = "res://addons/AWOC/editor/config/config.tres"
const AWOC_PLUGIN_NAME: String = "AWOC"


func get_plugin_name()->String:
	return AWOC_PLUGIN_NAME
	
	
func get_config_path()->String:
	return AWOC_CONFIG_PATH
