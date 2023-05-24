class_name CosineGenerator extends PaletteGenerator

@export var offset := Vector3():
	set = _set_offset
@export var amplitude := Vector3():
	set = _set_amplitude
@export var frequency := Vector3():
	set = _set_frequency
@export var phase := Vector3():
	set = _set_phase

@export var alpha_enabled := false:
	set = _set_alpha_enabled
@export var alpha := Vector4():
	set = _set_alpha

func _generate_1d(t:float, offset:float, amplitude:float, frequency:float, phase:float)->float:
	return offset + amplitude * cos(2 * PI * (frequency * t + phase))

func generate_color(t:float)->Color:
	return Color(
		_generate_1d(t, offset.x, amplitude.x, frequency.x, phase.x),
		_generate_1d(t, offset.y, amplitude.y, frequency.y, phase.y),
		_generate_1d(t, offset.z, amplitude.z, frequency.z, phase.z),
		_generate_1d(t, alpha.x, alpha.y, alpha.z, alpha.w) if alpha_enabled else 1.0,
	)

func generate(gradient:Gradient):
	for i in gradient.get_point_count():
		var t := gradient.get_offset(i)
		var color := generate_color(t)
		gradient.set_color(i, color)

func _set_offset(v:Vector3)->void:
	if offset == v: return
	offset = v
	emit_changed()

func _set_amplitude(v:Vector3)->void:
	if amplitude == v: return
	amplitude = v
	emit_changed()

func _set_frequency(v:Vector3)->void:
	if frequency == v: return
	frequency = v
	emit_changed()

func _set_phase(v:Vector3)->void:
	if phase == v: return
	phase = v
	emit_changed()

func _set_alpha_enabled(v:bool)->void:
	if alpha_enabled == v: return
	alpha_enabled = v
	emit_changed()

func _set_alpha(a:Vector4)->void:
	if alpha == a: return
	alpha = a
	emit_changed()
