class_name PlanetLayers extends Node2D

var layers:Array[PlanetLayer] = []

@export var is_spinning := false
@export var spin := Vector2()

@export var texture_offset := Vector2():
	set(to):
		texture_offset = to
		set_parameter("texture_offset", texture_offset)

@export_group("Light", "light_")
@export var light_color := Color(1.0, 1.0, 1.0):
	set(lc):
		light_color = lc
		set_parameter("light_color", light_color)
@export var light_direction := Vector3(0.0, 0.0, 1.0):
	set(ld):
		light_direction = ld
		set_parameter("light_direction", light_direction)
@export var light_minimum := 0.0:
	set(lm):
		light_minimum = lm
		set_parameter("light_minimum", light_minimum)
@export var light_maximum := 1.0:
	set(lm):
		light_maximum = lm
		set_parameter("light_maximum", light_maximum)

func _ready()->void:
	for c in get_children():
		if not c is PlanetLayer:
			continue
		layers.push_back(c as PlanetLayer)
	update()

func _process(delta):
	if is_spinning:
		texture_offset += spin * delta

func update()->void:
	set_parameter("texture_offset", texture_offset)
	
	set_parameter("light_color", light_color)
	set_parameter("light_direction", light_direction)
	set_parameter("light_minimum", light_minimum)
	set_parameter("light_maximum", light_maximum)

func set_parameter(name:String, value:Variant)->void:
	for l in layers:
		l.set(name, value)

func set_shader_parameter(name:String, value:Variant)->void:
	for l in layers:
		l.material.set_shader_parameter(name, value)

func add_layer(layer:PlanetLayer)->void:
	if layers.has(layer) || layer.get_parent():
		return
	
	add_child(layer)
	layers.push_back(layer)
	
	update()

func remove_layer(layer:PlanetLayer)->void:
	if !layers.has(layer):
		return
	layers.erase(layer)
	if layer.get_parent() == self: remove_child(layer)
