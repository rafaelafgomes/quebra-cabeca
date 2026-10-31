extends Node2D

@export var cena_peca: PackedScene = preload("res://peca.tscn")

var imagem_completa: Texture2D
var num_linhas_colunas: int = 3 
const TAMANHO_TABULEIRO = 600.0
const TAMANHO_PECA = 200.0
var offset_tabuleiro: Vector2
var pecas_encaixadas_total: int = 0

func _ready():
	randomize()
	num_linhas_colunas = Global.tamanho_grade
	imagem_completa = Global.imagem_selecionada
	offset_tabuleiro = $ColorRect.position
	$ImagemFinal.position = offset_tabuleiro + Vector2(TAMANHO_TABULEIRO/2.0, TAMANHO_TABULEIRO/2.0)
	$ImagemFinal.texture = imagem_completa
	$ImagemFinal.scale = Vector2(
		TAMANHO_TABULEIRO / imagem_completa.get_width(), 
		TAMANHO_TABULEIRO / imagem_completa.get_height())
	$ImagemFinal.visible = false
	$Label.visible = false
	$JogarNovamente.visible = false
	if not $JogarNovamente.pressed.is_connected(_on_jogar_novamente_pressed):
		$JogarNovamente.pressed.connect(_on_jogar_novamente_pressed)
	if not $Voltar.pressed.is_connected(_on_voltar_pressed):
		$Voltar.pressed.connect(_on_voltar_pressed)
	gerar_tabuleiro()

func gerar_tabuleiro():
	pecas_encaixadas_total = 0
	$ImagemFinal.visible = false
	var tamanho_peca = TAMANHO_TABULEIRO / num_linhas_colunas
	var largura_img = imagem_completa.get_width()
	var altura_img = imagem_completa.get_height()
	var corte_x = largura_img / num_linhas_colunas
	var corte_y = altura_img / num_linhas_colunas
	
	for linha in range(num_linhas_colunas):
		for coluna in range(num_linhas_colunas):
			var peca = cena_peca.instantiate()
			add_child(peca)
			var sprite = peca.get_node("Sprite2D")
			sprite.texture = imagem_completa
			sprite.region_rect = Rect2(
				coluna * corte_x,
				linha * corte_y,
				corte_x,
				corte_y)
			sprite.scale = Vector2(
				tamanho_peca / corte_x, 
				tamanho_peca / corte_y)
			var col_shape = peca.get_node("CollisionShape2D")
			if col_shape.shape is RectangleShape2D:
				col_shape.shape = col_shape.shape.duplicate()
				col_shape.shape.size = Vector2(tamanho_peca, tamanho_peca)
			var pos_final = offset_tabuleiro + Vector2(
				coluna * tamanho_peca + (tamanho_peca / 2.0), 
				linha * tamanho_peca + (tamanho_peca / 2.0))
			peca.posicao_correta = pos_final
			var largura_limite_embaralhado = 180.0
			var pos_inicial_sorteada = Vector2(
				randf_range(tamanho_peca / 2.0, largura_limite_embaralhado),
				randf_range(offset_tabuleiro.y + (tamanho_peca / 2.0), offset_tabuleiro.y + TAMANHO_TABULEIRO - (tamanho_peca / 2.0)))
			peca.position = pos_inicial_sorteada
			peca.peca_encaixada_sinal.connect(_ao_encaixar_peca)

func _ao_encaixar_peca():
	pecas_encaixadas_total += 1
	print("Peças encaixadas: ", pecas_encaixadas_total, " de ", num_linhas_colunas * num_linhas_colunas)
	if pecas_encaixadas_total >= (num_linhas_colunas * num_linhas_colunas):
		executar_efeito_vitoria()
		
func executar_efeito_vitoria():
	for child in get_children():
		if child is Area2D:
			child.visible = false
	$ImagemFinal.visible = true
	var material_shader = $ImagemFinal.material as ShaderMaterial
	if material_shader:
		material_shader.set_shader_parameter("progresso", 0.0)
		var tween = create_tween()
		tween.tween_property(material_shader, "shader_parameter/progresso", 1.0, 1.0)
	$Label.visible = true
	$Fogos.emitting = true
	$JogarNovamente.visible = true

func _on_jogar_novamente_pressed():
	for child in get_children():
		if child is Area2D:
			child.queue_free()
	$Label.visible = false
	$JogarNovamente.visible = false
	$Fogos.emitting = false
	gerar_tabuleiro()
	
func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
