//
//  EventViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventpopTitle: UILabel!
    @IBOutlet weak var eventpopPlace: UILabel!
    @IBOutlet weak var eventpopDate: UILabel!
    @IBOutlet weak var eventpopTime: UILabel!
    
    var tableData = [eventComponents]()
    var eventTitleText = ""
    var eventPlaceText = ""
    var eventDateText = ""
    var eventTimeText = ""
    var eventImageText = ""
    
    var isZooming = false
    var originalImageCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popView.layer.cornerRadius = 10
        popView.layer.masksToBounds = true
        
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.isUserInteractionEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        pinchGesture.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        panGesture.delegate = self
        eventImageView.addGestureRecognizer(pinchGesture)
        eventImageView.addGestureRecognizer(panGesture)
        eventpopTitle.text = eventTitleText
        eventpopPlace.text = eventPlaceText
        eventpopDate.text = eventDateText
        eventpopTime.text = eventTimeText
        
        let url = MaguenCredentials.urlEventImages + eventImageText + ".jpg"
        if let cad = URL(string: url) {
            if let data = NSData(contentsOf: cad) {
                eventImageView.image = UIImage(data: data as Data)
            }
        }
        
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began {
            
            let currentScale = self.eventImageView.frame.size.width / self.eventImageView.bounds.size.width
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
            let currentScale = self.eventImageView.frame.size.width / self.eventImageView.bounds.size.width
            var newScale = currentScale * sender.scale
            
            if newScale < 1 {
                
                /*let w = UIScreen.main.bounds.width
                let h = UIScreen.main.bounds.height
                let center = CGPoint(x: w/2, y: h/2)*/
                
                newScale = 1
                
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.eventImageView.transform = transform
                
                //self.eventImageView.center = center
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
                self.eventImageView.transform = CGAffineTransform.identity
                self.eventImageView.center = center
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
            sender.setTranslation(CGPoint.zero, in: self.eventImageView.superview)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
