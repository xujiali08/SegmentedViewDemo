//
//  ContentViewController.swift
//  segmentViewDemo
//
//  Created by jiali on 2020/12/8.
//

import UIKit

class ContentViewController: UIViewController {
    
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = ITSegmentedView()
    var params: [String: Any]?
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "嘿嘿"
        let image = UIImage(named: "backNavigation", in: nil, compatibleWith: nil)
        let leftBar = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeAction))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = leftBar
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        segmentedView.titles = ["你好", "好呀"]
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeSegmentViewIndex() {
        segmentedView.selectItemAt(index: 0)
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
//        segmentedView.translatesAutoresizingMaskIntoConstraints = false
//        segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        segmentedView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listContainerView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor).isActive = true
        listContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
}

extension ContentViewController: ITSegmentedViewDelegate {
    func itSegmentedView(_ segmentedView: ITSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension ContentViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return ViewController1()
        } else {
            return ViewController2()
        }
    }
}

class ViewController1: ITSegmentListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemPink
    }
}

class ViewController2: ITSegmentListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBlue
    }
}
