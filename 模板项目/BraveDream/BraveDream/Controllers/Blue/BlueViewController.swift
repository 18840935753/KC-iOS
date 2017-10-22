//
//  BlueViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/7/14.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class BlueViewController: BaseViewController {

    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(bottomTable)
        bottomTable.tableHeaderView = tableHeader
        
        totalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigation(alpha: 0)
        
        // 背景图开始切换
        tableHeader.beginTransitionBackImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigation(alpha: 1)
        
        // 背景图停止切换
        tableHeader.endTransitionBackImage()
    }
    
    
    // MARK: - 视图 -
    
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
    private lazy var tableHeader: BlueTableHeader = {
        let tableHeader = BlueTableHeader()
        return tableHeader
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        bottomTable.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(-navigationBarHeight-20)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        tableHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomTable)
            make.left.equalTo(self.bottomTable)
            make.width.equalTo(self.bottomTable)
            make.height.equalTo(230)
        }
        
        bottomTable.layoutIfNeeded()
        bottomTable.layoutSubviews()
        bottomTable.tableHeaderView = tableHeader
    }
    
    fileprivate func yelSubVC() {
        let subVC = YellowSubViewController()
        subVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(subVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Delegate -

extension BlueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        yelSubVC()
    }
}

extension BlueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        cell?.backgroundColor = .white
        return cell!
    }
}

extension BlueViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let seperateY:CGFloat = 160
//        var alpha = scrollView.contentOffset.y / seperateY
//        
//        if alpha > 1 {
//            alpha = 1
//        }
//        
//        navigation(alpha: alpha)
    }
}
