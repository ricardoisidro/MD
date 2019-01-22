//
//  HorarioResoModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class HorarioResoModel: NSObject {
    
    var horarios_reso_id: Int64
    var centro_id: Int64
    var tipo_reso_id: Int64
    var titulo: String?
    var horario: String
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let db_horarios_reso = Table("horarios_reso")
    let db_horarios_reso_id = Expression<Int64>("horarios_reso_id")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_tipo_reso_id = Expression<Int64>("tipo_reso_id")
    let db_titulo = Expression<String?>("titulo")
    let db_horario = Expression<String>("horario")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.horarios_reso_id = -1
        self.centro_id = -1
        self.tipo_reso_id = -1
        self.titulo = ""
        self.horario = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> HorarioResoModel {
        let horario = HorarioResoModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "horarios_reso_id"){
                horario.horarios_reso_id = Int64(val[1])!
            }
            else if(val[0] == "centro_id") {
                horario.centro_id = Int64(val[1])!
            }
            if(val[0] == "tipo_reso_id"){
                horario.tipo_reso_id = Int64(val[1])!
            }
            else if(val[0] == "titulo") {
                horario.titulo = val[1]
            }
            else if(val[0] == "horario") {
                horario.horario = val[1]
            }
            else if(val[0] == "eliminado") {
                horario.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                horario.fecha_modificacion = date
            }
        }
        return horario
    }
    
    func onCreateHorarioResoDB(connection: Connection) {
        
        do {
            try connection.run(db_horarios_reso.create(ifNotExists: true) { t in
                t.column(db_horarios_reso_id, primaryKey: true)
                t.column(db_centro_id)
                t.column(db_tipo_reso_id)
                t.column(db_titulo)
                t.column(db_horario)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateHorarioResoDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertHorarioResoDB(connection: Connection, objeto: HorarioResoModel) {
        do {
            let insert = db_horarios_reso.insert(or: .replace,
                                                 db_horarios_reso_id <- Int64(objeto.horarios_reso_id),
                                                 db_centro_id <- Int64(objeto.centro_id),
                                                 db_tipo_reso_id <- Int64(objeto.tipo_reso_id),
                                                 db_titulo <- objeto.titulo,
                                                 db_horario <- objeto.horario,
                                                 db_eliminado <- Int64(objeto.eliminado),
                                                 db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertHorarioResoDBError: \(ex)")
        }
        
    }
}
