//
//  EventViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventpopTitle: UILabel!
    @IBOutlet weak var eventpopPlace: UILabel!
    @IBOutlet weak var eventpopDate: UILabel!
    @IBOutlet weak var eventpopTime: UILabel!
    
    var eventImageView = UIImageView()
    var tableData = [eventComponents]()
    var eventTitleText = ""
    var eventPlaceText = ""
    var eventDateText = ""
    var eventTimeText = ""
    var eventImageText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popView.layer.cornerRadius = 10
        popView.layer.masksToBounds = true
        
        scrollView.delegate = self
        
        eventImageView.frame = CGRect(x: 0.0, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        //eventImageView.contentMode = UIView.ContentMode.scaleAspectFit
        eventImageView.isUserInteractionEnabled = true
        //scrollView.isUserInteractionEnabled = true
        scrollView.addSubview(eventImageView)
        
        //eventImageView.image = UIImage(named: "evento_uno")
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture))
        //eventImageView.addGestureRecognizer(pinchGesture)
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
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = eventImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
            
        }
        else {
            contentsFrame.origin.x = 0
        }
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }
        else {
            contentsFrame.origin.y = 0
            
        }
        
        eventImageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("Scroll view did zoom")
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("View for zooming")
        return eventImageView
    }
    
    /*func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //centerScrollViewContents()
    }*/
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        sender.view?.transform = ((sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale))!)
        sender.scale = 1.0
    }
    
    

    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
