//
//  pCredencial.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/31/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation

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
