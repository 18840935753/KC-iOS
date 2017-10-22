//
//  KLineCollectionView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/17.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KLineCollectionView: UIView {
    
    // MARK: - 属性 -
    
    fileprivate var timeInfos: [NSMutableAttributedString]?
    
    public var timeEntity: TimeLineEntity? {
        didSet {
            
            guard let entity = timeEntity else { return }
            
            timeInfos = [NSMutableAttributedString]()
            
            let timeAttr = NSMutableAttributedString(string: entity.currtTime ?? "")
            timeAttr.addAttributes([NSForegroundColorAttributeName: UIColor.black,
                                    NSFontAttributeName:UIFont.systemFont(ofSize: 12)],
                                    range: NSMakeRange(0, timeAttr.length))
            timeInfos?.append(timeAttr)
            
            let priceStr = "价 \(String(format: "%.2f", entity.lastPirce))"
            var rateStr = "幅 +\(String(format: "%.2f", entity.rate ?? 0))%"
            let volumeStr = "量 \(String(format: "%.f", entity.volume))"
            
            var fontColor = UIColor(red: 203/255.0, green: 31/255.0, blue: 3/255.0, alpha: 1)
            if (entity.rate ?? 0) < 0 {
                rateStr = "幅 \(String(format: "%.2f", entity.rate ?? 0))%"
                fontColor = UIColor(red: 22/255.0, green: 176/255.0, blue: 62/255.0, alpha: 1)
            }
            
            let colors = [fontColor, fontColor, UIColor.darkGray]
            let attrs = [priceStr, rateStr, volumeStr]
            
            for i in 0..<colors.count {
                let attr = NSMutableAttributedString(string: attrs[i])
                attr.addAttributes([NSForegroundColorAttributeName: colors[i],
                                    NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
                                    range: NSMakeRange(2, attr.length-2))
                attr.addAttributes([NSForegroundColorAttributeName: UIColor.black,
                                    NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
                                   range: NSMakeRange(0, 1))
                timeInfos?.append(attr)
            }
            
            stockInfoCollection.reloadData()
        }
    }
    
    public var kLineEntity: KLineEntity? {
        didSet {
            
            guard let entity = kLineEntity else { return }
            
            timeInfos = [NSMutableAttributedString]()
            
            let timeAttr = NSMutableAttributedString(string: entity.date)
            timeAttr.addAttributes([NSForegroundColorAttributeName: UIColor.black,
                                    NSFontAttributeName:UIFont.systemFont(ofSize: 12)],
                                   range: NSMakeRange(0, timeAttr.length))
            timeInfos?.append(timeAttr)
            
            let openStr   = "开 \(String(format: "%.2f", entity.open))"
            let highStr   = "高 \(String(format: "%.2f", entity.high))"
            let volumeStr = "量 \(String(format: "%.2f万", entity.volume/10000))"
            let closeStr  = "收 \(String(format: "%.2f", entity.close))"
            let lowStr    = "低 \(String(format: "%.2f", entity.low))"
            var rateStr   = "幅 +\(String(format: "%.2f", entity.rate))%"
            
            let riseColor = UIColor(red: 203/255.0, green: 31/255.0, blue: 3/255.0, alpha: 1)
            let fallColor = UIColor(red: 22/255.0, green: 176/255.0, blue: 62/255.0, alpha: 1)
            var fontColor = riseColor
            if entity.rate < 0 {
                rateStr = "幅 \(String(format: "%.2f", entity.rate))%"
                fontColor = fallColor
            }
            
            let openAttr = NSMutableAttributedString(string: openStr)
            if entity.preClosePx<entity.open {
                openAttr.addAttributes([NSForegroundColorAttributeName:fallColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, openAttr.length-2))
            } else {
                openAttr.addAttributes([NSForegroundColorAttributeName:riseColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, openAttr.length-2))
            }
            timeInfos?.append(openAttr)
            
            let highAttr = NSMutableAttributedString(string: highStr)
            if entity.high<entity.mid {
                highAttr.addAttributes([NSForegroundColorAttributeName:fallColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, highAttr.length-2))
            } else {
                highAttr.addAttributes([NSForegroundColorAttributeName:riseColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, highAttr.length-2))
            }
            timeInfos?.append(highAttr)
            
            let volumeAttr = NSMutableAttributedString(string: volumeStr)
            volumeAttr.addAttributes([NSForegroundColorAttributeName:UIColor.darkGray, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, volumeAttr.length-2))
            timeInfos?.append(volumeAttr)
            
            let closeAttr = NSMutableAttributedString(string: closeStr)
            closeAttr.addAttributes([NSForegroundColorAttributeName:fontColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, closeAttr.length-2))
            timeInfos?.append(closeAttr)
            
            let lowAttr = NSMutableAttributedString(string: lowStr)
            if entity.low<entity.mid {
                lowAttr.addAttributes([NSForegroundColorAttributeName:fallColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, lowAttr.length-2))
            }else{
                lowAttr.addAttributes([NSForegroundColorAttributeName:riseColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, lowAttr.length-2))
            }
            timeInfos?.append(lowAttr)
            
            let rateAttr = NSMutableAttributedString(string: rateStr)
            rateAttr.addAttributes([NSForegroundColorAttributeName:fontColor, NSFontAttributeName:UIFont.systemFont(ofSize: 12)], range: NSMakeRange(2, rateAttr.length-2))
            timeInfos?.append(rateAttr)
            
            for i in 1..<(timeInfos?.count ?? 1) {
                timeInfos?[i].addAttributes([NSForegroundColorAttributeName: UIColor.black,
                                    NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
                                   range: NSMakeRange(0, 1))
            }
            
            
            // 格式需要
            timeInfos?.insert(NSMutableAttributedString(string: ""), at: 4)
            
            stockInfoCollection.reloadData()
        }
    }
    
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(stockInfoCollection)
        
        totalLayout()
    }
    
    
    // MARK: - 视图 -
    
    private lazy var stockInfoCollection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let fullWidth = Commons.isLandscape() ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
        flowLayout.itemSize = CGSize(width: (fullWidth-10*2)/4, height: 15)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let stockInfoCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        stockInfoCollection.showsHorizontalScrollIndicator = false
        stockInfoCollection.backgroundColor = .white
        stockInfoCollection.delegate = self
        stockInfoCollection.dataSource = self
        stockInfoCollection.register(KLineCollectionCell.self, forCellWithReuseIdentifier: "stockInfoReuse")
        return stockInfoCollection
    }()
    
    
    // MARK: - 布局 -
    private func totalLayout() {
        
        stockInfoCollection.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(5, 10, 0, 10))
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

extension KLineCollectionView: UICollectionViewDelegate {
    
}

extension KLineCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeInfos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockInfoReuse", for: indexPath) as! KLineCollectionCell
        cell.name.attributedText = timeInfos?[indexPath.row]
        return cell
    }
}
