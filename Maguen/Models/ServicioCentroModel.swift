//
//  ServicioCentroModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class ServicioCentroModel : NSObject {
    
    var servicio_centro_id: Int64
    var servicio_id: Int64
    var centro_id: Int64
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let db_servicio_centro = Table("servicio_centro")
    let db_servicio_centro_id = Expression<Int64>("servicio_centro_id")
    let db_servicio_id = Expression<Int64>("servicio_id")
    let db_centro_id = Expression<Int64>("centro_id")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.servicio_centro_id = -1
        self.servicio_id = -1
        self.centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> ServicioCentroModel {
        let servicio = ServicioCentroModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "servicio_centro_id"){
                servicio.servicio_centro_id = Int64(val[1])!
            }
            else if(val[0] == "servicio_id") {
                servicio.servicio_id = Int64(val[1])!
            }
            if(val[0] == "centro_id"){
                servicio.centro_id = Int64(val[1])!
            }
            else if(val[0] == "eliminado") {
                servicio.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                servicio.fecha_modificacion = date
            }
        }
        return servicio
    }
    
    func onCreateServicioCentroDB(connection: Connection) {
        
        do {
            try connection.run(db_servicio_centro.create(ifNotExists: true) { t in
                t.column(db_servicio_centro_id, primaryKey: true)
                t.column(db_servicio_id)
                t.column(db_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateServicioCentroDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertServicioCentroDB(connection: Connection, objeto: ServicioCentroModel) {
        do {
            let insert = db_servicio_centro.insert(or: .replace,
                                                   db_servicio_centro_id <- Int64(objeto.servicio_centro_id),
                                                   db_servicio_id <- Int64(objeto.servicio_id),
                                                   db_centro_id <- Int64(objeto.centro_id),
                                                   db_eliminado <- Int64(objeto.eliminado),
                                                   db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertServicioCentroDBError: \(ex)")
        }
        
    }
    
}
