//
//  HomeViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct cellComponents {
    var cellImage = UIImage()
    var cellColor = UIColor()
    var cellTitle = String()
}

class HomeViewController: UITableViewController {

    var tableViewData = [cellComponents]()
    var seguesIdentifiers = ["MediosDigitales", "Templos", "Eventos", "SuperEmet", "Kashrut"]
    //var seguesIdentifiers = ["MediosDigitales", "Templos", "Eventos", "SuperEmet", "Kashrut", "Escuelas", "Juventud", "Comites", "Directorio"]
    
    @IBOutlet var homeTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableViewData =
            [cellComponents(cellImage: #imageLiteral(resourceName: "icon_medios"), cellColor: MaguenColors.blue1, cellTitle: "MEDIOS DIGITALES"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_templos"), cellColor: MaguenColors.blue2, cellTitle: "TEMPLOS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_eventos"), cellColor: MaguenColors.blue3, cellTitle: "EVENTOS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_superemet"), cellColor: MaguenColors.blue4, cellTitle: "SUPER EMET"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_kmd"), cellColor: MaguenColors.blue5, cellTitle: "KASHRUT"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_escuelas"), cellColor: MaguenColors.blue6, cellTitle: "ESCUELAS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_juventud"), cellColor: MaguenColors.blue7, cellTitle: "JUVENTUD"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_directorio"), cellColor: MaguenColors.blue8, cellTitle: "DIRECTORIO")]
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCell
        cell.backgroundColor = tableViewData[indexPath.row].cellColor
        cell.imageCell.image = tableViewData[indexPath.row].cellImage
        cell.labelCell.text = tableViewData[indexPath.row].cellTitle
        cell.labelCell.font = UIFont.boldSystemFont(ofSize: 25.0)
        cell.labelCell.textColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 80.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        print("You tapped cell number \(indexPath.row).")
        homeTableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < 5 {
            performSegue(withIdentifier: seguesIdentifiers[indexPath.row], sender: self)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

}
