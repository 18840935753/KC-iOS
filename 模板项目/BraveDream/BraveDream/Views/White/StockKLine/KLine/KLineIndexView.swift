//
//  KLineIndexView.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class KLineIndexView: BaseView {
    
    // MARK: - 属性 -
    
    fileprivate lazy var indexNames: [[String]] = {
        let indexNames = [["前复权", "不复权", "后复权"],
                          ["成交量", "MACD", "KDJ", "BOLL"]]
        return indexNames
    }()
    
    fileprivate var selectIndex: IndexPath?
    
    // MARK: - 系统 Function -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        selectIndex = IndexPath(row: 0, section: 0)
        
        self.addSubview(bottomTable)
        
        totalLayout()
    }
    
    
    // MARK: - 视图 -
    
    // 指标列表
    fileprivate lazy var bottomTable:UITableView = {
        let bottomTable = UITableView(frame: CGRect.zero, style: .plain)
        bottomTable.register(UITableViewCell.self, forCellReuseIdentifier: "kIndexReuse")
        bottomTable.showsVerticalScrollIndicator = false
        bottomTable.backgroundColor = .clear
        bottomTable.delegate = self
        bottomTable.dataSource = self
        bottomTable.separatorStyle = .none
        return bottomTable
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        bottomTable.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
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

extension KLineIndexView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectIndex = indexPath
        bottomTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != indexNames.count-1 {
            return 0.5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != indexNames.count-1 {
            let footer = UIView(frame: CGRect(x: 5, y: 0, width: self.frame.width-5*2, height: 0.5))
            footer.backgroundColor = .lightGray
            return footer
        }
        return UIView()
    }
}

extension KLineIndexView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return indexNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexNames[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kIndexReuse")
        cell?.backgroundColor = .clear
        
        for v in (cell?.subviews)! {
            v.removeFromSuperview()
        }
        
        let index = UILabel(frame: CGRect(x: 0, y: 5, w: self.frame.width, h: 38-10))
        index.font = UIFont.systemFont(ofSize: 12)
        index.textColor = .black
        index.text = indexNames[indexPath.section][indexPath.row]
        index.textAlignment = .center
        cell?.addSubview(index)
        
        if selectIndex == indexPath {
            index.textColor = baseViewColor
            index.backgroundColor = UIColor(white: 0, alpha: 0.1)
        }else{
            index.textColor = .black
            index.backgroundColor = .clear
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
}
