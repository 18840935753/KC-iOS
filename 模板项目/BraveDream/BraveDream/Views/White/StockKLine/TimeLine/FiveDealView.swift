//
//  FiveDealView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class FiveDealView: UIView {
    
    var fiveGearBtn:UIButton!
    var detailBtn:UIButton!
    
    var sell1Price = UILabel()
    var sell2Price = UILabel()
    var sell3Price = UILabel()
    var sell4Price = UILabel()
    var sell5Price = UILabel()
    var sell1Count = UILabel()
    var sell2Count = UILabel()
    var sell3Count = UILabel()
    var sell4Count = UILabel()
    var sell5Count = UILabel()
    
    var buy1Price = UILabel()
    var buy2Price = UILabel()
    var buy3Price = UILabel()
    var buy4Price = UILabel()
    var buy5Price = UILabel()
    var buy1Count = UILabel()
    var buy2Count = UILabel()
    var buy3Count = UILabel()
    var buy4Count = UILabel()
    var buy5Count = UILabel()
    
    private lazy var buySalesTitles:[[String]] = {
        let titles = [["卖5","卖4","卖3","卖2","卖1"],
                      ["买1","买2","买3","买4","买5"]]
        return titles
    }()
    
    var openPrice:Double?
    
    var data:JSUTradeModel! {
        didSet{
            let riseColor = UIColor(red: 203/255.0, green: 31/255.0, blue: 3/255.0, alpha: 1)
            let fallColor = UIColor(red: 22/255.0, green: 176/255.0, blue: 62/255.0, alpha: 1)
            
            if let bp = data.bp1 {
                self.buy1Price.text = String(format: "%.2f", (bp.toDouble() ?? 0))
                if let o = self.openPrice , (bp.toDouble() ?? 0) >= o {
                    self.buy1Price.textColor = riseColor
                }else{
                    self.buy1Price.textColor = fallColor
                }
            }
            if let bp = data.bp2 {
                self.buy2Price.text = String(format: "%.2f", (bp.toDouble() ?? 0))
                if let o = self.openPrice , (bp.toDouble() ?? 0) >= o{
                    self.buy2Price.textColor = riseColor
                }else{
                    self.buy2Price.textColor = fallColor
                }
                
            }
            if let bp = data.bp3{
                self.buy3Price.text = String(format: "%.2f", (bp.toDouble() ?? 0))
                if let o = self.openPrice , (bp.toDouble() ?? 0) >= o{
                    self.buy3Price.textColor = riseColor
                }else{
                    self.buy3Price.textColor = fallColor
                }
            }
            if let bp = data.bp4{
                self.buy4Price.text = String(format: "%.2f", (bp.toDouble() ?? 0))
                if let o = self.openPrice , (bp.toDouble() ?? 0) >= o{
                    self.buy4Price.textColor = riseColor
                }else{
                    self.buy4Price.textColor = fallColor
                }
            }
            if let bp = data.bp5{
                self.buy5Price.text = String(format: "%.2f", (bp.toDouble() ?? 0))
                if let o = self.openPrice , (bp.toDouble() ?? 0) >= o{
                    self.buy5Price.textColor = riseColor
                }else{
                    self.buy5Price.textColor = fallColor
                }
            }
            
            if let bc = data.bc1{
                self.buy1Count.text = sepKWithNum("\((bc.toInt() ?? 0)/100)")
            }
            if let bc = data.bc2{
                self.buy2Count.text = sepKWithNum("\((bc.toInt() ?? 0)/100)")
            }
            if let bc = data.bc3{
                self.buy3Count.text = sepKWithNum("\((bc.toInt() ?? 0)/100)")
            }
            if let bc = data.bc4{
                self.buy4Count.text = sepKWithNum("\((bc.toInt() ?? 0)/100)")
            }
            if let bc = data.bc5{
                self.buy5Count.text = sepKWithNum("\((bc.toInt() ?? 0)/100)")
            }
            
            if let sp = data.sp1{
                self.sell1Price.text = String(format: "%.2f", (sp.toDouble() ?? 0))
                if let o = self.openPrice , (sp.toDouble() ?? 0) >= o{
                    self.sell1Price.textColor = riseColor
                }else{
                    self.sell1Price.textColor = fallColor
                }
            }
            if let sp = data.sp2{
                self.sell2Price.text = String(format: "%.2f", (sp.toDouble() ?? 0))
                if let o = self.openPrice , (sp.toDouble() ?? 0) >= o{
                    self.sell2Price.textColor = riseColor
                }else{
                    self.sell2Price.textColor = fallColor
                }
            }
            if let sp = data.sp3{
                self.sell3Price.text = String(format: "%.2f", (sp.toDouble() ?? 0))
                if let o = self.openPrice , (sp.toDouble() ?? 0) >= o{
                    self.sell3Price.textColor = riseColor
                }else{
                    self.sell3Price.textColor = fallColor
                }
            }
            if let sp = data.sp4{
                self.sell4Price.text = String(format: "%.2f", (sp.toDouble() ?? 0))
                if let o = self.openPrice , (sp.toDouble() ?? 0) >= o{
                    self.sell4Price.textColor = riseColor
                }else{
                    self.sell4Price.textColor = fallColor
                }
            }
            if let sp = data.sp5{
                self.sell5Price.text = String(format: "%.2f", (sp.toDouble() ?? 0))
                if let o = self.openPrice , (sp.toDouble() ?? 0) >= o{
                    self.sell5Price.textColor = riseColor
                }else{
                    self.sell5Price.textColor = fallColor
                }
            }
            if let sc = data.sc1{
                self.sell1Count.text = sepKWithNum("\((sc.toInt() ?? 0)/100)")
            }
            if let sc = data.sc2{
                self.sell2Count.text = sepKWithNum("\((sc.toInt() ?? 0)/100)")
            }
            if let sc = data.sc3{
                self.sell3Count.text = sepKWithNum("\((sc.toInt() ?? 0)/100)")
            }
            if let sc = data.sc4{
                self.sell4Count.text = sepKWithNum("\((sc.toInt() ?? 0)/100)")
            }
            if let sc = data.sc5{
                self.sell5Count.text = sepKWithNum("\((sc.toInt() ?? 0)/100)")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        
        setupBuySaleView()
        setupFiveGearAndDetailBtns()
    }
    
    // 创建买五卖五视图
    private func setupBuySaleView() {
        
        // 卖五
        var lastSaleName = UILabel()
        self.addSubview(lastSaleName)
        for i in 0..<buySalesTitles[0].count {
            
            let name = UILabel()
            name.font = UIFont.systemFont(ofSize: 11)
            name.textColor = .darkGray
            name.text = buySalesTitles[0][i]
            name.textAlignment = .center
            self.addSubview(name)
            
            name.snp.makeConstraints { (make) in
                make.left.equalTo(self)
                make.top.equalTo(lastSaleName.snp.bottom)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(1)/5)
                make.height.equalTo(self.snp.height).multipliedBy(CGFloat(1)/11)
            }

            lastSaleName = name
            
            let price = UILabel()
            price.textAlignment = .center
            price.font = UIFont.systemFont(ofSize: 11)
            price.textColor = .darkGray
            price.text = "- -"
            self.addSubview(price)
            
            price.snp.makeConstraints({ (make) in
                make.left.equalTo(name.snp.right)
                make.top.equalTo(name)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(2)/5)
                make.height.equalTo(name.snp.height)
            })
            
            let count = UILabel()
            count.textAlignment = .center
            count.font = UIFont.systemFont(ofSize: 11)
            count.textColor = .darkGray
            count.text = "- -"
            self.addSubview(count)
            
            count.snp.makeConstraints({ (make) in
                make.left.equalTo(price.snp.right)
                make.top.equalTo(name)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(2)/5)
                make.height.equalTo(name.snp.height)
            })
            
            if i==0 {
                sell5Count = count
                sell5Price = price
            }else if i==1 {
                sell4Count = count
                sell4Price = price
            }else if i==2 {
                sell3Count = count
                sell3Price = price
            }else if i==3 {
                sell2Count = count
                sell2Price = price
            }else if i==4 {
                sell1Count = count
                sell1Price = price
            }
        }
        
        // 买五
        var lastBuyName = UILabel()
        self.addSubview(lastBuyName)
        
        lastBuyName.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
        }

        for i in 0..<buySalesTitles[1].count {
            let name = UILabel()
            name.font = UIFont.systemFont(ofSize: 11)
            name.textColor = .darkGray
            name.text = buySalesTitles[1][buySalesTitles[1].count-1-i]
            name.textAlignment = .center
            self.addSubview(name)
            
            name.snp.makeConstraints({ (make) in
                make.left.equalTo(self)
                make.bottom.equalTo(lastBuyName.snp.top)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(1)/5)
                make.height.equalTo(self.snp.height).multipliedBy(CGFloat(1)/11)
            })
            
            lastBuyName = name
            
            let price = UILabel()
            price.textAlignment = .center
            price.font = UIFont.systemFont(ofSize: 11)
            price.text = "- -"
            self.addSubview(price)
            
            price.snp.makeConstraints({ (make) in
                make.left.equalTo(name.snp.right)
                make.top.equalTo(name)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(2)/5)
                make.height.equalTo(name.snp.height)
            })
            
            
            let count = UILabel()
            count.font = UIFont.systemFont(ofSize: 11)
            count.text = "- -"
            count.textColor = .darkGray
            count.textAlignment = .center
            self.addSubview(count)
            
            count.snp.makeConstraints({ (make) in
                make.left.equalTo(price.snp.right)
                make.top.equalTo(name)
                make.width.equalTo(self.snp.width).multipliedBy(CGFloat(2)/5)
                make.height.equalTo(name.snp.height)
            })

            
            if i==0 {
                buy5Count = count
                buy5Price = price
            }else if i==1 {
                buy4Count = count
                buy4Price = price
            }else if i==2 {
                buy3Count = count
                buy3Price = price
            }else if i==3 {
                buy2Count = count
                buy2Price = price
            }else if i==4 {
                buy1Count = count
                buy1Price = price
            }
        }
        
        let sepLine = UIView()
        sepLine.backgroundColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 234/255.0, alpha: 1)
        self.addSubview(sepLine)
        
        sepLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: 创建五档与明细视图
    private func setupFiveGearAndDetailBtns() {
        
        fiveGearBtn = UIButton(type: .custom)
        // fiveGearBtn.setTitle("五档", for: .normal)
        fiveGearBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        fiveGearBtn.setTitleColor(UIColor(red: 55/255.0, green: 138/255.0, blue: 229/255.0, alpha: 1), for: .selected)
        fiveGearBtn.setTitleColor(.darkGray, for: .normal)
        fiveGearBtn.layer.cornerRadius = 3
        fiveGearBtn.layer.borderWidth = 0.5
        fiveGearBtn.layer.borderColor = UIColor.lightGray.cgColor
        fiveGearBtn.isSelected = true
        // fiveGearBtn.addTarget(self, action: #selector(self.switchAction(_:)), for: .touchUpInside)
        self.addSubview(fiveGearBtn)
        
        fiveGearBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-5)
            make.height.equalTo(0)
        }
    
        
        //        detailBtn = UIButton(type: .custom)
        //        detailBtn.setTitle("明细", for: .normal)
        //        detailBtn.isHidden = true   // 隐藏
        //        detailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        //        detailBtn.setTitleColor(allBlueColor, for: .selected)
        //        detailBtn.setTitleColor(baseColor, for: .normal)
        //        detailBtn.layer.cornerRadius = 3
        //        detailBtn.layer.borderWidth = 0.5
        //        detailBtn.layer.borderColor = textColorLightGray.cgColor
        //        detailBtn.addTarget(self, action: #selector(self.switchAction(_:)), for: .touchUpInside)
        //        self.view.addSubview(detailBtn)
        //        detailBtn.mas_makeConstraints { (make) in
        //            _ = make?.height.mas_equalTo()(20)
        //            _ = make?.width.mas_equalTo()(self.fiveGearBtn)
        //            _ = make?.left.mas_equalTo()(self.fiveGearBtn.mas_right)?.offset()(20)
        //            _ = make?.right.mas_equalTo()(self.bsBack)
        //            _ = make?.top.mas_equalTo()(self.fiveGearBtn)
        //        }
    }
    
    // MARK: 数字以K划分
   private func sepKWithNum(_ num:String?) -> String {
        if num?.isEmpty == true {
            return "0"
        }
        if (Double(num!) ?? 0) < 1000 {
            return num!
        }
        if (Double(num!) ?? 0) > 1000 {
            let numberFormatter1 = NumberFormatter()
            numberFormatter1.positiveFormat = "##0.00"
            let str = numberFormatter1.string(from: NSNumber(value: (Double(num!) ?? 0)/1000))!
            return "\(str)k"
        }
        return "0"
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
