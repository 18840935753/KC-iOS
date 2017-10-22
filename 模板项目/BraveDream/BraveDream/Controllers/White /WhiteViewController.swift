//
//  WhiteViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class WhiteViewController: BaseViewController {
    
    // MARK: - 属性 -
    
    private var vm = StockMarketViewModel.share

    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = baseViewColor
        
        view.addSubview(stockInfo)
        
        self.addChildViewController(stockKLine)
        view.addSubview(stockKLine.view)
        
        totalLayout()
    }
    
    // MARK: - 自定义 Function -
    
    // 行情横屏
    @objc private func landscapeAction(_ sender: UIButton) {
        vm.presentStockLandscapeChart(from: self)
    }
    
    // MARK: - 视图 -
    
    // 股票基本价格信息
    private lazy var stockInfo: StockInfoView = {
        let stockInfo = StockInfoView()
        return stockInfo
    }()
    
    // 分时图 K-Line
    private lazy var stockKLine: StockKLineViewController = {
        let stockKLine = StockKLineViewController()
        return stockKLine
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        stockInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(navigationHeight)
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
        }
        stockKLine.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.stockInfo.snp.bottom).offset(10)
            make.left.right.equalTo(self.view)
            make.height.equalTo(260)
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
