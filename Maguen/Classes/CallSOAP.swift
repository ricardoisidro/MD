//
//  CallSOAP.swift
//  Maguen
//
//  Created by ExpresionBinaria on 11/21/18.
//  Copyright © 2018 Expression B. All rights reserved.
//
import CryptoSwift

class CallSOAP : NSObject, XMLParserDelegate {
    
    var dataTask: URLSessionDataTask?
    let mySession = URLSession.shared
    var parser = XMLParser()
    var currentParsingElement:String = ""
    var soapResult:String = ""
    var tablesToSync: [String] = [String]()
    var idToSync: [String] = [String]()
    var done: Bool = false

    var parseType: String = ""
    var parseResult: String = ""
    
    func makeRequest(endpoint: String, soapMessage: String) {
        //Prepare request
        self.done = false
        if endpoint.contains("GetModifyTables") {
            parseType = "GetModifyTablesResponse"
            parseResult = "GetModifyTablesResult"
        }
        else if endpoint.contains("GetIDs"){
            parseType = "GetIDsResponse"
            parseResult = "GetIDsResult"
        }
        else if endpoint.contains("GetEntidad"){
            parseType = "GetEntidadResponse"
            parseResult = "GetEntidadResult"
        }
        else if endpoint.contains("GetNotificaciones"){
            parseType = "GetNotificacionesResponse"
            parseResult = "GetNotificacionesResult"
        }
        
        let url = URL(string: endpoint)
        let req = NSMutableURLRequest(url: url!)
        let msgLength = soapMessage.count
        req.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        req.httpMethod = "POST"
        req.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //Make the request
        //dataTask?.cancel()
        dataTask = mySession.dataTask(with: req as URLRequest ) { (data, response, error) in
            defer {
                self.dataTask = nil
            }
            guard let data = data else {
                self.done = true
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        dataTask?.resume()
    }
    
    //MARK:- XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "GetModifyTables" {
            //print("Started parsing modifytables...")
        } else if elementName == "GetIDs" {
            //print("Started parsing ids...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == parseResult {
                self.soapResult = ""
                self.soapResult += foundedChar
            }
            else {
                self.soapResult += "nothing"
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == parseType {
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.done = true
        /*DispatchQueue.main.async {
            if(self.parseType == "GetModifyTablesResponse") {
                self.getTablesList()
            }
            else if(self.parseType == "GetIDs"){
                self.getIDList()
            }
            
        }*/
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
        print("parseErrorOccurred: \(parseError)")
    }
}
