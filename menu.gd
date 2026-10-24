extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Conecta o clique do botão 'Jogar' à função de troca de cena
	$Iniciar.pressed.connect(_on_botao_jogar_pressed)

func _on_botao_jogar_pressed():
	# Troca a cena atual para a cena do jogo
	get_tree().change_scene_to_file("res://subMenu.tscn")
