//
//  MagazineViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

class MagazineViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let db_publicacion = Table("publicacion")
    let db_publicacion_id = Expression<Int64>("publicacion_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_fecha_inicial_publicacion = Expression<Date>("fecha_inicial_publicacion")
    //let db_fecha_final_publicacion = Expression<String>("fecha_final_publicacion")
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_paginas = Expression<Int64>("paginas")
    //var db_activo = Expression<Int64>("activo")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    var publicationId: Int64 = 0
    var numberOfPages: Int64 = 0
    var vctitle: String? = ""
    var pages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        setViewControllers([pagesViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.view.backgroundColor = MaguenColors.black1
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            // where categoria publicacion id = 1 (1 periodico; 2 revista)
            let query = db_publicacion.select(db_publicacion_id, db_descripcion, db_fecha_inicial_publicacion, db_categoria_publicacion_id, db_paginas, db_eliminado, db_fecha_modificacion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 2).where(db_eliminado == 0)
            let currentMagazine = try db.pluck(query)
            
            publicationId = try (currentMagazine?.get(db_publicacion_id))!
            print(publicationId)
            numberOfPages = try (currentMagazine?.get(db_paginas))!
            print(numberOfPages)
            
            vctitle = try currentMagazine?.get(db_descripcion)
            print(vctitle!)
            /*guard let queryResults = try? db.prepare(query) else {
             print("ERROR al consultar usuario")
             return
             }
             
             for row in queryResults {
             print("nombre: \(row[db_user_name]), apellido: \(row[db_user_surname1]), fecha vig.: \(row[db_user_idactivedate]), tipoid: \(row[db_user_idtype]), cardid: \(row[db_user_cardid])")
             let apellido = try row.get(db_user_surname1) + " " + row.get(db_user_surname2)
             let data = usuario(nombre: try row.get(db_user_name), apellido1: apellido, fecha: try row.get(db_user_idactivedate), tipoCredencial: Int(try row.get(db_user_idtype)), imagen: try row.get(db_user_photo), idCredencial: try Int(row.get(db_user_cardid)))
             tableData.append(data)
             }*/
        }
        catch let err {
            print("Read publicacionDB error: \(err)")
        }
        for i in 1...numberOfPages {
            let pagename = "pagina" + String(i) + ".jpg"
            pages.append(pagename)
        }
    }
    
    lazy var pagesViewControllers:[UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MagazinePage01ViewController") as! MagazinePage01ViewController,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MagazinePage02ViewController") as! MagazinePage02ViewController
        ]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pagesViewControllers.index(of: viewController) ?? 0
        if(currentIndex <= 0) {
            return nil
        }
        return pagesViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = pagesViewControllers.index(of: viewController) ?? 0
        if(currentIndex >= pagesViewControllers.count-1) {
            return nil
        }
        return pagesViewControllers[currentIndex + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesViewControllers.count
    }

}
