@tool
class_name UIAnimationController extends Node


# VARIABLES
## Identifier
const is_ui_anim: Object = null

# References
var panel: UIAnimationPanel

## Values
### Groups
@export var groups: PackedStringArray
@export var unique_nodes: Dictionary # All the unique node paths and their names
@export var grouped_nodes: Dictionary # All the groups and their nodes

## Events

## Triggers


# INITIALISATION
func _ready():
	if not self.renamed.is_connected(_get_configuration_warnings):
		self.renamed.connect(_get_configuration_warnings)
	_get_configuration_warnings()


# ERROR HANDLING
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	var root: Node = get_tree().edited_scene_root
	if get_parent() != root:
		warnings.append("UIAnimationController needs to be directly under root node")
	return warnings

## Happens when the node is reparented
func _notification(what):
	if what == NOTIFICATION_PARENTED:
		_get_configuration_warnings()


# UPDATE VALUES
## Groups
### Modification
func rename_group(old_name: String, new_name: String) -> void:
	var index: int = groups.find(old_name)
	groups[index] = new_name
	var old_node_paths: Array[NodePath] = grouped_nodes[old_name]
	grouped_nodes.erase(old_name)
	grouped_nodes[new_name] = old_node_paths

func rename_node(path: NodePath, new_name: String) -> void:
	unique_nodes[path] = new_name

### Deletion
func _remove_unique_nodes() -> void:
	# Create a list of all nodes in every group
	var all_grouped_nodes: Array[NodePath]
	for node_array in grouped_nodes.values():
		all_grouped_nodes.append_array(node_array)
	# Create a list of unique nodes from that list
	var all_unique_nodes: Array[NodePath]
	for node in all_grouped_nodes:
		if not node in all_unique_nodes:
			all_unique_nodes.append(node)
	# Remove any unique ssnodes not found
	for node in unique_nodes.keys():
		if not node in all_unique_nodes:
			unique_nodes.erase(node)

func remove_group(group_name: String) -> void:
	grouped_nodes.erase(group_name)
	var control_index: int = groups.find(group_name)
	groups.remove_at(control_index)
	_remove_unique_nodes()
