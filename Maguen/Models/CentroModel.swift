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
    
    var centro_id: Int64
    var categoria_centro_id: Int64
    var imagen_portada: String?
    var nombre: String
    var descripcion: String
    var domicilio_centro_id: Int64
    var telefonos: String?
    var activo: Int64
    var seccion_id: Int64?
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let table_centro = Table("centro")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_imagen_portada = Expression<String>("imagen_portada")
    let db_nombre = Expression<String>("nombre")
    let db_descripcion = Expression<String>("descripcion")
    let db_domicilio_centro_id = Expression<Int64>("domicilio_centro_id")
    let db_telefonos = Expression<String?>("telefonos")
    let db_activo = Expression<Int64>("activo")
    let db_seccion_id = Expression<Int64?>("seccion_id")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
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
        self.fecha_modificacion = nil
    }
    
    func deserializaCentro(dato: String) -> CentroModel {
        let centro = CentroModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "centro_id"){
                centro.centro_id = Int64(val[1])!
            }
            else if(val[0] == "categoria_centro_id") {
                centro.categoria_centro_id = Int64(val[1])!
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
                centro.domicilio_centro_id = Int64(val[1])!
            }
            else if(val[0] == "teléfonos") {
                centro.telefonos = val[1]
            }
            else if(val[0] == "activo") {
                centro.activo = Int64(val[1])!
            }
            else if(val[0] == "seccion_id") {
                centro.seccion_id = Int64(val[1])
            }
            else if(val[0] == "eliminado") {
                centro.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                centro.fecha_modificacion = date
            }
            
        }
        
        return centro
        
    }
    
    func onCreateCentroDB(connection: Connection) {
        
        do {
            try connection.run(table_centro.create(ifNotExists: true) { t in
                t.column(db_centro_id, primaryKey: true)
                t.column(db_categoria_centro_id)
                t.column(db_imagen_portada)
                t.column(db_nombre)
                t.column(db_descripcion)
                t.column(db_domicilio_centro_id)
                t.column(db_telefonos)
                t.column(db_activo)
                t.column(db_seccion_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateCentroDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCentroDB(objeto: CentroModel, connection: Connection) {
        do {
            let insert = table_centro.insert(or: .replace, db_centro_id <- Int64(objeto.centro_id),
                                          db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                          db_imagen_portada <- objeto.imagen_portada!,
                                          db_nombre <- objeto.nombre,
                                          db_descripcion <- objeto.descripcion,
                                          db_domicilio_centro_id <- Int64(objeto.domicilio_centro_id),
                                          db_telefonos <- objeto.telefonos,
                                          db_activo <- Int64(objeto.activo),
                                          db_seccion_id <- objeto.seccion_id,
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertCentroDBError: \(ex)")
        }
        
    }
    
}
