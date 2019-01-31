//
//  CategoriaCentroModel.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/22/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class CategoriaCentroModel: NSObject {
    
    var categoria_centro_id: Int64
    var descripcion: String?
    var eliminado: Int64?
    var fecha_modificacion: Date?
    
    override init() {
        self.categoria_centro_id = -1
        self.descripcion = ""
        self.eliminado = -1
        self.fecha_modificacion = nil
    }
    
    let table_categoriacentro = Table("categoria_centro")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_eliminado = Expression<Int64?>("eliminado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    func deserializaCategoriaCentro(dato: String) -> CategoriaCentroModel {
        
        let categoriaCentro = CategoriaCentroModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "categoria_centro_id"){
                categoriaCentro.categoria_centro_id = Int64(val[1])!
            }
            else if(val[0] == "descripcion") {
                categoriaCentro.descripcion = val[1]
            }
            else if(val[0] == "eliminado") {
                categoriaCentro.eliminado = Int64(val[1])
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                categoriaCentro.fecha_modificacion = date
            }
        }
                
        return categoriaCentro
    }
    
    func onCreateCategoriaCentroDB(connection: Connection) {
        
        do {
            
            try connection.run(table_categoriacentro.create(ifNotExists: true) { t in
                t.column(db_categoria_centro_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateCategoriaCentro SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCategoriaCentroDB(connection: Connection, objeto: CategoriaCentroModel) {
        do {
            let insert = table_categoriacentro.insert(or: .replace,
                                                    db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                                    db_descripcion <- objeto.descripcion!,
                                                    db_eliminado <- Int64(objeto.eliminado!),
                                                    db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex{
            print("onInsertCategoriaCentro Error: \(ex)")
            Global.shared.sincroniceOK = false && Global.shared.sincroniceOK
        }
        
    }
}
