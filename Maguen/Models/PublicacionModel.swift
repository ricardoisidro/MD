//
//  PublicacionModel.swift
//  Maguen
//
//  Created by Ricardo Isidro on 11/26/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class PublicacionModel: NSObject {
    
    var publicacion_id: Int
    var descripcion: String
    var fecha_inicial_publicacion: Date?
    var fecha_final_publicacion: String
    var categoria_publicacion_id: Int
    var paginas: Int
    var eliminado: Int
    var fecha_modificacion: String
    var activo: Int
    
    override init() {
        self.publicacion_id = 0
        self.descripcion = ""
        self.fecha_inicial_publicacion = nil
        self.fecha_final_publicacion = ""
        self.categoria_publicacion_id = 0
        self.paginas = -1
        self.eliminado = 0
        self.fecha_modificacion = ""
        self.activo = 0
    }
    
    static func deserializaEvento(dato: String) -> PublicacionModel {
        let publicacion = PublicacionModel()
        let datesFormatter = DateFormatter()
        let defaultFormat = "dd/MM/yyyy HH:mm:ss"
        let initialPairs = dato.components(separatedBy: "|@")
        for valuesPairs in initialPairs {
            let val = valuesPairs.components(separatedBy: "@|")
            
            if(val[0] == "publicacion_id"){
                publicacion.publicacion_id = Int(val[1])!
            }
            else if(val[0] == "descripcion") {
                publicacion.descripcion = val[1]
            }
            else if(val[0] == "fecha_inicial_publicacion") {
                datesFormatter.dateFormat = defaultFormat
                let date = datesFormatter.date(from: val[1])
                publicacion.fecha_inicial_publicacion = date
            }
            else if(val[0] == "fecha_final_publicacion") {
                publicacion.fecha_final_publicacion = val[1]
            }
            else if(val[0] == "categoria_publicacion_id") {
                publicacion.categoria_publicacion_id = Int(val[1])!
            }
            else if(val[0] == "paginas") {
                publicacion.paginas = Int(val[1])!
            }
            else if(val[0] == "eliminado") {
                publicacion.eliminado = Int(val[1])!
            }
            else if(val[0] == "fecha_modificacion") {
                publicacion.fecha_modificacion = val[1]
            }
            else if(val[0] == "activo") {
                publicacion.activo = Int(val[1])!
            }
            
        }
        return publicacion
    }
}
