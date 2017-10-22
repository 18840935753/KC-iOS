//
//  BaseLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class BaseLineViewController: UIViewController {
    
    // MARK: - 属性 -
    
    public var selectCallback: ( (_ selected: Bool, _ entity: AnyObject, _ selectIndex: Int) -> Void )?

    
    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
    }
    
    
    // MARK: -  自定义 Function -
    
    // 显示加载
    public func showIndicator(to view: UIView) {
        let indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        view.addSubview(indicator)
        
        indicator.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(30)
        }
        
        indicator.startAnimating()
    }
    
    // 隐藏加载
    public func hideIndicator(to view: UIView) {
        for v in view.subviews {
            if let indicator = v as? UIActivityIndicatorView {
                indicator.stopAnimating()
            }
        }
    }
    
    // MARK: - 视图 -
    

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
