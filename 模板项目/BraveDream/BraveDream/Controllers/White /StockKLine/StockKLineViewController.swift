//
//  StockKLineViewController.swift
//  BraveDream
//
//  Created by kang chao on 2017/8/15.
//  Copyright © 2017年 kang chao. All rights reserved.
//

import UIKit

class StockKLineViewController: BaseViewController {

    // MARK: - 属性 -
    
    private var vm = StockMarketViewModel.share
    
    // 上次显示的控制器
    private var lastVC: UIViewController?
    
    // 控制器类名
    private var VCNames: [String] = ["TimeLineViewController",
                                     "FiveLineViewController",
                                     "DateLineViewController",
                                     "WeekLineViewController",
                                     "MonthLineViewController"]
    // 控制器存储
    private var VCStores = [String: UIViewController]()
    
    
    // MARK: - 系统 Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(priceOptionView)
        view.addSubview(pressDetailView)
        
        switchOption(to: 0)
        view.addSubview(landscapeButton)
        
        totalLayout()
        totalCallBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.isStatusBarHidden = Commons.isLandscape()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    // MARK: - 网络请求 -
    
    
    // MARK: - 自定义 Function -
    
    // 选择展示界面
    private func switchOption(to index: Int) {
        
        // 代码获取命名空间名,并动态创建相应的类
        
        guard index < VCNames.count else { return }
        
        let vcName = VCNames[index]
    
        if lastVC != nil, let store = VCStores[vcName] {
            if type(of: lastVC!).className != type(of: store).className {
                self.transition(from: lastVC!, to: store,
                                duration: 0,
                                options: .curveEaseIn,
                                animations: nil,
                                completion: nil)
                lastVC = store
                view.addSubview(landscapeButton)
            }
            return
        }
        
        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name+"."+vcName)
        guard let typeClass = cls as? UIViewController.Type else { return }
        
        let vc = typeClass.init() as? BaseLineViewController
        self.addChildViewController(vc!)
        
        vc?.selectCallback = { [weak self] (selected, entity, selectIndex) in
            self?.priceOptionView.btnBack.isHidden = selected
            self?.pressDetailView.isHidden = !selected
            
            if let timeEntity = entity as? TimeLineEntity {
                self?.pressDetailView.timeEntity = timeEntity
            }
            if let kLineEntity = entity as? KLineEntity {
                self?.pressDetailView.kLineEntity = kLineEntity
            }
        }
        
        // 注1: view frame 必须设置, 否则 transition 无法显示切换后的视图
        // 注2: 不可以使用 snapkit 对其进行设置 否则在切换中会出现视图无法显示问题
        vc?.view.frame = CGRect(x: 0, y: 90, w: view.frame.width, h: view.frame.height-90)
        
        if !Commons.isLandscape() {
            vc?.view.frame = CGRect(x: 0, y: 35+10, w: view.frame.width, h: view.frame.height-(35+10))
        }
        
        view.addSubview((vc?.view)!)
        view.addSubview(landscapeButton)
        
        // 存储控制器
        VCStores[vcName] = vc
        
        lastVC = vc
    }
    
    // 关闭界面
    @objc private func landscapeAction(_ sender: UIButton) {
        if !Commons.isLandscape() {
            vm.presentStockLandscapeChart(from: self)
        }
    }
    
    
    // MARK: - 视图 -
    
    // 切换 分时 日周月等
    private lazy var priceOptionView: KLineTopView = {
        let optionView = KLineTopView()
        return optionView
    }()
    
    // 长按展示具体信息等
    private lazy var pressDetailView: KLineCollectionView = {
        let pressDetailView = KLineCollectionView()
        return pressDetailView
    }()
    
    // 横屏图标
    private lazy var landscapeButton: UIButton = {
        let landscapeButton = UIButton(type: .custom)
        landscapeButton.setImage(UIImage(named: "landscapeIcon"), for: .normal)
        landscapeButton.addTarget(self, action: #selector(self.landscapeAction(_:)), for: .touchUpInside)
        return landscapeButton
    }()
    
    // MARK: - 布局 -
    
    private func totalLayout() {
        
        priceOptionView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(90)
        })
        
        pressDetailView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(35)
            
            if Commons.isLandscape() {
                make.top.equalTo(self.view).offset(90-35-10)
            } else {
                make.top.equalTo(self.view)
            }
        }
        
        landscapeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.bottom.equalTo(self.view).offset(-30)
            make.width.height.equalTo(30)
        }
    }
    
    
    // MARK: - 回调 -
    
    private func totalCallBack() {
        
        priceOptionView.dismissBack = { [weak self] in
            self?.vm.dismissStockLandscapeChart(from: self!)
        }
        priceOptionView.clickIndex = { [weak self] (index) in
            self?.switchOption(to: index)
        }
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
