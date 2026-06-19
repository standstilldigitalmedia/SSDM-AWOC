@tool
class_name AWOCMaterialLibraryManager
extends SSDMLibraryManagerBase


#EditorInterface.inspect_object(awoc)

"""extends Node

@export var texture_paths: Array[String] = [
	"res://textures/dirt.png",
	"res://textures/grass.png",
	"res://textures/stone.png"
]

var texture_array: Texture2DArray

func _ready() -> void:
	var image_list: Array[Image] = []
	
	for path in texture_paths:
		# 1. Load the texture resource from disk
		var tex = load(path) as Texture2D
		if tex:
			# 2. Extract the raw pixel Image data
			var img = tex.get_image()
			image_list.append(img)
			
	if image_list.size() > 0:
		# 3. Instantiate the Texture2DArray
		texture_array = Texture2DArray.new()
		# 4. Populate it with the collected images
		texture_array.create_from_images(image_list)
		
		# Example: Assign the array to a shader material
		# var mat = $MeshInstance3D.material_override as ShaderMaterial
		# mat.set_shader_parameter("my_texture_array", texture_array)"""
		
		
		
func modify_resource_property(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	if !params.has("prop") or !params.has("value"):
		return SSDMResult.print_failure("Paramaters does not have the correct keys")
	if params['prop'] != "color":
		return SSDMResult.print_failure("What are you trying to modify?")
	resource_reference.stored_value = params.get("value")
	return await disk_resource_reference.save_resource_to_disk()
	
	
func add_resource(params: Dictionary) -> SSDMResult:
	if !params.has("name") or !params.has("color"):
		return SSDMResult.print_failure("Paramaters does not have the correct keys")
	var material_ref := SSDMDiskResourceReference.new()
	material_ref.res_name = params.get("name")
	var add_dictionary_result: SSDMResult = await _add_dictionary_resource(material_ref)
	if !add_dictionary_result.is_success():
		return add_dictionary_result
	var save_resource_result: SSDMResult = await disk_resource_reference.save_resource_to_disk()
	if !save_resource_result.is_success():
		return save_resource_result
	return SSDMResult.success("Resource " + material_ref.res_name + " created successfully")
	

func rename_resource(new_name: String, resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return await _rename_dictionary_resource(new_name, resource_reference)
	

func delete_resource(resource_reference: SSDMResourceReference, params: Dictionary = {}) -> SSDMResult:
	return await _delete_dictionary_resource(resource_reference)
