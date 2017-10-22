//
//  YellowViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SnapKit
import AlamofireObjectMapper
import Alamofire

class YellowViewController: BaseViewController {
    
    private var vm = ServiceViewModel.instance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.barTintColor = baseViewColor
        
        // MARK: - Example: EZSwiftExtensions BlockButton
        let button = BlockButton { (btn) in
            print("click btn")
        }
        button.backgroundColor = baseViewColor
        view.addSubview(button)
        
        
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
