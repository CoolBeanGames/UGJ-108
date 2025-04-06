extends RichTextLabel
class_name text_label

@export var scale_label : bool = true
@export var max_lines : int = 3
@export var scale_ratio : float = 0.1
@export var min_max : Vector2 = Vector2(16, 512)
@export var font_size : int

var parent : Control
var _needs_update := true

func _ready() -> void:
	parent = get_parent()
	adjust_text_size()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_needs_update = true

func _process(_delta: float) -> void:
	if _needs_update:
		_needs_update = false
		call_deferred("adjust_text_size")

func adjust_text_size():
	if parent == null:
		parent = get_parent()

	var min_dim = min(parent.size.x, parent.size.y)
	font_size = clamp(min_dim * scale_ratio, min_max.x, min_max.y)
	
	var step := 2  # smaller step for better fitting

	while font_size > min_max.x:
		add_theme_font_size_override("normal_font_size", font_size)
		await get_tree().process_frame  # let it update layout
		if get_line_count() <= max_lines:
			break
		font_size -= step

	add_theme_font_size_override("normal_font_size", font_size)
