extends Area2D
signal peca_encaixada_sinal
var arrastando: bool = false
var offset: Vector2 = Vector2.ZERO
var posicao_correta: Vector2
var encaixada: bool = false
const DISTANCIA_ENCAIXE: float = 40.0

func _input_event(_viewport, event, _shape_idx):
	if encaixada:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastando = true
			z_index = 10 
			offset = global_position - get_global_mouse_position()
			get_viewport().set_input_as_handled()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and arrastando:
			arrastando = false
			z_index = 0
			verificar_encaixe()
			
func _process(_delta):
	if arrastando:
		var nova_posicao = get_global_mouse_position() + offset
		var limite_tela = get_viewport_rect().size
		var tamanho_real_peca = $Sprite2D.region_rect.size.x * $Sprite2D.scale.x
		var margem = tamanho_real_peca / 2.0
		nova_posicao.x = clamp(nova_posicao.x, margem, limite_tela.x - margem)
		nova_posicao.y = clamp(nova_posicao.y, margem, limite_tela.y - margem)
		global_position = nova_posicao
		
func verificar_encaixe():
	var distancia = global_position.distance_to(posicao_correta)
	if distancia < DISTANCIA_ENCAIXE:
		global_position = posicao_correta
		encaixada = true
		z_index = 1
		print("Peça encaixada com sucesso!")
		peca_encaixada_sinal.emit()
		
