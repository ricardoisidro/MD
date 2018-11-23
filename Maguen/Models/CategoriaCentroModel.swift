//
//  CategoriaCentroModel.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/22/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class CategoriaCentroModel: NSObject {
    
    var categoria_centro_id: String?
    var descripcion: String?
    var eliminado: String?
    var fecha_modificacion: String?
    
    override init() {}
    
    init(categoria_centro_id: String, descripcion: String, eliminado: String, fecha_modificacion: String) {
        self.categoria_centro_id = categoria_centro_id
        self.descripcion = descripcion
        self.eliminado = eliminado
        self.fecha_modificacion = fecha_modificacion
    }
    
    func get_categoria_centro_id() -> String
    {
        return categoria_centro_id!;
    }
    
    func set_categoria_centro_id(value: String)
    {
         self.categoria_centro_id = value;
    }
    
    func get_descripcion() -> String
    {
        return descripcion!;
    }
    
    func set_descripcion(value: String)
    {
         self.descripcion = value;
    }
    
    func get_eliminado() -> String
    {
        return eliminado!;
    }
    
    func set_eliminado(value: String)
    {
        self.eliminado = value;
    }
    
    func get_fecha_modificacion() -> String
    {
        return  fecha_modificacion!;
    }
    
    func set_fecha_modificacion(value: String)
    {
        self.fecha_modificacion = value;
    }
    
    
    static func deserializaCategoriaCentro(dato: String) -> CategoriaCentroModel {
        //var categoria_centro_dictionary: [String:String]
        let ccm = CategoriaCentroModel()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            //categoria_centro_dictionary[val[0]] = val[1]
            
            if(val[0] == "categoria_centro_id"){
                ccm.set_categoria_centro_id(value: val[1])
            }
            else if(val[0] == "descripcion") {
                ccm.set_descripcion(value: val[1])
            }
            else if(val[0] == "eliminado") {
                ccm.set_eliminado(value: val[1])
            }
            else if(val[0] == "fecha_modificacion") {
                ccm.set_fecha_modificacion(value: val[1])
            }
        }
        return ccm
    }
    
}
