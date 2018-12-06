//
//  NotificationRequest.swift
//  Maguen
//
//  Created by ExpresionBinaria on 12/5/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation

class NotificationRequest: NSObject, Codable {
    var LastSinc: String
    var comunidad: [Int] = [Int]()
    var templos: [Int] = [Int]()
    var juventud: [Int] = [Int]()
    var colegios: [Int] = [Int]()
    
    override init() {
        self.LastSinc = ""
        self.comunidad = []
        self.templos = []
        self.juventud = []
        self.colegios = []
    }
}
