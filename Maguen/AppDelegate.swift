//
//  AppDelegate.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    
    var activityIndicator: UIActivityIndicatorView!
    
    var database: Connection!
    let db_categoria_centro = Table("categoria_centro")
    let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_centro = Table("centro")
    let db_centro_id = Expression<Int64>("centro_id")
    //let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    let db_imagen_portada = Expression<String>("imagen_portada")
    let db_nombre = Expression<String>("nombre")
    //let db_descripcion = Expression<String>("descripcion")
    let db_domicilio_centro_id = Expression<Int64>("domicilio_centro_id")
    let db_telefonos = Expression<String>("telefonos")
    let db_activo = Expression<Int64>("activo")
    let db_seccion_id = Expression<Int64>("seccion_id")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_eventos = Table("eventos")
    let db_evento_id = Expression<Int64>("evento_id")
    //let db_centro_id = Expression<Int64>("centro_id")
    let db_titulo = Expression<String>("titulo")
    let db_fecha_inicial_publicacion = Expression<Date>("fecha_inicial_publicacion")
    let db_fecha_final_publicacion = Expression<String>("fecha_final_publicacion")
    let db_horario = Expression<String>("horario")
    let db_imagen = Expression<String?>("imagen")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_comite = Table("comites")
    let db_comite_id = Expression<Int64>("comite_id")
    let db_nombre_comite = Expression<String>("nombre_comite")
    let db_telefono = Expression<String>("telefono")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_categoria_publicacion = Table("categoria_publicacion")
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    //let db_descripcion = Expression<String>("categoria_descripcion")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_publicacion = Table("publicacion")
    let db_publicacion_id = Expression<Int64>("publicacion_id")
    //let db_descripcion = Expression<String>("descripcion")
    //let db_fecha_inicial_publicacion = Expression<String>("fecha_inicial_publicacion")
    //let db_fecha_final_publicacion = Expression<String>("fecha_final_publicacion")
    //let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_paginas = Expression<Int64>("paginas")
    //var db_activo = Expression<Int64>("activo")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_comunidad = Table("comunidad")
    let db_comunidad_id = Expression<Int64>("comunidad_id")
    //let db_descripcion = Expression<String>("descripcion")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_horario_clase = Table("horario_clase")
    let db_horario_clase_id = Expression<Int64>("horario_clase")
    let db_clase_id = Expression<Int64>("clase_id")
    let db_profesor = Expression<String>("profesor")
    let db_dias = Expression<String>("dias")
    //let db_horario = Expression<String>("horario")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")

    let db_clases = Table("clases")
    let db_clases_id = Expression<Int64>("clase_id")
    //let db_descripcion = Expression<String>("descripcion")
    //var db_centro_id = Expression<Int64>("centro_id")

    let db_horarios_reso = Table("horarios_reso")
    let db_horarios_reso_id = Expression<Int64>("horarios_reso_id")
    //let db_centro_id = Expression<Int64>("centro_id")
    let db_tipo_reso_id = Expression<Int64>("tipo_reso_id")
    //let db_titulo = Expression<String>("titulo")
    //let db_horario = Expression<String>("horario")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_servicio_centro = Table("servicio_centro")
    let db_servicio_centro_id = Expression<Int64>("servicio_centro_id")
    //let db_servicio_id = Expression<Int64>("servicio_id")
    //let db_centro_id = Expression<Int64>("centro_id")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    let db_servicio = Table("servicio")
    let db_servicio_id = Expression<Int64>("servicio_id")
    //let db_descripcion = Expression<String>("descripcion")
    //let db_imagen = Expression<String?>("imagen")
    //let db_activo = Expression<Int64>("activo")
    //let db_categoria_centro_id = Expression<Int64>("categoria_centro_id")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")

    let db_domicilio = Table("domicilio")
    let db_domicilio_id = Expression<Int64>("domicilio_id")
    let db_calle = Expression<String>("calle")
    let db_numero_exterior = Expression<String>("numero_exterior")
    let db_numero_interior = Expression<String>("numero_interior")
    let db_cp = Expression<Int64>("cp")
    let db_colonia = Expression<String>("colonia")
    let db_delegacion_municipio = Expression<String>("delegacion_municipio")
    let db_estado = Expression<String>("estado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")

    let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")

    //MARK: - TabBarController delegate
    // This delegate open the modal view before open the desired view.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if viewController is CardController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 1
                return false
            }
        }
        else if viewController is NewSettingsViewController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                //tabBarController.selectedIndex = 4
                return false
                
                //192.168.1.171
            }
        }
        
        return true
    }
    
    // This delegate open the modal view after open the desired view.
    /*func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let validString = UserDefaults.standard.string(forKey: "name") ?? ""
        let sessionisEmpty = (validString == "")
        if viewController is CardController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                print("Pedir login antes de la credencial")
            }
        }
        else if viewController is NewSettingsViewController && sessionisEmpty {
            if let popUpVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AskLoginViewController") {
                tabBarController.present(popUpVC, animated: true)
                print("Pedir login antes de los ajustes")
            }
        }
    }*/

    //MARK: - App delegates
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        var lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        }
        catch let ex {
            print("createDBFile error: \(ex)")
        }
        
        onCreateCategoriaCentroDB()
        onCreateDomicilioDB()
        onCreateCentroDB()
        onCreateEventosDB()
        onCreateServicioDB()
        onCreateServicioCentroDB()
        onCreateHorarioResoDB()
        onCreateHorarioClaseDB()
        onCreateClasesDB()
        onCreateComiteDB()
        onCreateCategoriaPublicacionDB()
        onCreatePublicacionDB()
        onCreateComunidadDB()
        
        if (lastDate == nil) {
            UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
            lastDate = "01/01/1990 00:00:00"
        }
        else {
            UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
        }
        
        let aesJSON = AESforJSON()
        let chainTablesEncodedandEncrypted = aesJSON.encodeAndEncryptJSONTablesString(fecha: lastDate!)
        let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetModifyTables", encryptedString: chainTablesEncodedandEncrypted)
        
        let soapRequest = CallSOAP()
        soapRequest.makeRequest(endpoint: MaguenCredentials.getModifyTables, soapMessage: soapXMLTables)
        
        while !soapRequest.done {
            usleep(100000)
            
        }
        let tablesToSync = self.getTablesList(soapResult: soapRequest.soapResult)
        
        for tables in tablesToSync  {
            print("""


            \(tables)


            """)
            let chainIDsEncodedandEncrypted = aesJSON.encodeAndEncryptJSONIDsString(fecha: lastDate!, tableName: tables)
            let soapXMLIDs = Global.shared.createSOAPXMLString(methodName: "GetIDs", encryptedString: chainIDsEncodedandEncrypted)
            soapRequest.makeRequest(endpoint: MaguenCredentials.getModifyID, soapMessage: soapXMLIDs)
            while !soapRequest.done {
                usleep(100000)
                
            }
            let idsToSync = self.getIDList(soapResult: soapRequest.soapResult)
            for ids in idsToSync{
                //print(ids)
                let chainEntityEncodedAndEncrypted = aesJSON.encodeAndEncryptJSONEntityString(tableName: tables, id: ids)
                let soapXMLEntities = Global.shared.createSOAPXMLString(methodName: "GetEntidad", encryptedString: chainEntityEncodedAndEncrypted)
                soapRequest.makeRequest(endpoint: MaguenCredentials.getEntidad, soapMessage: soapXMLEntities)
                while !soapRequest.done {
                    usleep(100000)
                }
                let entitiesToSync = self.getEntitiesList(soapResult: soapRequest.soapResult, table: tables)
                //_ = self.getEntitiesList(soapResult: soapRequest.soapResult, table: tables)
                print(entitiesToSync)
            }
        }
        
        //let currentDate2 = Date()
        //let dateFormat = DateFormatter()
        //dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
        //print(dateFormat.string(from: currentDate2))
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getTablesList(soapResult: String) -> [String] {
        var tablesToSync: [String] = [String]()
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let modifyTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            tablesToSync = modifyTablesResult.Value.components(separatedBy: ",")
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        return tablesToSync
        
    }
    
    func getIDList(soapResult: String) -> [String]{
        var idToSync: [String] = []
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let idTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            
            idToSync = idTablesResult.Value.components(separatedBy: "@")
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        
        return idToSync
    }
    
    func getEntitiesList(soapResult: String, table: String) -> String{
        var entitiesToSync: String = ""
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let entityTablesResult = try jsonDecoder.decode(GetModifyTablesResponse.self, from: Data(decrypted.utf8))
            
            entitiesToSync = entityTablesResult.Value
            
            if(table == "categoria_centro") {
                let ccm = CategoriaCentroModel.deserializaCategoriaCentro(dato: entitiesToSync)
                onInsertCategoriaCentroDB(objeto: ccm)
            }
            else if(table == "domicilio") {
                let d = DomicilioModel.deserializaCentro(dato: entitiesToSync)
                onInsertDomicilioDB(objeto: d)
            }
            else if(table == "centro") {
                let c = CentroModel.deserializaCentro(dato: entitiesToSync)
                onInsertCentroDB(objeto: c)
            }
            else if(table == "eventos") {
                let e = EventosModel.deserializaEvento(dato: entitiesToSync)
                onInsertEventosDB(objeto: e)
            }
            else if(table == "servicio") {
                let s = ServicioModel.deserializaCentro(dato: entitiesToSync)
                onInsertServicioDB(objeto: s)
            }
            else if(table == "servicio_centro") {
                let sc = ServicioCentroModel.deserializaEvento(dato: entitiesToSync)
                onInsertServicioCentroDB(objeto: sc)
            }
            else if(table == "horarios_reso") {
                let hr = HorarioResoModel.deserializaEvento(dato: entitiesToSync)
                onInsertHorarioResoDB(objeto: hr)
            }
            else if(table == "clases") {
                let c = ClasesModel.deserializaEvento(dato: entitiesToSync)
                onInsertClasesDB(objeto: c)
            }
            else if(table == "horario_clase") {
                let h = HorarioClaseModel.deserializaEvento(dato: entitiesToSync)
                onInsertHorarioClaseDB(objeto: h)
            }
            else if(table == "comites") {
                let c = ComiteModel.deserializaEvento(dato: entitiesToSync)
                onInsertComiteDB(objeto: c)
            }
            else if(table == "categoria_publicacion") {
                let cp = CategoriaPublicacionModel.deserializaEvento(dato: entitiesToSync)
                onInsertCategoriaPublicacionDB(objeto: cp)
            }
            else if(table == "publicacion") {
                let p = PublicacionModel.deserializaEvento(dato: entitiesToSync)
                onInsertPublicacionDB(objeto: p)
            }
            else if(table == "comunidad") {
                let c = ComunidadModel.deserializaEvento(dato: entitiesToSync)
                onInsertComunidadDB(objeto: c)
            }
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        
        return entitiesToSync
    }
    
    func onCreateCategoriaCentroDB() {
        
        do {
            let db = database
            try db!.run(db_categoria_centro.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(db_categoria_centro_id, primaryKey: true) //     "id" TEXT PRIMARY KEY NOT NULL,
                t.column(db_descripcion)  //     "descripcion" TEXT,
                t.column(db_eliminado)   //      "eliminado" TEXT,
                t.column(db_fecha_modificacion)//"fecha_modificacion" TEXT
            })
        }
        catch let ex {
            print("onCreateCategoriaCentro SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCategoriaCentroDB(objeto: CategoriaCentroModel) {
        do {
            let db = database
            let insert = db_categoria_centro.insert(or: .replace,
                                                    db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                                    db_descripcion <- objeto.descripcion!,
                                                    db_eliminado <- Int64(objeto.eliminado!),
                                                    db_fecha_modificacion <- objeto.fecha_modificacion!)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertCategoriaCentro Error: \(ex)")
        }
        
    }
    
    func onCreateCentroDB() {
        
        do {
            let db = database
            try db!.run(db_centro.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
                t.column(db_centro_id, primaryKey: true)
                t.column(db_categoria_centro_id) //     "id" TEXT PRIMARY KEY NOT NULL,
                t.column(db_imagen_portada)  //     "descripcion" TEXT,
                t.column(db_nombre)   //      "eliminado" TEXT,
                t.column(db_descripcion)//"fecha_modificacion" TEXT
                t.column(db_domicilio_centro_id)
                t.column(db_telefonos)
                t.column(db_activo)
                t.column(db_seccion_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateCentroDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCentroDB(objeto: CentroModel) {
        do {
            let db = database
            let insert = db_centro.insert(or: .replace, db_centro_id <- Int64(objeto.centro_id),
                                                    db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                                    db_imagen_portada <- objeto.imagen_portada!,
                                                    db_nombre <- objeto.nombre,
                                                    db_descripcion <- objeto.descripcion,
                                                    db_domicilio_centro_id <- Int64(objeto.domicilio_centro_id),
                                                    db_telefonos <- objeto.telefonos!,
                                                    db_activo <- Int64(objeto.activo),
                                                    db_seccion_id <- Int64?(objeto.seccion_id!)!,
                                                    db_eliminado <- Int64(objeto.eliminado),
                                                    db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertCentroDBError: \(ex)")
        }
        
    }
    
    func onCreateEventosDB() {
        
        do {
            let db = database
            try db!.run(db_eventos.create(ifNotExists: true) { t in
                t.column(db_evento_id, primaryKey: true)
                t.column(db_centro_id)
                t.column(db_titulo)
                t.column(db_fecha_inicial_publicacion)
                t.column(db_fecha_final_publicacion)
                t.column(db_horario)
                t.column(db_imagen)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateEventosDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertEventosDB(objeto: EventosModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let defaultDateTime = formatter.date(from: "01/01/1990 00:00:00")
        
        do {
            let db = database
            let insert = db_eventos.insert(or: .replace,
                                           db_evento_id <- Int64(objeto.evento_id),
                                          db_centro_id <- Int64(objeto.centro_id),
                                          db_titulo <- objeto.titulo,
                                          db_fecha_inicial_publicacion <- objeto.fecha_inicial_publicacion ?? defaultDateTime!,
                                          db_fecha_final_publicacion <- objeto.fecha_final_publicacion,
                                          db_horario <- objeto.horario,
                                          db_imagen <- objeto.imagen!,
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertCentroDBError: \(ex)")
        }
        
    }
    
    func onCreateComiteDB() {
        
        do {
            let db = database
            try db!.run(db_comite.create(ifNotExists: true) { t in
                t.column(db_comite_id, primaryKey: true)
                t.column(db_nombre_comite)
                t.column(db_telefono)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateComitesDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertComiteDB(objeto: ComiteModel) {
        do {
            let db = database
            let insert = db_comite.insert(or: .replace,
                                           db_comite_id <- Int64(objeto.comite_id),
                                           db_nombre_comite <- objeto.nombre_comite,
                                           db_telefono <- objeto.telefono,
                                           db_eliminado <- Int64(objeto.eliminado),
                                           db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertComiteDBError: \(ex)")
        }
        
    }
    
    func onCreateCategoriaPublicacionDB() {
        
        do {
            let db = database
            try db!.run(db_categoria_publicacion.create(ifNotExists: true) { t in
                t.column(db_categoria_publicacion_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateCategoriaPublicacionDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertCategoriaPublicacionDB(objeto: CategoriaPublicacionModel) {
        do {
            let db = database
            let insert = db_categoria_publicacion.insert(or: .replace,
                                          db_categoria_publicacion_id <- Int64(objeto.categoria_publicacion_id),
                                          db_descripcion <- objeto.descripcion,
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertCategoriaPublicacionDBError: \(ex)")
        }
        
    }
    
    func onCreatePublicacionDB() {
        
        do {
            let db = database
            try db!.run(db_publicacion.create(ifNotExists: true) { t in
                t.column(db_publicacion_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_fecha_inicial_publicacion)
                t.column(db_fecha_final_publicacion)
                t.column(db_categoria_publicacion_id)
                t.column(db_paginas)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
                t.column(db_activo)
            })
        }
        catch let ex {
            print("onCreatePublicacionDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertPublicacionDB(objeto: PublicacionModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let defaultDateTime = formatter.date(from: "01/01/1990 00:00:00")
        do {
            let db = database
            let insert = db_publicacion.insert(or: .replace,
                                                         db_publicacion_id <- Int64(objeto.publicacion_id),
                                                         db_descripcion <- objeto.descripcion,
                                                         db_fecha_inicial_publicacion <- objeto.fecha_inicial_publicacion ?? defaultDateTime!,
                                                         db_fecha_final_publicacion <- objeto.fecha_final_publicacion,
                                                         db_categoria_publicacion_id <- Int64(objeto.categoria_publicacion_id),
                                                         db_paginas <- Int64(objeto.paginas),
                                                         db_eliminado <- Int64(objeto.eliminado),
                                                         db_fecha_modificacion <- objeto.fecha_modificacion,
                                                         db_activo <- Int64(objeto.activo))
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertPublicacionDBError: \(ex)")
        }
        
    }
    
    func onCreateComunidadDB() {
        
        do {
            let db = database
            try db!.run(db_comunidad.create(ifNotExists: true) { t in
                t.column(db_comunidad_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateComunidadDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertComunidadDB(objeto: ComunidadModel) {
        do {
            let db = database
            let insert = db_comunidad.insert(or: .replace,
                                                         db_comunidad_id <- Int64(objeto.comunidad_id),
                                                         db_descripcion <- objeto.descripcion,
                                                         db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertComunidadDBError: \(ex)")
        }
        
    }
    
    func onCreateHorarioClaseDB() {
        
        do {
            let db = database
            try db!.run(db_horario_clase.create(ifNotExists: true) { t in
                t.column(db_horario_clase_id, primaryKey: true)
                t.column(db_clase_id)
                t.column(db_profesor)
                t.column(db_dias)
                t.column(db_horario)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateHorarioClaseDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertHorarioClaseDB(objeto: HorarioClaseModel) {
        do {
            let db = database
            let insert = db_horario_clase.insert(or: .replace,
                                             db_horario_clase_id <- Int64(objeto.horario_clase_id),
                                             db_clase_id <- Int64(objeto.clase_id),
                                             db_profesor <- objeto.profesor,
                                             db_dias <- objeto.dias,
                                             db_horario <- objeto.horario,
                                             db_eliminado <- Int64(objeto.eliminado),
                                             db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertHorarioClaseDBError: \(ex)")
        }
        
    }
    
    func onCreateClasesDB() {
        
        do {
            let db = database
            try db!.run(db_clases.create(ifNotExists: true) { t in
                t.column(db_clase_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateComunidadDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertClasesDB(objeto: ClasesModel) {
        do {
            let db = database
            let insert = db_clases.insert(or: .replace,
                                             db_clase_id <- Int64(objeto.clase_id),
                                             db_descripcion <- objeto.descripcion,
                                             db_centro_id <- Int64(objeto.centro_id),
                                             db_eliminado <- Int64(objeto.eliminado),
                                             db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertComunidadDBError: \(ex)")
        }
        
    }
    
    func onCreateHorarioResoDB() {
        
        do {
            let db = database
            try db!.run(db_horarios_reso.create(ifNotExists: true) { t in
                t.column(db_horarios_reso_id, primaryKey: true)
                t.column(db_centro_id)
                t.column(db_tipo_reso_id)
                t.column(db_titulo)
                t.column(db_horario)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateHorarioResoDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertHorarioResoDB(objeto: HorarioResoModel) {
        do {
            let db = database
            let insert = db_horarios_reso.insert(or: .replace,
                                                 db_horarios_reso_id <- Int64(objeto.horarios_reso_id),
                                                 db_centro_id <- Int64(objeto.centro_id),
                                                 db_tipo_reso_id <- Int64(objeto.tipo_reso_id),
                                                 db_titulo <- objeto.titulo,
                                                 db_horario <- objeto.horario,
                                                 db_eliminado <- Int64(objeto.eliminado),
                                                 db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertHorarioResoDBError: \(ex)")
        }
        
    }
    
    func onCreateServicioCentroDB() {
        
        do {
            let db = database
            try db!.run(db_servicio_centro.create(ifNotExists: true) { t in
                t.column(db_servicio_centro_id, primaryKey: true)
                t.column(db_servicio_id)
                t.column(db_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateServicioCentroDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertServicioCentroDB(objeto: ServicioCentroModel) {
        do {
            let db = database
            let insert = db_servicio_centro.insert(or: .replace,
                                                 db_servicio_centro_id <- Int64(objeto.servicio_centro_id),
                                                 db_servicio_id <- Int64(objeto.servicio_id),
                                                 db_centro_id <- Int64(objeto.centro_id),
                                                 db_eliminado <- Int64(objeto.eliminado),
                                                 db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertServicioCentroDBError: \(ex)")
        }
        
    }
    
    func onCreateServicioDB() {
        
        do {
            let db = database
            try db!.run(db_servicio.create(ifNotExists: true) { t in
                t.column(db_servicio_id, primaryKey: true)
                t.column(db_descripcion)
                t.column(db_imagen)
                t.column(db_activo)
                t.column(db_categoria_centro_id)
                t.column(db_eliminado)
                t.column(db_fecha_modificacion)
            })
        }
        catch let ex {
            print("onCreateServicioDB SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertServicioDB(objeto: ServicioModel) {
        do {
            let db = database
            let insert = db_servicio.insert(or: .replace,
                                          db_servicio_id <- Int64(objeto.servicio_id),
                                          db_descripcion <- objeto.descripcion,
                                          db_imagen <- objeto.imagen,
                                          db_categoria_centro_id <- Int64(objeto.categoria_centro_id),
                                          db_activo <- Int64(objeto.activo!),
                                          db_eliminado <- Int64(objeto.eliminado),
                                          db_fecha_modificacion <- objeto.fecha_modificacion)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertServicioDBError: \(ex)")
        }
        
    }
    
    func onCreateDomicilioDB() {
        
        do {
            let db = database
            try db!.run(db_domicilio.create(ifNotExists: true) { t in
                t.column(db_domicilio_id, primaryKey: true)
                t.column(db_calle)
                t.column(db_numero_exterior)
                t.column(db_numero_interior)
                t.column(db_cp)
                t.column(db_colonia)
                t.column(db_delegacion_municipio)
                t.column(db_estado)
                t.column(db_fecha_modificacion)//"fecha_modificacion" TEXT
            })
        }
        catch let ex {
            print("onCreateCategoriaCentro SQLite exception: \(ex)")
        }
        
    }
    
    func onInsertDomicilioDB(objeto: DomicilioModel) {
        do {
            let db = database
            let insert = db_domicilio.insert(or: .replace,
                                                    db_domicilio_id <- Int64(objeto.domicilio_id),
                                                    db_calle <- objeto.calle,
                                                    db_numero_exterior <- objeto.numero_exterior,
                                                    db_numero_interior <- objeto.numero_interior,
                                                    db_cp <- Int64(objeto.cp!),
                                                    db_colonia <- objeto.colonia,
                                                    db_delegacion_municipio <- objeto.delegacion_municipio,
                                                    db_estado <- objeto.estado,
                                                    db_fecha_modificacion <- objeto.fecha_modificacion!)
            try db!.run(insert)
        }
        catch let ex {
            print("onInsertCategoriaCentro Error: \(ex)")
        }
        
    }
    
}

