class_name PlanetLayer extends Sprite2D

const PlanetLayerShader := preload("res://addons/planet2d/planet.gdshader")

@export_group("Texture", "texture_")
@export var texture_scale := Vector2(0.5, 0.5):
	set(ts):
		texture_scale = ts
		material.set_shader_parameter("texture_scale", texture_scale)

@export var texture_offset := Vector2():
	set(to):
		texture_offset = to
		material.set_shader_parameter("texture_offset", texture_offset * texture_offset_scale)

@export var texture_offset_scale := 1.0:
	set(tos):
		texture_offset_scale = tos
		material.set_shader_parameter("texture_offset", texture_offset * texture_offset_scale)

@export_group("Atmosphere", "atmosphere_")
@export var atmosphere_color := Color(1.0, 1.0, 1.0):
	set(ac):
		atmosphere_color = ac
		material.set_shader_parameter("atmosphere_color", atmosphere_color)

@export var atmosphere_intensity := 0.1:
	set(ai):
		atmosphere_intensity = ai
		material.set_shader_parameter("atmosphere_intensity", atmosphere_intensity)

@export_group("Light", "light_")
@export var light_color := Color(1.0, 1.0, 1.0):
	set(lc):
		light_color = lc
		material.set_shader_parameter("light_color", light_color)
@export var light_direction := Vector3(0.0, 0.0, 1.0):
	set(ld):
		light_direction = ld
		material.set_shader_parameter("light_direction", light_direction)
@export var light_minimum := 0.1:
	set(lm):
		light_minimum = lm
		material.set_shader_parameter("light_minimum", light_minimum)
@export var light_maximum := 1.0:
	set(lm):
		light_maximum = lm
		material.set_shader_parameter("light_maximum", light_maximum)

@export_group("Specular", "specular_")
@export var specular_color := Color(1.0, 1.0, 1.0):
	set(sc):
		specular_color = sc
		material.set_shader_parameter("specular_color", specular_color)
@export var specular_intensity := 0.2:
	set(si):
		specular_intensity = si
		material.set_shader_parameter("specular_intensity", specular_intensity)
@export var specular_shininess := 1.0:
	set(ss):
		specular_shininess = ss
		material.set_shader_parameter("specular_shininess", specular_shininess)

func _init()->void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	material = ShaderMaterial.new()
	material.shader = PlanetLayerShader

func _ready()->void:
	update()

func update()->void:
	material.set_shader_parameter("texture_scale", texture_scale)
	material.set_shader_parameter("texture_offset", texture_offset * texture_offset_scale)
	
	material.set_shader_parameter("atmosphere_color", atmosphere_color)
	material.set_shader_parameter("atmosphere_intensity", atmosphere_intensity)
	
	material.set_shader_parameter("light_color", light_color)
	material.set_shader_parameter("light_direction", light_direction)
	material.set_shader_parameter("light_minimum", light_minimum)
	material.set_shader_parameter("light_maximum", light_maximum)
	
	material.set_shader_parameter("specular_color", specular_color)
	material.set_shader_parameter("specular_intensity", specular_intensity)
	material.set_shader_parameter("specular_shininess", specular_shininess)
