//
//  pSetUsuarioApp.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

class pSetUsuarioApp: NSObject, Codable {
    var usuarioActual: pUsuarioApp
    var telefonoActual: pTelefono
    var credencialActual: pCredencial

    
    override init() {
        self.usuarioActual = pUsuarioApp()
        self.telefonoActual = pTelefono()
        self.credencialActual = pCredencial()
    }
}






