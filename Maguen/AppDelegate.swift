//
//  AppDelegate.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, XMLParserDelegate {

    var window: UIWindow?
    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    var currentParsingElement:String = ""
    var soapString:String = ""
    

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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if (UserDefaults.standard.object(forKey: "dateLastSync") == nil) {
            UserDefaults.standard.set("01/01/1990 00:00:00", forKey: "dateLastSync")
        }
        else {
            
        }
        
        let lastDate = UserDefaults.standard.string(forKey: "dateLastSync")
        let getModifyTablesRequest = GetModifyTablesRequest(FechaSincronizacion: lastDate!)
        print(getModifyTablesRequest)
        let chainEncodedandEncrypted = encodeAndEncryptJSONString(GetModifyTablesRequest: getModifyTablesRequest)
        
        print(chainEncodedandEncrypted.toBase64()!)
        
        let soapMessage =
        "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><GetModifyTables xmlns='http://tempuri.org/'><Cadena>\(chainEncodedandEncrypted.toBase64()!)</Cadena><Token></Token></GetModifyTables></soap:Body></soap:Envelope>"
        
        //Prepare request
        let url = URL(string: MaguenCredentials.getModifyTables)
        let req = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        req.httpMethod = "POST"
        req.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //Make the request
        dataTask?.cancel()
        dataTask = mySession.dataTask(with: req as URLRequest) { (data, response, error) in
            defer { self.dataTask = nil }
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        dataTask?.resume()
        
        
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
        print("Hi, Im back")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func encodeAndEncryptJSONString(GetModifyTablesRequest: GetModifyTablesRequest) -> Array<UInt8> {
        var cipherRequest: [UInt8] = []
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(GetModifyTablesRequest)
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
}

