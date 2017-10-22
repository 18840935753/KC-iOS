//
//  KLineCollectionCell.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/17.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KLineCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(name)
        
        name.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    
    public var name: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 8)
        name.backgroundColor = .white
        name.textColor = .black
        return name
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
