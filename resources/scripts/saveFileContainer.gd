extends CenterContainer

func _process(_delta: float) -> void:
    var path: String = self.get_meta('file_location')
    var does_file_exist: bool = FileAccess.file_exists(path)
    self.visible = does_file_exist
    return