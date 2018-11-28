//
//  ComiteModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class ComiteModel: NSObject {
    
    var comite_id: Int
    var nombre_comite: String
    var telefono: String
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.comite_id = 0
        self.nombre_comite = ""
        self.telefono = ""
        self.eliminado = 0
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> ComiteModel {
        let comite = ComiteModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "comite_id"){
                comite.comite_id = Int(val[1])!
            }
            else if(val[0] == "nombre_comite") {
                comite.nombre_comite = val[1]
            }
            else if(val[0] == "telefono") {
                let numero = val[1].replacingOccurrences(of: "-", with: "")
                comite.telefono = numero
            }
            else if(val[0] == "eliminado") {
                comite.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                comite.fecha_modificacion = val[1]
            }
            
        }
        return comite
    }
    
}
