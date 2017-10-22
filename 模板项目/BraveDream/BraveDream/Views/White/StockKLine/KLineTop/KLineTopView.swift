//
//  KLineTopView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KLineTopView: BaseView {
    
    // MARK: - 属性 -
    
    public var dismissBack: ( () -> Void )?
    public var clickIndex: ( (_ index: Int) -> Void )?
    
    private lazy var topTitles: [String] = {
        let titles = ["分时", "五日", "日K", "周K", "月K"]
        return titles
    }()
    
    private lazy var prices: [String] = {
        let prices = ["同济科技 600846", "12.87 (+0.23%)", "成交量: 10520.52万", "时间: 08:00:00"]
        return prices
    }()
    
    public var btnBack: UIView!
    private var selectLine: UIView!
    private var selectIndex: Int = 0
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        // 价格 涨幅等
        let width = (UIScreen.main.bounds.size.height-60-15)/4
        
        var lastLb = UILabel()
        self.addSubview(lastLb)
        
        // 切换按钮
        btnBack = UIView()
        btnBack.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        self.addSubview(btnBack)
        
        lastLb.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self)
            make.bottom.equalTo(btnBack.snp.top)
            make.width.equalTo(0)
        }
        
        if Commons.isLandscape() {
            
            for i in 0..<prices.count {
                
                let lb = UILabel()
                lb.text = prices[i]
                self.addSubview(lb)
                
                lb.snp.makeConstraints { (make) in
                    make.top.bottom.equalTo(lastLb)
                    make.left.equalTo(lastLb.snp.right)
                    make.width.equalTo(width)
                }
                
                if i == 0 {
                    lb.textColor = UIColor.black
                    lb.font = UIFont.systemFont(ofSize: 15)
                }
                if i == 1 {
                    lb.textColor = UIColor.red
                    lb.font = UIFont.systemFont(ofSize: 15)
                }
                if i == 2 {
                    lb.textColor = UIColor.gray
                    lb.font = UIFont.systemFont(ofSize: 13)
                }
                if i == 3 {
                    lb.textColor = UIColor.gray
                    lb.font = UIFont.systemFont(ofSize: 13)
                }
                
                lastLb = lb
            }
            
            // 关闭按钮
            let closeBtn = UIButton(type: .custom)
            closeBtn.setImage(UIImage(named: "closeIcon"), for: .normal)
            closeBtn.addTarget(self, action: #selector(self.closeAction(_:)), for: .touchUpInside)
            closeBtn.imageEdgeInsets = UIEdgeInsetsMake(9, 9, 9, 9)
            self.addSubview(closeBtn)
            
            closeBtn.snp.makeConstraints { (make) in
                make.centerY.equalTo(lastLb)
                make.right.equalTo(self).offset(-15)
                make.width.height.equalTo(40)
            }
            
        }

        let isLandscape = Commons.isLandscape()
        btnBack.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            if isLandscape {
                make.bottom.equalTo(self).offset(-10)
                make.height.equalTo(35)
            } else {
                make.top.equalTo(self)
                make.height.equalTo(35)
            }
        }
        
        var lastBtn = UIButton(type: .custom)
        lastBtn.isHidden = true
        lastBtn.backgroundColor = .cyan
        btnBack.addSubview(lastBtn)
        
        lastBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(btnBack)
            make.left.equalTo(btnBack)
            make.width.equalTo(0)
        })
        
        for i in 0..<topTitles.count {
            let btn = UIButton(type: .custom)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitle(topTitles[i], for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.addTarget(self, action: #selector(self.tabAction(_:)), for: .touchUpInside)
            btn.tag = i+100
            btnBack.addSubview(btn)
            
            if i == 0 {
                btn.setTitleColor(baseViewColor, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            }
            
            btn.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(lastBtn)
                make.left.equalTo(lastBtn.snp.right)
                make.width.equalTo(self).multipliedBy(CGFloat(1)/5)
            })
            
            lastBtn = btn
        }
        
        selectLine = UIView()
        selectLine.backgroundColor = baseViewColor
        btnBack.addSubview(selectLine)
        
        selectLine.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(btnBack)
            make.height.equalTo(2)
            make.width.equalTo(lastBtn)
        }
    }
    
    
    // MARK: - 自定义 Function -
    
    // 切换标题
    @objc private func tabAction(_ sender: UIButton) {
        
        if clickIndex != nil {
            clickIndex!(sender.tag-100)
        }
        
        let sepWidth = UIScreen.main.bounds.size.width/5
        if selectIndex != sender.tag - 100 {
            if let lastSelectBtn = self.viewWithTag(selectIndex+100) as? UIButton {
                lastSelectBtn.setTitleColor(.gray, for: .normal)
            }
            sender.setTitleColor(baseViewColor, for: .normal)
            selectIndex = sender.tag-100
        }
        
        UIView.animate(withDuration: 0.2) {
            self.selectLine.snp.remakeConstraints({ (make) in
                make.left.bottom.equalTo(sender)
                make.height.equalTo(2)
                make.width.equalTo(sepWidth)
            })
            self.layoutIfNeeded()
        }
    }
    
    // MARK: 取消横屏
    @objc private func closeAction(_ sender:UIButton) {
        if dismissBack != nil {
            dismissBack!()
        }
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
