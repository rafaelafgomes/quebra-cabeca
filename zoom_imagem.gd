extends TextureRect

# Guarda a escala original da imagem
@onready var escala_original: Vector2 = scale

func _ready() -> void:
	# Garante programaticamente que o pivô está exatamente no centro da imagem,
	# mesmo que o container tente resetar.
	pivot_offset = size / 2.0
	
	# Conecta os sinais do mouse direto por código (ou pela aba Nó -> Sinais do Godot)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	# Joga a imagem para a frente de tudo (z_index alto) 
	# para ela não ficar por baixo de outros elementos ao crescer
	z_index = 10
	
	# Anima o zoom para ficar maior (ex: 1.15 = 15% maior) de forma suave
	var tween = create_tween()
	tween.tween_property(self, "scale", escala_original * 2.0, 0.2).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited():
	# Reseta a camada visual
	z_index = 0
	
	# Retorna ao tamanho original quando o mouse sai
	var tween = create_tween()
	tween.tween_property(self, "scale", escala_original, 0.2).set_trans(Tween.TRANS_SINE)
