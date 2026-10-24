extends Node2D

@export var cena_peca: PackedScene = preload("res://peca.tscn")

# Pega a imagem e o tamanho da grade definidos no Global
var imagem_completa: Texture2D
var num_linhas_colunas: int = 3 
const TAMANHO_TABULEIRO = 600.0 # Tamanho fixo da área do ColorRect (600x600 px)
const TAMANHO_PECA = 200.0

# Posição na tela onde o tabuleiro montado vai ficar
var offset_tabuleiro: Vector2
var pecas_encaixadas_total: int = 0

func _ready():
	randomize() # sorteio aleatório a cada partida
	
	# Carrega as configurações globais escolhidas no menu
	num_linhas_colunas = Global.tamanho_grade
	imagem_completa = Global.imagem_selecionada
	
	# Pega a posição real onde você colocou o ColorRect no editor
	offset_tabuleiro = $ColorRect.position
	
	# Posiciona a imagem final exatamente no centro do ColorRect (600x600)
	$ImagemFinal.position = offset_tabuleiro + Vector2(TAMANHO_TABULEIRO/2.0, TAMANHO_TABULEIRO/2.0)
	$ImagemFinal.texture = imagem_completa
	$ImagemFinal.scale = Vector2(
		TAMANHO_TABULEIRO / imagem_completa.get_width(), 
		TAMANHO_TABULEIRO / imagem_completa.get_height()
	)
	$ImagemFinal.visible = false
	
	# Esconde a mensagem de vitória e conecta o botão de reiniciar
	$Label.visible = false
	$JogarNovamente.visible = false
	
	# Conecta os sinais de clique dos botões aos seus respectivos métodos
	if not $JogarNovamente.pressed.is_connected(_on_jogar_novamente_pressed):
		$JogarNovamente.pressed.connect(_on_jogar_novamente_pressed)
		
	if not $Voltar.pressed.is_connected(_on_voltar_pressed):
		$Voltar.pressed.connect(_on_voltar_pressed)
		
	gerar_tabuleiro()

#recorte da imagem
func gerar_tabuleiro():
	pecas_encaixadas_total = 0
	$ImagemFinal.visible = false
	
	# Calcula o tamanho de cada peça dinamicamente (ex: 600 / 4 = 150px para o médio)
	var tamanho_peca = TAMANHO_TABULEIRO / num_linhas_colunas
	
	# Descobre o tamanho real da textura para fazer o recorte proporcional
	var largura_img = imagem_completa.get_width()
	var altura_img = imagem_completa.get_height()
	var corte_x = largura_img / num_linhas_colunas
	var corte_y = altura_img / num_linhas_colunas
	
	for linha in range(num_linhas_colunas):
		for coluna in range(num_linhas_colunas):
			var peca = cena_peca.instantiate()
			add_child(peca)
			# Recorte visual do pedaço correspondente da imagem
			var sprite = peca.get_node("Sprite2D")
			sprite.texture = imagem_completa
			
			#recorte
			sprite.region_rect = Rect2(
				coluna * corte_x,
				linha * corte_y,
				corte_x,
				corte_y
			)
			
			# Ajusta a escala da peça para caber certinho no grid dinâmico
			sprite.scale = Vector2(
				tamanho_peca / corte_x, 
				tamanho_peca / corte_y
			)
			
			# Ajusta o tamanho da área de colisão (CollisionShape2D) da peça para acompanhar o novo tamanho
			var col_shape = peca.get_node("CollisionShape2D")
			if col_shape.shape is RectangleShape2D:
				col_shape.shape.size = Vector2(tamanho_peca, tamanho_peca)
			
			# Posição correta no tabuleiro
			var pos_final = offset_tabuleiro + Vector2(
				coluna * tamanho_peca + (tamanho_peca / 2.0), 
				linha * tamanho_peca + (tamanho_peca / 2.0)
			)
			peca.posicao_correta = pos_final
			
			# Posiciona a peça embaralhada no lado esquerdo/inferior da tela
			var pos_inicial_sorteada = Vector2(
				randf_range(50, 200),
				randf_range(100, 500)
			)
			# Define a posição inicial no tabuleiro
			peca.position = pos_inicial_sorteada
			# Conecta o sinal de cada peça gerada à função de contagem
			peca.peca_encaixada_sinal.connect(_ao_encaixar_peca)

func _ao_encaixar_peca():
	pecas_encaixadas_total += 1
	print("Peças encaixadas: ", pecas_encaixadas_total, " de ", num_linhas_colunas * num_linhas_colunas)
	if pecas_encaixadas_total >= (num_linhas_colunas * num_linhas_colunas):
		executar_efeito_vitoria()
		
func executar_efeito_vitoria():
	#Esconde as peças individuais para mostrar a imagem completa sem linhas de corte
	for child in get_children():
		if child is Area2D:
			child.visible = false
	$ImagemFinal.visible = true
	
	#Anima a propriedade 'progresso' do Shader de 0.0 a 1.0 durante 1 segundo
	var material_shader = $ImagemFinal.material as ShaderMaterial
	if material_shader:
		material_shader.set_shader_parameter("progresso", 0.0)
		var tween = create_tween()
		tween.tween_property(material_shader, "shader_parameter/progresso", 1.0, 1.0)
	
	#Exibe a interface de vitória
	$Label.visible = true
	$JogarNovamente.visible = true

func _on_jogar_novamente_pressed():
	# Limpa as peças antigas para reiniciar
	for child in get_children():
		if child is Area2D:
			child.queue_free()
	$Label.visible = false
	$JogarNovamente.visible = false
	gerar_tabuleiro()
	
func _on_voltar_pressed():
	# Retorna para a tela de Menu Principal
	get_tree().change_scene_to_file("res://menu.tscn")
