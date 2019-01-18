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
    var telefonoActual: pTelefono
    var credencialActual: pCredencial

    
    override init() {
        self.usuarioActual = jsUsuarioApp()
        self.telefonoActual = pTelefono()
        self.credencialActual = pCredencial()
    }
}

class jsUsuarioApp: NSObject, Codable {
    var nombre: String
    var numero_maguen: String
    var primer_apellido: String
    var segundo_apellido: String?
    var sexo: String
    var fecha_nacimiento: String?
    var fecha_activacion: String?
    var usuario: String
    var contrasena: String
    var correo: String
    var comunidad_id: Int64?
    var categoria_id: Int64
    var usuario_app_id: Int64
    var activo: Int64
    var eliminado: Int64
    //var telefonoActual: String?
    //var credencialActual: String?
    
    override init() {
        self.nombre = ""
        self.numero_maguen = ""
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
        self.usuario_app_id = -1
        self.activo = -1
        self.eliminado = -1
        //self.telefonoActual = nil
        //self.credencialActual = nil
    }
    
}

class pTelefono: NSObject, Codable {
    var activo: Int64
    var imei: String?
    var numero: String?
    var sistema_operativo: String?
    var telefono_id: Int64
    var tipo_id: Int64
    var usuario_app_id: Int64
    
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

class pCredencial: NSObject, Codable {
    var credencial_id : Int64
    var fecha_expedicion: String?
    var fecha_vencimiento: String?
    var vigencia: Int64
    var activa: Int64
    var usuario_app_id: Int64
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
