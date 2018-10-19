//
//  MagazineViewController.swift
//  Maguen
//
//  Created by ExpresionBinaria on 10/17/18.
//  Copyright © 2018 Expression B. All rights reserved.
//

import UIKit

class MagazineViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        setViewControllers([pagesViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        let titleColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleColor

        self.view.backgroundColor = MaguenColors.black1
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesViewControllers.count
    }

}
