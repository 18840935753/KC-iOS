//
//  BaseViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = baseViewColor
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        // self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setStatusTextColor(style: .lightContent)
    }
    
    // MARK: - 自定义 Function -
    
    // 显示 / 隐藏导航栏
    public func navigation(isHidden: Bool) {
        navigationController?.navigationBar.setBackgroundImage(isHidden ? UIImage() : nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = isHidden ? UIImage() : nil
    }
    
    // 渐变导航栏
    public func navigation(alpha: CGFloat) {
        let navigationColor = UIColor(red: 2/255.0, green: 152/255.0, blue: 252/255.0, alpha: alpha)
        let alphaImage = UIImage().colorToImage(color: navigationColor, alpha: alpha, width: 1, height: 1)
        navigationController?.navigationBar.setBackgroundImage(alphaImage, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // 隐藏导航栏分割线
    public func hideNavigationBottomLine() {
        navigationController?.navigationBar.shadowImage =  UIImage()
    }
    
    // 状态栏字体颜色
    public func setStatusTextColor(style: UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
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
