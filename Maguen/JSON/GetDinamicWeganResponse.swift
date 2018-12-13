//
//  GetDinamicWeganResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 12/13/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

struct GetDinamicWeganResponse: Decodable {
    var Value: String
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
}
