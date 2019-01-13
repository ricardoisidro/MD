//
//  pSetUsuarioApp.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class pSetUsuarioApp: NSObject, Codable {
    var usuarioActual: jsUsuarioApp
    var telefonoActual: telefonos
    var credencialActual: credencial

    
    override init() {
        self.usuarioActual = jsUsuarioApp()
        self.telefonoActual = telefonos()
        self.credencialActual = credencial()
    }
}

class jsUsuarioApp: NSObject, Codable {
    var nombre: String
    var primer_apellido: String
    var segundo_apellido: String
    var sexo: String
    var fecha_nacimiento: Date?
    var fecha_activacion: Date?
    var usuario: String
    var contrasena: String
    var correo: String
    var comunidad_id: Int64?
    var categoria_id: Int64
    var credencial_id: Int64
    var activo: Int64
    var eliminado: Int64
    var telefonoActual: String?
    var credencialActual: String?
    
    override init() {
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
        self.categoria_id = -1
        self.credencial_id = -1
        self.activo = -1
        self.eliminado = -1
        self.telefonoActual = nil
        self.credencialActual = nil
    }
    
}

class telefonos: NSObject, Codable {
    var activo: Int
    var imei: String?
    var numero: String?
    var sistema_operativo: String?
    var telefono_id: Int
    var tipo_id: Int
    var usuario_app_id: Int
    
    override init() {
        self.activo = -1
        self.imei = ""
        self.numero = ""
        self.sistema_operativo = ""
        self.telefono_id = -1
        self.tipo_id = -1
        self.usuario_app_id = -1
    }
}

class credencial: NSObject, Codable {
    var credencial_id : Int
    var fecha_expedicion: Date?
    var fecha_vencimiento: Date?
    var vigencia: Int
    var activa: Int
    var usuario_app_id: Int
    var fotografia: String?
    
    override init() {
        self.credencial_id = -1
        self.fecha_expedicion = nil
        self.fecha_vencimiento = nil
        self.vigencia = -1
        self.activa = -1
        self.usuario_app_id = -1
        self.fotografia = ""
    }
}
