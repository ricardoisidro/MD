//
//  Credencial.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import SQLite
import Foundation

class Credencial : NSObject
{
    var credencial_id : Int64
    var fecha_expedicion : Date?
    var fecha_vencimiento : Date?
    var vigencia : Int64
    var activa : Int64
    var fotografia : String?
    var usuario_app_id : Int64
    
    
    //campos de la tabla
    let table_credencial = Table("credencial")
    let db_credencial_id = Expression<Int64>("credencial_id")
    let db_fecha_expedicion = Expression<Date?>("fecha_expedicion")
    let db_fecha_vencimiento = Expression<Date?>("fecha_vencimiento")
    let db_vigencia = Expression<Int64>("vigencia")
    let db_activa = Expression<Int64>("activa")
    let db_fotografia = Expression<String?>("fotografia")
    let db_usuario_app_id = Expression<Int64>("usuario_app_id")
    
    
    override init()
    {
        self.credencial_id = -1
        self.fecha_expedicion = nil
        self.fecha_vencimiento = nil
        self.vigencia = -1
        self.activa = -1
        self.fotografia = ""
        self.usuario_app_id = -1
    }
    
    
    static func deserializaCredencial(dato: String) -> Credencial {
        let cre = Credencial()
        let datesFormatter = DateFormatter()
        let defaultFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            if(val[0] == "credencial_id") {
                cre.credencial_id = Int64(val[1])!
            }
            else if(val[0] == "fecha_expedicion") {
                datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                cre.fecha_expedicion = date
            }
            else if(val[0] == "fecha_vencimiento") {
                datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                cre.fecha_vencimiento = date
            }
            else if(val[0] == "vigencia") {
                cre.vigencia = Int64(val[1])!
            }
            else if(val[0] == "activa") {
                cre.activa = Int64(val[1])!
            }
            else if(val[0] == "fotografia") {
                cre.fotografia = val[1]
            }
            else if(val[0] == "usuario_app_id") {
                cre.usuario_app_id = Int64(val[1])!
            }
        }
        return cre
    }
    
    
    func onCreate(connection: Connection)
    {
        do
        {
            try connection.run(table_credencial.create(ifNotExists: true) { t in
                t.column(db_credencial_id, primaryKey: true)
                t.column(db_fecha_expedicion)
                t.column(db_fecha_vencimiento)
                t.column(db_vigencia)
                t.column(db_activa)
                t.column(db_fotografia)
                t.column(db_usuario_app_id)
            })
        }
        catch let ex {
            //print("onCreateRegistro SQLite exception: \(ex)")
        }
    }
    func onInsert(connection: Connection, objeto: Credencial) {
        do
        {
            let insert = table_credencial.insert(or: .replace,
                                                 db_credencial_id <- objeto.credencial_id,
                                                 db_fecha_expedicion <- objeto.fecha_expedicion,
                                                 db_fecha_vencimiento <- objeto.fecha_vencimiento,
                                                 db_vigencia <- objeto.vigencia,
                                                 db_activa <- objeto.activa,
                                                 db_fotografia <- objeto.fotografia,
                                                 db_usuario_app_id <- objeto.usuario_app_id)
            try connection.run(insert)
        }
        catch let ex {
            //print("onInsertRegistro SQLite exception: \(ex)")
        }
    }
    
    func onReadData(connection: Connection) -> Credencial {
        do {
            let query = table_credencial.select(db_credencial_id, db_fecha_expedicion, db_fecha_vencimiento, db_vigencia, db_activa, db_fotografia, db_usuario_app_id)
            
            let currentCredential = try connection.pluck(query)
            
            let obj = Credencial()
            
            obj.credencial_id = try (currentCredential?.get(db_credencial_id))!
            obj.fecha_expedicion = try currentCredential?.get(db_fecha_expedicion) ?? nil
            obj.fecha_vencimiento = try currentCredential?.get(db_fecha_vencimiento)
            obj.vigencia = try (currentCredential?.get(db_vigencia))!
            obj.activa = try (currentCredential?.get(db_activa))!
            obj.fotografia = try currentCredential?.get(db_fotografia)
            obj.usuario_app_id = try (currentCredential?.get(db_usuario_app_id))!
            
            return obj
            
        }
        catch let ex {
            //print("Read CredencialDB error: \(ex)")

            return Credencial()
        }
    }
    
    func onDelete(connection: Connection) {
        do {
            try connection.run(table_credencial.delete())
        }
        catch let ex {
            //print("onDeleteCredencial error: \(ex)")
        }
    }
    
    func onUpdate(connection: Connection, picture: String) -> Bool {
        
        var success = false
        do {
            if try connection.run(table_credencial.update(db_fotografia <- picture)) > 0
            {
                //print("Updated")
                success = true
            }
            else {
                //print("Not updated")
                success = false
            }
        }
        catch let error {
            //print("onUpdateTelefonos exception: \(error)")
            success = false
        }
        return success
    }
}
