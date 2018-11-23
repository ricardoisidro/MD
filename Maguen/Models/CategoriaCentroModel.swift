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
    
    
    let db_categoria_centro = Table("categoria_centro")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    var categoria_centro_id: Int
    var descripcion: String?
    var eliminado: Int?
    var fecha_modificacion: String?
    
    init(categoria_centro_id: Int, descripcion: String, eliminado: Int, fecha_modificacion: String) {
        self.categoria_centro_id = categoria_centro_id
        self.descripcion = descripcion
        self.eliminado = eliminado
        self.fecha_modificacion = fecha_modificacion
        
    }
    
    func get_categoria_centro_id() -> Int
    {
        return categoria_centro_id;
    }
    
    func set_categoria_centro_id(value: Int)
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
    
    func get_eliminado() -> Int
    {
        return eliminado!;
    }
    
    func set_eliminado(value: Int)
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
        
        var datos:[Any] = [0, "", 0, ""]
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            //categoria_centro_dictionary[val[0]] = val[1]
            
            if(val[0] == "categoria_centro_id"){
                //ccm.set_categoria_centro_id(value: Int(val[1])!)
                datos[0] = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                //ccm.set_descripcion(value: val[1])
                datos[1] = val[1]
            }
            else if(val[0] == "eliminado") {
                //ccm.set_eliminado(value: Int(val[1])!)
                datos[2] = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                //ccm.set_fecha_modificacion(value: val[1])
                datos[3] = val[1]
            }
        }
        
        return CategoriaCentroModel(categoria_centro_id: datos[0] as! Int, descripcion: datos[1] as! String, eliminado: datos[2] as! Int, fecha_modificacion: datos[3] as! String)
    }
    
    
    
}
