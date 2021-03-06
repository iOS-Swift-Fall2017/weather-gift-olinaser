//
//  PageVC.swift
//  WeatherGift
//
//  Created by oliver naser on 10/16/17.
//  Copyright © 2017 oliver naser. All rights reserved.
//

import UIKit


class PageVC: UIPageViewController {
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()

    @objc var pageControl: UIPageControl!
    var listButton: UIButton!
    var barButtonWidth: CGFloat = 44
    var barButtonHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        
        var newLocation = WeatherLocaiton(name: <#T##String#>, coordinates: <#T##String#>)
        newLocation.name = ""
        locationsArray.append(newLocation)
        loadLocations()
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurePageControl()
        configureListButton()
    }
    
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey:"locationsArray") as? Data else {
            print("777")
        }
        let decoder = JSONDecoder()
        if let locationsArray = try? decoder.decode(Array.self, from: locationsEncoded) as [WeatherLocaiton]
        self.locationsArray = locationsArray
    } else {
    print("2989823r8932")
    }
}
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonHeight
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        
        let safeHeight = view.frame.height - (view.safeAreaInsets.bottom)
        
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: safeHeight - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
//        pageControl.addTarget(self, action: #selector(pageControlPressed), for: .touchUpInside)
        
        view.addSubview(pageControl)
        
        
        
    }
    
    //MARK: -UI CONFIG METHODS
    
    func configureListButton() {
        let safeHeight = view.frame.height - (view.safeAreaInsets.bottom)
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: safeHeight - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setImage(UIImage(named:"listButton"), for: .normal)
        listButton.setImage(UIImage(named:"listButton-Highlighted" ), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
        print("list button")
    }
    //MARK:-  Segues
    @objc func segueToListVC() {
        performSegue(withIdentifier: "ToListVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentViewController = self.viewControllers![0] as? DetailVC else
        {return}
        locationsArray = currentViewController.locationsArray
        if segue.identifier == "ToListVC" {
            let destination = segue.destination as! ListVC
            destination.locationsArray = locationsArray
            destination.currentPage = currentPage
        }
    }
    
    @IBAction func unwingFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
        
    }
    
    func createDetailVC(forPage page:Int ) -> DetailVC {
        
     currentPage = min(max(0, page), locationsArray.count-1)
    let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
        
    }

}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count-1 {
                return createDetailVC(forPage: currentViewController.currentPage+1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage-1)
            }
        }
        
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
            pageControl.currentPage = currentViewController.currentPage
        }
        
//        func pageControlPressed() {
//            guard let currentViewController = self.viewControllers![0] as? DetailVC else
//            {return}
//            currentPage = currentViewController.currentPage
//            if pageControl.currentPage < currentPage {
//                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .reverse, animated: true, completion: nil)
//            } else if pageControl.currentPage > currentPage {
//                setViewControllers([createDetailVC(forPage: pageControl.currentPage)], direction: .forward, animated: true, completion: nil)
//            }
//        }
        
    }
    
}



