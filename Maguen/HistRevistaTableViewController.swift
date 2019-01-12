//
//  HistRevistaTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 1/11/19.
//  Copyright © 2019 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct historicorComponents {
    var hpImageR = UIImage()
    var hpTextR = String()
}


class HistRevistaTableViewController: UITableViewController {

    
    var tableViewData = [historicorComponents]()
    
    var revistaTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData =
            [historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista") ,hpTextR: "Revista Octubre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Noviembre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Diciembre"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Enero"),
             historicorComponents(hpImageR: #imageLiteral(resourceName: "img_revista"), hpTextR: "Revista Febrero")
        ]
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.tableView.backgroundColor = MaguenColors.black1
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }



    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hrevista") as! HistRevistaCell
        
        cell.imgHRevista.image = tableViewData[indexPath.row].hpImageR
        cell.imgHRevista.layer.cornerRadius = cell.imgHRevista.frame.size.width / 2
       
        cell.imgHRevista.clipsToBounds = true
        cell.imgHRevista.contentMode = .scaleAspectFill
        cell.textHRevista.text = tableViewData[indexPath.row].hpTextR
        
        
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        //print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "HistRevista", sender: tableViewData[indexPath.row].hpTextR)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //  guard let segueData = sender as? String
        //     else { return }
        
        // let controller = segue.destination as? SidurPageViewController
        // controller?.tipoRezo = segueData
        
        
        
        
    }

}
