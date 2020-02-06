//
//  CollectionDemoController.swift
//  TIMFlowView_Example
//
//  Created by Tim's Mac Book Pro on 2020/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TIMFlowView

class CollectionDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "模仿 UIColletionView "
        view.backgroundColor = UIColor.orange
        setupFlowView()
        setupData()
    }
    
    private func setupFlowView() {
       let fView = TIMFlowView()
       fView.frame = view.bounds
       fView.contentInset = UIEdgeInsets(top: isIphoneX ? 88.0 : 64.0, left: 0, bottom: 0, right: 0)
       fView.dataSource = self
       fView.delegate   = self
       fView.backgroundColor = UIColor.orange
       
       // 添加 banner 视图
       let headerView = DemoHeaderView.headerView(with: kScreenWidth * 0.56) { (index) in
           print("点击了第\(index)个banner")
       }
       fView.flowHeaderView = headerView
       
       view.addSubview(fView)
       flowView = fView
    }
    
    private func setupData() {
         DispatchQueue.global().async {
             guard let plistPath = Bundle.main.path(forResource: "images.plist", ofType: nil),
                 let models = NSArray(contentsOfFile: plistPath) as? [[String: Any]] else {
                     print("未获取到模型文件")
                     return
                 }
             
             for model in models {
                 self.flowModels.append(model.kj.model(FlowModel.self))
             }
             
             DispatchQueue.main.async {
                 self.flowView.reloadData()
             }
         }
    }

    private weak var flowView: TIMFlowView!
    private lazy var flowModels: [FlowModel] = []
}


extension CollectionDemoController: TIMFlowViewDataSource {
    func numberOfColumns(in flowView: TIMFlowView, at section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        default:
            return 5
        }
    }
    
    func numberOfSections(in flowView: TIMFlowView) -> Int { 3 }
    func numberOfItems(in flowView: TIMFlowView, at section: Int) -> Int {
        switch section {
        case 0:
            return 9
        case 1:
            return flowModels.count
        default:
            return 80
        }
    }
    
    func flowViewItem(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> TIMFlowViewItem? {
        let section = indexPath.section
        switch section {
        case 0:
            let collectionItemID = "collectionItemID"
            var item: TIMFlowViewItem?
            guard let dequeueItem = flowView.dequeueReuseableItem(with: collectionItemID) else {
                item = TIMFlowViewItem(with: collectionItemID)
                item?.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                return item
            }
            item = dequeueItem
            return item
        case 1:
            let item = FlowDemoItem.item(with: flowView)
            item?.flowModel = flowModels[indexPath.item]
            return item
        default:
            let collectionItemID = "collectionItemID"
            var item: TIMFlowViewItem?
            guard let dequeueItem = flowView.dequeueReuseableItem(with: collectionItemID) else {
                item = TIMFlowViewItem(with: collectionItemID)
                item?.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
                return item
            }
            item = dequeueItem
            return item
        }
    }
}

extension CollectionDemoController: TIMFlowViewDelegate {
    func itemHeight(in flowView: TIMFlowView, at indexPath: TIMIndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 80.0
        case 1:
            let model = flowModels[indexPath.item]
            return model.height * (flowView.itemWidhth(in: indexPath.section) / model.width)
        default:
            return 100.0
        }
    }
    
    
    func viewForSectionHeader<V>(in flowView: TIMFlowView, at section: Int) -> V? where V : TIMFlowHeaderFooterView {
        let headerID = "headerID"
        var headerView: V?
        guard let header = flowView.dequeueReuseableSectionHeaderView(with: headerID) as? V else {
            headerView = TIMFlowHeaderFooterView(with: headerID) as? V
            headerView?.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            headerView?.frame = CGRect(x: 0, y: 0, width: 0, height: 80.0)
            return headerView
        }
        headerView = header
        return headerView
    }
}
