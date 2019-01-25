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
            let query = db_publicacion.select(db_publicacion_id, db_descripcion, db_fecha_inicial_publicacion, db_categoria_publicacion_id, db_paginas, db_eliminado, db_fecha_modificacion).order(db_fecha_inicial_publicacion.date.desc).where(db_categoria_publicacion_id == 1).where(db_eliminado == 0)
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

class FrameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var imageIndex: Int? {
        didSet {
            pageLabel.text = "Página \(String(imageIndex!+1))"
        }
    }
    
    var totalPages: Int? {
        didSet {
            pageLabel.text = pageLabel.text! + "/\(String(totalPages!))"
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
    
    var isZooming = false
    var originalImageCenter: CGPoint?
    
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
        
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinchGesture.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        panGesture.delegate = self
        
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(panGesture)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGesture)
        
        
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale * sender.scale
            if newScale > 1 {
                self.isZooming = true
            }
        }
            
        else if sender.state == .changed {
            
            guard let view = sender.view else { return }
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currentScale * sender.scale
            
            if newScale < 1 {
                
                let w = UIScreen.main.bounds.width
                let h = UIScreen.main.bounds.height
                let center = CGPoint(x: w/2, y: h/2)
                
                newScale = 1

                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
                
                self.imageView.center = center
                sender.scale = 1.0
            }
            else {
                view.transform = transform
                sender.scale = 1.0
            }
        }
            
        else if sender.state == .failed || sender.state == .cancelled {
            
            let w = UIScreen.main.bounds.width
            let h = UIScreen.main.bounds.height
            
            let center = self.originalImageCenter ?? CGPoint(x: w/2, y: h/2)
            
            //let center = self.originalImageCenter
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = CGAffineTransform.identity
                self.imageView.center = center
            }, completion: {_ in self.isZooming = false })
        }
        
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        }
        else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.imageView.superview)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
