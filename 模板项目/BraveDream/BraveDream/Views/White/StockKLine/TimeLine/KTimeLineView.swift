
//
//  KTimeLIne.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KTimeLineView: KBaseLineView {
    
    var dataset = KTimeDataSet()
    var offsetMaxPrice:CGFloat = 0
    var countOfTimes:Int = 0
    
    var isDrawAvgEnabled = true
    var endPointShowEnabled = true
    
    var breathingPoint:CALayer!
    private var loading:UILabel!
    
    lazy var longPressGesture:UILongPressGestureRecognizer = {
        let alongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureAction(_:)))
        return alongPressGesture
    }()
    
    var volumeWidth:CGFloat! {
        get {
            return contentWidth()/CGFloat(countOfTimes)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // loadingDataView()
    }
    
    // MARK: 赋值区域
    func setupData(_ dataSet: KTimeDataSet) {
        dataset = dataSet
        notifyDataSetChanged()
    }
    
    // MARK: 数据极值
    func setCurrentDataMaxAndMin() {
        if dataset.data.count > 0 {
            maxPrice = CGFloat(FLT_MIN)
            minPrice = CGFloat(FLT_MAX)
            maxVolume = CGFloat(FLT_MIN)
            offsetMaxPrice = CGFloat(FLT_MIN)
            
            for i in 0..<dataset.data.count {
                let entity = dataset.data[i]
                
                offsetMaxPrice = CGFloat(Float(offsetMaxPrice) > fabsf(Float(entity.lastPirce-entity.preClosePx)) ? Float(offsetMaxPrice) : fabsf(Float(entity.lastPirce-entity.preClosePx)))
                //                if entity.avgPirce == 0 {
                //                    offsetMaxPrice = CGFloat(Float(offsetMaxPrice) > fabsf(Float(entity.avgPirce-entity.preClosePx)) ? Float(offsetMaxPrice) : fabsf(Float(entity.avgPirce-entity.preClosePx)))
                //                }
                maxVolume = maxVolume > entity.volume ? maxVolume : entity.volume
            }
            
            maxPrice = (dataset.data.first?.preClosePx ?? 0)+offsetMaxPrice
            minPrice = (dataset.data.first?.preClosePx ?? 0)-offsetMaxPrice
            
            if maxPrice==minPrice{
                maxPrice = maxPrice+0.01
                minPrice = minPrice-0.01
            }
            
            for i in 0..<dataset.data.count {
                let entity = dataset.data[i]
                if entity.avgPirce != 0 {
                    entity.avgPirce = entity.avgPirce < minPrice ? minPrice : entity.avgPirce
                    entity.avgPirce = entity.avgPirce > maxPrice ? maxPrice : entity.avgPirce
                }
            }
        }
    }
    
    // MARK: 通知刷新数据
    override func notifyDataSetChanged() {
        super.notifyDataSetChanged()
        setNeedsDisplay()
    }
    
    // MARK: 长按手势
    func handleLongPressGestureAction(_ longTap:UILongPressGestureRecognizer) {
        if !highlightLineShowEnabled {
            return
        }
        if longTap.state == UIGestureRecognizerState.began {
            let point = longTap.location(in: self)
            if point.x>contentLeft() && point.x<contentRight() && point.y>contentTop() && point.y<contentBottom() {
                highlightLineCurrentEnabled = true
                getHighlightByTouchPoint(point)
            }
        }
        if longTap.state == UIGestureRecognizerState.ended {
            if highlightLineCurrentEnabled {
                highlightLineCurrentEnabled = false
            }
            setNeedsDisplay()
        }
        if longTap.state == UIGestureRecognizerState.changed {
            let point = longTap.location(in: self)
            if point.x>contentLeft() && point.x<contentRight() && point.y>contentTop() && point.y<contentBottom() {
                highlightLineCurrentEnabled = true
                getHighlightByTouchPoint(point)
            }
        }
    }
    
    // MARK: 长按点位置
    func getHighlightByTouchPoint(_ point:CGPoint) {
        highlightLineCurrentIndex = (Int)((point.x - contentLeft())/volumeWidth)
        setNeedsDisplay()
    }
    
    // MARK: 开始画图
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addGestureRecognizer(longPressGesture)
        
        setCurrentDataMaxAndMin()
        let context = UIGraphicsGetCurrentContext()
        drawGridBackgroud(context, rect: rect)
        drawTimeLabel(context)
        
        if dataset.data.count>0 {
            // loading.removeFromSuperview()
            drawTimeLine(context)
            drawMaxMinPriceRate(context)
        }
    }
    
    // MARK: 画空数据视图
    private func loadingDataView() {
        loading = UILabel()
        loading.layer.borderWidth = 0.5
        loading.layer.borderColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 234/255.0, alpha: 1).cgColor
        loading.backgroundColor = .white
        loading.textAlignment = .center
        loading.textColor = .darkGray
        loading.font = UIFont.systemFont(ofSize: 16)
        loading.text = "加载中......"
        self.addSubview(loading)
        
        loading.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
        }
    }
    
    // MARK: 网格线
    override func drawGridBackgroud(_ context:CGContext?, rect:CGRect) {
        super.drawGridBackgroud(context, rect: rect)
    }
    
    // MARK: 时间轴
    func drawTimeLabel(_ context:CGContext?) {
        let drawAttributes = xAxisAttributedDic ?? defaultAttributedDic
        
        if dataset.days.count>0 {
            for i in 0..<dataset.days.count {
                let dateAttStr = NSMutableAttributedString(string: dataset.days[i], attributes: drawAttributes as? [String : Any])
                let sizeDateAttStr = dateAttStr.size()
                let leftSpace = (contentWidth()/5-sizeDateAttStr.width)/2
                drawLabel(context!, attributesText: dateAttStr, rect: CGRect(x: leftSpace+contentWidth()/5*CGFloat(i)+contentLeft(), y: uperChartHeightScale*contentHeight()+contentTop()+2, width: sizeDateAttStr.width, height: sizeDateAttStr.height))
                
                let startX = contentWidth()/5*CGFloat(i)+contentLeft()
                drawline(context!, startPoint: CGPoint(x: startX, y: contentTop()), stopPoint: CGPoint(x: startX, y: (uperChartHeightScale*contentHeight()+contentTop())), color: kBorderColor, lineWitdth: 0.25)
                drawline(context!, startPoint: CGPoint(x: startX, y: (uperChartHeightScale*contentHeight()+contentTop())+xAxisHeitht-10), stopPoint: CGPoint(x: startX, y: contentBottom()), color: kBorderColor, lineWitdth: 0.25)
            }
        }else{
            let startTimeAttStr = NSMutableAttributedString(string: "9:30", attributes: drawAttributes as? [String : Any])
            let sizeStartTimeAttStr = startTimeAttStr.size()
            drawLabel(context!, attributesText: startTimeAttStr, rect: CGRect(x: contentLeft(), y: uperChartHeightScale*contentHeight()+contentTop()+2, width: sizeStartTimeAttStr.width, height: sizeStartTimeAttStr.height))
            
            let midTimeAttStr = NSMutableAttributedString(string: "11:30/13:00", attributes: drawAttributes as? [String : Any])
            let sizeMidTimeAttStr = midTimeAttStr.size()
            drawLabel(context!, attributesText: midTimeAttStr, rect: CGRect(x: contentWidth()/2+contentLeft()-sizeMidTimeAttStr.width/2, y: uperChartHeightScale*contentHeight()+contentTop()+2, width: sizeMidTimeAttStr.width, height: sizeMidTimeAttStr.height))
            
            let stopTimeAttStr = NSMutableAttributedString(string: "15:00", attributes: drawAttributes as? [String : Any])
            let sizeStopTimeAttStr = stopTimeAttStr.size()
            drawLabel(context!, attributesText: stopTimeAttStr, rect: CGRect(x: contentRight()-sizeStopTimeAttStr.width, y: uperChartHeightScale*contentHeight()+contentTop()+2, width: sizeStopTimeAttStr.width, height: sizeStopTimeAttStr.height))
        }
    }
    
    // MARK: 两侧价格及涨跌幅
    func drawMaxMinPriceRate(_ context:CGContext?) {
        let drawAttributes = xAxisAttributedDic ?? defaultAttributedDic
        
        let maxUpPrice = NSMutableAttributedString(string: "\(String(format: "%.2f", maxPrice))", attributes: drawAttributes as? [String : Any])
        let midPrice = NSMutableAttributedString(string: "\(String(format: "%.2f", (maxPrice+minPrice)/2))", attributes: drawAttributes as? [String : Any])
        let minDownPrice = NSMutableAttributedString(string: "\(String(format: "%.2f", minPrice))", attributes: drawAttributes as? [String : Any])
        
        let sizeMaxUpPrice = maxUpPrice.size()
        let sizeMinDownPrice = minDownPrice.size()
        let sizeMidPrice = midPrice.size()
        
        drawLabel(context!, attributesText: maxUpPrice, rect: CGRect(x: contentRight()-sizeMaxUpPrice.width, y: contentTop(), width: sizeMaxUpPrice.width, height: sizeMaxUpPrice.height))
        drawLabel(context!, attributesText: midPrice, rect: CGRect(x: contentRight()-sizeMidPrice.width, y: uperChartHeightScale*contentHeight()/2+contentTop()-sizeMidPrice.height/2, width: sizeMidPrice.width, height: sizeMidPrice.height))
        drawLabel(context!, attributesText: minDownPrice, rect: CGRect(x: contentRight()-sizeMinDownPrice.width, y: uperChartHeightScale*contentHeight()+contentTop()-sizeMinDownPrice.height, width: sizeMinDownPrice.width, height: sizeMinDownPrice.height))
    }
    
    // MARK: 画分时线
    func drawTimeLine(_ context:CGContext?) {
        context?.saveGState()
        
        candleCoordsScale = uperChartHeightScale*contentHeight()/(maxPrice-minPrice)
        volumeCoordsScale = (contentHeight()-(uperChartHeightScale*contentHeight())-xAxisHeitht)/(self.maxVolume-0)
        
        let fillPath = CGMutablePath()
        
        for i in 0..<dataset.data.count {
            let entity = dataset.data[i]
            let left = volumeWidth*CGFloat(i)+contentLeft()+volumeWidth/6
            let candleWidth = volumeWidth-volumeWidth/6
            let startX = left+candleWidth/2.0
            var yPrice:CGFloat = 0
            
            var color = dataset.volumeRiseColor
            if i>0 {
                let lastEntity = dataset.data[i-1]
                let lastX = startX-volumeWidth
                var lastYPrice = (maxPrice-lastEntity.lastPirce)*candleCoordsScale+contentTop()
                yPrice = (maxPrice-entity.lastPirce)*candleCoordsScale+contentTop()
                
                // kc: 解决边线超出顶部问题
                if yPrice<10 { yPrice = 10 }
                if lastYPrice<10 { lastYPrice = 10 }
                
                self.drawline(context!, startPoint: CGPoint(x: lastX, y: lastYPrice), stopPoint: CGPoint(x: startX, y: yPrice), color: dataset.priceLineCorlor , lineWitdth: dataset.lineWidth )
                
                // MARK: 画均线
                if isDrawAvgEnabled {
                    if lastEntity.avgPirce > 0 && entity.avgPirce > 0 {
                        let lastYAvg = (maxPrice-lastEntity.avgPirce)*candleCoordsScale+contentTop()
                        let yAvg = (maxPrice-entity.avgPirce)*candleCoordsScale+contentTop()
                        drawline(context!, startPoint: CGPoint(x: lastX, y: lastYAvg), stopPoint: CGPoint(x: startX, y: yAvg), color: dataset.avgLineCorlor , lineWitdth: dataset.lineWidth)
                    }
                }
                
                if entity.lastPirce > lastEntity.lastPirce {
                    color = dataset.volumeRiseColor
                } else if entity.lastPirce < lastEntity.lastPirce {
                    color = self.dataset.volumeFallColor
                }else{
                    color = self.dataset.volumeTieColor
                }
                
                if i==1 {
                    fillPath.move(to: CGPoint(x: contentLeft(), y: uperChartHeightScale*contentHeight()+contentTop()))
                    fillPath.addLine(to: CGPoint(x: contentLeft(), y: lastYPrice))
                    fillPath.addLine(to: CGPoint(x: lastX, y: lastYPrice))
                }else{
                    fillPath.addLine(to: CGPoint(x: startX, y: yPrice))
                }
                if i == dataset.data.count-1 {
                    fillPath.addLine(to: CGPoint(x: startX, y: yPrice))
                    fillPath.addLine(to: CGPoint(x: startX, y: uperChartHeightScale*contentHeight()+contentTop()))
                    fillPath.closeSubpath()
                }
            }
            
            // 成交量
            let volume = (entity.volume - 0) * volumeCoordsScale
            drawRect(context!, rect: CGRect(x: left, y: contentBottom()-volume, width: candleWidth, height: volume), color: color)
            
            // 十字线
            if highlightLineCurrentEnabled {
                if i==highlightLineCurrentIndex {
                    if i==0 {
                        yPrice = (maxPrice - entity.lastPirce)*candleCoordsScale + contentTop()
                    }
                    var entity = TimeLineEntity()
                    if dataset.data.count>i {
                        entity = dataset.data[i]
                    }
                    drawHighlighted(context!, point: CGPoint(x: startX, y: yPrice), idex: i, value: entity, color: dataset.highlightLineColor, lineWidth: dataset.highlightLineWidth)
                    
                    // 回调长按选中的 K线
                    if selectCallback != nil {
                        selectCallback!(true, entity, i)
                    }
                }
            } else {
                
                if selectCallback != nil {
                    selectCallback!(false, entity, i)
                }
            }
            
            // 尾点
            if (self.endPointShowEnabled) {
                if (i == dataset.data.count-1 && i != self.countOfTimes-1) {
                    breathingPoint = setupBreathingPoint()
                    breathingPoint.frame = CGRect(x: startX-4/2, y: yPrice-4/2, width: 4, height: 4)
                }
            }
        }
        
        if dataset.drawFilledEnabled && dataset.data.count > 0 {
            drawLinearGradient(context!, path: fillPath, alpha: dataset.fillAlpha, startColor: dataset.fillStartColor.cgColor, endColor: dataset.fillStopColor.cgColor)
        }
        
        for i in 0..<dataset.data.count {
            let entity = dataset.data[i]
            let left = volumeWidth*CGFloat(i)+contentLeft()+volumeWidth/6
            let candleWidth = volumeWidth-volumeWidth/6
            let startX = left+candleWidth/2
            if i>0 {
                let lastEntity = dataset.data[i-1]
                let lastX = startX-volumeWidth
                if isDrawAvgEnabled {
                    if lastEntity.avgPirce>0 && entity.avgPirce>0 {
                        let lastYAvg = (maxPrice-lastEntity.avgPirce)*candleCoordsScale+contentTop()
                        let yAvg = (maxPrice-entity.avgPirce)*candleCoordsScale+contentTop()
                        drawline(context!, startPoint: CGPoint(x:lastX, y:lastYAvg), stopPoint: CGPoint(x:startX, y:yAvg), color: dataset.avgLineCorlor, lineWitdth: dataset.lineWidth)
                    }
                }
            }
        }
        
        // ......
        context?.restoreGState()
    }
    
    func drawLinearGradient(_ context:CGContext,
                            path:CGPath,
                            alpha:CGFloat,
                            startColor:CGColor,
                            endColor:CGColor) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let colors = [startColor, endColor]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let pathRect = path.boundingBox
        
        let startPoint = CGPoint(x: pathRect.midX, y: pathRect.minY)
        let endPoint = CGPoint(x: pathRect.midX, y: pathRect.maxY)
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.setAlpha(dataset.fillAlpha)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }
    
    // MARK: 画尾点
    func setupBreathingPoint() -> CALayer {
        if breathingPoint == nil {
            breathingPoint = CAScrollLayer()
            breathingPoint.backgroundColor = UIColor.white.cgColor
            breathingPoint.cornerRadius = 2
            breathingPoint.masksToBounds = true
            breathingPoint.borderWidth = 1
            breathingPoint.borderColor = dataset.priceLineCorlor.cgColor
            breathingPoint.add(groupAnimationDurTimes(1.5), forKey: "breathingPoint")
            layer.addSublayer(breathingPoint)
            return breathingPoint
        }
        return breathingPoint
    }
    
    // MARK: 尾点动画
    func breathingLight(_ time:Float) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 1)
        animation.toValue = NSNumber(value: 0.3) //alpha
        animation.autoreverses = true
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return animation
    }
    
    func groupAnimationDurTimes(_ time:Float) -> CAAnimationGroup {
        let scaleAnim = CABasicAnimation(keyPath: "transform")
        scaleAnim.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnim.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1.0))
        scaleAnim.isRemovedOnCompletion = false
        
        let array = [breathingLight(time), scaleAnim]
        let animation = CAAnimationGroup()
        animation.animations = array
        animation.duration = CFTimeInterval(time)
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation;
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

