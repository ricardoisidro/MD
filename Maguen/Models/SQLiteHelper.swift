//
//  SQLiteHelper.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/13/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import Foundation
import SQLite

class SQLiteHelper
{
    
    static let shared = SQLiteHelper()
    //var database: Connection!
    
    init() {}
    //var database: Connection!
    
    func inicializa(nameBD: String) -> Connection {
        
        var database: Connection!
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent(nameBD).appendingPathExtension("sqlite3")
            database = try Connection(fileURL.path)
            
            
            //self.database = database
            //return database
            //self.onCreate(db: database)
        }
        catch let ex {
            //print("createDBFile error: \(ex)")
        }
        return database
    }
    
    func onCreate(db: Connection) {
        let usr = UsuarioApp()
        usr.onCreate(connection: db)
        let cred = Credencial()
        cred.onCreate(connection: db)
        let tels = Telefonos()
        tels.onCreate(connection: db)
    }
    
}
