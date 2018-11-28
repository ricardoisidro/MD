//
//  CentroModel.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/22/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class CentroModel: NSObject {
    
    var centro_id: Int
    var categoria_centro_id: Int
    var imagen_portada: String?
    var nombre: String
    var descripcion: String
    var domicilio_centro_id: Int
    var telefonos: String?
    var activo: Int
    var seccion_id: Int64?
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.centro_id = -1
        self.categoria_centro_id = -1
        self.imagen_portada = ""
        self.nombre = ""
        self.descripcion = ""
        self.domicilio_centro_id = -1
        self.telefonos = ""
        self.activo = -1
        self.seccion_id = -1
        self.eliminado = -1
        self.fecha_modificacion = ""
    }
    
    static func deserializaCentro(dato: String) -> CentroModel {
        //var categoria_centro_dictionary: [String:String]
        let centro = CentroModel()
        
        //var datos:[Any] = [0, 0, "", "", "", 0, "", 0, 0, 0, ""]
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "centro_id"){
                centro.centro_id = Int(val[1])!
            }
            else if(val[0] == "categoria_centro_id") {
                centro.categoria_centro_id = Int(val[1])!
            }
            else if(val[0] == "imagen_portada") {
                centro.imagen_portada = val[1]
            }
            else if(val[0] == "nombre") {
                centro.nombre = val[1]
            }
            else if(val[0] == "descripcion") {
                centro.descripcion = val[1]
            }
            else if(val[0] == "domicilio_centro_id") {
                centro.domicilio_centro_id = Int(val[1])!
            }
            else if(val[0] == "teléfonos") {
                centro.telefonos = val[1]
            }
            else if(val[0] == "activo") {
                centro.activo = Int(val[1])!
            }
            else if(val[0] == "seccion_id") {
                centro.seccion_id = Int64(val[1]) ?? 0
            }
            else if(val[0] == "eliminado") {
                centro.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                centro.fecha_modificacion = val[1]
            }
            
        }
        
        return centro
        
    }
    
}
