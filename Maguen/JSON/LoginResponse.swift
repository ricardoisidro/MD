//
//  LoginResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/14/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

struct LoginResponse : Decodable {
    var Value: Value
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
}

struct Value: Decodable {
    var usuario_app_id: Int
    var nombre: String
    var primer_apellido: String
    var segundo_apellido: String
    var sexo: String
    var fecha_nacimiento: String
    var fecha_activacion: String
    var usuario: String
    var contrasena: String
    var correo: String
    var comunidad_id: Int
    var categoria_id: Int // 1: socio titular, 2: esposa, 3: hijos, socios titulares; 4: socio invitado
    var credencial_id: Int
    var activo: Int
    var eliminado: Int
    var telefonoActual: telefonoActual
    var credencialActual: credencialActual
    
}

struct telefonoActual:Decodable {
    var telefono_id : Int
    var numero : String
    var imei: String
    var sistema_operativo: String
    var activo: Int
    var tipo_id: Int
    var usuario_app_id: Int
}

struct credencialActual: Decodable {
    var credencial_id : Int
    var fecha_expedicion: String
    var fecha_vencimiento: String
    var vigencia: Int
    var activa: Int
    var usuario_app_id: Int
    var fotografia: String
}
