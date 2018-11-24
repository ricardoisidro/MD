//
//  EventosModel.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/23/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class EventosModel: NSObject {
    
    var evento_id: Int
    var centro_id: Int
    var titulo: String
    var fecha_inicial_publicacion: String
    var fecha_final_publicacion: String
    var horario: String
    var imagen: String?
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.evento_id = 0
        self.centro_id = 0
        self.titulo = ""
        self.fecha_inicial_publicacion = ""
        self.fecha_final_publicacion = ""
        self.horario = ""
        self.imagen = ""
        self.eliminado = 0
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> EventosModel {
        let evento = EventosModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "evento_id"){
                evento.evento_id = Int(val[1])!
            }
            else if(val[0] == "centro_id") {
                evento.centro_id = Int(val[1])!
            }
            else if(val[0] == "titulo") {
                evento.titulo = val[1]
            }
            else if(val[0] == "fecha_inicial_publicacion") {
                evento.fecha_inicial_publicacion = val[1]
            }
            else if(val[0] == "fecha_final_publicacion") {
                evento.fecha_final_publicacion = val[1]
            }
            else if(val[0] == "horario") {
                evento.horario = val[1]
            }
            else if(val[0] == "imagen") {
                evento.imagen = val[1]
            }
            else if(val[0] == "eliminado") {
                evento.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                evento.fecha_modificacion = val[1]
            }
        
        }
        return evento
    }
    
}
