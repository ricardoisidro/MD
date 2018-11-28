//
//  HorarioClaseModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class HorarioClaseModel : NSObject {
    
    var horario_clase_id: Int
    var clase_id: Int
    var profesor: String
    var dias: String
    var horario: String
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.horario_clase_id = -1
        self.clase_id = -1
        self.profesor = ""
        self.dias = ""
        self.horario = ""
        self.eliminado = -1
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> HorarioClaseModel {
        let horario = HorarioClaseModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "horario_clase_id"){
                horario.horario_clase_id = Int(val[1])!
            }
            else if(val[0] == "clase_id") {
                horario.clase_id = Int(val[1])!
            }
            if(val[0] == "profesor"){
                horario.profesor = val[1]
            }
            else if(val[0] == "dias") {
                horario.dias = val[1]
            }
            else if(val[0] == "horario") {
                horario.horario = val[1]
            }
            else if(val[0] == "eliminado") {
                horario.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                horario.fecha_modificacion = val[1]
            }
        }
        return horario
    }
    
}
