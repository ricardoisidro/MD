//
//  ServicioModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class ServicioModel : NSObject {
    
    var servicio_id: Int
    var descripcion: String
    var imagen: String!
    var activo: Int64?
    var categoria_centro_id: Int
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.servicio_id = -1
        self.descripcion = ""
        self.imagen = ""
        self.activo = -1
        self.categoria_centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = ""
        
    }
    
    static func deserializaCentro(dato: String) -> ServicioModel {
        let servicio = ServicioModel()
        
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "servicio_id"){
                servicio.servicio_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                servicio.descripcion = val[1]
            }
            else if(val[0] == "imagen") {
                servicio.imagen = val[1]
            }
            else if(val[0] == "activo") {
                servicio.activo = Int64(val[1]) ?? 0
            }
            else if(val[0] == "categoria_centro_id") {
                servicio.categoria_centro_id = Int(val[1])!
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
