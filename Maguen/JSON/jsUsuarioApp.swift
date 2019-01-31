//
//  jsUsuarioApp.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/31/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class jsUsuarioApp: NSObject, Decodable {
    var usuario_app_id: Int64
    var nombre: String?
    var primer_apellido: String?
    var segundo_apellido: String?
    var sexo: String?
    var fecha_nacimiento: String?
    var fecha_activacion: String?
    var usuario: String?
    var contrasena: String?
    var correo: String?
    var comunidad_id: Int64?
    var domicilio_id: Int64?
    var categoria_id: Int64? // 1: socio titular, 2: esposa, 3: hijos, socios titulares; 4: socio invitado
    var credencial_id: Int64?
    var activo: Int64?
    var eliminado: Int64?
    var telefonoActual: jsTelefonoActual
    var credencialActual: jsCredencialActual
    
    override init() {
        self.usuario_app_id = -1
        self.nombre = ""
        self.primer_apellido = ""
        self.segundo_apellido = ""
        self.sexo = ""
        self.fecha_nacimiento = nil
        self.fecha_activacion = nil
        self.usuario = ""
        self.contrasena = ""
        self.correo = ""
        self.comunidad_id = -1
        self.domicilio_id = -1
        self.categoria_id = -1
        self.credencial_id = -1
        self.activo = -1
        self.eliminado = -1
        self.credencialActual = jsCredencialActual()
        self.telefonoActual = jsTelefonoActual()
    }
}
