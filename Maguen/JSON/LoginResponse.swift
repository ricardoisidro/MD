//
//  LoginResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/14/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class LoginResponse: NSObject, Decodable {
    
    var Value: Value4
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
    
    override init() {
        
        self.Correcto = false
        self.MensajeError = ""
        self.ex = ""
        self.Incorrecto = false
        self.Value = Value4()
        
    }
}

/*struct LoginResponse : Decodable {
    var Value: Value?
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
}*/

class Value4: NSObject, Decodable {
    var usuario_app_id: Int
    var nombre: String?
    var primer_apellido: String?
    var segundo_apellido: String?
    var sexo: String?
    var fecha_nacimiento: String?
    var fecha_activacion: String?
    var usuario: String?
    var contrasena: String?
    var correo: String?
    var comunidad_id: Int?
    var categoria_id: Int // 1: socio titular, 2: esposa, 3: hijos, socios titulares; 4: socio invitado
    var credencial_id: Int
    var activo: Int?
    var eliminado: Int?
    var telefonoActual: TelefonoActual
    var credencialActual: CredencialActual
    
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
        self.categoria_id = -1
        self.credencial_id = -1
        self.activo = -1
        self.eliminado = -1
        self.credencialActual = CredencialActual()
        self.telefonoActual = TelefonoActual()
    }
}

/*struct Value: Decodable {
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
    var comunidad_id: Int?
    var categoria_id: Int? // 1: socio titular, 2: esposa, 3: hijos, socios titulares; 4: socio invitado
    var credencial_id: Int64
    var activo: Int?
    var eliminado: Int?
    var telefonoActual: telefonoActual
    var credencialActual: credencialActual
    
}*/

/*struct telefonoActual:Decodable {
    var telefono_id : Int64
    var numero : String?
    var imei: String?
    var sistema_operativo: String?
    var activo: Int?
    var tipo_id: Int?
    var usuario_app_id: Int64
}

struct credencialActual: Decodable {
    var credencial_id : Int64
    var fecha_expedicion: String?
    var fecha_vencimiento: String?
    var vigencia: Int?
    var activa: Int?
    var usuario_app_id: Int
    var fotografia: String?
}*/
class TelefonoActual: NSObject, Decodable {
    
    var telefono_id: Int
    var activo: Int
    var imei: String?
    var numero: String?
    var sistema_operativo: String?
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

class CredencialActual: NSObject, Decodable {
    var credencial_id : Int
    var fecha_expedicion: String?
    var fecha_vencimiento: String?
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
