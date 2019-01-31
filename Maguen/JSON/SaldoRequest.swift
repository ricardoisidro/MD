//
//  SaldoRequest.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/20/18.
//  Copyright © 2018 Expression B. All rights reserved.
//
import Foundation

class SaldoRequest : NSObject, Codable {
    var usuario: String?
    
    override init() {
        self.usuario = ""
    }
}
