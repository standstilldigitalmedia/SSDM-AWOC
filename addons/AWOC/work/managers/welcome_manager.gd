class_name AWOCWelcomeManager
extends SSDMDiskResourceManager

const WELCOME_RESOURCE_PATH: String = "res://addons/AWOC/welcome/welcome.tres"


func get_or_create_welcome_resource() -> SSDMResult:
	var welcome_resource_reference: SSDMResourceReference = SSDMResourceReference.new()
	welcome_resource_reference.res_path = WELCOME_RESOURCE_PATH
	welcome_resource_reference.resource = welcome_resource_reference.get_resource()
	if welcome_resource_reference.resource:
		var result = SSDMResult.success()
		result.data = welcome_resource_reference
		return result
	else:
		welcome_resource_reference.resource = AWOCWelcomeResource.new()
		var save_resource: SSDMResult = await save_resource_to_disk(welcome_resource_reference)
		if !save_resource.is_success():
			return save_resource	
	parent_disk_resource_reference = welcome_resource_reference
	resource_dictionary = welcome_resource_reference.resource.awoc_dictionary
	var result = SSDMResult.success()
	result.data = welcome_resource_reference
	return result
	
	
func get_new_resource() -> SSDMResult:
	return await get_or_create_welcome_resource()
	
	
func create_resource(res_name: String, resource_reference: SSDMResourceReference, additional_data: Variant = null, parent_name: String = "") -> SSDMResult:
	return await get_or_create_welcome_resource()
	
	
func rename_resource(old_name: String, new_name: String) -> SSDMResult:
	return SSDMResult.failure("You should not be renaming the Welcome resource")
	
	
func delete_resource(resource_name: String) -> SSDMResult:
	return SSDMResult.failure("You should not be deleting the Welcome resource")
	
	
