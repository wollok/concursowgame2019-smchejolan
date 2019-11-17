import items.*
import ataquesEspeciales.*
import wollok.game.*
import cosillas.*


class Personaje {
	var property position
	var property vida 
	var ataque
	var property energia 
	var property estamina = 30
	
	var item = vacio 
	const ataqueEspecial
	
	var referenciaImagen
	var property orientacion 
	
	method image() = orientacion.imagen(referenciaImagen)
	
	method modificarPersonaje(_){}
	method iniciar(){}
	method esAtravezable() = true
	method esSoporte()=false	
	
	method mover(orientacionMov,cant){	
		if(orientacionMov.posicionEnEsaDireccion(self,cant).x()>=0 && orientacionMov.posicionEnEsaDireccion(self,cant).x()<=15){
			if(self.sePuedeMover(orientacionMov,cant)){
				position = orientacionMov.posicionEnEsaDireccion(self,cant)
				orientacion = orientacionMov
				item.mover(position,orientacion)
			}
		}
	}
	
	//metodo caer
	method subir(cant){
			position = position.up(cant)
			item.mover(position,orientacion)
	}
	method bajar(){
			position = position.down(1)		
			item.mover(position,orientacion)				
	}
	//Hacer que la gravedad sirva con el objeto de abajo
	method enSoporte() =	game.getObjectsIn(position.down(1)).any({elemento =>elemento.esSoporte()})
		
	method onStairs(escaleras)= escaleras.any({escalera => position == escalera.position() || position == escalera.position().up(1)})
	
	method muerto()= vida <= 0	
	
	method disminuirVida(cant){
		item.disminuirVida(self,cant)
	}
	method aumentarVida(cant){
		if(vida + cant <= 100){
			vida += cant 
		}
	}	
	method restarVida(cant){
		if(!self.muerto()){
			if(vida-cant>=0){
				vida-=cant
			}else{
				vida=0
			}
		}
	}
	method modificarEnergia(cant){
		if((energia+cant).between(0,100)){
			energia+=cant
		}else{
			if(energia+cant<0){energia=0}
			if(energia+cant>100){energia=100}
		}
	}	
	method item(itemNuevo){
		item=itemNuevo
	}
	method tomarItem(itemTomado){
		if(!itemTomado.tomado()){
			item.tomarItem(self,itemTomado)
			item.tomado(true)			
		}
	}
	
	method usarAtaqueEspecial(enemigo){
		if(energia>=ataqueEspecial.costo()){
			self.modificarEnergia(-(ataqueEspecial.costo()))
			ataqueEspecial.usar(self,enemigo)	
		}
	}
	
	method subirEstamina(cant){
		if(estamina + cant <= 30)
			estamina+=cant
	}
	method dropearItem(){
		item.borrar(self)
	}
	method atacar(enemigo){
		if(estamina>=10){
			if(orientacion.posicionEnEsaDireccion(self,1) == enemigo.position() && position.y() == enemigo.position().y())
				enemigo.disminuirVida(ataque + item.plusDeAtaque())
			    estamina-=10
			    item.usarItem()	
			}
		if(item.esInutil()){
			self.dropearItem()
		}	
	}
	method sePuedeMover(orientacionMv,cant) = game.getObjectsIn(orientacionMv.posicionEnEsaDireccion(self,cant)).all({objeto => objeto.esAtravezable()})	
}