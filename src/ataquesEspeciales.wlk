import personajes.*
import items.*
import wollok.game.*
import cosillas.*



object lanzarBolaDeFuego{
	const property projectiles = []
	method costo()=10
	method usar(personaje,_){
		projectiles.add(new Projectil(ref="fireball",poder=self,danio = 15,lanzador = personaje,position= personaje.orientacion().posicionEnEsaDireccion(personaje,1),orientacion=personaje.orientacion(),alcance=6))
		game.addVisual(projectiles.last())
	}
	method toString()="fuego"
	method esAtravezable() = true
	
}

object golpeFuerte{
	method costo()=30
	method usar(personaje,enemigo){
			if((enemigo.position().x() - personaje.position().x()).abs() == 1){
				enemigo.disminuirVida(30)
		}
	}
}
object tentaculos{
	const property projectiles = []
	method costo() = 50
	method usar(personaje,_){
		projectiles.add(new Projectil(ref="tentacle",poder=self,alcance=2,danio=40,lanzador=personaje,position=personaje.orientacion().posicionEnEsaDireccion(personaje,1),orientacion=personaje.orientacion()))
		projectiles.add(new Projectil(ref="tentacle",poder=self,alcance=2,danio=40,lanzador=personaje,position=personaje.orientacion().contraria().posicionEnEsaDireccion(personaje,1),orientacion=personaje.orientacion().contraria()))
		game.addVisual(projectiles.last())
		game.addVisual(projectiles.get(projectiles.size()-2))
	}
	method toString()="tentaculo"	
	method esAtravezable() = true
}

object lanzarFlecha{
	const property projectiles  = []
	method costo() = 10
	method usar(personaje,_){
		projectiles.add(new Projectil(ref="flecha",alcance=6,poder = self,danio= 15,lanzador = personaje,position=personaje.orientacion().posicionEnEsaDireccion(personaje,1),orientacion=personaje.orientacion()))
		game.addVisual(projectiles.last())
	}	
	method toString()="flecha"	
	method esAtravezable() = true
}

class Projectil{
	var property orientacion 
	var property position
	const lanzador
	const poder
	var movimientos = 0
	var danio
	var ref
	var alcance
	
	method image() = orientacion.imagen(ref) 
	method modificarPersonaje(enemigo){
		if(enemigo!=lanzador){
			enemigo.disminuirVida(danio)
		}
		self.borrar()
	}
	method borrar(){
		game.removeVisual(self)
		poder.projectiles().remove(self)
	}
	method limpiar(){
		if(movimientos > alcance){
			self.borrar()
		}
	}
	method mover(){
		position = orientacion.posicionEnEsaDireccion(self,1)
		movimientos++
	}
	method esSoporte()=false
	method esAtravezable() = true	
}