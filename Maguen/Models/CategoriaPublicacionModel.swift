//
//  CategoriaPublicacionModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class CategoriaPublicacionModel: NSObject {
    
    var categoria_publicacion_id: Int64
    var descripcion: String?
    var eliminado: Int64
    var fecha_modificacion: Date?
    
    let table_categoria_publicacion = Table("categoria_publicacion")
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_descripcion = Expression<String>("categoria_descripcion")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.categoria_publicacion_id = -1
        self.descripcion = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    func deserializaEvento(dato: String) -> CategoriaPublicacionModel {
        let categoriaPublicacion = CategoriaPublicacionModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "categoria_publicacion_id"){
                categoriaPublicacion.categoria_publicacion_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                categoriaPublicacion.descripcion = val[1]
            }
            else if(val[0] == "eliminado") {
                categoriaPublicacion.eliminado = Int64(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                categoriaPublicacion.fecha_modificacion = date
            }
            
        }
        return categoriaPublicacion
    }
    
    func onCreateCategoriaPublicacionDB(connection: Connection) {
        
        do {
            try connection.run(table_categoria_publicacion.create(ifNotExists: true) { t in
                t.column(db_categoria_publicacion_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateCategoriaPublicacionDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCategoriaPublicacionDB(connection: Connection, objeto: CategoriaPublicacionModel) {
        do {
            let insert = table_categoria_publicacion.insert(or: .replace,
                                                         db_categoria_publicacion_id <- Int64(objeto.categoria_publicacion_id),
                                                         db_descripcion <- objeto.descripcion ?? "",
                                                         db_eliminado <- Int64(objeto.eliminado),
                                                         db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertCategoriaPublicacionDBError: \(ex)")
            Global.shared.sincroniceOK = false && Global.shared.sincroniceOK

        }
        
    }
    
}
