//
//  SchoolsTableViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/16/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

struct schoolComponents {
    var schoolImage = UIImage()
    var schoolText = String()
    var schoolPage = String()
}

class SchoolsTableViewController: UITableViewController {

    var tableViewData = [schoolComponents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewData = [schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "ATID", schoolPage: "https://www.atid.edu.mx/web/"), schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "Maguén David", schoolPage: "https://www.chmd.edu.mx/"), schoolComponents(schoolImage: #imageLiteral(resourceName: "icon_escuelas"), schoolText: "OR Hajayim", schoolPage: "http://ideurban.com.mx/archivos/536")]
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableViewData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "school") as! SchoolCell
        
        cell.imgSchool.image = tableViewData[indexPath.row].schoolImage
        cell.imgSchool.layer.cornerRadius = cell.imgSchool.frame.size.width / 2
        cell.imgSchool.clipsToBounds = true
        cell.txtSchool.text = tableViewData[indexPath.row].schoolText
        
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
        print("You tapped cell number \(indexPath.row).")
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "schoolpage", sender: tableViewData[indexPath.row].schoolPage)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "schoolpage") {
            let controller = segue.destination as? SchoolPageViewController
            controller?.schoolURL = (sender as! String)
            
        }
    }
    

}
