//
//  KBaseLineView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/16.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KBaseLineView: KBaseView {
    
    // MARK: - 属性 -
    
    public var selectCallback: ( (_ selected: Bool, _ entity: AnyObject, _ selectIndex: Int) -> Void )?
    
    var uperChartHeightScale:CGFloat = 0.715
    var xAxisHeitht:CGFloat = 20
    var xAxisAttributedDic:NSDictionary?
    var defaultAttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.clear, NSForegroundColorAttributeName:UIColor.black]
    var highlightAttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.groupTableViewBackground, NSForegroundColorAttributeName:UIColor.black]
    var clearBackLabelAttributedDic:NSDictionary = [NSFontAttributeName:UIFont.systemFont(ofSize: 10), NSBackgroundColorAttributeName:UIColor.clear, NSForegroundColorAttributeName:UIColor.black]
    
    var maxPrice:CGFloat = 0
    var minPrice:CGFloat = 0
    var maxVolume:CGFloat = 0
    var candleCoordsScale:CGFloat = 0
    var volumeCoordsScale:CGFloat = 0
    
    var highlightLineShowEnabled = true
    var highlightLineCurrentEnabled = false
    var highlightLineCurrentPoint = CGPoint(x: 0, y: 0)
    var highlightLineCurrentIndex = 0
    
    var kGridBackGroundColor:UIColor = UIColor.white
    var kBorderWidth:CGFloat = 0.5
    var kBorderColor = UIColor(white: 0, alpha: 0.3)
    var kDottedColor = UIColor(white: 0, alpha: 0.3)
    
    var scrollEnabled = true
    var leftYAxisIsInChart = true
    var rightYAxisDrawEnabled = true
    var zoomEnabled = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // MARK: 网格线
    func drawGridBackgroud(_ context:CGContext?, rect:CGRect) {
        let backGroundColor = self.kGridBackGroundColor
        context?.setFillColor(backGroundColor.cgColor)
        context?.fill(rect)
        
        // 画边框
        context?.setLineWidth(kBorderWidth)
        context?.setStrokeColor(kBorderColor.cgColor)
        context?.stroke(CGRect(x: contentLeft(), y: contentTop(), width: contentWidth(), height: uperChartHeightScale*contentHeight()))
        
        let y1 = uperChartHeightScale*contentHeight()+xAxisHeitht
        let h1 = contentBottom()-(uperChartHeightScale*contentHeight()+xAxisHeitht)
        context?.stroke(CGRect(x: contentLeft(), y: y1, width: contentWidth(), height: h1))
        
        // 画中间线
        let tpy = uperChartHeightScale*contentHeight()/2+contentTop()
        let ppy = uperChartHeightScale*contentHeight()/2+contentTop()
        drawDottedline(context!,
                       startPoint: CGPoint(x: contentLeft(), y: tpy),
                       stopPoint: CGPoint(x: contentRight(), y: ppy),
                       color: kDottedColor,
                       lineWitdth: kBorderWidth/2.0)
    }
    
    // MARK: 画实线
    func drawline(_ context:CGContext,
                  startPoint:CGPoint,
                  stopPoint:CGPoint,
                  color:UIColor,
                  lineWitdth:CGFloat) {
        if startPoint.x < contentLeft() || stopPoint.x > contentRight() || startPoint.y < contentTop() || stopPoint.y < contentTop() {
            return
        }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWitdth)
        context.beginPath()
        context.move(to: CGPoint(x: startPoint.x, y: startPoint.y))
        context.addLine(to: CGPoint(x: stopPoint.x, y: stopPoint.y))
        context.strokePath()
    }
    
    // MARK: 画虚线
    func drawDottedline(_ context:CGContext,
                        startPoint:CGPoint,
                        stopPoint:CGPoint,
                        color:UIColor,
                        lineWitdth:CGFloat) {
        if startPoint.x < contentLeft() || stopPoint.x > contentRight() || startPoint.y < contentTop() || stopPoint.y < contentTop() {
            return
        }
        
        context.saveGState()
        context.beginPath()
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWitdth)
        
        let lengths:[CGFloat] = [3, 1]
        context.setLineDash(phase: 0, lengths: lengths)
        context.move(to: startPoint)
        context.addLine(to: CGPoint(x: stopPoint.x, y: stopPoint.y))
        context.strokePath()
        context.restoreGState()
    }
    
    // MARK: 画十字线
    func drawHighlighted(_ context:CGContext, point:CGPoint, idex:Int, value:Any, color:UIColor, lineWidth:CGFloat) {
        
        var leftMarketStr = ""
        var bottomMarkerStr = ""
        var rightMarkerStr = ""
        var volumeMarkerStr = ""
        
        if let entity = value as? TimeLineEntity {
            leftMarketStr = handleStrWithPrice(entity.lastPirce)
            bottomMarkerStr = entity.currtTime ?? ""
            rightMarkerStr = handleStrWithPrice(entity.lastPirce)
            volumeMarkerStr = String(format: "%@%@", arguments: [handleShowNumWithVolume(entity.volume), handleShowWithVolume(entity.volume)])
        } else if let entity = value as? KLineEntity {
            leftMarketStr = handleStrWithPrice(entity.close)
            bottomMarkerStr = entity.date
            volumeMarkerStr = String(format: "%@%@", arguments: [handleShowNumWithVolume(entity.volume), handleShowWithVolume(entity.volume)])
        }
        
        // kc: 注释掉
        // if [leftMarketStr, bottomMarkerStr, rightMarkerStr].contains("") {
        // return
        // }
        
        bottomMarkerStr = " "+bottomMarkerStr+" "
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        context.beginPath()
        context.move(to: CGPoint(x: point.x, y: contentTop()))
        context.addLine(to: CGPoint(x: point.x, y: contentBottom()))
        context.strokePath()
        
        context.beginPath()
        context.move(to: CGPoint(x: contentLeft(), y: point.y))
        context.addLine(to: CGPoint(x: contentRight(), y: point.y))
        context.strokePath()
        
        let radius:CGFloat = 3.0
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(x: point.x-(radius/2.0), y: point.y-(radius/2.0), width: radius, height: radius))
        
        let drawAttributes = highlightAttributedDic
        
        // 左侧文本
        let leftMarkerStrAtt = NSMutableAttributedString(string: leftMarketStr, attributes: drawAttributes as? [String : Any])
        let leftMarkerStrAttSize = leftMarkerStrAtt.size()
        // drawLabel(context, attributesText: leftMarkerStrAtt, rect: CGRect(x: contentLeft()-leftMarkerStrAttSize.width, y: point.y-leftMarkerStrAttSize.height/2.0, width: leftMarkerStrAttSize.width, height: leftMarkerStrAttSize.height))
        
        // 下侧文本
        let bottomMarkerStrAtt = NSMutableAttributedString(string: bottomMarkerStr, attributes: drawAttributes as? [String : Any])
        let bottomMarkerStrAttSize = bottomMarkerStrAtt.size()
        var rect = CGRect(x: point.x-bottomMarkerStrAttSize.width/2.0, y: uperChartHeightScale*contentHeight()+contentTop(), width: leftMarkerStrAttSize.width, height: leftMarkerStrAttSize.height)
        if rect.size.width+rect.origin.x > contentRight() {
            rect.origin.x = contentRight()-rect.size.width
        }
        if rect.origin.x < contentLeft() {
            rect.origin.x = contentLeft()
        }
        // drawLabel(context, attributesText: leftMarkerStrAtt, rect: rect)
        
        // 右侧文本
        let rightMarkerStrAtt = NSMutableAttributedString(string: rightMarkerStr, attributes: drawAttributes as? [String : Any])
        let rightMarkerStrAttSize = rightMarkerStrAtt.size()
        drawLabel(context, attributesText: rightMarkerStrAtt, rect: CGRect(x: contentRight()-rightMarkerStrAttSize.width, y: point.y-rightMarkerStrAttSize.height/2.0, width: rightMarkerStrAttSize.width, height: rightMarkerStrAttSize.height))
        
        // 成交量
        let volumeMarkerStrAtt = NSMutableAttributedString(string: volumeMarkerStr, attributes: clearBackLabelAttributedDic as? [String : Any])
        let volumeMarkerStrAttSize = volumeMarkerStrAtt.size()
        drawLabel(context, attributesText: volumeMarkerStrAtt, rect: CGRect(x: contentLeft(), y: contentHeight()*uperChartHeightScale+xAxisHeitht, width: volumeMarkerStrAttSize.width, height: volumeMarkerStrAttSize.height))
    }
    
    // MARK: 绘制两侧价格
    func drawLabelPrice(_ context:CGContext?) {
        let labelBGColor = UIColor(white: 1, alpha: 0)
        let drawAttributes = xAxisAttributedDic ?? defaultAttributedDic
        
        // 价格统一往左移2个像素，价格标签把图标的线遮挡了
        let maxPriceStr = handleStrWithPrice(maxPrice)
        let maxPriceAttStr = NSMutableAttributedString(string: maxPriceStr, attributes: drawAttributes as? [String : Any])
        let sizeMaxPriceAttStr = maxPriceAttStr.size()
        let maxPriceRect = CGRect(x: contentRight()-sizeMaxPriceAttStr.width-(leftYAxisIsInChart ? 0 : sizeMaxPriceAttStr.width+2), y: contentTop(), width: sizeMaxPriceAttStr.width, height: sizeMaxPriceAttStr.height)
        drawRect(context!, rect: maxPriceRect, color: labelBGColor)
        drawLabel(context!, attributesText: maxPriceAttStr, rect: maxPriceRect)
        
        let midPriceStr = handleStrWithPrice((maxPrice+minPrice)/2.0)
        let midPriceAttStr = NSMutableAttributedString(string: midPriceStr, attributes: drawAttributes as? [String : Any])
        let sizeMidPriceAttStr = midPriceAttStr.size()
        let midPriceRect = CGRect(x: contentRight()-sizeMidPriceAttStr.width-(leftYAxisIsInChart ? 0 : sizeMidPriceAttStr.width+2), y: ((uperChartHeightScale * contentHeight())/2.0 + contentTop())-sizeMidPriceAttStr.height/2.0, width: sizeMidPriceAttStr.width, height: sizeMidPriceAttStr.height)
        drawRect(context!, rect: midPriceRect, color: labelBGColor)
        drawLabel(context!, attributesText: midPriceAttStr, rect: midPriceRect)
        
        let minPriceStr = handleStrWithPrice(minPrice)
        let minPriceAttStr = NSMutableAttributedString(string: minPriceStr, attributes: drawAttributes as? [String : Any])
        let sizeMinPriceAttStr = minPriceAttStr.size()
        let minPriceRect = CGRect(x: contentRight()-sizeMinPriceAttStr.width-(leftYAxisIsInChart ? 0 : sizeMidPriceAttStr.width+2), y: ((uperChartHeightScale*contentHeight())+contentTop()-sizeMinPriceAttStr.height), width: sizeMinPriceAttStr.width, height: sizeMinPriceAttStr.height)
        drawRect(context!, rect: minPriceRect, color: labelBGColor)
        drawLabel(context!, attributesText: minPriceAttStr, rect: minPriceRect)
        
        //        let zeroVolumeStr = handleShowWithVolume(maxVolume)
        //        let zeroVolumeAttStr = NSMutableAttributedString(string: zeroVolumeStr, attributes: drawAttributes as? [String : Any])
        //        let zeroVolumeAttStrSize = zeroVolumeAttStr.size()
        //        let zeroVolumeRect = CGRect(x: contentLeft()-(leftYAxisIsInChart ? 0 : sizeMidPriceAttStr.width+2), y: contentBottom()-zeroVolumeAttStrSize.height, width: zeroVolumeAttStrSize.width, height: zeroVolumeAttStrSize.height)
        //        drawRect(context!, rect: zeroVolumeRect, color: labelBGColor)
        //        drawLabel(context!, attributesText: zeroVolumeAttStr, rect: zeroVolumeRect)
        //
        //        let maxVolumeStr = handleShowWithVolume(maxVolume)
        //        let maxVolumeAttStr = NSMutableAttributedString(string: maxVolumeStr, attributes: drawAttributes as? [String : Any])
        //        let maxVolumeAttStrSize = maxVolumeAttStr.size()
        //        let maxVolumeRect = CGRect(x: contentLeft()-(leftYAxisIsInChart ? 0 : sizeMidPriceAttStr.width+2), y: (uperChartHeightScale*contentHeight())+xAxisHeitht, width: maxVolumeAttStrSize.width, height: maxVolumeAttStrSize.height)
        //        drawRect(context!, rect: maxVolumeRect, color: labelBGColor)
        //        drawLabel(context!, attributesText: maxVolumeAttStr, rect: maxVolumeRect)
        
        //        if (self.rightYAxisDrawEnabled) {
        //            NSString * maxRateStr = [self handleRateWithPrice:self.maxPrice originPX:(self.maxPrice+self.minPrice)/2.0];
        //            NSMutableAttributedString * maxRateAttStr = [[NSMutableAttributedString alloc]initWithString:maxRateStr attributes:drawAttributes];
        //            CGSize sizeMaxRateAttStr = [maxRateAttStr size];
        //            CGRect maxRateRect = CGRectMake(self.contentRight- (self.leftYAxisIsInChart?sizeMaxRateAttStr.width:0), self.contentTop, sizeMaxRateAttStr.width, sizeMaxRateAttStr.height);
        //            [self drawRect:context rect:maxRateRect color:labelBGColor];
        //            [self drawLabel:context attributesText:maxRateAttStr rect:maxRateRect];
        //
        //            NSString * minRateStr = [self handleRateWithPrice:self.minPrice originPX:(self.maxPrice+self.minPrice)/2.0];
        //            NSMutableAttributedString * minRateAttStr = [[NSMutableAttributedString alloc]initWithString:minRateStr attributes:drawAttributes];
        //            CGSize sizeMinRateAttStr = [minRateAttStr size];
        //            CGRect minRateRect = CGRectMake(self.contentRight-(self.leftYAxisIsInChart?sizeMinRateAttStr.width:0), ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinRateAttStr.height ), sizeMinRateAttStr.width, sizeMinRateAttStr.height);
        //            [self drawRect:context rect:minRateRect color:labelBGColor];
        //            [self drawLabel:context attributesText:minRateAttStr rect:minRateRect];
        //        }
        
    }
    
    // MARK: 画文本
    func drawLabel(_ context:CGContext, attributesText:NSAttributedString, rect:CGRect) {
        attributesText.draw(in: rect)
    }
    
    // MARK: 画矩形
    func drawRect(_ context:CGContext, rect:CGRect, color:UIColor) {
        if rect.origin.x+rect.size.width>contentRight() {
            return
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
    }
    
    // MARK: 价格保留两位小数
    func handleStrWithPrice(_ price:CGFloat) -> String {
        return String(format: "%.2f", price)
    }
    
    
    // MARK: 成交单位
    func handleShowNumWithVolume(_ volume:CGFloat) -> String {
        var avolume = volume
        avolume = volume/100.0
        if avolume<10000.0 {
            return String(format: "%.0f", arguments: [avolume])
        } else if avolume>10000.0 && avolume<100000000.0 {
            return String(format: "%.2f", arguments: [avolume/1000.0])
        } else {
            return String(format: "%.2f", arguments: [avolume/100000000.0])
        }
    }
    func handleShowWithVolume(_ volume:CGFloat) -> String {
        var avolume = volume
        avolume = volume/100.0
        if avolume<10000.0 {
            return "手 "
        } else if avolume>10000.0 && avolume<100000000.0 {
            return "万手 "
        } else {
            return "亿手 "
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
