extends CharacterBody2D

# estados que o player pode assumir
enum estadosJogador {
	idle,
	andando,
	pulando,
	agachando,
	caindo,
	deslizando
}

@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var max_vel = 180.0
const JUMP_VELOCITY = -300.0
var contadorPulos = 0
@export var maxPulos = 2
@export var accel = 400
@export var decel = 600
@export var deslizar_decel = 100
var direction = 0
var estado: estadosJogador



func _ready() -> void:
	vai_para_Idle()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match estado:#verifica estado atual do jogador
		estadosJogador.idle:
			idle_estado(delta)
		estadosJogador.andando:
			andando_estado(delta)
		estadosJogador.pulando:
			pulando_estado(delta)
		estadosJogador.agachando:
			agachando_estado(delta)
		estadosJogador.caindo:
			caindo_estado(delta)
		estadosJogador.deslizando:
			deslizando_estado(delta)
			
	move_and_slide()
	
	
func vai_para_Idle():
	estado = estadosJogador.idle
	anim.play("Idle")
	
func vai_para_Andar():
	estado = estadosJogador.andando
	anim.play("andar")
	
func vai_para_Pular():
	estado = estadosJogador.pulando
	anim.play("pular")
	velocity.y = JUMP_VELOCITY
	contadorPulos += 1
	
func vai_para_Agachar():
	estado = estadosJogador.agachando
	anim.play("agachar")
	diminuiColisor()
	
func parar_agachar():#ajusta o colisor pro tamanho normal
	aumentaColisor()

func vai_para_cair():
	estado = estadosJogador.caindo
	anim.play("cair")
	
func vai_para_deslizar():
	estado = estadosJogador.deslizando
	anim.play("deslizar")
	diminuiColisor()
	
func parar_deslizar():
	aumentaColisor()

func idle_estado(delta):
	move(delta)
	if velocity.x != 0:
		vai_para_Andar()
		return
		
	if Input.is_action_just_pressed("pulo"):
		vai_para_Pular()
		return
		
	if Input.is_action_pressed("agachar"):
		vai_para_Agachar()
		return
		
func andando_estado(delta):
	move(delta)
	
	if velocity.x == 0:
		vai_para_Idle()
		return
	
	if Input.is_action_just_pressed("pulo"):
		vai_para_Pular()
		return
		
	if !is_on_floor():
		vai_para_cair()
		return
		
	if Input.is_action_just_pressed("agachar"):
		vai_para_deslizar()
		return
		
		
func pulando_estado(delta):
	move(delta)
	
	if Input.is_action_just_pressed("pulo") && podePular():
		vai_para_Pular()
		return
		
	if velocity.y > 0:
		vai_para_cair()
		return
		
func agachando_estado(_delta):
	atualiza_dir()
	if Input.is_action_just_released("agachar"):
		parar_agachar()
		vai_para_Andar()
		return

func caindo_estado(delta):
	move(delta)
	
	if Input.is_action_just_pressed("pulo") && podePular():
		vai_para_Pular()
		return
	
	if is_on_floor():
		contadorPulos = 0
		
		if velocity.x == 0:
			vai_para_Idle()
		else:
			vai_para_Andar()
		return

func deslizando_estado(delta):
	velocity.x = move_toward(velocity.x, 0, deslizar_decel * delta)
	
	if Input.is_action_just_released("agachar"):
		parar_deslizar()
		vai_para_Andar()
		return
		
	if velocity.x == 0:
		parar_deslizar()
		vai_para_Agachar()
		return
		
		
func atualiza_dir():
	direction  = Input.get_axis("esq", "dir")
	
	if direction < 0:
		anim.flip_h = true #inverte a sprite do plyr na horizontal
	elif direction > 0:
		anim.flip_h = false

func podePular() -> bool:
	return contadorPulos < maxPulos
	
	
func move(delta):
	atualiza_dir()
	
	if direction: # direction é -1 com player andando para esquerda e 1 andando pra direita
		velocity.x = move_toward(velocity.x, direction * max_vel, accel * delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)


	
func diminuiColisor():
	colisao.shape.radius = 5
	colisao.shape.height = 10
	colisao.position.y = 3

func aumentaColisor():
	colisao.shape.radius = 6
	colisao.shape.height = 16
	colisao.position.y = 0
	
	
