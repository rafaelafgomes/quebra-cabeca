extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Conecta o clique do botão 'Jogar' à função de troca de cena
	$CenterContainer/HBoxContainer/VBoxContainer/Facil.pressed.connect(_on_botao_jogar_facil_pressed)
	$CenterContainer/HBoxContainer/VBoxContainer2/Medio.pressed.connect(_on_botao_jogar_medio_pressed)
	$CenterContainer/HBoxContainer/VBoxContainer3/Dificil.pressed.connect(_on_botao_jogar_dificil_pressed)

func _on_botao_jogar_facil_pressed():
	# Troca a cena atual para a cena do jogo
	Global.tamanho_grade = 3
	Global.imagem_selecionada = preload("res://assets/imagem1.png")
	get_tree().change_scene_to_file("res://jogo.tscn")
	
func _on_botao_jogar_medio_pressed():
	# Troca a cena atual para a cena do jogo
	Global.tamanho_grade = 4
	Global.imagem_selecionada = preload("res://assets/imagem1.png")
	get_tree().change_scene_to_file("res://jogo.tscn")
	
func _on_botao_jogar_dificil_pressed():
	# Troca a cena atual para a cena do jogo
	Global.tamanho_grade = 5
	Global.imagem_selecionada = preload("res://assets/imagem1.png")
	get_tree().change_scene_to_file("res://jogo.tscn")
	
