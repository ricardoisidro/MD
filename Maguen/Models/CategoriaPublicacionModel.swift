//
//  CategoriaPublicacionModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class CategoriaPublicacionModel: NSObject {
    
    var categoria_publicacion_id: Int
    var descripcion: String
    var eliminado: Int
    var fecha_modificacion: String
    
    override init() {
        self.categoria_publicacion_id = 0
        self.descripcion = ""
        self.eliminado = 0
        self.fecha_modificacion = ""
    }
    
    static func deserializaEvento(dato: String) -> CategoriaPublicacionModel {
        let categoriaPublicacion = CategoriaPublicacionModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "categoria_publicacion_id"){
                categoriaPublicacion.categoria_publicacion_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                categoriaPublicacion.descripcion = val[1]
            }
            else if(val[0] == "eliminado") {
                categoriaPublicacion.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                categoriaPublicacion.fecha_modificacion = val[1]
            }
            
        }
        return categoriaPublicacion
    }
    
}
