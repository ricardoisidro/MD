//
//  ComunidadModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class ComunidadModel: NSObject {
    
    var comunidad_id: Int64
    var descripcion: String
    var fecha_modificacion: Date?
    
    let db_comunidad = Table("comunidad")
    let db_comunidad_id = Expression<Int64>("comunidad_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.comunidad_id = -1
        self.descripcion = ""
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> ComunidadModel {
        let comunidad = ComunidadModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "comunidad_id"){
                comunidad.comunidad_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                comunidad.descripcion = val[1]
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                comunidad.fecha_modificacion = date
            }
        }
        return comunidad
    }
    
    func onCreateComunidadDB(connection: Connection) {
        
        do {
            try connection.run(db_comunidad.create(ifNotExists: true) { t in
                t.column(db_comunidad_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateComunidadDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertComunidadDB(connection: Connection, objeto: ComunidadModel) {
        do {
            let insert = db_comunidad.insert(or: .replace,
                                             db_comunidad_id <- Int64(objeto.comunidad_id),
                                             db_descripcion <- objeto.descripcion,
                                             db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertComunidadDBError: \(ex)")
            Global.shared.sincroniceOK = false && Global.shared.sincroniceOK

        }
        
    }
}
