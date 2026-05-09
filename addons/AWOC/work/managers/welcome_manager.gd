class_name AWOCWelcomeManager
extends SSDMResourceManagerBase

const WELCOME_RESOURCE_PATH: String = "res://addons/AWOC/start_here/welcome.tres"


func create_resource() -> SSDMResult:
	return SSDMResult.success("", AWOCResource.new())
	
	
func get_or_create_welcome_resource() -> SSDMResult:
	#if parent_disk_resource_reference:
		#return SSDMResult.success("", parent_disk_resource_reference)
	var welcome_resource_reference: SSDMResourceReference = SSDMResourceReference.new()
	welcome_resource_reference.res_path = WELCOME_RESOURCE_PATH
	if FileAccess.file_exists(WELCOME_RESOURCE_PATH):
		welcome_resource_reference.resource = welcome_resource_reference.get_resource()
		return SSDMResult.success("", welcome_resource_reference)
	else:
		welcome_resource_reference.resource = AWOCWelcomeResource.new()
		var save_resource: SSDMResult = await _save_resource_to_disk(welcome_resource_reference)
		if !save_resource.is_success():
			return save_resource	
	#parent_disk_resource_reference = welcome_resource_reference
	#resource_dictionary = welcome_resource_reference.resource.awoc_dictionary
	return SSDMResult.success("", welcome_resource_reference)
