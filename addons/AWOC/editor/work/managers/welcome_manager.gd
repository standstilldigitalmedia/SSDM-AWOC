class_name AWOCWelcomeManager
extends AWOCResourceManagerBase

const WELCOME_RESOURCE_PATH: String = "res://addons/AWOC/start_here/welcome.tres"


func get_new_resource() -> AWOCResult:
	return AWOCResult.success("", AWOCResource.new())
	
	
func get_or_create_welcome_resource() -> AWOCResult:
	if _parent_resource_reference:
		return AWOCResult.success("", _parent_resource_reference)
	var welcome_resource_reference: AWOCResourceReference = AWOCResourceReference.new()
	welcome_resource_reference.res_path = WELCOME_RESOURCE_PATH
	if FileAccess.file_exists(WELCOME_RESOURCE_PATH):
		var welcome_resource: AWOCWelcomeResource = welcome_resource_reference.get_resource()
		welcome_resource_reference.resource = welcome_resource
		welcome_resource.awoc_dictionary = welcome_resource.awoc_dictionary.duplicate()
		return AWOCResult.success("", welcome_resource_reference)
	else:
		welcome_resource_reference.resource = AWOCWelcomeResource.new()
		var save_resource: AWOCResult = await _save_resource_to_disk(welcome_resource_reference)
		if !save_resource.is_success():
			return save_resource	
	return AWOCResult.success("", welcome_resource_reference)
