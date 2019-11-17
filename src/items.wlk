import personajes.*
import ataquesEspeciales.*
import wollok.game.*
import cosillas.*


class ItemDefensa {
	var vidaDelEscudo
	const ref
    var	orientacion	= iddle
    var property position 	
	var property tomado =false	
	method image()=orientacion.imagen(ref)	
	method usarItem(){}
	method tomarItem(personaje,item){
	}
	method esAtravezable() = true	
	method esSoporte()=false
	method plusDeAtaque()=0
	method esInutil() = vidaDelEscudo <= 0
	method modificarPersonaje(personaje){
			if(!self.tomado())
			personaje.tomarItem(self)
		}
	method disminuirVida(personaje,cant){
		vidaDelEscudo -= cant
		if(self.esInutil()){
			personaje.dropearItem()
		}
	}	
	method borrar(personaje){
		game.removeVisual(self)
		personaje.item(vacio)
	}
	method mover(posicion,orientacionPer){
		position = posicion
		orientacion = orientacionPer		
	}	
	method limpiar(){
		game.removeVisual(self)
	}
}

class ItemArma {
	const ataque
	var cantidadDeUsos
	const ref
    var	orientacion = iddle
	var property position 
	var property tomado =false
	method image()=orientacion.imagen(ref)	
	method tomarItem(personaje,item){
	}
	method esAtravezable() = true
	method usarItem(){
		cantidadDeUsos--		
	}
	method esInutil() = cantidadDeUsos == 0
	method esSoporte()=false	
	method modificarPersonaje(personaje){
			if(!self.tomado())
			personaje.tomarItem(self)
		}
	method mover(posicion,orientacionPer){
		position = posicion
		orientacion = orientacionPer
	}	
	method borrar(personaje){
		game.removeVisual(self)
		personaje.item(vacio)
	}
	method plusDeAtaque()=ataque
	method disminuirVida(personaje,cant){
		personaje.restarVida(cant)
	}
	method limpiar(){
		game.removeVisual(self)
	}
	
}
/* 
class itemTeletransportacion {
	method costo() = 10
	method usarItem(){
		if(personaje.vida()<=50){
			if(personaje.orientacion() === derecha){
				personaje.mover(izquierda,5)
			}else{
				personaje.mover(derecha,5)
			}			
		}	
}*/


class HealerEnergia{
	const property position
	var imagen
	var property cant
	var consumido = false
	method esSoporte()=false	
	method image()=imagen
	method esAtravezable() = true
	method modificarPersonaje(personaje){
		personaje.modificarEnergia(cant)
		consumido=true
		game.removeVisual(self)
	}
	method disminuirVida(_1,_2){}
	method tomado()=false
	method limpiar(){
		if(!consumido)
		game.removeVisual(self)
	}
	
}
class HealerVida inherits HealerEnergia{
	override method modificarPersonaje(personaje){
		personaje.aumentarVida(cant)
		super(personaje)
	}	
}

object vacio{
	method esAtravezable() = true
	method usarItem(){}
	method disminuirVida(personaje,cant){
	    personaje.restarVida(cant)
	}
	method tomarItem(personaje,item){
		personaje.item(item)
	}
	method tomado()=false
	method esSoporte()=false
	method mover(_1,_2){}	
	method modificarPersonaje(_){}
	method plusDeAtaque()=0
	method borrar(){}
	method esInutil() = false
}