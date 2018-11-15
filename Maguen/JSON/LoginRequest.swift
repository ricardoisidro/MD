//
//  LoginRequest.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/14/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

struct LoginRequest : Codable {
    var contrasena: String
    var imei: String
    var sistema_operativo: String
    var usuario: String
}
