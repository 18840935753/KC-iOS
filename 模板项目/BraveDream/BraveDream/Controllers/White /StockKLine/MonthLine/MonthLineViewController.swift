//
//  MonthLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class MonthLineViewController: BaseLineViewController {
    
    // MARK: - 属性 -
    
    private var vm = StockKLineViewModel.share
    
    
    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(kLine)
        view.addSubview(kIndex)
        
        netMonthLineData()
        
        totalLayout()
        totalCallBack()
    }
    
    
    // MARK: - 网络请求 -
    
    // 月数据
    private func netMonthLineData() {
        
        let params = ["code": "000001",
                      "adjusted": "",
                      "type": "14901",
                      "from": Util.date(before: 365*10),
                      "to": Util.date(before: 0)]
        
        showIndicator(to: kLine)
        vm.postMonthLineData(params, success: { (data) in
            self.monthLineData = data as? JSUKLineMessage
            self.hideIndicator(to: self.kLine)
        }) { (error) in
            print(error)
            self.hideIndicator(to: self.kLine)
        }
    }
    
    
    // MARK: - 赋值 -
    
    // 月K数据
    private var monthLineData: JSUKLineMessage? {
        didSet {
            guard let model = monthLineData else { return }
            let set = vm.kLineDataSet(from: model)
            kLine.setupData(set)
        }
    }
    
    
    // MARK: - 视图 -
    
    // K线 主图
    private lazy var kLine: KLineView = {
        let kLine = KLineView()
        return kLine
    }()
    
    // K线 指标
    private lazy var kIndex: KLineIndexView = {
        let kIndex = KLineIndexView()
        return kIndex
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        kLine.snp.remakeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(0, 10, 15, 70))
        }
        
        kIndex.snp.remakeConstraints { (make) in
            make.left.equalTo(self.kLine.snp.right).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-15)
        }
        
    }
    
    
    // MARK: - 回调 -
    
    private func totalCallBack() {
        kLine.selectCallback = { [weak self] (selected, entity, selectIndex) in
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
