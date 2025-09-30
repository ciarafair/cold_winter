extends Button

func _on_pressed() -> void:
    var container: Node = get_node('../../')
    if SettingsManager.settings_file_contents.reportSaveFileUpdates.value  == true:
        print_debug('Deleting save file.')
    if container == null:
        push_error('Could not use save button as the container is null.')
        return
    SignalManager.deleteFileSignal.emit(container.get_meta('save_file_location'))
    return