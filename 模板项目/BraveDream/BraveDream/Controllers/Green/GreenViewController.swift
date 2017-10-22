//
//  GreenViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class GreenViewController: BaseViewController {
    
    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(bottomView)
        view.addSubview(bottomTable)
        bottomTable.tableHeaderView = tableHeader
        
        totalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideNavigationBottomLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 视图 -
    
    // 底层
    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = baseViewColor
        return bottomView
    }()
    
    // 列表
    fileprivate lazy var bottomTable:UITableView = {
        let bottomTable = UITableView(frame: CGRect.zero, style: .plain)
        bottomTable.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        footerView.backgroundColor = .white
        bottomTable.tableFooterView = footerView
        bottomTable.showsVerticalScrollIndicator = false
        bottomTable.backgroundColor = .clear
        bottomTable.delegate = self
        bottomTable.dataSource = self
        bottomTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return bottomTable
    }()
    
    // 列表头
    private lazy var tableHeader: MainTableHeader = {
        let tableHeader = MainTableHeader()
        return tableHeader
    }()
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(navigationBarHeight+20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-tabBarHeight)
        }
        
        bottomTable.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(navigationBarHeight+20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-tabBarHeight)
        }
        
        tableHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomTable)
            make.left.equalTo(self.bottomTable)
            make.width.equalTo(self.bottomTable)
            make.height.equalTo(200)
        }
        
        bottomTable.layoutIfNeeded()
        bottomTable.layoutSubviews()
        bottomTable.tableHeaderView = tableHeader 
    }

}

// MARK: - Delegate -

extension GreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        cell?.backgroundColor = .white
        return cell!
    }
}

