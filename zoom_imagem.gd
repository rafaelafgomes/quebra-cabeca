extends TextureRect

@onready var escala_original: Vector2 = scale

func _ready() -> void:
	pivot_offset = size / 2.0
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	z_index = 10
	var tween = create_tween()
	tween.tween_property(self, "scale", escala_original * 2.0, 0.2).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited():
	z_index = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", escala_original, 0.2).set_trans(Tween.TRANS_SINE)
