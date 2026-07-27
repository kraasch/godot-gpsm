@tool
extends EditorPlugin

## The plugin name (or node name if it ever becomes a node).
#var plugin_type : String = "GlitchIntroNode" # NOTE: comment in, if needed.

## The location of the plugin's main script.
#var plugin_script : Resource = preload("res://addons/gpsm/code/main.gd") # NOTE: comment in, if needed.

## The location of the plugin's icon.
#var plugin_icon : Resource = preload("res://addons/gpsm/assets/gpsm.png") # NOTE: comment in, if needed.

## The base type of the plugin.
#var plugin_base : String = "Control" # NOTE: comment in, if needed.

#func _enable_plugin() -> void: # NOTE: comment in, if needed.
	# Add autoloads here.
	#pass

#func _disable_plugin() -> void: # NOTE: comment in, if needed.
	# Remove autoloads here.
	#pass

## Called after add_child(). 
#func _enter_tree() -> void: # NOTE: comment in, if needed.
	#add_custom_type(plugin_type, plugin_base, plugin_script, plugin_icon)

## Called when node is removed from tree.
#func _exit_tree() -> void: # NOTE: comment in, if needed.
	#remove_custom_type(plugin_type)
