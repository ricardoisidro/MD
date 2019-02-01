//
//  HomeViewController.swift
//  Maguen
//
//  Created by Ricardo Isidro on 10/11/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

struct cellComponents {
    var cellImage = UIImage()
    var cellColor = UIColor()
    var cellTitle = String()
}

class HomeViewController: UITableViewController {

    var tableViewData = [cellComponents]()
    var seguesIdentifiers = ["MediosDigitales", "Templos","Sidur", "Eventos", "SuperEmet", "Kashrut", "Escuelas", "Juventud", "Comite", "Directorio"]
    //var seguesIdentifiers = ["MediosDigitales", "Templos", "Eventos", "SuperEmet", "Kashrut", "Escuelas", "Juventud", "Comites", "Directorio"]
    
    @IBOutlet var homeTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableViewData =
            [cellComponents(cellImage: #imageLiteral(resourceName: "icon_medios"), cellColor: MaguenColors.blue1, cellTitle: "MEDIOS DIGITALES"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_templos"), cellColor: MaguenColors.blue2, cellTitle: "TEMPLOS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "msidur"), cellColor: MaguenColors.blue3, cellTitle: "SIDUR"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_eventos"), cellColor: MaguenColors.blue4, cellTitle: "EVENTOS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_superemet"), cellColor: MaguenColors.blue5, cellTitle: "SUPER EMET"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_kmd"), cellColor: MaguenColors.blue6, cellTitle: "KASHRUT"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_escuelas"), cellColor: MaguenColors.blue7, cellTitle: "ESCUELAS"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_juventud"), cellColor: MaguenColors.blue8, cellTitle: "JUVENTUD"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_comite"), cellColor: MaguenColors.blue9, cellTitle: "COMITÉ"),
            cellComponents(cellImage: #imageLiteral(resourceName: "icon_directorio"), cellColor: MaguenColors.blue10, cellTitle: "DIRECTORIO")]
        
        self.homeTableView.backgroundColor = MaguenColors.black1
        self.navigationController?.navigationBar.barTintColor = MaguenColors.black2
        
    }
    
    // MARK: - Hide and show NavBar
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    //MARK: - TableView
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
       
            return 90.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        ////print("You tapped cell number \(indexPath.row).")
        homeTableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: seguesIdentifiers[indexPath.row], sender: tableViewData[indexPath.row].cellTitle)
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //var controller = UIViewController()
        switch(segue.identifier)
        {
        case "MediosDigitales":
            let controller = segue.destination as? MediaTableViewController
            controller?.navigationItem.title = (sender as! String)

        case "Templos":
            let controller = segue.destination as? ChurchsTableViewController
            controller?.navigationItem.title = (sender as! String)
        case "Sidur":
            let controller = segue.destination as? SidurTableViewController
            controller?.navigationItem.title = (sender as! String)
        case "Eventos":
            let controller = segue.destination as? EventTableViewController
            controller?.navigationItem.title = (sender as! String)

        case "Juventud":
            let controller = segue.destination as? YouthTableViewController
            controller?.navigationItem.title = (sender as! String)

        case "Kashrut":
            let controller = segue.destination as? KashrutController
            controller?.navigationItem.title = (sender as! String)

        case "Comite":
            let controller = segue.destination as? CommitteeTableViewController
            controller?.navigationItem.title = (sender as! String)

        case "SuperEmet":
            let controller = segue.destination as? StoreController
            controller?.navigationItem.title = (sender as! String)

        case "Directorio":
            let controller = segue.destination as? DirectoryTableViewController
            controller?.navigationItem.title = (sender as! String)

        case "Escuelas":
            let controller = segue.destination as? SchoolsTableViewController
            controller?.navigationItem.title = (sender as! String)

        case .none:
            print("None")
        case .some(_):
            print("Some")
        }

    }
    

}
