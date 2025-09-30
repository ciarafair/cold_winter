extends Node

var save_file_location: String = 'user://save_file_1.json'

var save_file_contents: Dictionary = {
    'test': 0,
    'isdefault': 0
}

var default_contents: Dictionary = {}

var known_files: Dictionary = {}
var file_num: int = 0
var is_file_loaded: bool = false

func _ready() -> void:
    SignalManager.saveFileSignal.connect(save_file)
    SignalManager.loadFileSignal.connect(load_file)
    SignalManager.newFileSignal.connect(create_new_file)
    SignalManager.deleteFileSignal.connect(delete_file)
    SignalManager.onlineSignal.emit(self)
    return

func _process(_delta: float) -> void:
    if save_file_contents.get('isdefault') == 0:
        default_contents = save_file_contents.duplicate()
        save_file_contents.isdefault = 1
    return

func save_file(path) -> void:
    if !FileAccess.file_exists(path):
        push_error("Failed to save file, could not find file at save location " + path + '. Creating new save file.')
    if FileAccess.file_exists(path):
        if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
            print_debug('Saving file at path ' + path + '.')
    save_file_contents.isdefault = 1
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_var(save_file_contents.duplicate())
    file.close()
    return

func load_file(path) -> void:
    if !FileAccess.file_exists(path):
        push_error("Failed to load file, could not find file at save location " + path + '.')
        create_new_file(path)
        return
    #print_debug('Found file at ' + path)
    var file = FileAccess.open(path, FileAccess.READ)
    var data = file.get_var()
    file.close()
    save_file_location = path

    var found_data = data.duplicate()
    save_file_contents = found_data
    is_file_loaded = true
    return

func create_new_file(path) -> void:
    if known_files.size() >= 1:
        path = new_location()
        if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
            print_debug('Save file already present. Creating new file in ' + path + '.')
        save_file_location = path
    else:
        if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
            print_debug('No save file found. Creating new file in ' + path + '.')
    var file = FileAccess.open(path, FileAccess.WRITE)
    save_file_contents.clear()
    save_file_contents = default_contents.duplicate()
    file.store_var(save_file_contents.duplicate())
    file.close()
    return

# Decides what number the file will be assigned
func new_location() -> String:
    var updated_location: String
    for num in range(1, known_files.size() + 1):
        var stringified_num = JSON.stringify(num)
        if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
            print_debug('Checking if save file #' + stringified_num + ' is present.')
        if known_files.has(num) == false:
            if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
                print_debug('Could not find save file #' + JSON.stringify(stringified_num) + ', but other save files are present. Creating save file #' + stringified_num + '.')
            updated_location = 'user://save_file_' + stringified_num + '.json'
            return updated_location
    updated_location = 'user://save_file_' + JSON.stringify(known_files.size() + 1) + '.json'		
    return updated_location

func delete_file(path) -> void:
    if !FileAccess.file_exists(path):
        push_error("Failed to delete file, could not find file at save location " + path + '.')
        return
    DirAccess.remove_absolute(path)
    if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
        print_debug('Successfully deleted file at ' + path + '.')
    dir_contents()
    return

func dir_contents() -> void: 
    var dir = DirAccess.open("user://")
    known_files.clear()
    if dir:
        dir.list_dir_begin()
        
        var files := []
        var file_name = dir.get_next()
        while file_name != "":
            if file_name.ends_with(".json") and file_name.begins_with("save_file_"):
                files.append(file_name)
            file_name = dir.get_next()
        
        dir.list_dir_end()
    
        files.sort_custom(func(a, b):
            var a_num = int(a.get_file().get_basename().trim_prefix("save_file_"))
            var b_num = int(b.get_file().get_basename().trim_prefix("save_file_"))
            return a_num < b_num
        )

        for item in files:
            var num = int(item.get_file().get_basename().trim_prefix("save_file_"))
            known_files[num] = "user://" + item

        if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
            print_debug("Found a sum total of %s files." % files.size())
            print_debug(known_files)
    else:
        push_warning("Could not enumerate directory contents for the path user://.")
