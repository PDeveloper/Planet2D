class_name PaletteGradient extends Gradient

@export var generator:PaletteGenerator:
	set = _set_generator
@export var resolution:int:
	set = _set_resolution

func _get_color(offset:float)->Color:
	return generator.generate_color(offset) if generator else Color()

func create_resolution(resolution:int)->void:
	while get_point_count() > 2: remove_point(0)
	set_offset(0, 0.0)
	set_color(0, _get_color(0.0))
	set_offset(1, 1.0)
	set_color(1, _get_color(1.0))
	var step := 1.0 / float(resolution)
	for i in (resolution - 2):
		var offset := (i + 1) * step
		add_point(offset, generator.generate_color(offset) if generator else Color())

func apply()->void:
	generator.generate(self)

func _set_generator(g:PaletteGenerator)->void:
	if generator:
		generator.changed.disconnect(_on_generator_changed)
	
	generator = g
	
	if generator:
		apply()
		generator.changed.connect(_on_generator_changed)

func _set_resolution(r:int)->void:
	create_resolution(r)

func _on_generator_changed()->void:
	apply()
