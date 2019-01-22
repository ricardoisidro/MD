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
    
    /*let db_categoria_centro = Table("categoria_centro")
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
    
    let table_eventos = Table("eventos")
    let db_evento_id = Expression<Int64>("evento_id")
    let db_titulo = Expression<String?>("titulo")
    let db_fecha_inicial_publicacion = Expression<Date?>("fecha_inicial_publicacion")
    let db_fecha_final_publicacion = Expression<Date?>("fecha_final_publicacion")
    let db_horario = Expression<String?>("horario")
    let db_imagen = Expression<String?>("imagen")
    /*
    let db_eventos = Table("eventos")
    let db_evento_id = Expression<Int64>("evento_id")
    //let db_centro_id = Expression<Int64>("centro_id")
    let db_titulo = Expression<String>("titulo")
    let db_fecha_inicial_publicacion = Expression<Date>("fecha_inicial_publicacion")
    let db_fecha_final_publicacion = Expression<Date>("fecha_final_publicacion")
    let db_horario = Expression<String>("horario")
    let db_imagen = Expression<String?>("imagen")
    //let db_eliminado = Expression<Int64>("eliminado")
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")*/
    
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
    
    let table_publicacion = Table("publicacion")
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
    //let db_fecha_modificacion = Expression<String>("fecha_modificacion")*/
    
    let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
    
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    var termineSincronizacion = false

    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //progress.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
        
        txtVersion.text = nsObject as? String
        
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
            
            let currentDate = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MM/yyyy HH:mm:ss"
            let currDate = dateFormat.string(from: currentDate)
            UserDefaults.standard.set(currDate, forKey: "dateLastSync")
            
            self.termineSincronizacion = true
            
            self.main {
                if self.termineSincronizacion {
                    self.showActivityIndicator(show: !self.termineSincronizacion)
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let controller = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                     self.present(controller, animated: false, completion: nil)
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
            print("getTablesList error: \(jsonErr)")
        }
        
        return entitiesToSync
    }

}
