//
//  pUsuarioApp.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/31/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class pUsuarioApp: NSObject, Codable {
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
