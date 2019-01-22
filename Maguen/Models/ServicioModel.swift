//
//  ServicioModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class ServicioModel : NSObject {
    
    var servicio_id: Int64
    var descripcion: String
    var imagen: String?
    var activo: Int64?
    var categoria_centro_id: Int64
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let db_servicio = Table("servicio")
    let db_servicio_id = Expression<Int64>("servicio_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_imagen = Expression<String?>("imagen")
    let db_activo = Expression<Int64?>("activo")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.servicio_id = -1
        self.descripcion = ""
        self.imagen = ""
        self.activo = -1
        self.categoria_centro_id = -1
        self.eliminado = -1
        self.fecha_modificacion = nil
        
    }
    
    func deserializaCentro(dato: String) -> ServicioModel {
        let servicio = ServicioModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "servicio_id"){
                servicio.servicio_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                servicio.descripcion = val[1]
            }
            else if(val[0] == "imagen") {
                servicio.imagen = val[1]
            }
            else if(val[0] == "activo") {
                servicio.activo = Int64(val[1]) ?? 0
            }
            else if(val[0] == "categoria_centro_id") {
                servicio.categoria_centro_id = Int64(val[1])!
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
    
    func onCreateServicioDB(connection: Connection) {
        
        do {
            try connection.run(db_servicio.create(ifNotExists: true) { t in
                t.column(db_servicio_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_imagen)
                t.column(db_activo)
                t.column(db_categoria_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateServicioDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertServicioDB(connection: Connection, objeto: ServicioModel) {
        do {
            let insert = db_servicio.insert(or: .replace,
                                            db_servicio_id <- Int64(objeto.servicio_id),
                                            db_descripcion <- objeto.descripcion,
                                            db_imagen <- objeto.imagen,
                                            db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                            db_activo <- objeto.activo,
                                            //db_seccion_id <- Int64?(objeto.seccion_id!)!,
                                            db_eliminado <- Int64(objeto.eliminado),
                                            db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertServicioDBError: \(ex)")
        }
        
    }
}
