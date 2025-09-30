extends Node

var settings_location: String = "user://settings.json"
var settings_file_contents: Dictionary = {
    "isFileLoaded": {
        "value": false,
        "setting_style": "checkbox",
        "display": false,
    },

    "reportOnline": {
        "value": false,
        "setting_style": "checkbox",
        "display": true,
    },

    "reportOffline": {
        "value": false,
        "setting_style": "checkbox",
        "display": true,
    },
    "reportSettingsUpdates": {
        "value": false,
        "setting_style": "checkbox",
        "display": true,
    },
    "reportSaveFileUpdates": {
        "value": false,
        "setting_style": "checkbox",
        "display": true,
    },
    "volume": {
        "value": 0,
        "setting_style": "slider",
        "display": true,
    },
}

func _process(_delta: float) -> void:
    if settings_file_contents.isFileLoaded.value == false:
        load_file(settings_location)
        return

func save_file(path: String) -> void:
    if !FileAccess.file_exists(path):
        if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
            push_warning("Failed to save settings file, could not find file at save location %s. Creating new save file." % path)
    if FileAccess.file_exists(path):
        if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
            print_debug("Saving settings file at path %s." % path)
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_var(settings_file_contents.duplicate())
    file.close()
    return

func load_file(path: String) -> void:
    if !FileAccess.file_exists(path):
        push_error("Failed to load file, could not find file at save location %s." % path)
        save_file(path)
        return
    var file: FileAccess= FileAccess.open(path, FileAccess.READ)
    var data: Variant = file.get_var()
    file.close()

    var found_data = data.duplicate()
    settings_file_contents = found_data

    settings_file_contents.isFileLoaded.value = true
    if SettingsManager.settings_file_contents.reportSettingsUpdates.value  == true:
        print_debug('Updated settings: ' + str(settings_file_contents) + '.')
    return