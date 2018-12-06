//
//  NotificationResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 12/5/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

struct NotificationResponse: Decodable {
    var Value: [Value2] = [Value2]()
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
    
}

struct Value2: Decodable {
    var id: Int
    var titulo: String
    var descripcion: String
    var fecha_publicacion: String
}

/*struct NotificationResponse: Decodable {
    var id: Int
    var titulo: String
    var descripcion: String
    var fecha_publicacion: String
}*/
