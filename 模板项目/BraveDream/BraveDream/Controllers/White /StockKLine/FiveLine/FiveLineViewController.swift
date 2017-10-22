//
//  FiveLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class FiveLineViewController: BaseLineViewController {
    
    // MARK: - 属性 -
    
    private var vm = StockKLineViewModel.share
    
    
    // MARK: - 系统 Function -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(timeLine)
    
        totalLayout()
        totalCallBack()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        netFiveDateData()
    }
    
    
    // MARK: - 网络请求 -
    
    // 五日数据
    private func netFiveDateData() {
        
        let params = ["code": "000001",
                      "incr": "1",
                      "type": "14901",
                      "dt": Util.date(before: 15)+" 15:30:00"]
        
        showIndicator(to: timeLine)
        vm.postFiveDateData(params, success: { (data) in
            self.timeLineData = data as? JSUPriceModel
            self.hideIndicator(to: self.timeLine)
        }) { (error) in
            print(error)
            self.hideIndicator(to: self.timeLine)
        }
    }
    
    
    // MARK: - 赋值 -
    
    // 分时数据
    private var timeLineData: JSUPriceModel? {
        didSet {
            guard let model = timeLineData else { return }
            
            let set = vm.fiveDateDataSet(from: model)
            timeLine.countOfTimes = 81*5
            timeLine.setupData(set)
        }
    }
    
    
    // MARK: - 视图 -
    
    // 分时
    private var timeLine: KTimeLineView = {
        let timeLine = KTimeLineView()
        // timeLine.delegate = self
        return timeLine
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        timeLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-15)
        }
    }
    
    
    // MARK: - 回调 -
    
    private func totalCallBack() {
        timeLine.selectCallback = { [weak self] (selected, entity, selectIndex) in
            self?.selectCallback!(selected, entity, selectIndex)
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
