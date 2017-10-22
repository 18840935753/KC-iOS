//
//  StockInfoView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/11.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class StockInfoView: BaseView {
    
    // MARK: - 局部变量 -
    
    private var tempStockPrice: CGFloat?
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(price)
        self.addSubview(indication)
        
        totalLayout()
        
        simulateData()
    }
    
    
    // MARK: - 视图 -
    
    // 股票价格
    private lazy var price: AMAnimatedNumber = {
        let price = AMAnimatedNumber(frame: CGRect(x: 15, y: 10, w: 100, h: self.frame.height-10*2))
        price.textFont = italicsAvenirFont24
        price.textColor = .red
        return price
    }()
    
    // 指示价格箭头
    private lazy var indication: UIImageView = {
        let indication = UIImageView()
        indication.isHidden = true
        indication.contentMode = .scaleAspectFit
        return indication
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        price.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.width.greaterThanOrEqualTo(60)
        }
        indication.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(2)
            make.top.bottom.equalTo(self.price)
            make.width.equalTo(8)
        }
    }
    
    
    // MARK: - 模拟数据 -
    
    private func simulateData() {
        
        price.setNumbers(tempStockPrice != nil ? "\(tempStockPrice)" : "--", animated: false)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
            self.tempStockPrice = self.tempStockPrice == nil ? 39.97 : self.tempStockPrice
            if self.tempStockPrice! > 40 {
                
                self.tempStockPrice! -= 0.05
                self.price.textColor = .green
            }else{
                
                self.tempStockPrice! += 0.05
                self.price.textColor = .red
            }
            
            let isUp = self.tempStockPrice! > 40
            UIView.animate(withDuration: 0.6, animations: {
                
                self.price.backgroundColor = UIColor(red: isUp ? 1 : 0, green: isUp ? 0 : 1, blue: 0, alpha: 0.1)
                
                self.indication.isHidden = false
                if isUp {
                    self.indication.image = UIImage(named: "upIcon")
                }else{
                    self.indication.image = UIImage(named: "downIcon")
                }
                
            }, completion: { (finsished) in
                self.indication.isHidden = true
                self.price.backgroundColor = .white
            })
            
            self.price.setNumbers("\(self.tempStockPrice!)", animated: true, direction: self.tempStockPrice! > 40 ? .up : .down)
        }
        
        timer.fire()
        RunLoop.current.add(timer, forMode: .UITrackingRunLoopMode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
