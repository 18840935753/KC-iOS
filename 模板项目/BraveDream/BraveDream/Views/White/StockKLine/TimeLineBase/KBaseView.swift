//
//  KBaseView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KBaseView: UIView {
    
    var contentRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var chartHeight:CGFloat = 0
    var chartWidth:CGFloat = 0
    private var offsetLeft:CGFloat?
    private var offsetTop:CGFloat?
    private var offsetRight:CGFloat?
    private var offsetBottom:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func addObserver() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func deviceOrientationDidChange(_ noti:Notification) {
        if UIDevice.current.orientation != UIDeviceOrientation.unknown {
            self.notifyDeviceOrientationChanged()
        }
    }
    
    func notifyDeviceOrientationChanged() {
        
    }
    
    override func layoutSubviews() {
        // 布局调整
        let bounds = self.bounds
        if bounds.width != chartWidth || bounds.height != chartHeight {
            self.setChartDimens(bounds.width, height: bounds.height)
            self.notifyDataSetChanged()
        }
    }
    
    func notifyDataSetChanged() {
        setNeedsLayout()
    }
    
    func setupChartOffsetWithLeft(_ left:CGFloat, top:CGFloat, right:CGFloat, bottom:CGFloat) {
        self.offsetLeft = left
        self.offsetRight = right
        self.offsetTop = top
        self.offsetBottom = bottom
        //by LiuK 需要设置_contentRect
        self.restrainViewPort(left, offsetTop: top, offsetRight: right, offsetBottom: bottom)
    }
    
    func setChartDimens(_ width:CGFloat, height:CGFloat) {
        let offsetLeft = self.offsetLeft
        let offsetTop = self.offsetTop
        let offsetRight = self.offsetRight
        let offsetBottom = self.offsetBottom
        chartHeight = height;
        chartWidth = width;
        self.restrainViewPort(offsetLeft ?? 0, offsetTop: offsetTop ?? 0, offsetRight: offsetRight ?? 0, offsetBottom: offsetBottom ?? 0)
    }
    
    func restrainViewPort(_ offsetLeft:CGFloat, offsetTop:CGFloat, offsetRight:CGFloat, offsetBottom:CGFloat) {
        contentRect.origin.x = offsetLeft;
        contentRect.origin.y = offsetTop;
        contentRect.size.width = chartWidth - offsetLeft - offsetRight;
        contentRect.size.height = chartHeight - offsetBottom - offsetTop;
    }
    
    func isInBoundsX(_ x:CGFloat) -> Bool {
        if isInBoundsLeft(x) && isInBoundsRight(x) {
            return true
        }
        return false
    }
    
    func isInBoundsY(_ y:CGFloat) -> Bool {
        if isInBoundsTop(y) && isInBoundsBottom(y) {
            return true
        }
        return false
    }
    
    func isInBoundsY(_ x:CGFloat, y:CGFloat) -> Bool {
        if isInBoundsX(x) && isInBoundsY(y) {
            return true
        }
        return false
    }
    
    func isInBoundsLeft(_ x:CGFloat) -> Bool {
        return contentRect.origin.x <= x ? true : false
    }
    
    func isInBoundsRight(_ x:CGFloat) -> Bool {
        let normalizeX:CGFloat = CGFloat(Int(x * 100)) / 100
        return contentRect.origin.x+contentRect.size.width >= normalizeX ? true : false
    }
    
    func isInBoundsTop(_ y:CGFloat) -> Bool {
        return contentRect.origin.y <= y ? true : false
    }
    
    func isInBoundsBottom(_ y:CGFloat) -> Bool {
        let normalizeY:CGFloat = CGFloat(Int(y * 100)) / 100
        return contentRect.origin.y+contentRect.size.height >= normalizeY ? true : false
    }
    
    func contentTop()->CGFloat {
        return contentRect.origin.y
    }
    
    func contentLeft()->CGFloat {
        return contentRect.origin.x
    }
    
    func contentRight()->CGFloat {
        return contentRect.origin.x + contentRect.size.width
    }
    
    func contentBottom()->CGFloat {
        return contentRect.origin.y + contentRect.size.height
    }
    
    func contentWidth()->CGFloat {
        return contentRect.size.width
    }
    
    func contentHeight()->CGFloat {
        return contentRect.size.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
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
