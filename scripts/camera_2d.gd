extends Camera2D

var alvo: Node2D


func _ready() -> void:
	procura_alvo()


func _process(_delta: float) -> void:
	position = alvo.position

func procura_alvo():
	var nodes = get_tree().get_nodes_in_group("Jogador")
	if nodes.size()  == 0:
		push_error("N achou Jogador")
		return
	alvo = nodes[0]
