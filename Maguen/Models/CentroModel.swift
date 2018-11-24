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
    let db_centro = Table("centro")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_imagen_portada = Expression<String?>("imagen_portada")
    let db_nombre = Expression<String>("nombre")
    let db_descripcion = Expression<String>("descripcion")
    let db_domicilio_centro_id = Expression<Int64>("domicilio_centro_id")
    let db_telefonos = Expression<String>("telefonos")
    let db_activo = Expression<Int64>("activo")
    let db_seccion_id = Expression<Int64?>("seccion_id")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
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
    
    init(centro_id: Int, categoria_centro_id: Int, imagen_portada: String, nombre: String, descripcion: String, domicilio_centro_id: Int, telefonos: String, activo: Int, seccion_id: Int64, eliminado: Int, fecha_modificacion: String) {
        self.centro_id = centro_id
        self.categoria_centro_id = categoria_centro_id
        self.imagen_portada = imagen_portada
        self.nombre = nombre
        self.descripcion = descripcion
        self.domicilio_centro_id = domicilio_centro_id
        self.telefonos = telefonos
        self.activo = activo
        self.seccion_id = seccion_id
        self.eliminado = eliminado
        self.fecha_modificacion = fecha_modificacion
    }
    
    override init() {
        self.centro_id = 0
        self.categoria_centro_id = 0
        self.imagen_portada = ""
        self.nombre = ""
        self.descripcion = ""
        self.domicilio_centro_id = 0
        self.telefonos = ""
        self.activo = 0
        self.seccion_id = 0
        self.eliminado = 0
        self.fecha_modificacion = ""
    }
    
    func get_centro_id() -> Int
    {
        return centro_id;
    }
    
    func set_centro_id(value: Int)
    {
        self.centro_id = value;
    }
    
    func get_categoria_centro_id() -> Int
    {
        return categoria_centro_id;
    }
    
    func set_categoria_centro_id(value: Int)
    {
        self.categoria_centro_id = value;
    }
    
    func get_imagen_portada() -> String
    {
        return imagen_portada!;
    }
    
    func set_imagen_portada(value: String)
    {
        self.imagen_portada = value;
    }
    
    func get_nombre() -> String
    {
        return nombre;
    }
    
    func set_nombre(value: String)
    {
        self.nombre = value;
    }
    
    func get_descripcion() -> String
    {
        return descripcion;
    }
    
    func set_descripcion(value: String)
    {
        self.descripcion = value;
    }
    
    func get_domicilio_centro_id() -> Int
    {
        return domicilio_centro_id;
    }
    
    func set_domicilio_centro_id(value: Int)
    {
        self.domicilio_centro_id = value;
    }
    
    func get_telefonos() -> String
    {
        return  telefonos!;
    }
    
    func set_telefonos(value: String)
    {
        self.telefonos = value;
    }
    
    func get_activo() -> Int
    {
        return activo;
    }
    
    func set_activo(value: Int)
    {
        self.activo = value;
    }
    
    func get_seccion_id() -> Int64
    {
        return seccion_id ?? 0;
    }
    
    func set_seccion_id(value: Int64)
    {
        self.seccion_id = value;
    }
    
    func get_eliminado() -> Int
    {
        return eliminado;
    }
    
    func set_eliminado(value: Int)
    {
        self.eliminado = value;
    }
    
    func get_fecha_modificacion() -> String
    {
        return  fecha_modificacion;
    }
    
    func set_fecha_modificacion(value: String)
    {
        self.fecha_modificacion = value;
    }
    
    static func deserializaCentro(dato: String) -> CentroModel {
        //var categoria_centro_dictionary: [String:String]
        let centro = CentroModel()
        
        //var datos:[Any] = [0, 0, "", "", "", 0, "", 0, 0, 0, ""]
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "centro_id"){
                //ccm.set_categoria_centro_id(value: Int(val[1])!)
                centro.centro_id = Int(val[1])!
            }
            else if(val[0] == "categoria_centro_id") {
                //ccm.set_descripcion(value: val[1])
                //datos[1] = Int(val[1])!
                centro.categoria_centro_id = Int(val[1])!
            }
            else if(val[0] == "imagen_portada") {
                //ccm.set_eliminado(value: Int(val[1])!)
                //datos[2] = val[1]
                centro.imagen_portada = val[1]
            }
            else if(val[0] == "nombre") {
                //ccm.set_fecha_modificacion(value: val[1])
                //datos[3] = val[1]
                centro.nombre = val[1]
            }
            else if(val[0] == "descripcion") {
                //ccm.set_fecha_modificacion(value: val[1])
                //datos[4] = val[1]
                centro.descripcion = val[1]
            }
            else if(val[0] == "domicilio_centro_id") {
                //ccm.set_fecha_modificacion(value: val[1])
                //datos[5] = Int(val[1])!
                centro.domicilio_centro_id = Int(val[1])!
            }
            else if(val[0] == "teléfonos") {
                //ccm.set_fecha_modificacion(value: val[1])
                centro.telefonos = val[1]
            }
            else if(val[0] == "activo") {
                //ccm.set_fecha_modificacion(value: val[1])
                centro.activo = Int(val[1])!
            }
            else if(val[0] == "seccion_id") {
                //ccm.set_fecha_modificacion(value: val[1])
                centro.seccion_id = Int64(val[1]) ?? 0
            }
            else if(val[0] == "eliminado") {
                //ccm.set_fecha_modificacion(value: val[1])
                centro.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                //ccm.set_fecha_modificacion(value: val[1])
                centro.fecha_modificacion = val[1]
            }
            
        }
        
        return centro
        //return CentroModel(centro_id: datos[0] as! Int, categoria_centro_id: datos[1] as! Int, imagen_portada: datos[2] as! String, nombre: datos[3] as! String, descripcion: datos[4] as! String, domicilio_centro_id: datos[5] as! Int, telefonos: datos[6] as! String, activo: datos[7] as! Int, seccion_id: datos[8] as! Int, eliminado: datos[9] as! Int, fecha_modificacion: datos[10] as! String)
    }
    
}
