//
//  ViewController.swift
//  Templete
//
//  Created by kang chao on 2017/4/1.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit
import AlamofireObjectMapper
import Alamofire
import TempleteFramework

class ViewController: UIViewController {

    private var vm = ServiceViewModel.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // MARK: - Example: EZSwiftExtensions BlockButton
        let button = BlockButton { (btn) in
            print("click btn")
        }
        button.backgroundColor = .cyan
        self.view.addSubview(button)
        
        // MARK: - Example: SnipKit
        button.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.height.equalTo(35)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        // MARK: - Example: Alamofire And ObjectMapper
        let params = ["adspaceId":"33", "userId":""]
        vm.postAdspace(params, success: { (data) in
            print(self.vm.adspaces ?? "default value")
        }) { (error) in
            print("error")
        }
        
        // MARK: User Framework
        let framework = TestViewController()
        framework.testFunc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

