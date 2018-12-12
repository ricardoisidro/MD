//
//  NotificationsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/15/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift

struct notificationsComponents {
    var notificationId = Int()
    var notificationTitle = String()
    var notificationDate = String()
    var notificationText = String()
}

class NotificationsTableViewController: UITableViewController {
    
    var tableViewData = [notificationsComponents]()

    @IBOutlet var notificationsTableView: UITableView!
    
    var dataTask: URLSessionDataTask?
    var mySession = URLSession.shared
    var currentParsingElement:String = ""
    var soapString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lastSyncDate = "01/01/1990 00:00:00"
        let communityArray = [1, 2, 3, 4, 5]
        let churchArray = [10, 11, 12, 13, 19, 20]
        let youthArray = [15, 18]
        let schoolArray = [14, 16, 17]
        let nr = NotificationRequest()
        nr.LastSinc = lastSyncDate
        nr.comunidad = communityArray
        nr.templos = churchArray
        nr.juventud = youthArray
        nr.colegios = schoolArray
        
        let aesJSON = AESforJSON()
        let chainEncodedandEncrypted = aesJSON.encodeAndEncryptJSONNotificationsString(request: nr)
        let soapXMLTables = Global.shared.createSOAPXMLString(methodName: "GetNotificaciones", encryptedString: chainEncodedandEncrypted)
        let soapRequest = CallSOAP()
        soapRequest.makeRequest(endpoint: MaguenCredentials.getNotificaciones, soapMessage: soapXMLTables)
        
        while !soapRequest.done {
            usleep(100000)
        }
        
        tableViewData = self.getNotifications(soapResult: soapRequest.soapResult)

        self.tableView.backgroundColor = MaguenColors.black1
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tableViewData.count > 0
        {
            self.tabBarItem.badgeValue = String(tableViewData.count)
            self.tabBarItem.badgeColor = .red
        }
        else {
            self.tabBarItem.badgeValue = nil
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if tableViewData.count > 0
        {
            self.tabBarItem.badgeValue = String(tableViewData.count)
            self.tabBarItem.badgeColor = .red
        }
        else {
            self.tabBarItem.badgeValue = nil
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTableView.dequeueReusableCell(withIdentifier: "notification") as! NotificationCell
        cell.notificationTitle.text = tableViewData[indexPath.row].notificationTitle
        cell.notificationTitle.font = UIFont.boldSystemFont(ofSize: 13.0)
        cell.notificationDate.text = tableViewData[indexPath.row].notificationDate
        cell.notificationDate.font = UIFont.systemFont(ofSize: 12.0)
        cell.notificationText.text = tableViewData[indexPath.row].notificationText
        cell.notificationText.font = UIFont.boldSystemFont(ofSize: 15.0)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableViewData.remove(at: indexPath.item)
            notificationsTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getNotifications(soapResult: String) -> [notificationsComponents] {
        var tablesToSync = [notificationsComponents]()
        do {
            
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            let decrypted = try soapResult.decryptBase64ToString(cipher: aes)
            
            let nr = try jsonDecoder.decode(NotificationResponse.self, from: Data(decrypted.utf8))
            
            let size = nr.Value.count
            print(size)
            if size > 0 {
                for i in 0...(size-1) {
                    let data = notificationsComponents(notificationId: nr.Value[i].id, notificationTitle: nr.Value[i].titulo, notificationDate: nr.Value[i].fecha_publicacion, notificationText: nr.Value[i].descripcion)
                    tablesToSync.append(data)
                }
                
            }
            return tablesToSync
            
        }
        catch let jsonErr{
            print("getTablesList error: \(jsonErr)")
        }
        return tablesToSync
        
    }
    
    //MARK:- Encode/decode methods
    
    func encodeAndEncryptJSONString(request: NotificationRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(request)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            cipherRequest = try aes.encrypt(Array(jsonString.utf8))
            
        }
        catch let err {
            print("encodeAndEncryptJSONString error: \(err)")
        }
        return cipherRequest
    }
    
    func updateAccount() {
        do {
            let jsonDecoder = JSONDecoder()
            let aes = try AES(key: Array(MaguenCredentials.key.utf8), blockMode: CBC(iv: Array(MaguenCredentials.IV.utf8)), padding: .pkcs7)
            var decrypted = try soapString.decryptBase64ToString(cipher: aes)
            _ = try jsonDecoder.decode(NotificationResponse.self, from: Data(decrypted.utf8))
        }
        catch let ex {
            print("updateNotifications error: \(ex)")
        }
    }

}
