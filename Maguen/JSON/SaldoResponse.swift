//
//  SaldoResponse.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/20/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

struct SaldoResponse : Decodable {
    var Value: String
    var Correcto: Bool
    var MensajeError: String
    var ex: String?
    var Incorrecto: Bool
}
