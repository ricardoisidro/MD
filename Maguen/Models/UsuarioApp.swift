//
//  UsuarioApp.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/12/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation
import SQLite

class UsuarioApp : NSObject
{
    var usuario_app_id : Int64
    var numero_maguen : String?
    var nombre : String?
    var primer_apellido : String?
    var segundo_apellido : String?
    var sexo : String?
    var fecha_nacimiento : Date?
    var usuario : String?
    var contrasena : String?
    var correo : String?
    var categoria_id : Int64
    var comunidad_id : Int64
    var domicilio_id : Int64
    var fecha_activacion : Date?
    var activo : Int64
    var eliminado : Int64
    
    
    //campos de la tabla
    let table_usuarioapp = Table("usuarioapp")
    let db_usuario_app_id = Expression<Int64>("usuario_app_id")
    let db_numero_maguen = Expression<String?>("numero_maguen")
    let db_nombre = Expression<String?>("nombre")
    let db_primer_apellido = Expression<String?>("primer_apellido")
    let db_segundo_apellido = Expression<String?>("segundo_apellido")
    let db_sexo = Expression<String?>("sexo")
    let db_fecha_nacimiento = Expression<Date?>("fecha_nacimiento")
    let db_usuario = Expression<String?>("usuario")
    let db_contrasena = Expression<String?>("contrasena")
    let db_correo = Expression<String?>("correo")
    let db_categoria_id = Expression<Int64>("categoria_id")
    let db_comunidad_id = Expression<Int64>("comunidad_id")
    let db_domicilio_id = Expression<Int64>("domicilio_id")
    let db_fecha_activacion = Expression<Date?>("fecha_activacion")
    let db_activo = Expression<Int64>("activo")
    let db_eliminado = Expression<Int64>("eliminado")
    
    
    override init()
    {
        self.usuario_app_id = -1
        self.numero_maguen = ""
        self.nombre = ""
        self.primer_apellido = ""
        self.segundo_apellido = ""
        self.sexo = ""
        self.fecha_nacimiento = nil
        self.usuario = ""
        self.contrasena = ""
        self.correo = ""
        self.categoria_id = -1
        self.comunidad_id = -1
        self.domicilio_id = -1
        self.fecha_activacion = nil
        self.activo = -1
        self.eliminado = -1
    }
    
    
    static func deserializaUsuarioApp(dato: String) -> UsuarioApp {
        let usu = UsuarioApp()
        let datesFormatter = DateFormatter()
        let defaultFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            if(val[0] == "usuario_app_id") {
                usu.usuario_app_id = Int64(val[1])!
            }
            else if(val[0] == "numero_maguen") {
                usu.numero_maguen = val[1]
            }
            else if(val[0] == "nombre") {
                usu.nombre = val[1]
            }
            else if(val[0] == "primer_apellido") {
                usu.primer_apellido = val[1]
            }
            else if(val[0] == "segundo_apellido") {
                usu.segundo_apellido = val[1]
            }
            else if(val[0] == "sexo") {
                usu.sexo = val[1]
            }
            else if(val[0] == "fecha_nacimiento") {
                datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                usu.fecha_nacimiento = date
            }
            else if(val[0] == "usuario") {
                usu.usuario = val[1]
            }
            else if(val[0] == "contrasena") {
                usu.contrasena = val[1]
            }
            else if(val[0] == "correo") {
                usu.correo = val[1]
            }
            else if(val[0] == "categoria_id") {
                usu.categoria_id = Int64(val[1])!
            }
            else if(val[0] == "comunidad_id") {
                usu.comunidad_id = Int64(val[1])!
            }
            else if(val[0] == "domicilio_id") {
                usu.domicilio_id = Int64(val[1])!
            }
            else if(val[0] == "fecha_activacion") {
                datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                usu.fecha_activacion = date
            }
            else if(val[0] == "activo") {
                usu.activo = Int64(val[1])!
            }
            else if(val[0] == "eliminado") {
                usu.eliminado = Int64(val[1])!
            }
        }
        return usu
    }
    
    
    func onCreate(connection: Connection)
    {
        do
        {
            try connection.run(table_usuarioapp.create(ifNotExists: true) { t in
                t.column(db_usuario_app_id, primaryKey: true)
                t.column(db_numero_maguen)
                t.column(db_nombre)
                t.column(db_primer_apellido)
                t.column(db_segundo_apellido)
                t.column(db_sexo)
                t.column(db_fecha_nacimiento)
                t.column(db_usuario)
                t.column(db_contrasena)
                t.column(db_correo)
                t.column(db_categoria_id)
                t.column(db_comunidad_id)
                t.column(db_domicilio_id)
                t.column(db_fecha_activacion)
                t.column(db_activo)
                t.column(db_eliminado)
            })
        }
        catch let ex {
            print("onCreateRegistro SQLite exception: \(ex)")
        }
    }
    func onInsert(connection: Connection, objeto: UsuarioApp) {
        do
        {
            let insert = table_usuarioapp.insert(or: .replace,
                                                 db_usuario_app_id <- objeto.usuario_app_id,
                                                 db_numero_maguen <- objeto.numero_maguen,
                                                 db_nombre <- objeto.nombre,
                                                 db_primer_apellido <- objeto.primer_apellido,
                                                 db_segundo_apellido <- objeto.segundo_apellido,
                                                 db_sexo <- objeto.sexo,
                                                 db_fecha_nacimiento <- objeto.fecha_nacimiento,
                                                 db_usuario <- objeto.usuario,
                                                 db_contrasena <- objeto.contrasena,
                                                 db_correo <- objeto.correo,
                                                 db_categoria_id <- objeto.categoria_id,
                                                 db_comunidad_id <- objeto.comunidad_id,
                                                 db_domicilio_id <- objeto.domicilio_id,
                                                 db_fecha_activacion <- objeto.fecha_activacion,
                                                 db_activo <- objeto.activo,
                                                 db_eliminado <- objeto.eliminado)
            try connection.run(insert)
        }
        catch let ex {
            print("onInsertRegistro SQLite exception: \(ex)")
        }
    }
}
