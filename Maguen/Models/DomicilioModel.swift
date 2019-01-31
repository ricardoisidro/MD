//
//  DomicilioModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/27/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import SQLite

class DomicilioModel: NSObject {
    
    var domicilio_id: Int64
    var calle: String
    var numero_exterior: String
    var numero_interior: String?
    var cp: Int64?
    var colonia: String
    var delegacion_municipio: String
    var estado: String
    var fecha_modificacion: Date?
    
    let db_domicilio = Table("domicilio")
    let db_domicilio_id = Expression<Int64>("domicilio_id")
    let db_calle = Expression<String>("calle")
    let db_numero_exterior = Expression<String>("numero_exterior")
    let db_numero_interior = Expression<String?>("numero_interior")
    let db_cp = Expression<Int64?>("cp")
    let db_colonia = Expression<String>("colonia")
    let db_delegacion_municipio = Expression<String>("delegacion_municipio")
    let db_estado = Expression<String>("estado")
    let db_fecha_modificacion = Expression<Date?>("fecha_modificacion")
    
    override init() {
        self.domicilio_id = -1
        self.calle = ""
        self.numero_exterior = ""
        self.numero_interior = ""
        self.cp = -1
        self.colonia = ""
        self.delegacion_municipio = ""
        self.estado = ""
        self.fecha_modificacion = nil
    }
    
    func deserializaCentro(dato: String) -> DomicilioModel {
        let domicilio = DomicilioModel()
        let datesFormatter = DateFormatter()
        datesFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "domicilio_id"){
                domicilio.domicilio_id = Int64(val[1])!
            }
            else if(val[0] == "calle") {
                domicilio.calle = val[1]
            }
            else if(val[0] == "numero_exterior") {
                domicilio.numero_exterior = val[1]
            }
            else if(val[0] == "numero_interior") {
                domicilio.numero_interior = val[1]
            }
            else if (val[0] == "cp") {
                domicilio.cp = Int64(val[1])
            }
            else if(val[0] == "colonia") {
                domicilio.colonia = val[1]
            }
            else if(val[0] == "delegacion_municipio") {
                domicilio.delegacion_municipio = val[1]
            }
            else if(val[0] == "estado") {
                domicilio.estado = val[1]
            }
            else if(val[0] == "fecha_modificacion") {
                let date = datesFormatter.date(from: val[1])
                domicilio.fecha_modificacion = date
            }
            
        }
        
        return domicilio
        
    }
    
    func onCreateDomicilioDB(connection: Connection) {
        
        do {
            try connection.run(db_domicilio.create(ifNotExists: true) { t in
                t.column(db_domicilio_id, primaryKey: true)
                t.column(db_calle)
                t.column(db_numero_exterior)
                t.column(db_numero_interior)
                t.column(db_cp)
                t.column(db_colonia)
                t.column(db_delegacion_municipio)
                t.column(db_estado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex{
            print("onCreateDomicilioDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertDomicilioDB(connection: Connection, objeto: DomicilioModel) {
        do {
            let insert = db_domicilio.insert(or: .replace,
                                             db_domicilio_id <- Int64(objeto.domicilio_id),
                                             db_calle <- objeto.calle,
                                             db_numero_exterior <- objeto.numero_exterior,
                                             db_numero_interior <- objeto.numero_interior,
                                             db_cp <- objeto.cp,
                                             db_colonia <- objeto.colonia,
                                             db_delegacion_municipio <- objeto.delegacion_municipio,
                                             db_estado <- objeto.estado,
                                             db_fecha_modificacion <- objeto.fecha_modificacion)
            try connection.run(insert)
        }
        catch let ex {
            print("onInsertDomicilioDB Error: \(ex)")
            Global.shared.sincroniceOK = false && Global.shared.sincroniceOK

        }
        
    }
}
