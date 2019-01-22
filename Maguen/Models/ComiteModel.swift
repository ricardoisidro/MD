//
//  ComiteModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class ComiteModel: NSObject {
    
    var comite_id: Int64
    var nombre_comite: String
    var telefono: String
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let table_comites = Table("comites")
    let db_comite_id = Expression<Int64>("comite_id")
    let db_nombre_comite = Expression<String>("nombre_comite")
    let db_telefono = Expression<String>("telefono")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.comite_id = -1
        self.nombre_comite = ""
        self.telefono = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> ComiteModel {
        let comite = ComiteModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "comite_id"){
                comite.comite_id = Int64(val[1])!
            }
            else if(val[0] == "nombre_comite") {
                comite.nombre_comite = val[1]
            }
            else if(val[0] == "telefono") {
                let numero = val[1].replacingOccurrences(of: "-", with: "")
                comite.telefono = numero
            }
            else if(val[0] == "eliminado") {
                comite.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                comite.fecha_modificacion = date
            }
            
        }
        return comite
    }
    
    func onCreateComiteDB(connection: Connection) {
        
        do {
            try connection.run(table_comites.create(ifNotExists: true) { t in
                t.column(db_comite_id, primaryKey: true)
                t.column(db_nombre_comite)
                t.column(db_telefono)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateComitesDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertComiteDB(connection: Connection, objeto: ComiteModel) {
        do {
            let insert = table_comites.insert(or: .replace,
                                          db_comite_id <- Int64(objeto.comite_id),
                                          db_nombre_comite <- objeto.nombre_comite,
                                          db_telefono <- objeto.telefono,
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertComiteDBError: \(ex)")
        }
        
    }
    
}
