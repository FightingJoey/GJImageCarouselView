//
//  TabBarViewController.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/22.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewController()
        self.initNavigationBar()
        self.tabBar.isTranslucent = true
    }
    
    func setupViewController() {
        let titleArray = ["首页", "详情"]
        
        let viewControllerArray = [
            RecommandViewController(),
            InvestViewController(),
        ]
        
        let navigationVCArray = NSMutableArray()
        for (index, controller) in viewControllerArray.enumerated() {
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.tabBarItem!.title = titleArray[index]
            navigationController.tabBarItem!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
            navigationController.tabBarItem!.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.DH_Red], for: .selected)
            navigationVCArray.add(navigationController)
        }
        self.viewControllers = navigationVCArray.mutableCopy() as! [UINavigationController]
    }
    
    /**
     Custom NavigationBar
     */
    func initNavigationBar() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().barTintColor = UIColor.DH_Red
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
