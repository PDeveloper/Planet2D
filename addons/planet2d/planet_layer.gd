@icon("res://addons/planet2d/icons/PlanetLayer.svg")
class_name PlanetLayer extends Sprite2D

## A Sprite2D with a [ShaderMaterial] (using [constant PlanetLayerShader]), a spherical distort shader with additional lighting effects.
##
## Any [Texture2D] can be attached to this Sprite2D and it will spherically distort it, with lighting effects.
## To have the effect of spinning, modify the [member texture_offset] to scroll the texture. If using [NoiseTexture2D], consider using [member NoiseTexture2D.color_ramp] to give more interesting results.

## Spherical distort and lighting shader
const PlanetLayerShader := preload("res://addons/planet2d/planet.gdshader")

@export_group("Texture", "texture_")

## Scales texture itself in the spherical rendering. At [1.0], texture repetition could be visible at texture boundaries. [0.5] ensures no repetition is visible.
## This will affect the range of [member texture_offset]. When set to [0.5], the range of [member texture_offset] becomes [0.0 - 2.0].
@export var texture_scale := Vector2(0.5, 0.5):
	set(ts):
		texture_scale = ts
		material.set_shader_parameter("texture_scale", texture_scale)

## The amount to scroll the texture by. The value is in UV coordinates, [0.0 - 1.0] is a full texture size scroll, if [member texture_scale] is 1.0.
@export var texture_offset := Vector2():
	set(to):
		texture_offset = to
		material.set_shader_parameter("texture_offset", texture_offset * texture_offset_scale)

## Scales the effect of [member texture_offset]. A higher scale will result in faster scrolling for the same offset.
@export var texture_offset_scale := 1.0:
	set(tos):
		texture_offset_scale = tos
		material.set_shader_parameter("texture_offset", texture_offset * texture_offset_scale)

@export_group("Atmosphere", "atmosphere_")

## Color of the atmosphere, primarily at the edges of the sphere at low values. Gives a fog effect.
@export var atmosphere_color := Color(1.0, 1.0, 1.0):
	set(ac):
		atmosphere_color = ac
		material.set_shader_parameter("atmosphere_color", atmosphere_color)

## Controls the density of the atmosphere. At higher values, the texture itself will become invisible as it is enveloped by the atmosphere.
@export var atmosphere_intensity := 0.0:
	set(ai):
		atmosphere_intensity = ai
		material.set_shader_parameter("atmosphere_intensity", atmosphere_intensity)

@export_group("Light", "light_")

## Color of the light affecting this layer.
@export var light_color := Color(1.0, 1.0, 1.0):
	set(lc):
		light_color = lc
		material.set_shader_parameter("light_color", light_color)

## The direction to the light source. This vector is normalized in the shader.
@export var light_direction := Vector3(0.0, 0.0, 1.0):
	set(ld):
		light_direction = ld
		material.set_shader_parameter("light_direction", light_direction)

## Minimum light level.
@export var light_minimum := 0.1:
	set(lm):
		light_minimum = lm
		material.set_shader_parameter("light_minimum", light_minimum)

## Maximum light level.
@export var light_maximum := 1.0:
	set(lm):
		light_maximum = lm
		material.set_shader_parameter("light_maximum", light_maximum)

@export_group("Specular", "specular_")

## Color of the specular effect.
@export var specular_color := Color(1.0, 1.0, 1.0):
	set(sc):
		specular_color = sc
		material.set_shader_parameter("specular_color", specular_color)

## Specular intensity, or brightness. Reasonable values are from [0.0 - 1.0].
@export var specular_intensity := 0.2:
	set(si):
		specular_intensity = si
		material.set_shader_parameter("specular_intensity", specular_intensity)

## The shininess of the material. Lower values will result in very diffused specular highlights (ex: ground). Higher values will have a smaller highlight (ex: water).
@export var specular_shininess := 1.0:
	set(ss):
		specular_shininess = ss
		material.set_shader_parameter("specular_shininess", specular_shininess)

@export_group("Pixelize", "pixelize_")
## Enable planet rendering pixelization
@export var pixelize_enabled := false:
	set(pe):
		pixelize_enabled = pe
		material.set_shader_parameter("pixelize_enabled", pixelize_enabled)

## Resolution scale of the render output. 0.5 means each pixel is 2x larger.
@export var pixelize_scale := 1.0:
	set(ps):
		pixelize_scale = ps
		material.set_shader_parameter("pixelize_scale", pixelize_scale)

func _init()->void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	
	material = ShaderMaterial.new()
	material.shader = PlanetLayerShader

func _ready()->void:
	update()

## Apply all parameters to the shader. Parameters should be applied as you set them, but in vector properties, you might need to update manually if setting member variables.
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
	
	material.set_shader_parameter("pixelize_enabled", pixelize_enabled)
	material.set_shader_parameter("pixelize_scale", pixelize_scale)
