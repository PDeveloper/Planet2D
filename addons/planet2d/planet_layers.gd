@icon("res://addons/planet2d/icons/PlanetLayers.svg")
class_name PlanetLayers extends Node2D

## A simple container to control child [PlanetLayer] node properties should reasonably be the same for a single planet.
##
## Also provides an easy way to have a spinning effect for all child [PlanetLayer] nodes.
## Use [method add_layer] and [method remove_layer] to register the [PlanetLayer] with this node.

## All child [PlanetLayer] nodes.
var layers:Array[PlanetLayer] = []

## Sets the spin mode, applied at this node's [method _process] event. Must have a non-zero [member spin] vector set to have any effect.
@export var is_spinning := false
## Speed of the spinning. The values are effectively delta [member PlanetLayer.texture_offset] per second.
@export var spin := Vector2()

## Controls the [member PlanetLayer.texture_offset] of all child [PlanetLayer] nodes.
@export var texture_offset := Vector2():
	set(to):
		texture_offset = to
		set_parameter("texture_offset", texture_offset)

@export_group("Light", "light_")
## Controls the [member PlanetLayer.light_color] of all child [PlanetLayer] nodes.
@export var light_color := Color(1.0, 1.0, 1.0):
	set(lc):
		light_color = lc
		set_parameter("light_color", light_color)

## Controls the [member PlanetLayer.light_direction] of all child [PlanetLayer] nodes.
@export var light_direction := Vector3(0.0, 0.0, 1.0):
	set(ld):
		light_direction = ld
		set_parameter("light_direction", light_direction)
		
## Controls the [member PlanetLayer.light_minimum] of all child [PlanetLayer] nodes.
@export var light_minimum := 0.0:
	set(lm):
		light_minimum = lm
		set_parameter("light_minimum", light_minimum)

## Controls the [member PlanetLayer.light_maximum] of all child [PlanetLayer] nodes.
@export var light_maximum := 1.0:
	set(lm):
		light_maximum = lm
		set_parameter("light_maximum", light_maximum)

@export_group("Pixelize", "pixelize_")
## Enable planet rendering pixelization
@export var pixelize_enabled := false:
	set(pe):
		pixelize_enabled = pe
		set_parameter("pixelize_enabled", pixelize_enabled)

## Resolution scale of the render output. 0.5 means each pixel is 2x larger.
@export var pixelize_scale := 1.0:
	set(ps):
		pixelize_scale = ps
		set_parameter("pixelize_scale", pixelize_scale)

func _ready()->void:
	for c in get_children():
		if not c is PlanetLayer:
			continue
		layers.push_back(c as PlanetLayer)
	update()

func _process(delta):
	if is_spinning:
		texture_offset += spin * delta

## Applies all properties to all child [PlanetLayer] nodes.
func update()->void:
	set_parameter("texture_offset", texture_offset)
	
	set_parameter("light_color", light_color)
	set_parameter("light_direction", light_direction)
	set_parameter("light_minimum", light_minimum)
	set_parameter("light_maximum", light_maximum)
	
	set_parameter("pixelize_enabled", pixelize_enabled)
	set_parameter("pixelize_scale", pixelize_scale)

## Utility method to set a property on child [PlanetLayer] nodes.
func set_parameter(name:String, value:Variant)->void:
	for l in layers:
		l.set(name, value)

## Utility method to set a Shader uniform on child [PlanetLayer] nodes.
func set_shader_parameter(name:String, value:Variant)->void:
	for l in layers:
		l.material.set_shader_parameter(name, value)

## Add a new [PlanetLayer] to this node. It must not have a parent, as it is with [method Node.add_child].
func add_layer(layer:PlanetLayer)->void:
	if layers.has(layer) || layer.get_parent():
		return
	
	add_child(layer)
	layers.push_back(layer)
	
	update()

## Remove a [PlanetLayer].
func remove_layer(layer:PlanetLayer)->void:
	if !layers.has(layer):
		return
	layers.erase(layer)
	remove_child(layer)
