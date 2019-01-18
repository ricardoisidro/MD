//
//  DetallesSaldoViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/13/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import UIKit
import SQLite
import CryptoSwift

class DetallesSaldoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let conn = SQLiteHelper.shared.inicializa(nameBD: "maguen")
    @IBOutlet weak var tableViewSaldos: UITableView!
    @IBOutlet weak var txtSaldo: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    var contenido: [Value3] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnClose.layer.cornerRadius = 10
        btnClose.layer.masksToBounds = true
        
        //self.tableViewSaldos =

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        
        let tabBarController = self.presentingViewController as? UITabBarController
        
        
        
        self.dismiss(animated: true) {
            let _ = tabBarController?.selectedIndex = 4
        }
      
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        txtSaldo.text = UserDefaults.standard.string(forKey: "balance") ?? ""
        
        let u = UsuarioApp()
        let res = u.onReadData(connection: conn)
        let user = res.usuario
    
        let aes = AESforJSON()
        let chainEncoded = aes.encodeAndEncryptJSONConsultarSaldo(objeto: user!)
        
        
        let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetSaldos", encryptedString: chainEncoded)
        
        let soapRequest = CallSOAP()
        soapRequest.makeRequest(endpoint: MaguenCredentials.getSaldos, soapMessage: soapXMLTables)
        
        while !soapRequest.done {
            usleep(100000)
            
        }
        
        let res2 = aes.decodeAndEncryptJSONConsultarSaldo(soapResult: soapRequest.soapResult)
    
        if res2.Correcto {
            
            for celda in res2.Value {
                contenido.append(celda)
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contenido.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detallesaldo") as! DetalleSaldoCellTableViewCell
        
        cell.textFactura.text = contenido[indexPath.row].DNUM
        cell.textDescripcion.text = contenido[indexPath.row].IDESCR
        let fechaCorta = contenido[indexPath.row].DFECHA.prefix(10)
        cell.textFecha.text = String(fechaCorta)
        let vencCorto = contenido[indexPath.row].DVENCE.prefix(10)
        cell.textVencimiento.text = String(vencCorto)
        
        cell.textMonto.text = "$ " + String(contenido[indexPath.row].DCANT)
        //cell.
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

