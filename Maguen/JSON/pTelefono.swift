//
//  pTelefono.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/31/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

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
