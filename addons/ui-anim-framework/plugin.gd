@tool
extends EditorPlugin


# VARIABLES
const panel_path: String = "res://addons/ui-anim-framework/gui/panel.tscn"
var panel: UIAnimationPanel


# INTIALISATION
func _init():
	name = "UIAnimFrameworkPluginPlugin"
	#add_autoload_singleton("BeehaveGlobalMetrics", "res://addons/beehave/metrics/beehave_global_metrics.gd")
	print("UI Animation Framework initialized!")


# LOAD/UNLOAD
func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	panel = preload(panel_path).instantiate()
	panel.interface = get_editor_interface().get_selection()
	add_control_to_bottom_panel(panel, "UI Animation")

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Erase the control from the memory.
	remove_control_from_bottom_panel(panel)
	panel.free()