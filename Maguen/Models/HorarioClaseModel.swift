//
//  HorarioClaseModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class HorarioClaseModel : NSObject {
    
    var horario_clase_id: Int64
    var clase_id: Int64
    var profesor: String
    var dias: String
    var horario: String
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let db_horario_clase = Table("horario_clase")
    let db_horario_clase_id = Expression<Int64>("horario_clase")
    let db_clase_id = Expression<Int64>("clase_id")
    let db_profesor = Expression<String>("profesor")
    let db_dias = Expression<String>("dias")
    let db_horario = Expression<String>("horario")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.horario_clase_id = -1
        self.clase_id = -1
        self.profesor = ""
        self.dias = ""
        self.horario = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> HorarioClaseModel {
        let horario = HorarioClaseModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "horario_clase_id"){
                horario.horario_clase_id = Int64(val[1])!
            }
            else if(val[0] == "clase_id") {
                horario.clase_id = Int64(val[1])!
            }
            if(val[0] == "profesor"){
                horario.profesor = val[1]
            }
            else if(val[0] == "dias") {
                horario.dias = val[1]
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
    
    func onCreateHorarioClaseDB(connection: Connection) {
        
        do {
            try connection.run(db_horario_clase.create(ifNotExists: true) { t in
                t.column(db_horario_clase_id, primaryKey: true)
                t.column(db_clase_id)
                t.column(db_profesor)
                t.column(db_dias)
                t.column(db_horario)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateHorarioClaseDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertHorarioClaseDB(connection: Connection, objeto: HorarioClaseModel) {
        do {
            let insert = db_horario_clase.insert(or: .replace,
                                                 db_horario_clase_id <- Int64(objeto.horario_clase_id),
                                                 db_clase_id <- Int64(objeto.clase_id),
                                                 db_profesor <- objeto.profesor,
                                                 db_dias <- objeto.dias,
                                                 db_horario <- objeto.horario,
                                                 db_eliminado <- Int64(objeto.eliminado),
                                                 db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertHorarioClaseDBError: \(ex)")
            Global.shared.sincroniceOK = false && Global.shared.sincroniceOK

        }
        
    }
    
}
