class_name SSDMPluginConfig
extends Resource


@export_group("Managers")
@export var manager_registry_entries: Array[SSDMRegistryEntry] = []

@export_group("Delete Behavior")
@export var send_to_recycle: bool = false

@export_group("File Extensions")
@export var valid_image_extensions: Array[String] = ["bmp", "jpg", "jpeg", "png", "tga"]
@export var image_file_filter: String = "Image Files"
@export var valid_model_extensions: Array[String] = ["glb", "gltf", "fbx", "obj", "blend"]
@export var model_file_filter: String = "3D Model Files"
@export var do_not_delete_extensions: Array[String] = ["gd"]

@export_group("Dock")
@export var dock_scene: PackedScene
@export var dock_slot: EditorDock.DockSlot = EditorDock.DockSlot.DOCK_SLOT_MAX
