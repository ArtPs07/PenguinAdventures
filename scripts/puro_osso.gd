extends CharacterBody2D

enum estados {
	andando,
	morrendo
}
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	vai_para_andar()

var status: estados

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		estados.andando:
			andandoEstado(delta)
		estados.morrendo:
			morrendoEstado(delta)
	
	move_and_slide()
	
func vai_para_andar():
	status = estados.andando
	anim.play("andando")
	
func vai_para_morrer():
	status = estados.morrendo
	anim.play("morrendo")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func andandoEstado(_delta):
	pass

func morrendoEstado(_delta):
	pass

func toumouDano():
	vai_para_morrer()
