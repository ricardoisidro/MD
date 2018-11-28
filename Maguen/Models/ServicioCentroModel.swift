//
//  ServicioCentroModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class ServicioCentroModel : NSObject {
    
    var servicio_centro_id: Int
    var servicio_id: Int
    var centro_id: Int
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.servicio_centro_id = -1
        self.servicio_id = -1
        self.centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> ServicioCentroModel {
        let servicio = ServicioCentroModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "servicio_centro_id"){
                servicio.servicio_centro_id = Int(val[1])!
            }
            else if(val[0] == "servicio_id") {
                servicio.servicio_id = Int(val[1])!
            }
            if(val[0] == "centro_id"){
                servicio.centro_id = Int(val[1])!
            }
            else if(val[0] == "eliminado") {
                servicio.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                servicio.fecha_modificacion = val[1]
            }
        }
        return servicio
    }
    
}
