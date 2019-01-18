//
//  Telefonos.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation
import SQLite

class Telefonos : NSObject
{
    var telefono_id : Int64
    var usuario_app_id : Int64
    var numero : String?
    var tipo_id : Int64
    var imei : String?
    var sistema_operativo : String?
    var activo : Int64
    
    
    //campos de la tabla
    let table_telefonos = Table("telefonos")
    let db_telefono_id = Expression<Int64>("telefono_id")
    let db_usuario_app_id = Expression<Int64>("usuario_app_id")
    let db_numero = Expression<String?>("numero")
    let db_tipo_id = Expression<Int64>("tipo_id")
    let db_imei = Expression<String?>("imei")
    let db_sistema_operativo = Expression<String?>("sistema_operativo")
    let db_activo = Expression<Int64>("activo")
    
    
    override init()
    {
        self.telefono_id = -1
        self.usuario_app_id = -1
        self.numero = ""
        self.tipo_id = -1
        self.imei = ""
        self.sistema_operativo = ""
        self.activo = -1
    }
    
    
    static func deserializaTelefonos(dato: String) -> Telefonos {
        let tel = Telefonos()
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            if(val[0] == "telefono_id") {
                tel.telefono_id = Int64(val[1])!
            }
            else if(val[0] == "usuario_app_id") {
                tel.usuario_app_id = Int64(val[1])!
            }
            else if(val[0] == "numero") {
                tel.numero = val[1]
            }
            else if(val[0] == "tipo_id") {
                tel.tipo_id = Int64(val[1])!
            }
            else if(val[0] == "imei") {
                tel.imei = val[1]
            }
            else if(val[0] == "sistema_operativo") {
                tel.sistema_operativo = val[1]
            }
            else if(val[0] == "activo") {
                tel.activo = Int64(val[1])!
            }
        }
        return tel
    }
    
    
    func onCreate(connection: Connection)
    {
        do
        {
            try connection.run(table_telefonos.create(ifNotExists: true) { t in
                t.column(db_telefono_id, primaryKey: true)
                t.column(db_usuario_app_id)
                t.column(db_numero)
                t.column(db_tipo_id)
                t.column(db_imei)
                t.column(db_sistema_operativo)
                t.column(db_activo)
            })
        }
        catch let ex {
            //print("onCreateRegistro SQLite exception: \(ex)")
        }
    }
    func onInsert(connection: Connection, objeto: Telefonos) {
        do
        {
            let insert = table_telefonos.insert(or: .replace,
                                                db_telefono_id <- objeto.telefono_id,
                                                db_usuario_app_id <- objeto.usuario_app_id,
                                                db_numero <- objeto.numero,
                                                db_tipo_id <- objeto.tipo_id,
                                                db_imei <- objeto.imei,
                                                db_sistema_operativo <- objeto.sistema_operativo,
                                                db_activo <- objeto.activo)
            try connection.run(insert)
        }
        catch let ex {
            //print("onInsertRegistro SQLite exception: \(ex)")
        }
    }
    
    func onReadData(connection: Connection) -> Telefonos {
        do {
            let query = table_telefonos.select(db_telefono_id, db_usuario_app_id, db_numero, db_tipo_id, db_imei, db_sistema_operativo, db_activo)
            
            let currentPhone = try connection.pluck(query)
            
            let obj = Telefonos()
            
            obj.telefono_id = try (currentPhone?.get(db_telefono_id))!
            obj.usuario_app_id = try (currentPhone?.get(db_usuario_app_id))!
            obj.numero = try currentPhone?.get(db_numero)
            obj.tipo_id = try (currentPhone?.get(db_tipo_id))!
            obj.imei = try currentPhone?.get(db_imei)
            obj.sistema_operativo = try currentPhone?.get(db_sistema_operativo)
            obj.activo = try (currentPhone?.get(db_activo))!
            
            return obj
            
        }
        catch let ex {
            //print("Read TelefonosDB error: \(ex)")
            
            return Telefonos()
        }
    }
    
    func onDelete(connection: Connection) {
        do {
            try connection.run(table_telefonos.delete())
        }
        catch let ex {
            //print("onDeleteTelefonos error: \(ex)")
        }
    }
    
    func onUpdate(connection: Connection, phone: String) -> Bool {
        
        var success = false
        do {
            if try connection.run(table_telefonos.update(db_numero <- phone)) > 0
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
