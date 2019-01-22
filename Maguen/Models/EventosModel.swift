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
    
    var evento_id: Int64
    var centro_id: Int64
    var titulo: String
    var fecha_inicial_publicacion: Date?
    var fecha_final_publicacion: Date?
    var horario: String
    var imagen: String?
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let table_eventos = Table("eventos")
    let db_evento_id = Expression<Int64>("evento_id")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_titulo = Expression<String>("titulo")
    let db_fecha_inicial_publicacion = Expression<Date?>("fecha_inicial_publicacion")
    let db_fecha_final_publicacion = Expression<Date?>("fecha_final_publicacion")
    let db_horario = Expression<String>("horario")
    let db_imagen = Expression<String?>("imagen")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.evento_id = -1
        self.centro_id = -1
        self.titulo = ""
        self.fecha_inicial_publicacion = nil
        self.fecha_final_publicacion = nil
        self.horario = ""
        self.imagen = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> EventosModel {
        let evento = EventosModel()
       
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "evento_id"){
                evento.evento_id = Int64(val[1])!
            }
            else if(val[0] == "centro_id") {
                evento.centro_id = Int64(val[1])!
            }
            else if(val[0] == "titulo") {
                evento.titulo = val[1]
            }
            else if(val[0] == "fecha_inicial_publicacion") {
                let date = datesFormatter.date(from: val[1])
                evento.fecha_inicial_publicacion = date
            }
            else if(val[0] == "fecha_final_publicacion") {
                let date = datesFormatter.date(from: val[1])
                evento.fecha_final_publicacion = date
                
            }
            else if(val[0] == "horario") {
                evento.horario = val[1]
            }
            else if(val[0] == "imagen") {
                evento.imagen = val[1]
            }
            else if(val[0] == "eliminado") {
                evento.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                //datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                evento.fecha_modificacion = date
            }
        
        }
        return evento
    }
    
    func onCreateEventosDB(connection: Connection) {
        
        do {
            //let db = database
            try connection.run(table_eventos.create(ifNotExists: true) { t in
                t.column(db_evento_id, primaryKey: true)
                t.column(db_centro_id)
                t.column(db_titulo)
                t.column(db_fecha_inicial_publicacion)
                t.column(db_fecha_final_publicacion)
                t.column(db_horario)
                t.column(db_imagen)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
            try connection.run(table_eventos.createIndex(db_fecha_final_publicacion))
            //try connection.run(table_eventos.createIndex(db_eliminado))
        }
        catch let ex{
            print("onCreateEventosDB SQLite exception: \(ex)")
        }
        
    }
    
    /*
     func onInsertEventosDB(objeto: EventosModel) {
     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
     let defaultDateTime = formatter.date(from: "01/01/1990 00:00:00")
     
     do {
     let db = database
     let insert = db_eventos.insert(or: .replace,
     db_evento_id <- Int64(objeto.evento_id),
     db_centro_id <- Int64(objeto.centro_id),
     db_titulo <- objeto.titulo,
     db_fecha_inicial_publicacion <- objeto.fecha_inicial_publicacion ?? defaultDateTime!,
     db_fecha_final_publicacion <- objeto.fecha_final_publicacion!,
     db_horario <- objeto.horario,
     db_imagen <- objeto.imagen!,
     db_eliminado <- Int64(objeto.eliminado),
     db_fecha_modificacion <- objeto.fecha_modificacion)
     try db!.run(insert)
     }
     catch let ex{
     print("onInsertCentroDBError: \(ex)")
     }
     
     }*/
    
    func onInsertEventosDB(connection: Connection, objeto: EventosModel) {
        do
        {
            let insert = table_eventos.insert(or: .replace,
                                              db_evento_id <- Int64(objeto.evento_id),
                                              db_centro_id <- Int64(objeto.centro_id),
                                              db_titulo <- objeto.titulo,
                                              db_fecha_inicial_publicacion <- objeto.fecha_inicial_publicacion,
                                              db_fecha_final_publicacion <- objeto.fecha_final_publicacion,
                                              db_horario <- objeto.horario,
                                              db_eliminado <- Int64(objeto.eliminado),
                                              db_fecha_modificacion <- objeto.fecha_modificacion,
                db_imagen <- objeto.imagen)
            try connection.run(insert)
        }
        catch let ex {
            print("onInsertEventosDB SQLite exception: \(ex)")
        }
    }
    
}
