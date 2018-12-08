//
//  DailyViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit
import SQLite

class DailyViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let db_publicacion = Table("publicacion")
    let db_publicacion_id = Expression<Int64>("publicacion_id")
    let db_descripcion = Expression<String>("descripcion")
    let db_fecha_inicial_publicacion = Expression<Date>("fecha_inicial_publicacion")
    let db_categoria_publicacion_id = Expression<Int64>("categoria_publicacion_id")
    let db_paginas = Expression<Int64>("paginas")
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
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        
        self.view.backgroundColor = MaguenColors.black1
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("maguen").appendingPathExtension("sqlite3")
            let db = try Connection(fileURL.path)
            // where categoria publicacion id = 1 (1 periodico; 2 revista)
            let query = db_publicacion.select(db_publicacion_id, db_descripcion, db_fecha_inicial_publicacion, db_categoria_publicacion_id, db_paginas, db_eliminado, db_fecha_modificacion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 1).where(db_eliminado == 0)
            let currentDaily = try db.pluck(query)
            
            publicationId = try (currentDaily?.get(db_publicacion_id))!
            numberOfPages = try (currentDaily?.get(db_paginas))!
            vctitle = try currentDaily?.get(db_descripcion)
            
        }
        catch let err {
            print("Read publicacionDB error: \(err)")
        }
        
        
        for i in 1...numberOfPages {
            let pagename = MaguenCredentials.urlMagazine + "\(String(publicationId))/pagina\(String(i)).jpg"
            pages.append(pagename)
        }
        
        let frameVC = FrameViewController()
        let currentCad = pages.first!
        
        if let cad = URL(string: currentCad) {
            if let data = NSData(contentsOf: cad) {
                frameVC.imageData = data as Data
                frameVC.imageIndex = 0
                frameVC.imageTitle = vctitle
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
                }
            }
            return frameVC
        }
        
        return nil
    }
    

    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class FrameViewController: UIViewController {
    
    var imageIndex: Int? {
        didSet {
            pageLabel.text = "Página \(String(imageIndex!+1))"
        }
    }
    var imageTitle: String? {
        didSet {
            titleLabel.text = imageTitle
        }
    }
    
    let navItem = UINavigationItem()
    var imageData: Data? {
        didSet {
            imageView.image = UIImage(data: imageData!)
        }
    }
    
    let imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    let titleLabel: UILabel = {
        let pt = UILabel()
        pt.font = UIFont.boldSystemFont(ofSize: 17.0)
        pt.textColor = UIColor.white
        pt.backgroundColor = UIColor.clear
        pt.translatesAutoresizingMaskIntoConstraints = false
        return pt
    }()
    
    let pageLabel: UILabel = {
        let pt = UILabel()
        pt.font = UIFont.systemFont(ofSize: 15.0)
        pt.textColor = UIColor.white
        pt.backgroundColor = UIColor.clear
        pt.translatesAutoresizingMaskIntoConstraints = false
        return pt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views: [String: Any] = [
            "v0": imageView,
            "v1": titleLabel,
            "v2": pageLabel]
        
        var allConstraints: [NSLayoutConstraint] = []
        
        //UINavigationItem
        view.backgroundColor = MaguenColors.black1
        view.addSubview(titleLabel)
        view.addSubview(pageLabel)
        view.addSubview(imageView)
        
        let imageViewHorizonConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", metrics: nil, views: views)
        allConstraints += imageViewHorizonConstraint
        let titleLabelHorizonConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", metrics: nil, views: views)
        allConstraints += titleLabelHorizonConstraint
        let pageLabelHorizonConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", metrics: nil, views: views)
        allConstraints += pageLabelHorizonConstraint
        let allVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[v1(>=30)]-1-[v2(>=30)]-[v0]-|", metrics: nil, views: views)
        allConstraints += allVerticalConstraints
        
        NSLayoutConstraint.activate(allConstraints)

        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor
        //self.navigationController?.navigationBar.topItem?.title = "HI"
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
        
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
    }
}
