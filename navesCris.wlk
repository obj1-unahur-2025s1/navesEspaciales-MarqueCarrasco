class NaveEspacial {
  var velocidad
  var direccionRespectoAlSol
  var combustible

  method direccionRespectoAlSol(nueva) {  
    if (-10 <= nueva <= 10) {
      direccionRespectoAlSol = nueva
    }
  }

  method direccionRespectoAlSol() = direccionRespectoAlSol

  method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000) }

  method desacelerar(cuanto) { velocidad = (velocidad + cuanto).max(0) }

  method irHaciaElSol() { direccionRespectoAlSol = 10 }

  method escaparDelSol() { direccionRespectoAlSol = -10 }

  method ponerseParaleloAlSol() { direccionRespectoAlSol = 0 }

  method acercarseUnPocoAlSol() { direccionRespectoAlSol = (direccionRespectoAlSol + 1).min(10) }

  method alejarseUnPocoDelSol() { direccionRespectoAlSol = (direccionRespectoAlSol - 1).max(-10) }

  method prepararViaje() {
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  method cargarCombustible(cuanto) { combustible += cuanto }

  method descargarCombustible(cuanto) { combustible -= cuanto }

  method estaTranquila() {
    return combustible >= 400 and velocidad < 12000
  }

  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }

  method escapar()

  method avisar()

  method estaDeRelajo() = self.estaTranquila()

}

class NaveBaliza inherits NaveEspacial {
  var colorDeBaliza
  var cambioDeColor = false
  method colorDeBaliza() = colorDeBaliza
  method cambiarColorDeBaliza(colorNuevo) { 
    colorDeBaliza = colorNuevo
    cambioDeColor = true 
    }
  override method prepararViaje() { 
    super()
    colorDeBaliza = "verde" 
    self.ponerseParaleloAlSol()
    }

  override method estaTranquila() = super() and colorDeBaliza != "rojo"

  override method escapar() { self.irHaciaElSol() }

  override method avisar() { self.cambiarColorDeBaliza("rojo")}

  override method estaDeRelajo() = super() and !cambioDeColor

}

class NaveDePasajeros inherits NaveEspacial {
  var property cantidadDePasajeros
  var cantidadDeComida
  var cantidadDeBebida
  const pasajeros = #{}
  var totalRacionesServidas = 0

  method sumarPasajero(pasajero) { pasajeros.add(pasajero) }

  method cargarComida(cuanta) { cantidadDeComida += cuanta }
  method descargarComida(cuanta) { cantidadDeComida -= cuanta }

  method cargarBebida(cuanta) { cantidadDeBebida += cuanta }
  method descargarBebida(cuanta) { cantidadDeBebida -= cuanta }

  override method prepararViaje() {
    super()
    self.cargarComida(4 * cantidadDePasajeros)
    self.cargarBebida(6 * cantidadDePasajeros)
    self.acercarseUnPocoAlSol() 
  }

  override method escapar() { self.acelerar(velocidad) }

  override method avisar() {
    cantidadDeComida -= cantidadDePasajeros
    cantidadDeBebida -= cantidadDePasajeros * 2
    totalRacionesServidas += cantidadDePasajeros * 3
   }

  override method estaDeRelajo() = super() and totalRacionesServidas < 50
}

class NaveDeCombate inherits NaveEspacial {
  var esVisible = true
  const property misilesDesplegados = []
  const misilesReplegados = []
  const mensajes = []

  method ponerseVisible() { esVisible = true }

  method ponerseInvisible() { esVisible = false }

  method estaInvisible() = esVisible == false

  method desplegarMisiles() {
    misilesReplegados.forEach{m=>misilesDesplegados.add(m)}
    misilesReplegados.clear()
  }
  method replegarMisiles() {
    misilesDesplegados.forEach{m=>misilesReplegados.add(m)}
    misilesDesplegados.clear()
  }

  method emitirMensaje(mensaje) { mensajes.add(mensaje) }
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = mensajes.first()
  method ultimoMensajeEmitido() = mensajes.last()
  method esEscueta() = !mensajes.any{m=>m.size() > 30}
  method emitioMensaje(mensaje) = mensaje.any{m=>m == mensaje}

  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = super() and misilesDesplegados.size() == 0
  
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }

  override method avisar() { self.emitirMensaje("Amenaza recibida") }

}

class NaveHospital inherits NaveDePasajeros {
  var property tienePreparadoLosQuirofanos

  override method estaTranquila() = super() and tienePreparadoLosQuirofanos == false

  override method recibirAmenaza() {
    super()
    tienePreparadoLosQuirofanos = true
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = super() and !self.estaInvisible()

  override method escapar() {
    super()
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}
