//
//  TimeLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class TimeLineViewController: BaseLineViewController {
    
    // MARK: - 属性 -
    
    private var vm = StockKLineViewModel.share
    
    
    // MARK: - 系统 Function -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(timeLine)
        view.addSubview(fiveDeal)
        
        totalLayout()
        totalCallBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        netTimeData()
        netFiveDealData()
        netRealTimeData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    
    // MARK: - 网络请求 -
    
    // 分时数据
    private func netTimeData() {
        
        let params = ["code": "000001",
                      "incr": "0",
                      "type": "14901",
                      "dt": ""]
        
        vm.postTimeLineData(params, success: { (data) in
            self.timeLineData = data as? JSUPriceModel
        }) { (error) in
            print(error)
        }
    }
    
    // 五档数据
    private func netFiveDealData() {
        
        let params = ["code": "000001"]
        
        vm.postFiveDealData(params, success: { (data) in
            self.fiveDealData = data as? JSUTradeModel
        }) { (error) in
            print(error)
        }
    }
    
    // 分时数据
    private func netRealTimeData() {
        
        let params = ["code": "000001",
                      "type": "14901"]
        
        showIndicator(to: timeLine)
        vm.postRealTimeData(params, success: { (data) in
            self.realTimeData = data as? JSUStateModel
            self.hideIndicator(to: self.timeLine)
        }) { (error) in
            self.hideIndicator(to: self.timeLine)
            print(error)
        }
    }
    
    
    // MARK: - 赋值 -
    
    // 分时数据
    private var timeLineData: JSUPriceModel? {
        didSet {
            guard let model = timeLineData else { return }
            
            let set = vm.timeLineDataSet(from: model)
            timeLine.countOfTimes = 241
            timeLine.setupData(set)
        }
    }
    
    // 五档数据
    private var fiveDealData: JSUTradeModel? {
        didSet {
            if realTimeData != nil && fiveDealData != nil {
                fiveDeal.data = fiveDealData
            }
        }
    }
    
    // 实时行情数据
    private var realTimeData: JSUStateModel? {
        didSet {
            fiveDeal.openPrice = realTimeData?.open
            if fiveDealData != nil && realTimeData != nil {
                fiveDeal.data = fiveDealData
            }
        }
    }
    
    
    // MARK: - 视图 -
    
    // 分时
    private var timeLine: KTimeLineView = {
        let timeLine = KTimeLineView()
        return timeLine
    }()
    
    // 五档
    private var fiveDeal: FiveDealView = {
        let fiveDeal = FiveDealView()
        return fiveDeal
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        timeLine.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-140)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-15)
        }
        
        fiveDeal.snp.remakeConstraints { (make) in
            make.left.equalTo(self.timeLine.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.timeLine)
            make.bottom.equalTo(self.timeLine)
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
