//
//  SimilarKLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/21.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class SimilarKLineViewController: BaseViewController {
    
    // MARK: - 属性 -
    
    private var vm = StockKLineViewModel.share
    
    fileprivate lazy var similarKLineTitles: [String] = {
        let similarKLineTitles = ["", "走势最相似的个股", "最相似的历史走势"]
        return similarKLineTitles
    }()

    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(bottomTable)
        bottomTable.tableHeaderView = tableHeader
        
        netSimilarKLineData()
        
        totalLayout()
    }
    
    // MARK: - 网络请求 -
    
    // 月数据
    private func netSimilarKLineData() {
        
        let params = ["code": "000001",
                      "adjusted": "",
                      "type": "14901",
                      "from": Util.date(before: 365),
                      "to": Util.date(before: 0)]
        
        vm.postDailyLineData(params, success: { (data) in
            self.dailyLineData = data as? JSUKLineMessage
        }) { (error) in
            print(error)
        }
    }
    
    
    // MARK: - 赋值 -
    
    // 相似K线数据
    private var dailyLineData: JSUKLineMessage? {
        didSet {
            guard let model = dailyLineData else { return }
            let set = vm.kLineDataSet(from: model)
            
            kLineSumData = [KLineDataSet]()
            kLineSumData?.append(set)
            kLineSumData?.append(set)
            kLineSumData?.append(set)
        }
    }
    
    // 相似K线汇总数据
    fileprivate var kLineSumData: [KLineDataSet]? {
        didSet {
            bottomTable.reloadData()
        }
    }
    
    
    // MARK: - 视图 -
    
    // 列表
    fileprivate lazy var bottomTable:UITableView = {
        let bottomTable = UITableView(frame: CGRect.zero, style: .plain)
        bottomTable.register(SimilarKLineCell.self, forCellReuseIdentifier: "similarKLineReuse")
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        footerView.backgroundColor = .white
        bottomTable.tableFooterView = footerView
        bottomTable.showsVerticalScrollIndicator = false
        bottomTable.backgroundColor = .clear
        bottomTable.delegate = self
        bottomTable.dataSource = self
        bottomTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        bottomTable.estimatedRowHeight = 220
        return bottomTable
    }()
    
    // 列表头
    private lazy var tableHeader: SimilarKLineHeaderView = {
        let tableHeader = SimilarKLineHeaderView()
        return tableHeader
    }()
    
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        bottomTable.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
        }
        
        tableHeader.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomTable)
            make.left.equalTo(self.bottomTable)
            make.width.equalTo(self.bottomTable)
            make.height.equalTo(90)
        }
        
        bottomTable.layoutIfNeeded()
        bottomTable.layoutSubviews()
        bottomTable.tableHeaderView = tableHeader
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

extension SimilarKLineViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if [1,2].contains(section) {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if [1,2].contains(section) {
            let title = UILabel(frame: CGRect(x: 0, y: 0, w: view.frame.width, h: 40))
            title.text = "  "+similarKLineTitles[section]
            title.font = avenirFont14
            title.backgroundColor = lightGray234
            return title
        }
        return UIView()
    }
}

extension SimilarKLineViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return similarKLineTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "similarKLineReuse") as! SimilarKLineCell
        
        cell.dataSet = kLineSumData?[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
}
