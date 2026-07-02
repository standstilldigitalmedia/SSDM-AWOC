class_name SSDMPluginConfig
extends Resource


@export_group("Managers")
@export var manager_registry_entries: Array[SSDMRegistryEntry] = []

@export_group("Delete Behavior")
@export var send_to_recycle: bool = false

@export_group("File Extensions")
@export var valid_image_extensions: Array[SSDMFileExtenstion]
@export var valid_model_extensions: Array[SSDMFileExtenstion]
@export var do_not_delete_extensions: Array[String] = ["gd"]
