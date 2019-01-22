//
//  PublicacionModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class PublicacionModel: NSObject {
    
    var publicacion_id: Int64
    var descripcion: String
    var fecha_inicial_publicacion: Date?
    var fecha_final_publicacion: Date?
    var categoria_publicacion_id: Int64?
    var paginas: Int64?
    var eliminado: Int64
    var fecha_modificacion: Date?
    var activo: Int64
    
    let table_publicacion = Table("publicacion")
    let db_publicacion_id = Expression<Int64>("publicacion_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_fecha_inicial_publicacion = Expression<Date?>("fecha_inicial_publicacion")
    let db_fecha_final_publicacion = Expression<Date?>("fecha_final_publicacion")
    let db_categoria_publicacion_id = Expression<Int64?>("categoria_publicacion_id")
    let db_paginas = Expression<Int64?>("paginas")
    let db_activo = Expression<Int64>("activo")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.publicacion_id = -1
        self.descripcion = ""
        self.fecha_inicial_publicacion = nil
        self.fecha_final_publicacion = nil
        self.categoria_publicacion_id = -1
        self.paginas = -1
        self.eliminado = -1
        self.fecha_modificacion = nil
        self.activo = -1
    }
    
    func deserializaEvento(dato: String) -> PublicacionModel {
        let publicacion = PublicacionModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "publicacion_id"){
                publicacion.publicacion_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                publicacion.descripcion = val[1]
            }
            else if(val[0] == "fecha_inicial_publicacion") {
                let date = datesFormatter.date(from: val[1])
                publicacion.fecha_inicial_publicacion = date
            }
            else if(val[0] == "fecha_final_publicacion") {
                let date = datesFormatter.date(from: val[1])
                publicacion.fecha_final_publicacion = date
            }
            else if(val[0] == "categoria_publicacion_id") {
                publicacion.categoria_publicacion_id = Int64(val[1])
            }
            else if(val[0] == "paginas") {
                publicacion.paginas = Int64(val[1])
            }
            else if(val[0] == "eliminado") {
                publicacion.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                publicacion.fecha_modificacion = date
            }
            else if(val[0] == "activo") {
                publicacion.activo = Int64(val[1])!
            }
            
        }
        return publicacion
    }
    
    func onCreatePublicacionDB(connection: Connection) {
        
        do {
            try connection.run(table_publicacion.create(ifNotExists: true) { t in
                t.column(db_publicacion_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_fecha_inicial_publicacion)
                t.column(db_fecha_final_publicacion)
                t.column(db_categoria_publicacion_id)
                t.column(db_paginas)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
                t.column(db_activo)
            })
        }
        catch let ex{
            print("onCreatePublicacionDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertPublicacionDB(connection: Connection, objeto: PublicacionModel) {
        do
        {
            let insert = table_publicacion.insert(or: .replace,
                                                  db_publicacion_id <- Int64(objeto.publicacion_id),
                                                  db_descripcion <- objeto.descripcion,
                                                  db_fecha_inicial_publicacion <- objeto.fecha_inicial_publicacion,
                                                  db_fecha_final_publicacion <- objeto.fecha_final_publicacion,
                                                  db_categoria_publicacion_id <- objeto.categoria_publicacion_id,
                                                  db_paginas <- objeto.paginas,
                                                  db_eliminado <- Int64(objeto.eliminado),
                                                  db_fecha_modificacion <- objeto.fecha_modificacion,
                                                  db_activo <- Int64(objeto.activo))
            try connection.run(insert)
        }
        catch let ex {
            print("onInsertPublicacionDB SQLite exception: \(ex)")
        }
    }
}
