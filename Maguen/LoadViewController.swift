//
//  LoadViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 12/18/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite
import CryptoSwift

class LoadViewController: UIViewController {

    @IBOutlet weak var txtVersion: UILabel!
    
    var progress: UIActivityIndicatorView!
    
    var database: Connection!
    
    let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    var termineSincronizacion = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        
        txtVersion.text = nsObject as? String
        
        
        let flag = UserDefaults.standard.bool(forKey: "loginOk")
            
        Global.shared.loginOk = flag
        
        self.showActivityIndicator()

        background {
            
            
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
            
            
            
            if (lastDate == nil) {
                UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
                lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
                let catcen = CategoriaCentroModel()
                catcen.onCreateCategoriaCentroDB(connection: self.database)
                //self.onCreateDomicilioDB()
                let dom = DomicilioModel()
                dom.onCreateDomicilioDB(connection: self.database)
                let c = CentroModel()
                c.onCreateCentroDB(connection: self.database)
                let ev = EventosModel()
                ev.onCreateEventosDB(connection: self.database)
                //self.onCreateServicioDB()
                let serv = ServicioModel()
                serv.onCreateServicioDB(connection: self.database)
                let serc = ServicioCentroModel()
                serc.onCreateServicioCentroDB(connection: self.database)
                //self.onCreateServicioCentroDB()
                let hr = HorarioResoModel()
                hr.onCreateHorarioResoDB(connection: self.database)
                let hc = HorarioClaseModel()
                hc.onCreateHorarioClaseDB(connection: self.database)
                let clas = ClasesModel()
                clas.onCreateClasesDB(connection: self.database)
                let com = ComiteModel()
                com.onCreateComiteDB(connection: self.database)
                let catp = CategoriaPublicacionModel()
                catp.onCreateCategoriaPublicacionDB(connection: self.database)
                let pub = PublicacionModel()
                pub.onCreatePublicacionDB(connection: self.database)
                let comu = ComunidadModel()
                comu.onCreateComunidadDB(connection: self.database)
            }
            else {
                
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
            
            if tablesToSync != [""] {
                for tables in tablesToSync  {
                    /*//print("""
                     
                     
                     \(tables)
                     
                     
                     """)*/
                    let chainIDsEncodedandEncrypted = aesJSON.encodeAndEncryptJSONIDsString(fecha: lastDate!, tableName: tables)
                    let soapXMLIDs = Global.shared.createSOAPXMLString(methodName: "GetIDs", encryptedString: chainIDsEncodedandEncrypted)
                    soapRequest.makeRequest(endpoint: MaguenCredentials.getModifyID, soapMessage: soapXMLIDs)
                    while !soapRequest.done {
                        usleep(100000)
                        
                    }
                    let idsToSync = self.getIDList(soapResult: soapRequest.soapResult)
                    for ids in idsToSync{
                        let chainEntityEncodedAndEncrypted = aesJSON.encodeAndEncryptJSONEntityString(tableName: tables, id: ids)
                        let soapXMLEntities = Global.shared.createSOAPXMLString(methodName: "GetEntidad", encryptedString: chainEntityEncodedAndEncrypted)
                        soapRequest.makeRequest(endpoint: MaguenCredentials.getEntidad, soapMessage: soapXMLEntities)
                        while !soapRequest.done {
                            usleep(100000)
                        }
                        //let entitiesToSync = self.getEntitiesList(soapResult: soapRequest.soapResult, table: tables)
                        _ = self.getEntitiesList(soapResult: soapRequest.soapResult, table: tables)
                        //print(entitiesToSync)
                    }
                }
            }
            else {
                
            }
            
            if Global.shared.sincroniceOK {
                let currentDate = Date()
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
                let currDate = dateFormat.string(from: currentDate)
                UserDefaults.standard.set(currDate, forKey: "dateLastSync")
                self.termineSincronizacion = true

            }
            
            
            self.main {
                if Global.shared.sincroniceOK {
                    if self.termineSincronizacion {
                        self.showActivityIndicator(show: !self.termineSincronizacion)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller, animated: false, completion: nil)
                    }
                }
                else {
                    let fecha = UserDefaults.standard.string(forKey: "dateLastSync")
                    if (fecha != nil) || (fecha != "01/01/1990 00:00:00") {
                        self.showActivityIndicator(show: !self.termineSincronizacion)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(controller, animated: false, completion: nil)
                    }
                    else {
                        let ac = UIAlertController(title: "Maguén David A.C.", message: "No se pudo sincronizar contenido ¿Que desea hacer?", preferredStyle: .alert)
                        let resetApp = UIAlertAction(title: "Intentar mas tarde", style: .destructive) {
                            (alert) -> Void in
                            // home button pressed programmatically - to thorw app to background
                            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                            // terminaing app in background
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                exit(EXIT_SUCCESS)
                            })
                        }
                        ac.addAction(UIAlertAction(title: "Reintentar", style: .default) {
                            (alert) -> Void in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "LoadViewController")
                            self.present(controller, animated: false, completion: nil)
                        })
                        ac.addAction(resetApp)
                        self.present(ac, animated: true)
                    }
                    
                }
                
            }
        }
        
    }

    
    func background(work: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            work()
        }
    }
    
    func main(work: @escaping () -> ()) {
        DispatchQueue.main.async {
            work()
        }
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            // Start the loading animation
            indicator.startAnimating()
        } else {
            // Stop the loading animation
            indicator.stopAnimating()
        }
    }
    
    func showActivityIndicator() {
        
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.color = .white
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
            
        
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
            print("getIDList error: \(jsonErr)")
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
                let ccm = CategoriaCentroModel()
                let info = ccm.deserializaCategoriaCentro(dato: entitiesToSync)
                ccm.onInsertCategoriaCentroDB(connection: self.database, objeto: info)
            }
            else if(table == "domicilio") {
                let dom = DomicilioModel()
                let info = dom.deserializaCentro(dato: entitiesToSync)
                dom.onInsertDomicilioDB(connection: self.database, objeto: info)
                //let d = DomicilioModel.deserializaCentro(dato: entitiesToSync)
                //onInsertDomicilioDB(objeto: d)
            }
            else if(table == "centro") {
                let c = CentroModel()
                let info = c.deserializaCentro(dato: entitiesToSync)
                c.onInsertCentroDB(objeto: info, connection: self.database)
            }
            else if(table == "eventos") {
                let e = EventosModel()
                let info = e.deserializaEvento(dato: entitiesToSync)
                e.onInsertEventosDB(connection: self.database, objeto: info)
            }
            else if(table == "servicio") {
                let s = ServicioModel()
                let info = s.deserializaCentro(dato: entitiesToSync)
                s.onInsertServicioDB(connection: self.database, objeto: info)
                //let s = ServicioModel.deserializaCentro(dato: entitiesToSync)
                //onInsertServicioDB(objeto: s)
            }
            else if(table == "servicio_centro") {
                let sc = ServicioCentroModel()
                let info = sc.deserializaEvento(dato: entitiesToSync)
                sc.onInsertServicioCentroDB(connection: self.database, objeto: info)
                //let sc = ServicioCentroModel.deserializaEvento(dato: entitiesToSync)
                //onInsertServicioCentroDB(objeto: sc)
            }
            else if(table == "horarios_reso") {
                let hr = HorarioResoModel()
                let info = hr.deserializaEvento(dato: entitiesToSync)
                hr.onInsertHorarioResoDB(connection: self.database, objeto: info)
                //let hr = HorarioResoModel.deserializaEvento(dato: entitiesToSync)
                //onInsertHorarioResoDB(objeto: hr)
            }
            else if(table == "clases") {
                let clas = ClasesModel()
                let info = clas.deserializaEvento(dato: entitiesToSync)
                clas.onInsertClasesDB(connection: self.database, objeto: info)
                //let c = ClasesModel.deserializaEvento(dato: entitiesToSync)
                //onInsertClasesDB(objeto: c)
            }
            else if(table == "horario_clase") {
                let h = HorarioClaseModel()
                let info = h.deserializaEvento(dato: entitiesToSync)
                h.onInsertHorarioClaseDB(connection: self.database, objeto: info)
                //let h = HorarioClaseModel.deserializaEvento(dato: entitiesToSync)
                //onInsertHorarioClaseDB(objeto: h)
            }
            else if(table == "comites") {
                let c = ComiteModel()
                let info = c.deserializaEvento(dato: entitiesToSync)
                c.onInsertComiteDB(connection: self.database, objeto: info)
                
            }
            else if(table == "categoria_publicacion") {
                let catp = CategoriaPublicacionModel()
                let info = catp.deserializaEvento(dato: entitiesToSync)
                catp.onInsertCategoriaPublicacionDB(connection: self.database, objeto: info)
                
            }
            else if(table == "publicacion") {
                let pub = PublicacionModel()
                let info = pub.deserializaEvento(dato: entitiesToSync)
                pub.onInsertPublicacionDB(connection: self.database, objeto: info)
                
            }
            else if(table == "comunidad") {
                let com = ComunidadModel()
                let info = com.deserializaEvento(dato: entitiesToSync)
                com.onInsertComunidadDB(connection: self.database, objeto: info)
                
            }
            
        }
        catch let jsonErr{
            print("getEntitiesList error: \(jsonErr)")
        }
        
        return entitiesToSync
    }

}
