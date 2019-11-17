import personajes.*
import items.*
import ataquesEspeciales.*
import wollok.game.*
import cosillas.*
import config.*

object menuInicial{
	method iniciar(){
		backGround.imagen("assets/menuInicial.jpg")
		game.addVisual(backGround)
		keyboard.any().onPressDo({
			game.clear()
			instructivo.iniciar()
		})
	}
}

object instructivo{
	method iniciar(){
		backGround.imagen("assets/instrucciones.jpg")
		game.addVisual(backGround)
		keyboard.space().onPressDo({
			game.clear()
			seleccionDeEscenario.iniciar()
		})
	}
}

object seleccionDeEscenario{
	const property escenario1 = new Pick (position = game.at(2,5),imagen="assets/escenario1Pick.png",contenido = nivel1) 
	const property escenario2 = new Pick (position = game.at(9,5),imagen="assets/escenario2Pick.png",contenido = nivel2) 
	const property escenario3 = new Pick (position = game.at(2,1),imagen="assets/escenario3Pick.png",contenido = nivel3) 
	const property escenario4 = new Pick (position = game.at(9,1),imagen="assets/escenario4Pick.png",contenido = nivel4) 
	var property cursor = new Cursor(position = game.at(2,5), seleccion=null, imagen = "assets/cursorEsc.png", movHorizontal=7, movVertical=4)
	
	
	method iniciar(){
		self.agregarElementos()
		config.configurarTeclasEscenario(self)
		config.configurarSeleccion(cursor)		
	}
	
	method agregarElementos(){
		game.addVisual(escenario1)		
		game.addVisual(escenario2)
		game.addVisual(escenario3)
		game.addVisual(escenario4)
		game.addVisual(cursor)
		game.hideAttributes(escenario1)		
		game.hideAttributes(escenario2)
		game.hideAttributes(escenario3)
		game.hideAttributes(escenario4)
		game.hideAttributes(cursor)
	}
	method eleccionDeEscenario() {
		cursor.bloquearSeleccion()
		game.clear()
		seleccionDePersonaje.iniciar(cursor.seleccion())
	}
}

object seleccionDePersonaje{
	var property nivel 
	
	var property mago = new Personaje (position = game.origin(), vida = 100,ataque = 10, energia = 100, item = vacio, ataqueEspecial = lanzarBolaDeFuego, orientacion = derecha,referenciaImagen="Mage")
	var property archer = new Personaje (position= game.origin(),vida = 100,ataque = 10, energia =100, item = vacio, ataqueEspecial = lanzarFlecha,orientacion = derecha,referenciaImagen= "Archer" )
	var property monster = new Personaje (position= game.origin(),vida = 100,ataque = 10, energia =100, item = vacio, ataqueEspecial = tentaculos,orientacion = derecha,referenciaImagen= "Monster" )
	var property knight = new Personaje (position= game.origin(),vida = 100,ataque = 10, energia =100, item = vacio, ataqueEspecial = golpeFuerte,orientacion = derecha,referenciaImagen= "Knight" )
	
	var property pickChar1 = new Pick(position = game.at(2,2),imagen = "assets/mage/iddle.png",contenido=mago)
	var property pickChar2 = new Pick(position = game.at(5,2),imagen = "assets/monster/iddle.png",contenido=monster)
	var property pickChar3 = new Pick(position = game.at(8,2),imagen = "assets/archer/iddle.png",contenido=archer)
	var property pickChar4 = new Pick(position = game.at(11,2),imagen = "assets/knight/iddle.png",contenido=knight)

	var property cursor1 = new Cursor(position = game.at(2,2),  seleccion=null, imagen = "assets/cursorPersonaje1.png", movHorizontal=3, movVertical=0)
	var property cursor2 = new Cursor(position = game.at(11,2),  seleccion=null, imagen = "assets/cursorPersonaje2.png", movHorizontal=3, movVertical=0)
	var property player1Ready = false
	var property player2Ready = false
	
	method iniciar(escenario){
		self.nivel(escenario)
		self.agregarElementos()		
		config.configurarTeclasSeleccionPersonaje(self)
		config.configurarSeleccion(cursor1)
		config.configurarSeleccion(cursor2)		
	}
	method agregarElementos(){
		game.addVisual(pickChar1)
		game.addVisual(pickChar2)
		game.addVisual(pickChar3)
		game.addVisual(pickChar4)
		game.addVisual(cursor1)
		game.addVisual(cursor2)
		game.hideAttributes(pickChar1)
		game.hideAttributes(pickChar2)
		game.hideAttributes(pickChar3)
		game.hideAttributes(pickChar4)
		game.hideAttributes(cursor1)
		game.hideAttributes(cursor2)
	}
	
	method personajeElegido1(){
		cursor1.seleccion().orientacion(derecha)
		cursor1.seleccion().position(game.at(1,1))
		nivel.player1(cursor1.seleccion())
	}
	method personajeElegido2(){
		cursor2.seleccion().orientacion(izquierda)
		cursor2.seleccion().position(game.at(14,1))
		nivel.player2(cursor2.seleccion())
	}
	method eleccionDePersonaje() {
		if(player1Ready && player2Ready){					
			game.clear()
			nivel.iniciar()
		}
	}
}

class Nivel {
	
	var property player1 = new Personaje (position = game.at(1,1), vida = 100,ataque = 10, energia = 100, item = vacio, ataqueEspecial = golpeFuerte, orientacion = derecha,referenciaImagen="Mage")
	var property player2  = new Personaje (position = game.at(14,1), vida = 100,ataque = 10, energia = 100, item = vacio, ataqueEspecial = golpeFuerte, orientacion = derecha,referenciaImagen="Mage")
	
	
	var property barraVP1= new BarraDeVida(position=game.at(0,8),personaje=player1)
	var property barraEP1= new BarraDeEnergia(position=game.at(0,8),personaje=player1)
	var property barraVP2= new BarraDeVida(position=game.at(12,8),personaje=player2)
	var property barraEP2= new BarraDeEnergia(position=game.at(12,8),personaje=player2)
	var property barraS1 = new BarraDeStamina(position=game.at(0,8),personaje=player1)
	var property barraS2 = new BarraDeStamina(position=game.at(12,8),personaje=player2)
	
	
	const property escaleras = #{}
	const property pisos = []
	const property poderesDeProjectiles = #{lanzarFlecha,lanzarBolaDeFuego,tentaculos}
	const property items = []
	
		
	method iniciar() {
		
		self.setBG()
		self.crearPisos()
		self.crearEscaleras()
		self.agregarPersonajes()
		self.agregarElementosVarios()
		config.configurarTeclasJuego(self)
		config.gravedad(self)
		config.configurarProjectiles(self)
		config.configurarAcciones(self)
		config.configurarItems(self)
		config.configurarEstamina(player1)
		config.configurarEstamina(player2)
		config.configurarColisiones(player1)
		config.configurarColisiones(player2)	
		config.configurarMusica(self.ref(),self.time())
		pisos.forEach({piso=>config.configurarColisiones(piso)})	
	}


	method setBG(){
		backGround.imagen("assets/BG/"+self.ref()+".jpg")
		game.addVisual(backGround)	
	}
	method agregarPersonajes() {
		game.addVisual(player1)
		game.hideAttributes(player1)
		game.addVisual(player2)
		game.hideAttributes(player2)
	}
	method ref()=""
	method time()
	method agregarElementosVarios(){
		game.addVisual(barraVP1)
		barraVP1.personaje(player1)
		game.addVisual(barraVP2)
		barraVP2.personaje(player2)
		game.addVisual(barraEP1)
		barraEP1.personaje(player1)
		game.addVisual(barraEP2)
		barraEP2.personaje(player2)
		game.addVisual(barraS1)				
		barraS1.personaje(player1)
		game.addVisual(barraS2)
		barraS2.personaje(player2)				
				
		escaleras.forEach({escalera => game.addVisual(escalera)
									   game.hideAttributes(escalera)
		})
		pisos.forEach({piso => game.addVisual(piso)
						       game.hideAttributes(piso)
		})
		
		game.hideAttributes(barraVP1)
		game.hideAttributes(barraVP2)
		game.hideAttributes(barraEP1)
		game.hideAttributes(barraEP2)	
		game.hideAttributes(barraS1)
		game.hideAttributes(barraS2)	
	}		

	

	method crearEscalera(inicio,fin,posicion){
		(inicio..fin).forEach({numero => escaleras.add(new ElementoDeEscenario(imagen="assets/Escalera.png",position=game.at(posicion,numero),esAtravezable=true))})
	}
	method crearEscaleras(){}
	method crearPiso(inicio,fin,altura,ref){	
		(inicio..fin).forEach({numero => pisos.add(new ElementoDeEscenario(imagen="assets/Piso"+ref+".png",position=game.at(numero,altura),esAtravezable=false))})
	}
/* method crearBase(ref){
		self.crearPiso(0,15,0,ref)
	}*/
	method crearPisos(){}
	method activarGravedad(){
		if(!player1.enSoporte())
			player1.bajar()		
		if(!player2.enSoporte())
			player2.bajar()		
	}
 	method ganar() {
		game.clear()
		gameOver.iniciar()
	}
	method generarPosicionItem(){
		var limite = pisos.size()-1
		var indice = 0.randomUpTo(limite).roundUp()
		return pisos.get(indice).position().up(1)
	}
	method limpiarItems(){
		if(!items.isEmpty()){
			items.forEach({item=>
				if(!item.tomado()){
					item.limpiar()
					items.remove(item)
				}	
			})
		}
	}
	method generarItem(){
		var prov=0.randomUpTo(100)
			if(prov.between(0,25))
				items.add( new ItemArma(ataque = 10, cantidadDeUsos = 3, ref="espada", position=self.generarPosicionItem()))
			if(prov.between(26,50))
				items.add(  new ItemDefensa(vidaDelEscudo = 20, ref="escudo", position=self.generarPosicionItem()))
			if(prov.between(51,75))
				items.add( new HealerVida(position=self.generarPosicionItem(),imagen="assets/vida.png",cant=30))
			if(prov.between(76,100))
				items.add(new HealerEnergia(position=self.generarPosicionItem(),imagen="assets/energia.png",cant= 70))
			return items.last()
	}
	method orientacion(_){}
	method position(_){}
} 

object gameOver{
	method iniciar(){
		game.addVisual(backGround)
		keyboard.any().onPressDo({game.stop()})
	}
}
object nivel1 inherits Nivel{
	override method ref()="Esc1"
	override method crearPisos(){
		self.crearPiso(0,15,0,self.ref())
		self.crearPiso(5,10,5,self.ref())
	}
	override method crearEscaleras(){
		self.crearEscalera(1,5,4)
		self.crearEscalera(1,5,11)
	}
	override method time()=512
	
}
object nivel2 inherits Nivel{
	override method ref()="Esc2"
	override method crearPisos(){
		self.crearPiso(0,15,0,self.ref())
		self.crearPiso(5,10,5,self.ref())
	}
	override method crearEscaleras(){
		self.crearEscalera(1,5,4)
		self.crearEscalera(1,5,11)
	}
	override method time()=574
}
object nivel3 inherits Nivel{
	override method ref()="Esc3"
	override method crearPisos(){
		self.crearPiso(0,15,0,self.ref())
		self.crearPiso(0,3,5,self.ref())
		self.crearPiso(12,15,5,self.ref())
	}
	override method crearEscaleras(){
		self.crearEscalera(1,5,4)
		self.crearEscalera(1,5,11)
	}
	override method time()=60
}
object nivel4 inherits Nivel{
	override method ref()="Esc4"
	override method crearPisos(){
		self.crearPiso(0,15,0,self.ref())
		self.crearPiso(3,11,6,self.ref())		
	}
	override method crearEscaleras(){
		self.crearEscalera(1,6,2)
		self.crearEscalera(1,6,12)
	}
	override method time()=499
}
