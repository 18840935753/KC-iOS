//
//  MainTableHeader.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/17.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit
import FSPagerView

class MainTableHeader: UIView {
    
    // MARK: - 声明 属性 -
    
    fileprivate let imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(whiteBack)
        whiteBack.addSubview(hideBottomCorner)
        whiteBack.addSubview(banner)
        banner.addSubview(pageControl)
    
        totalLayout()
    }
    
    // MARK: - 声明 控件 -
    
    // 白板
    private lazy var whiteBack:UIView = {
        let whiteBack = UIView()
        whiteBack.layer.cornerRadius = 10
        whiteBack.backgroundColor = .white
        return whiteBack
    }()
    
    // 底部圆角遮挡
    private lazy var hideBottomCorner:UIView = {
        let hideBottomCorner = UIView()
        hideBottomCorner.backgroundColor = .white
        return hideBottomCorner
    }()
    
    // 轮播图
    private lazy var banner:FSPagerView = {
        let banner = FSPagerView()
        banner.delegate = self
        banner.dataSource = self
        banner.itemSize = .zero
        banner.isInfinite = true
        banner.automaticSlidingInterval = 6
        banner.transformer = FSPagerViewTransformer(type:.depth)
        banner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "bannerReuse")
        return banner
    }()
    
    // 轮播图
    fileprivate lazy var pageControl:FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        pageControl.numberOfPages = self.imageNames.count
        pageControl.contentHorizontalAlignment = .right
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return pageControl
    }()
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        whiteBack.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        hideBottomCorner.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.whiteBack)
            make.left.right.equalTo(self.whiteBack)
            make.height.equalTo(60)
        }
        
        banner.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10))
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.banner)
            make.left.right.equalTo(self.banner)
            make.height.equalTo(20)
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

extension MainTableHeader: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "bannerReuse", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        
        pageControl.currentPage = index
    }
}

extension MainTableHeader: FSPagerViewDelegate {
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}
