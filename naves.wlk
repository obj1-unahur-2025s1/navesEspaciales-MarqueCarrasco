class Nave{
  var velocidad
  var direccionSol
  var combustible

  method velocidad()= velocidad
  method direccionSol()= direccionSol
  method combustible()= combustible

  method acelerar(cuanto){velocidad= (velocidad + cuanto).min(100000)}
  method desacelerar(cuanto){velocidad= (velocidad -cuanto).max(0)} 

  method irHaciaElSol(){direccionSol= 10}
  method escaparDelSol(){direccionSol= -10}
  method ponerseParaleloSol(){direccionSol= 0}
  method acercarseUnPocoAlSol(){direccionSol= (direccionSol + 1).min(10)}
  method alejarseUnPocoDelSol(){direccionSol= (direccionSol - 1).max(-10)}

  method cargarCombustible(cuanto){combustible= combustible + cuanto}
  method descargarCombustible(cuanto){combustible= (combustible - cuanto).max(0)}
  method pepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila()= self.combustible() >= 4000 
                          and self.velocidad()  <= 12000
  method recibirAmenaza()

  method estaDeRelajo()= self.estaTranquila()

}

class Navebaliza inherits Nave{
    var colorBaliza
    const coloresPermitidos= #{"verde" , "rojo" , "azul"}
    method cambiarColorDeBaliza(colorNuevo){
        if (coloresPermitidos.constain(colorNuevo)){
            colorBaliza=  colorNuevo
        }
        else{  
            self.error("solo se acepta el color : rojo, verde, azul")
        }
        
    }

    method colorBaliza() = colorBaliza

    override method pepararViaje(){
        self.cambiarColorDeBaliza("verde")
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.ponerseParaleloSol()
        
    }

    override method estaTranquila()= super()
                                     and self.colorBaliza() != "rojo"

    override method recibirAmenaza(){
        self.irHaciaElSol()
        self.cambiarColorDeBaliza("rojo")
    }

}

class NavePasajero inherits Nave{
    var property  cantPasajeros
    var racionesComida 
    var racionesBebida 

    method racionesComida()= racionesComida
    method racionesBebida()= racionesBebida
    
    method cargarComida(cuanta){racionesComida= racionesComida + (cuanta * cantPasajeros)}
    method descargarComida(cuanta){racionesComida = (racionesComida - cuanta).max(0)}
    method cargarBebida(cuanta){racionesBebida= racionesBebida + cuanta}
    method descargarBebdida(cuanta){racionesBebida= (racionesBebida + cuanta).max(0)}


    override method pepararViaje(){
        self.cargarComida(4)
        self.cargarBebida(6)
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.acercarseUnPocoAlSol()
    }

    override method recibirAmenaza(){
        self.acelerar(velocidad * 2)
        racionesComida= self.racionesComida() - self.cantPasajeros()
        racionesBebida= self.racionesBebida() - (self.cantPasajeros() * 2)

    }

}

class NaveCombate inherits Nave{
    var visibilidad
    var misilesDesplegados
    const mensajesEmitidos= #{}

    method estaInvisible()= !visibilidad 
    method ponerseVisible(){visibilidad = true}
    method ponerseInvisible(){visibilidad = false}

    method misilesDesplegados()= misilesDesplegados
    method desplegarMisiles(){ misilesDesplegados = true}
    method replegarMisiles(){misilesDesplegados = false}

    method emitirMensaje(mensaje){mensajesEmitidos.add(mensaje)}
    method mensajesEmitidos()= mensajesEmitidos.size()
    method primerMensajeEmitido()= mensajesEmitidos.first()
    method ultimoMensajeEmitido()= mensajesEmitidos.last()
    method esEscueta()= mensajesEmitidos.all{m => m.size() <= 30 }
    method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

    override method pepararViaje(){
        self.ponerseVisible()
        self.replegarMisiles()
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en mision")
    }

    override method estaTranquila()= super() and !self.misilesDesplegados()

    override method recibirAmenaza(){
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
        self.emitirMensaje("Amenaza recibida")
    }
}

class NaveHospital inherits NavePasajero{
    var quirofanos

    method equiparQuirofanos(){quirofanos = true}
    method estaEquipado()= quirofanos

    override method estaTranquila()= super() and !self.estaEquipado()

    override method recibirAmenaza(){
        super()
        self.equiparQuirofanos()
    }
}

class NaveCombateSigilosa inherits NaveCombate{
    override method estaTranquila()= super() and !self.estaInvisible()
    override method recibirAmenaza(){
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
        
    }
}
