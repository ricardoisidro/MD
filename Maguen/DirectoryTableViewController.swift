//
//  DirectoryTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct directoryComponents {
    var directoryImage = UIImage()
    var directoryTitle = String()
    var directoryPhone = String()
}

class DirectoryTableViewController: UITableViewController {
    
    var tableViewData = [directoryComponents]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewData = [directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Arija", directoryPhone: "58140649"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Ayudas", directoryPhone: "58140636"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Caja", directoryPhone: "58140654"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "CMD", directoryPhone: "58140600"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Eventos", directoryPhone: "58140633"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Juventud", directoryPhone: "58140626"),
                         directoryComponents(directoryImage: #imageLiteral(resourceName: "img_jebrakadisha"), directoryTitle: "Prensa", directoryPhone: "58140652")]
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "directory") as! DirectoryCell
        
        cell.imgDirectory.image = tableViewData[indexPath.row].directoryImage
        cell.imgDirectory.layer.cornerRadius = cell.imgDirectory.frame.size.width / 2
        cell.imgDirectory.clipsToBounds = true
        cell.txtDirectory.text = tableViewData[indexPath.row].directoryTitle
        cell.txtPhone.text = tableViewData[indexPath.row].directoryPhone
        cell.layer.borderWidth = CGFloat(5.0)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
        
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let option = indexPath.row
        ////print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        let number = tableViewData[indexPath.row].directoryPhone
        let url:NSURL = NSURL(string: "tel://" + number)!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        
    }

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
