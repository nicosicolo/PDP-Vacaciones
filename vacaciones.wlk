class UserException inherits Exception { }

class Lugar {
    const property nombre
    method parametroDivertido()
    method esTranquilo()
    method esRaro() = nombre.length() > 10
    method tieneNombrePar() = nombre.length() % 2 == 0

    //Template method
    method esDivertido() = self.tieneNombrePar() && self.parametroDivertido()
}

class Ciudad inherits Lugar {
    var property cantidadHabitantes
    var property atraccionesTuristicas
    var property decibelesPromedio

    override method parametroDivertido () = cantidadHabitantes.length() > 3 && cantidadHabitantes > 100000

    override method esTranquilo() = decibelesPromedio < 20
}

class Pueblo inherits Lugar {
    var property extension
    var property fechaFundacion
    var property provincia

    override method parametroDivertido() = fechaFundacion.year() < 1800 && provincia.esDelLitoral()

    override method esTranquilo() = provincia.equalsIgnoreCase("la pampa")
}

class Balneario inherits Lugar {
    var property metrosPlaya
    var property tieneMarPeligroso //ahora lo dejo como booleano, podria ser un metodo.
    var property tienePeatonal

    override method parametroDivertido() = tieneMarPeligroso && metrosPlaya > 300

    override method esTranquilo() = !tienePeatonal
}

class Provincia {
    var property nombre
    const property provinciasLitoral = ["Entre Ríos", "Corrientes", "Misiones"] 
    method esDelLitoral() = provinciasLitoral.contains(nombre)
}

class Persona {
    var property presupuestoMaximo
    var property tourAsignado
    const property preferenciaVacaciones = []

    method agregarPreferencia(preferencia) {
        preferenciaVacaciones.add(preferencia)
    }

    method quitarPreferencia(preferencia) {
        preferenciaVacaciones.remove(preferencia)
    }

    method asignarTour(tour) {
      tourAsignado = tour
    }

    method darseDeBaja() {
        tourAsignado.darDeBajaPasajero(self)
        tourAsignado = null
    }

    method lugarEsAdecuado(lugar) = preferenciaVacaciones.any({preferencia => preferencia.lugarCumplePreferencia(lugar)})

    method montoEsAdecuado(monto) = presupuestoMaximo > monto

    method todosLosLugaresSonAdecuados(recorrido) = recorrido.all({ciudad => self.lugarEsAdecuado(ciudad)})
}

class Preferencia {
    method lugarCumplePreferencia(lugar) 
}

object tranquilidad inherits Preferencia {
    override method lugarCumplePreferencia(lugar) = lugar.esTranquilo()
}
object diversion inherits Preferencia {
    override method lugarCumplePreferencia(lugar) = lugar.esDivertido()
}
object raro inherits Preferencia {
    override method lugarCumplePreferencia(lugar) = lugar.esRaro()
}

class Tour {
    var property fechaDeSalida
    var property montoAPagar
    var property personasRequeridas
    var property confirmado
    const property recorrido = []
    const property pasajeros = []

    method pasajeroPuedeSumarse(pasajero) = personasRequeridas > 0 && pasajero.montoEsAdecuado(montoAPagar) && pasajero.todosLosLugaresSonAdecuados(recorrido)

    method asignarPasajero(pasajero) {
        pasajero.asignarTour(self)
        pasajeros.add(pasajero)
        self.modificarPersonasRequeridas()
    }

    method agregarPasajero(pasajero) {
        if (!confirmado && self.pasajeroPuedeSumarse(pasajero)){
            self.asignarPasajero(pasajero)
        } else {
            throw new UserException(message = "No puede agregarse el pasajero al tour.") 
        }
    }

    method modificarPersonasRequeridas() {
        personasRequeridas -= 1
        if (personasRequeridas == 0) {
            confirmado = true
        }
    }

    method darDeBajaPasajero(pasajero) {
        personasRequeridas += 1
        if (personasRequeridas == 1) {
            confirmado = false
        }
    }
}