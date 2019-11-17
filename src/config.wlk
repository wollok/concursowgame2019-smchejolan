import niveles.*
import wollok.game.*
import items.*
import personajes.*
import cosillas.*

object config {
	
	method configurarMusica(ref,time){
		game.sound("assets/music/"+ref+".ogg")
		game.onTick(time * 1000,"musiquita",{game.sound("music/"+ref+".ogg")})
	}
	
	method configurarTeclasEscenario(menu){
		keyboard.w().onPressDo({if(menu.cursor().position().y()==1)
								menu.cursor().subir()
		})
		keyboard.s().onPressDo({if(menu.cursor().position().y()==5)
								menu.cursor().bajar()
		})
		keyboard.d().onPressDo({if(menu.cursor().position().x()==2)
								menu.cursor().movDerecha()
		})
		keyboard.a().onPressDo({if(menu.cursor().position().x()==9)
								menu.cursor().movIzquierda()
		})
		keyboard.enter().onPressDo({menu.eleccionDeEscenario()})
	}
	method configurarSeleccion(cursor){
		game.onCollideDo(cursor,{pick=>cursor.seleccion(pick.contenido())})
	}
	method configurarTeclasSeleccionPersonaje(menu){
		keyboard.d().onPressDo({if(menu.cursor1().position().x()<11)
								menu.cursor1().movDerecha()
		})
		keyboard.a().onPressDo({if(menu.cursor1().position().x()>2)
								menu.cursor1().movIzquierda()
		})
		keyboard.e().onPressDo({if(menu.cursor1().position()!=menu.cursor2().position()){
								menu.cursor1().bloquearSeleccion()
								menu.player1Ready(true)		
								menu.personajeElegido1()	
								menu.eleccionDePersonaje()
		}})
		keyboard.right().onPressDo({if(menu.cursor2().position().x()<11)
								menu.cursor2().movDerecha()
		})
		keyboard.left().onPressDo({if(menu.cursor2().position().x()>2)
								menu.cursor2().movIzquierda()
		})
		keyboard.control().onPressDo({ if(menu.cursor1().position()!=menu.cursor2().position()){
									menu.cursor2().bloquearSeleccion()
									menu.player2Ready(true)
									menu.personajeElegido2()
									menu.eleccionDePersonaje()						
		}})
		
	}
	
	method configurarTeclasJuego(nivel){
		keyboard.a().onPressDo({ nivel.player1().mover(izquierda,1)})
		keyboard.d().onPressDo({ nivel.player1().mover(derecha,1)})
		keyboard.w().onPressDo({if(nivel.player1().onStairs(nivel.escaleras())){ 
								nivel.player1().subir(1)
								}else{
								if(nivel.player1().enSoporte()){
								nivel.player1().subir(2)
								}}
		})
		keyboard.s().onPressDo({if(nivel.player1().onStairs(nivel.escaleras())&& nivel.player1().position().y()>1) 
								nivel.player1().bajar()
		})
		keyboard.g().onPressDo({ nivel.player1().atacar(nivel.player2())})
		keyboard.h().onPressDo({ nivel.player1().usarAtaqueEspecial(nivel.player2())})
		
		keyboard.left().onPressDo({ nivel.player2().mover(izquierda,1)})
		keyboard.right().onPressDo({ nivel.player2().mover(derecha,1)})
		keyboard.up().onPressDo({if(nivel.player2().onStairs(nivel.escaleras())){
								nivel.player2().subir(1)
								}else{
								if(nivel.player2().enSoporte()){
								nivel.player2().subir(2)
								}}
		})
		keyboard.down().onPressDo({if(nivel.player2().onStairs(nivel.escaleras())&& nivel.player2().position().y()>1) 
								      nivel.player2().bajar()
		})
		keyboard.shift().onPressDo({ nivel.player2().atacar(nivel.player1())})
		keyboard.minusKey().onPressDo({ nivel.player2().usarAtaqueEspecial(nivel.player1())})
		
	}
	
	method configurarColisiones(elemento) {//sacar if usar polimorfismo//hecho
		game.onCollideDo(elemento,{item =>	item.modificarPersonaje(elemento)})
	}		
	

	method configurarAcciones(nivel) {
		game.onTick(1000, "GAMEOVER", { 
							if (nivel.player1().muerto()){
								backGround.imagen("assets/gameOVerP2.jpg")
								nivel.ganar()
							}
							if(nivel.player2().muerto()){
								backGround.imagen("assets/gameOVerP1.jpg")
								nivel.ganar()
							}
		})	
	} 	
	method configurarProjectiles(nivel){
		nivel.poderesDeProjectiles().forEach({poder=>
			game.onTick(200,"projectil"+poder.toString(),{
				if(!poder.projectiles().isEmpty()){
					poder.projectiles().forEach({projectil=>projectil.mover()})
					poder.projectiles().forEach({projectil=>projectil.limpiar()})
				}		
			})
		})		
	}
	method configurarItems(nivel){
		nivel.items().add( new HealerVida(position=nivel.generarPosicionItem(),imagen="assets/Vida.png",cant=30))	
		game.addVisual(nivel.items().last())	
		game.onTick(10000,"items",{
			if(!nivel.items().isEmpty()){
				nivel.limpiarItems()
			}	
			var item = nivel.generarItem()	
			game.addVisual(item)		
			game.hideAttributes(item)		
			
		})
	}
	method configurarEstamina(player) {
		game.onTick(2500, "Ganar estamina", {player.subirEstamina(10)})
	} 
	
	method gravedad(nivel){//arreglar gravedad para que la use el nivel
		game.onTick(0.3 * 1000,"Caida",{nivel.activarGravedad()})
	}
	
}
