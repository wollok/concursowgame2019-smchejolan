import personajes.*
import items.*
import ataquesEspeciales.*
import wollok.game.*

//polimorfismo para las orientaciones imagen

object derecha{
	method imagen(ref) = "assets/"+ref+"/der.png"
	method posicionEnEsaDireccion(jugador,cant)= jugador.position().right(cant)
	method contraria()=izquierda
}
object izquierda{
	method imagen(ref) = "assets/"+ref+"/izq.png"
	method posicionEnEsaDireccion(jugador,cant)= jugador.position().left(cant)
	method contraria()=derecha	
}

object iddle{
	method imagen(ref) = "assets/"+ref+"/iddle.png"	
	method posicionEnEsaDireccion(_1,_2)=game.origin()
}

object backGround{
	var property position = game.origin() 
	var property imagen = "cuadraditoDelWollok.png"
	method image() = imagen
	method modificarPersonaje(_){}
	method esAtravezable() = true
	method esSoporte()=false}

class Cursor{
	var property position
	var property seleccion
	var property imagen
	var movHorizontal
	var movVertical
	
	method bloquearSeleccion(){
		movHorizontal = 0
		movVertical = 0
	}
	
	method image()=imagen
	method subir(){
		position = position.up(movVertical)
	}	
	method bajar(){
		position = position.down(movVertical)
	}
	method movDerecha(){
		position = position.right(movHorizontal)
	}
	method movIzquierda(){
		position = position.left(movHorizontal)
	}	
}
	
class Pick{
	var property position
	var imagen
	var property contenido

	method seleccion(_){}	
	method image() = imagen 
}

	
class ElementoDeEscenario{ 
	const imagen
	const property position 
	const property esAtravezable
	method image() = imagen	
	method esSoporte()= true
	method modificarPersonaje(_){}
	method disminuirVida(_){}
}


class BarraDeVida{
	const property position
	var property personaje
	method disminuirVida(_){}
	method esAtravezable() = true
	method esSoporte()=false	
	method modificarPersonaje(_){}

	method image()	= "assets/barras/vida"+(personaje.vida()-(personaje.vida()%10)).toString() + ".png"
}
class BarraDeEnergia inherits BarraDeVida{
		
	override method image()="assets/barras/energia"+(personaje.energia()-(personaje.energia()%10)).toString() + ".png"
}

class BarraDeStamina inherits BarraDeVida{
	override method image() = "assets/barras/stam"+(personaje.estamina()-(personaje.estamina()%10)) + ".png"
}

