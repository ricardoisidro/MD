//
//  ClasesModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class ClasesModel : NSObject {
    
    var clase_id: Int64
    var descripcion: String
    var centro_id: Int64
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let db_clases = Table("clases")
    let db_clases_id = Expression<Int64>("clase_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    let db_eliminado = Expression<Int64>("eliminado")

    override init() {
        self.clase_id = -1
        self.descripcion = ""
        self.centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> ClasesModel {
        let clase = ClasesModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "clase_id"){
                clase.clase_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                clase.descripcion = val[1]
            }
            else if(val[0] == "centro_id") {
                clase.centro_id = Int64(val[1])!
            }
            else if(val[0] == "eliminado") {
                clase.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                clase.fecha_modificacion = date
            }
            
        }
        return clase
    }
    
    func onCreateClasesDB(connection: Connection) {
        
        do {
            try connection.run(db_clases.create(ifNotExists: true) { t in
                t.column(db_clases_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateComunidadDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertClasesDB(connection: Connection, objeto: ClasesModel) {
        do {
            let insert = db_clases.insert(or: .replace,
                                          db_clases_id <- Int64(objeto.clase_id),
                                          db_descripcion <- objeto.descripcion,
                                          db_centro_id <- Int64(objeto.centro_id),
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertComunidadDBError: \(ex)")
        }
        
    }
}
