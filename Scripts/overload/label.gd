extends RichTextLabel
class_name text_label

@export var scale_label : bool = true
@export var max_lines : int = 3
@export var scale_ratio : float = 0.1
@export var min_max : Vector2 = Vector2(16,512)
@export var font_size : int

var parent : Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update_text_size()

func update_text_size():
	parent = get_parent()
	var min_dim = min(parent.get_rect().size.x,parent.get_rect().size.y)
	font_size = min_dim * scale_ratio
	font_size = clamp(font_size,min_max.x,min_max.y)
	add_theme_font_size_override("normal_font_size",font_size)
	while get_line_count() > max_lines and font_size > min_max.x:
		font_size -= 16
		add_theme_font_size_override("normal_font_size",font_size)
	pass
