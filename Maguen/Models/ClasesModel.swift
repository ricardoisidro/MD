//
//  ClasesModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class ClasesModel : NSObject {
    
    var clase_id: Int
    var descripcion: String
    var centro_id: Int
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.clase_id = -1
        self.descripcion = ""
        self.centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> ClasesModel {
        let clase = ClasesModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "clase_id"){
                clase.clase_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                clase.descripcion = val[1]
            }
            else if(val[0] == "centro_id") {
                clase.centro_id = Int(val[1])!
            }
            else if(val[0] == "eliminado") {
                clase.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                clase.fecha_modificacion = val[1]
            }
            
        }
        return clase
    }
}
