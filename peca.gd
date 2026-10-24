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
			z_index = 10 # Traz a peça para a frente de TODAS enquanto arrasta
			offset = global_position - get_global_mouse_position()
			get_viewport().set_input_as_handled()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and arrastando:
			arrastando = false
			z_index = 0 # Volta para a camada padrão se não encaixar
			verificar_encaixe()
			
func _process(_delta):
	if arrastando:
		var nova_posicao = get_global_mouse_position() + offset
		# Pega o tamanho da janela do jogo em pixels
		var limite_tela = get_viewport_rect().size
		
		# Define uma margem de segurança (metade do tamanho da peça, 100px)
		# para a peça não sumir nem pela metade nas bordas
		var margem = 100.0
		
		# Limpa as coordenadas para ficarem presas dentro da janela
		nova_posicao.x = clamp(nova_posicao.x, margem, limite_tela.x - margem)
		nova_posicao.y = clamp(nova_posicao.y, margem, limite_tela.y - margem)
		
		global_position = nova_posicao
		
		
func verificar_encaixe():
	# Compara a posição atual com a posição correta do tabuleiro
	var distancia = global_position.distance_to(posicao_correta)
	# Calcula a distância entre a posição atual e a correta
	if distancia < DISTANCIA_ENCAIXE:
		global_position = posicao_correta
		encaixada = true
		z_index = 1 # Peças montadas ficam acima do chão, mas abaixo de quem está sendo arrastado
		print("Peça encaixada com sucesso!")
		# Emite o sinal para avisar a cena principal
		peca_encaixada_sinal.emit()
		
