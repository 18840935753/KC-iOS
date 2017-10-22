//
//  KLineView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KLineView: KBaseLineView {
    
    // MARK: - 属性 -
    
    var dataset = KLineDataSet()
    
    var lastPinCount:Int = 0
    var lastPinScale:CGFloat = 0
    var candleWidth:CGFloat = 5
    var candleMaxWidth:CGFloat = 16
    var candleMinWidth:CGFloat = 4
    var isShowAvgMarkerEnabled = true
    var oldContentOffsetX: CGFloat = 0
    
    var astartDrawIndex = 0
    var startDrawIndex:Int {
        set{
            var nv = newValue
            if nv<0 {
                nv = 0
            }
            if (nv+countOfshowCandle()>(dataset.data?.count ?? 0)) {
                astartDrawIndex = nv
            }
            astartDrawIndex = nv
        }
        get{
            return astartDrawIndex
        }
    }
    
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bottomScroll)
        
        totalLayout()
    }
    
    
    // MARK: - 视图 -
    
    // 底层滑动
    fileprivate lazy var bottomScroll: UIScrollView = {
        let bottomScroll = UIScrollView()
        bottomScroll.backgroundColor = .clear
        bottomScroll.showsVerticalScrollIndicator = false
        bottomScroll.showsHorizontalScrollIndicator = false
        bottomScroll.minimumZoomScale = 1
        bottomScroll.maximumZoomScale = 1
        bottomScroll.delegate = self
        
        // 缩放手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinAction(_:)))
        bottomScroll.addGestureRecognizer(pinchGesture)
        
        // 长按手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(_:)))
        bottomScroll.addGestureRecognizer(longPressGesture)
        
        return bottomScroll
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        bottomScroll.snp.remakeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    
    // MARK: - Draw 赋值 -
    
    func setupData(_ dataSet: KLineDataSet) {
        dataset = dataSet
        notifyDataSetChanged()
        
        bottomScroll.contentSize = CGSize(width: CGFloat(dataset.data?.count ?? 0) * candleWidth, height: 0)
        bottomScroll.contentOffset.x = CGFloat((dataset.data?.count ?? 0)-countOfshowCandle()-1) * candleWidth
    }
    
    
    // MARK: - Draw Function -
    
    // 蜡烛数量
    fileprivate func countOfshowCandle() -> Int {
        return Int(contentWidth() / candleWidth)
    }
    
    // 计算数据极值
    func setCurrentDataMaxAndMin() {
        if (dataset.data?.count ?? 0) > 0 {
            maxPrice = CGFloat(FLT_MIN)
            minPrice = CGFloat(FLT_MAX)
            maxVolume = CGFloat(FLT_MIN)
            
            let idx = startDrawIndex
            for i in idx..<startDrawIndex+countOfshowCandle() {
                if i<(dataset.data?.count ?? 0) {
                    let entity = dataset.data?[i]
                    if entity == nil { return }
                    minPrice = minPrice < (entity?.low)! ? minPrice : (entity?.low)!
                    maxPrice = maxPrice > (entity?.high)! ? maxPrice : (entity?.high)!
                    maxVolume = maxVolume > (entity?.volume)! ? maxVolume : (entity?.volume)!
                    
                    if CGFloat((entity?.ma5)!) > 0 {
                        minPrice = minPrice < (entity?.ma5)! ? minPrice : (entity?.ma5)!
                        maxPrice = maxPrice > (entity?.ma5)! ? maxPrice : (entity?.ma5)!
                    }
                    if CGFloat((entity?.ma10)!) > 0 {
                        minPrice = minPrice < (entity?.ma10)! ? minPrice : (entity?.ma10)!
                        maxPrice = maxPrice > (entity?.ma10)! ? maxPrice : (entity?.ma10)!
                    }
                    if CGFloat((entity?.ma20)!) > 0 {
                        minPrice = minPrice < (entity?.ma20)! ? minPrice : (entity?.ma20)!
                        maxPrice = maxPrice > (entity?.ma20)! ? maxPrice : (entity?.ma20)!
                    }
                }
            }
            if maxPrice - minPrice < 0.3 {
                maxPrice = maxPrice + 0.5
                minPrice = minPrice - 0.5
            }
        }
    }
    
    // 更新
    override func notifyDataSetChanged() {
        super.notifyDataSetChanged()
        setNeedsDisplay()
        startDrawIndex = (dataset.data?.count ?? 0)-countOfshowCandle()-1
    }
    
    // 获取焦点
    func getHighlightByTouchPoint(_ point:CGPoint) {
        highlightLineCurrentIndex = startDrawIndex+Int(((point.x-contentLeft())/candleWidth))
        setNeedsDisplay()
    }
    
    // 缩放方法
    @objc private func pinAction(_ pin: UIPinchGestureRecognizer) {
        if !zoomEnabled { return }
        highlightLineCurrentEnabled = false
        pin.scale = pin.scale-lastPinScale+1
        candleWidth = pin.scale * candleWidth
        
        if(candleWidth > candleMaxWidth){
            candleWidth = candleMaxWidth
        }
        if(candleWidth < candleMinWidth){
            candleWidth = candleMinWidth
        }
        let offset = (lastPinCount-countOfshowCandle())/2
        if labs(offset) != 0 {
            lastPinCount = countOfshowCandle()
            startDrawIndex = startDrawIndex+offset
            setNeedsDisplay()
        }
        lastPinScale = pin.scale
    
        bottomScroll.contentSize = CGSize(width: CGFloat(dataset.data?.count ?? 0) * candleWidth, height: 0)
    }
    
    // 长按方法
    @objc private func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        if !highlightLineShowEnabled { return }
        if longPress.state == .began {
            let point = longPress.location(in: self)
            if point.x>contentLeft() && point.x<contentRight() && point.y>contentTop() && point.y<contentBottom() {
                highlightLineCurrentEnabled = true
                getHighlightByTouchPoint(point)
            }
        }
        if longPress.state == .ended {
            highlightLineCurrentEnabled = false
            setNeedsDisplay()
        }
        if longPress.state == .changed {
            let point = longPress.location(in: self)
            if point.x>contentLeft() && point.x<contentRight() && point.y>contentTop() && point.y<contentBottom() {
                highlightLineCurrentEnabled = true
                getHighlightByTouchPoint(point)
            }
        }
    }
    
    
    // MARK: - Draw 界面 -
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setCurrentDataMaxAndMin()
        let context = UIGraphicsGetCurrentContext()
        drawGridBackgroud(context, rect: rect)
        if (dataset.data?.count ?? 0)>0 {
            drawCandle(context)
        }
        drawLabelPrice(context)
    }
    
    // 画蜡烛图
    func drawCandle(_ context:CGContext?) {
        context?.saveGState()
        
        let idx = ( startDrawIndex>=0 ? startDrawIndex:0 )
        candleCoordsScale = uperChartHeightScale*contentHeight()/(maxPrice-minPrice)
        volumeCoordsScale = (contentHeight()-(uperChartHeightScale*contentHeight())-xAxisHeitht)/(maxVolume-0)

        
        if idx > (dataset.data?.count ?? 0) { return }
        
        for i in idx..<(dataset.data?.count ?? 0) {
            let entity = dataset.data?[i]
            let open = ((maxPrice-(entity?.open)!)*candleCoordsScale)+contentTop()
            let close = ((maxPrice-(entity?.close)!)*candleCoordsScale)+contentTop()
            let high = ((maxPrice-(entity?.high)!)*candleCoordsScale)+contentTop()
            let low = ((maxPrice-(entity?.low)!)*candleCoordsScale)+contentTop()
            let left = (candleWidth*CGFloat(i-idx)+contentLeft())+candleWidth/6.0
            
            let acandleWidth = candleWidth-candleWidth/3.0
            let startX = left + acandleWidth/2.0
            
            // 日期
            if i>startDrawIndex+5 && i<(dataset.data?.count)!-2 {
                if i%Int(180/candleWidth) == 0 {
                    drawline(context!, startPoint: CGPoint(x: startX, y: contentTop()), stopPoint: CGPoint(x: startX, y: (uperChartHeightScale*contentHeight()+contentTop())), color: kBorderColor, lineWitdth: 0.5)
                    // drawline(context!, startPoint: CGPoint(x: startX, y: (uperChartHeightScale*contentHeight()+contentTop())+xAxisHeitht-10), stopPoint: CGPoint(x: startX, y: contentBottom()), color: kBorderColor, lineWitdth: 0.5)
                    
                    let date = entity?.date
                    let drawAttributes = defaultAttributedDic
                    let dateStrAtt = NSMutableAttributedString(string: date!, attributes: drawAttributes as? [String : Any])
                    let dateStrAttSize = dateStrAtt.size()
                    drawLabel(context!, attributesText: dateStrAtt, rect: CGRect(x: startX-dateStrAttSize.width/2, y: uperChartHeightScale*contentHeight()+contentTop()+2, width: dateStrAttSize.width, height: dateStrAttSize.height))
                }
            }
            
            var color = dataset.candleRiseColor
            if open<close {
                color = dataset.candleFallColor
                let height = close-open<1.0 ? 1.0:(close-open)
                drawRect(context!, rect: CGRect(x: left, y: open, width: acandleWidth, height: height), color: color!)
                drawline(context!, startPoint: CGPoint(x: startX, y: high), stopPoint: CGPoint(x: startX, y: low), color: color!, lineWitdth: dataset.candleTopBottmLineWidth)
            } else if open==close {
                if i>1 {
                    let lastEntity = dataset.data?[i-1]
                    if CGFloat((lastEntity?.close)!) > CGFloat((entity?.close)!) {
                        color = dataset.candleFallColor
                    }
                }
                drawRect(context!, rect: CGRect(x: left, y: open, width: acandleWidth, height: 1.5), color: color!)
                drawline(context!, startPoint: CGPoint(x: startX, y: high), stopPoint: CGPoint(x: startX, y: low), color: color!, lineWitdth: dataset.candleTopBottmLineWidth)
            } else {
                color = dataset.candleRiseColor
                let height = open-close<1.0 ? 1.0:(open-close)
                drawRect(context!, rect: CGRect(x: left, y: close, width: acandleWidth, height: height), color: color!)
                drawline(context!, startPoint: CGPoint(x: startX, y: high), stopPoint: CGPoint(x: startX, y: low), color: color!, lineWitdth: dataset.candleTopBottmLineWidth)
            }
            
            if i>0 {
                let lastEntity = dataset.data?[i-1]
                let lastX = startX - candleWidth
                
                let lastY5 = (maxPrice-(lastEntity?.ma5)!)*candleCoordsScale+contentTop()
                let y5 = (maxPrice-(entity?.ma5)!)*candleCoordsScale+contentTop()
                if CGFloat((entity?.ma5)!)>0 && CGFloat((lastEntity?.ma5)!)>0 {
                    drawline(context!, startPoint: CGPoint(x: lastX, y: lastY5), stopPoint: CGPoint(x: startX, y: y5), color: dataset.avgMA5Color!, lineWitdth: dataset.avgLineWidth)
                }
                
                let lastY10 = (maxPrice-(lastEntity?.ma10)!)*candleCoordsScale+contentTop()
                let y10 = (maxPrice-(entity?.ma10)!)*candleCoordsScale+contentTop()
                if CGFloat((entity?.ma10)!)>0 && CGFloat((lastEntity?.ma10)!)>0 {
                    drawline(context!, startPoint: CGPoint(x: lastX, y: lastY10), stopPoint: CGPoint(x: startX, y: y10), color: dataset.avgMA10Color!, lineWitdth: dataset.avgLineWidth)
                }
                
                let lastY20 = (maxPrice-(lastEntity?.ma20)!)*candleCoordsScale+contentTop()
                let y20 = (maxPrice-(entity?.ma20)!)*candleCoordsScale+contentTop()
                if CGFloat((entity?.ma20)!)>0 && CGFloat((lastEntity?.ma20)!)>0 {
                    drawline(context!, startPoint: CGPoint(x: lastX, y: lastY20), stopPoint: CGPoint(x: startX, y: y20), color: dataset.avgMA20Color!, lineWitdth: dataset.avgLineWidth)
                }
            }
            
            // 成交量
            let volume = ((entity?.volume)!-0)*volumeCoordsScale
            drawRect(context!, rect: CGRect(x: left, y: contentBottom()-volume, width: acandleWidth, height: volume), color: color!)
        }
        
        for i in idx..<(dataset.data?.count ?? 0) {
            let entity = dataset.data?[i]
            let close = ((maxPrice-(entity?.close)!)*candleCoordsScale)+contentTop()
            let left = (candleWidth*CGFloat(i-idx)+contentLeft())+candleWidth/6.0
            let acandleWidth = candleWidth-candleWidth/6.0
            let startX = left+acandleWidth/2.0
            
            // 十字线
            if highlightLineCurrentEnabled {
                if i==highlightLineCurrentIndex {
                    var entity = KLineEntity()
                    if i<(dataset.data?.count)! {
                        entity = (dataset.data?[i])!
                    }
                    drawHighlighted(context!, point: CGPoint(x: startX-dataset.highlightLineWidth/2, y: close), idex: idx, value: entity, color: dataset.highlightLineColor!, lineWidth: dataset.highlightLineWidth)
                    
                    let isDrawRight = startX<(contentRight())/2.0
                    drawAvgMarket(context, idex: i, isDrawRight: isDrawRight)
                    // 回调长按选中的 K线
                    if selectCallback != nil {
                        selectCallback!(true, entity, i)
                    }
                }
            } else {
                if selectCallback != nil {
                    selectCallback!(false, entity!, i)
                }
            }
        }
    
        // kc: 注释掉
        // if !highlightLineCurrentEnabled {
        // drawAvgMarket(context, idex: 0, isDrawRight: false)
        // }
        context?.restoreGState()
    }
    
    // 画显示 MA5 MA10 MA20
    func drawAvgMarket(_ context:CGContext?, idex:Int, isDrawRight:Bool) {
        if !isShowAvgMarkerEnabled {
            return
        }
        var entity = KLineEntity()
        if idex==0 {
            entity = dataset.data?.last ?? KLineEntity()
        }else{
            entity = (dataset.data?[idex])!
        }
        
        let ma5AttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.clear, NSForegroundColorAttributeName:dataset.avgMA5Color ?? .clear]
        let ma10AttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.clear, NSForegroundColorAttributeName:dataset.avgMA10Color ?? .clear]
        let ma20AttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.clear, NSForegroundColorAttributeName:dataset.avgMA20Color ?? .clear]
        
        let ma5Str = String(format: "MA5 %.2f", entity.ma5)
        let ma5StrAtt = NSMutableAttributedString(string: ma5Str, attributes: ma5AttributedDic as? [String : Any])
        let ma5StrAttSize = ma5StrAtt.size()
        
        let ma10Str = String(format: "MA10 %.2f", entity.ma10)
        let ma10StrAtt = NSMutableAttributedString(string: ma10Str, attributes: ma10AttributedDic as? [String : Any])
        let ma10StrAttSize = ma10StrAtt.size()
        
        let ma20Str = String(format: "MA20 %.2f", entity.ma20)
        let ma20StrAtt = NSMutableAttributedString(string: ma20Str, attributes: ma20AttributedDic as? [String : Any])
        let ma20StrAttSize = ma20StrAtt.size()
        
        let radius = ma5StrAttSize.height/2
        let length = ma5StrAttSize.width+ma20StrAttSize.width+ma10StrAttSize.width+radius*8
        let space = radius
        
        var startP = CGPoint(x: contentLeft(), y: contentTop())
        if isDrawRight {
            startP.x = contentRight()-length-4
        }
        startP.y = startP.y+(radius/2.0)+2
        let labelY = contentTop()+(radius/4.0)
        
        // Background
        let bgColor = UIColor(white: 1, alpha: 0)
        drawRect(context!, rect: CGRect(x: startP.x, y: contentTop()+1, width: length, height: ma5StrAttSize.height), color: bgColor)
        
        // =====
        context?.setFillColor((dataset.avgMA5Color?.cgColor)!)
        context?.fillEllipse(in: CGRect(x: (radius/2.0), y: startP.y, width: radius, height: radius))
        startP.x = (radius+space)
        drawLabel(context!, attributesText: ma5StrAtt, rect: CGRect(x: startP.x, y: labelY, width: ma5StrAttSize.width, height: ma5StrAttSize.height))
        startP.x = startP.x+(ma5StrAttSize.width+space)
        
        // =====
        context?.setFillColor((dataset.avgMA10Color?.cgColor)!)
        context?.fillEllipse(in: CGRect(x: startP.x+(radius/2.0), y: startP.y, width: radius, height: radius))
        startP.x = startP.x+(radius+space)
        drawLabel(context!, attributesText: ma10StrAtt, rect: CGRect(x: startP.x, y: labelY, width: ma10StrAttSize.width, height: ma10StrAttSize.height))
        startP.x = startP.x+(ma10StrAttSize.width+space)
        
        // =====
        context?.setFillColor((dataset.avgMA20Color?.cgColor)!)
        context?.fillEllipse(in: CGRect(x: startP.x+(radius/2.0), y: startP.y, width: radius, height: radius))
        startP.x = startP.x+(radius+space)
        drawLabel(context!, attributesText: ma20StrAtt, rect: CGRect(x: startP.x, y: labelY, width: ma20StrAttSize.width, height: ma20StrAttSize.height))
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

extension KLineView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        
        print(abs(Int(offset)-Int(oldContentOffsetX)))
        
        // 首次进入计算
        if oldContentOffsetX == 0 {
            startDrawIndex = (dataset.data?.count ?? 0)-countOfshowCandle()
            oldContentOffsetX = offset
            setNeedsDisplay()
        }
        
        else if abs(Int(offset)-Int(oldContentOffsetX)) >= Int(candleWidth) {
            startDrawIndex = Int(offset/candleWidth)
            oldContentOffsetX = offset
            setNeedsDisplay()
        }
    }
    
}

