//
//  HorarioResoModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class HorarioResoModel: NSObject {
    
    var horario_reso_id: Int
    var centro_id: Int
    var tipo_reso_id: Int
    var titulo: String
    var horario: String
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.horario_reso_id = -1
        self.centro_id = -1
        self.tipo_reso_id = -1
        self.titulo = ""
        self.horario = ""
        self.eliminado = -1
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> HorarioResoModel {
        let horario = HorarioResoModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "horario_reso_id"){
                horario.horario_reso_id = Int(val[1])!
            }
            else if(val[0] == "centro_id") {
                horario.centro_id = Int(val[1])!
            }
            if(val[0] == "tipo_reso_id"){
                horario.tipo_reso_id = Int(val[1])!
            }
            else if(val[0] == "titulo") {
                horario.titulo = val[1]
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
