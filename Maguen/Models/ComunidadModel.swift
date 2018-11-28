//
//  ComunidadModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class ComunidadModel: NSObject {
    
    var comunidad_id: Int
    var descripcion: String
    var fecha_modificacion: String
    
    override init() {
        self.comunidad_id = 0
        self.descripcion = ""
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> ComunidadModel {
        let comunidad = ComunidadModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "comunidad_id"){
                comunidad.comunidad_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                comunidad.descripcion = val[1]
            }
            else if(val[0] == "fecha_modificacion") {
                comunidad.fecha_modificacion = val[1]
            }
        }
        return comunidad
    }
}
