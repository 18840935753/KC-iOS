//
//  TabBarViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.delegate = delegate
        self.title = "Irregularity"
        self.tabBar.shadowImage = UIImage(named: "transparent")
        self.tabBar.backgroundImage = UIImage(named: "background_dark")
        self.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        
        self.didHijackHandler = {
            [weak self] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        let naviGreen  = UINavigationController(rootViewController: GreenViewController())
        let naviYellow = UINavigationController(rootViewController: YellowViewController())
        let naviRed    = UINavigationController(rootViewController: RedViewController())
        let naviWhite  = UINavigationController(rootViewController: WhiteViewController())
        let naviBlue   = UINavigationController(rootViewController: BlueViewController())
        
        naviGreen.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Green", image: UIImage(named: "GreenIconN"), selectedImage: UIImage(named: "GreenIconS"))
        naviYellow.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Yel", image: UIImage(named: "YellowIconN"), selectedImage: UIImage(named: "YellowIconS"))
        naviRed.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        naviWhite.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "White", image: UIImage(named: "YellowIconN"), selectedImage: UIImage(named: "YellowIconS"))
        naviBlue.tabBarItem = ESTabBarItem.init(ExampleBouncesContentView(), title: "Blue", image: UIImage(named: "BlueIconN"), selectedImage: UIImage(named: "BlueIconS"))
        
        naviBlue.tabBarItem.badgeValue = "3"
        naviBlue.tabBarItem.badgeColor = UIColor.orange
        
        self.viewControllers = [naviGreen, naviYellow, naviRed, naviWhite, naviBlue]
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
