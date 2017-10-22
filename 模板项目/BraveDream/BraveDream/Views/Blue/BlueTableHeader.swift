//
//  BlueTableHeader.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/17.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class BlueTableHeader: UIView {
    
    // MARK: - 声明 属性 -
    
    private let imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
    
    private var timer: Timer?
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backImage)
        
        totalLayout()
    }
    
    // MARK: - 自定义 Function -
    
    // 点击切换背景图
    func tapBackImageAction() {
        
        backImage.image = UIImage(named: imageNames[Int(arc4random_uniform(7-0)+0)])

        let tranAni = CATransition()
        tranAni.type = "rippleEffect"
        tranAni.subtype = kCATransitionFromBottom
        tranAni.duration = 3.0
        tranAni.repeatCount = 1
        self.layer.add(tranAni, forKey: "transition")
        
    }
    
    // 开始定时切换背景图
    public func beginTransitionBackImage() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { [weak self] (timer) in
                self?.tapBackImageAction()
            })
        }
    }
    
    // 停止定时切换背景图
    public func endTransitionBackImage() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // MARK: - 声明 控件 -
    
    // 图片
    private lazy var backImage:UIImageView = {
        let backImage = UIImageView()
        backImage.image = UIImage(named: self.imageNames[2])
        backImage.isUserInteractionEnabled = true
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.tapBackImageAction))
        backImage.addGestureRecognizer(tapImage)
        return backImage
    }()
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        backImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    deinit {
        print("BlueTableHeader dealloc")
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
