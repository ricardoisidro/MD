//
//  CategoriaCentroModel.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/22/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class CategoriaCentroModel: NSObject {
    
    var categoria_centro_id: Int
    var descripcion: String?
    var eliminado: Int?
    var fecha_modificacion: String?
    
    override init() {
        self.categoria_centro_id = 0
        self.descripcion = ""
        self.eliminado = 0
        self.fecha_modificacion = ""
    }
    
    static func deserializaCategoriaCentro(dato: String) -> CategoriaCentroModel {
        let categoriaCentro = CategoriaCentroModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "categoria_centro_id"){
                categoriaCentro.categoria_centro_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                categoriaCentro.descripcion = val[1]
            }
            else if(val[0] == "eliminado") {
                categoriaCentro.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                categoriaCentro.fecha_modificacion = val[1]
            }
        }
                
        return categoriaCentro
    }
    
    
    
}
