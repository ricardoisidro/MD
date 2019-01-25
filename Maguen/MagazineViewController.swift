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
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_paginas = Expression<Int64>("paginas")
    let db_eliminado = Expression<Int64>("eliminado")
    let db_fecha_modificacion = Expression<String>("fecha_modificacion")
    
    var publicationId = Int64()
    var numberOfPages = Int64()
    var vctitle: String? = ""
    var pages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.view.backgroundColor = MaguenColors.black1
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            // where categoria publicacion id = 1 (1 periodico; 2 revista)
            let query = db_publicacion.select(db_publicacion_id, db_descripcion, db_fecha_inicial_publicacion, db_categoria_publicacion_id, db_paginas, db_eliminado, db_fecha_modificacion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 2).where(db_eliminado == 0)
            let currentDaily = try db.pluck(query)
            
            publicationId = try currentDaily?.get(db_publicacion_id) ?? 0
            numberOfPages = try currentDaily?.get(db_paginas) ?? 0
            vctitle = try currentDaily?.get(db_descripcion)
            
        }
        catch let err {
            print("Read publicacionDB error: \(err)")
        }
        
        if numberOfPages > 0 {
            for i in 1...numberOfPages {
                let pagename = MaguenCredentials.urlMagazine + "\(String(publicationId))/pagina\(String(i)).jpg"
                pages.append(pagename)
            }
        }
        else {
            let pagename = MaguenCredentials.urlMagazine + "\(String(publicationId))/pagina.jpg"
            pages.append(pagename)
        }
        
        let frameVC = FrameViewController()
        let currentCad = pages.first!
        if let cad = URL(string: currentCad) {
            if let data = NSData(contentsOf: cad) {
                frameVC.imageData = data as Data
                frameVC.imageIndex = 0
                frameVC.imageTitle = vctitle
                frameVC.totalPages = Int(numberOfPages)

            }
        }
        
        let viewController = [frameVC]
        setViewControllers(viewController, direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = (viewController as! FrameViewController).imageIndex ?? 0
        
        
        if (currentIndex > 0) {
            let frameVC = FrameViewController()
            let lastPage = pages[currentIndex - 1]
            if let cad = URL(string: lastPage) {
                if let data = NSData(contentsOf: cad) {
                    frameVC.imageData = data as Data
                    frameVC.imageIndex = currentIndex - 1
                    frameVC.imageTitle = vctitle
                    frameVC.totalPages = Int(numberOfPages)

                }
            }
            return frameVC
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = (viewController as! FrameViewController).imageIndex ?? 0
        
        
        if (currentIndex < pages.count - 1) {
            let frameVC = FrameViewController()
            let nextPage = pages[currentIndex + 1]
            if let cad = URL(string: nextPage) {
                if let data = NSData(contentsOf: cad) {
                    frameVC.imageData = data as Data
                    frameVC.imageIndex = currentIndex + 1
                    frameVC.imageTitle = vctitle
                    frameVC.totalPages = Int(numberOfPages)

                }
            }
            return frameVC
        }
        
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
}
