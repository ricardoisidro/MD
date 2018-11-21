//
//  Constants.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import Foundation
import UIKit

struct MaguenColors {
    // Main screen blue color palette
    static let blue1 = UIColor(red:0.03, green:0.03, blue:0.16, alpha:1.0)
    static let blue2 = UIColor(red:0.04, green:0.09, blue:0.24, alpha:1.0)
    static let blue3 = UIColor(red:0.07, green:0.14, blue:0.33, alpha:1.0)
    static let blue4 = UIColor(red:0.02, green:0.20, blue:0.48, alpha:1.0)
    static let blue5 = UIColor(red:0.12, green:0.26, blue:0.57, alpha:1.0)
    static let blue6 = UIColor(red:0.21, green:0.36, blue:0.64, alpha:1.0)
    static let blue7 = UIColor(red:0.31, green:0.45, blue:0.73, alpha:1.0)
    static let blue8 = UIColor(red:0.44, green:0.56, blue:0.78, alpha:1.0)
    static let blue9 = UIColor(red:0.60, green:0.69, blue:0.85, alpha:1.0)
    
    //fondo principal ActivityTemplos
    static let black1 = UIColor(red:0.10, green:0.10, blue:0.11, alpha:1.0)
    //fondo recuadro central DetallesTemplosActivity y dialog (modal)
    static let black2 = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    //avisos
    static let gray1 = UIColor(red:0.26, green:0.27, blue:0.29, alpha:1.0)
    //expandableitem: #202020
    static let gray2 = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    
    //textos
    static let titlescolor = UIColor(red:0.24, green:0.71, blue:0.95, alpha:1.0)
    static let datescolor = UIColor(red:0.59, green:0.79, blue:0.89, alpha:1.0)
    
    static let white1 = [NSAttributedString.Key.foregroundColor:UIColor.white]
}

struct MaguenCredentials {
    static let key = "Expr3s10nB1n4r14"
    static let IV = "Expr3s10nB1n4r14"
    static let getUsuarioApp = "http://189.213.167.180/MaguenApp/wsMaguenApp.asmx?op=GetUsuarioApp"
    static let getSaldoActual = "http://189.213.167.180/MaguenApp/wsMaguenApp.asmx?op=GetSaldoActual"
    static let getModifyTables = "http://189.213.167.180/MaguenApp/wsMaguenApp.asmx?op=GetModifyTables"
}
