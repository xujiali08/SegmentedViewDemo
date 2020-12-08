//
//  ITSegmentedContainerViewController.swift
//  ITService
//
//  Created by jiali on 2020/12/3.
//  Copyright © 2020 italki. All rights reserved.
//

import UIKit

public typealias ITSegmentedListContainerViewListDelegate = JXSegmentedListContainerViewListDelegate
public typealias ITSegmentedDotDataSource = JXSegmentedDotDataSource
public typealias ITSegmentedBaseDataSource = JXSegmentedBaseDataSource
public typealias ITSegmentedTitleDataSource = JXSegmentedTitleDataSource

public protocol ITSegmentedViewDelegate: JXSegmentedViewDelegate {
    /// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
    func itSegmentedView(_ segmentedView: ITSegmentedView, didSelectedItemAt index: Int)

    /// 点击选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
//    func itSegmentedView(_ segmentedView: ITSegmentedView, didClickSelectedItemAt index: Int)

    /// 滚动选中的情况才会调用该方法
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 选中的index
//    func itSegmentedView(_ segmentedView: ITSegmentedView, didScrollSelectedItemAt index: Int)

    /// 正在滚动中的回调
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - leftIndex: 正在滚动中，相对位置处于左边的index
    ///   - rightIndex: 正在滚动中，相对位置处于右边的index
    ///   - percent: 从左往右计算的百分比
//    func itSegmentedView(_ segmentedView: ITSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat)

    /// 是否允许点击选中目标index的item
    ///
    /// - Parameters:
    ///   - segmentedView: JXSegmentedView
    ///   - index: 目标index
//    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool
}

@objc
public protocol ITSegmentedListContainerViewDataSource: JXSegmentedListContainerViewDataSource {
    /// 返回list的数量
    func segmentedNumberOfLists(in listContainerView: ITSegmentedListContainerView) -> Int

    /// 根据index初始化一个对应列表实例，需要是遵从`JXSegmentedListContainerViewListDelegate`协议的对象。
    /// 如果列表是用自定义UIView封装的，就让自定义UIView遵从`JXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIView即可。
    /// 如果列表是用自定义UIViewController封装的，就让自定义UIViewController遵从`JXSegmentedListContainerViewListDelegate`协议，该方法返回自定义UIViewController即可。
    /// 注意：一定要是新生成的实例！！！
    ///
    /// - Parameters:
    ///   - listContainerView: JXSegmentedListContainerView
    ///   - index: 目标index
    /// - Returns: 遵从JXSegmentedListContainerViewListDelegate协议的实例
    func segmentedListContainerView(_ listContainerView: ITSegmentedListContainerView, initListAt index: Int) -> ITSegmentedListContainerViewListDelegate

    /// 控制能否初始化对应index的列表。有些业务需求，需要在某些情况才允许初始化某些列表，通过通过该代理实现控制。
    @objc optional func segmentedListContainerView(_ listContainerView: ITSegmentedListContainerView, canInitListAt index: Int) -> Bool

    /// 返回自定义UIScrollView或UICollectionView的Class
    /// 某些特殊情况需要自己处理UIScrollView内部逻辑。比如项目用了FDFullscreenPopGesture，需要处理手势相关代理。
    ///
    /// - Parameter listContainerView: JXSegmentedListContainerView
    /// - Returns: 自定义UIScrollView实例
    @objc optional func segmentedScrollViewClass(in listContainerView: ITSegmentedListContainerView) -> AnyClass
}

open class ITSegmentedContainerViewController: UIViewController {

    public var segmentedView = ITSegmentedView()
    var baseDataSource: ITSegmentedBaseDataSource?
    
    open weak var dataSource: ITSegmentedListContainerViewDataSource?
    open weak var delegate: ITSegmentedViewDelegate?
    public var titles = [String]()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        segmentedView.delegate = self
        segmentedView.titles = titles
        view.addSubview(segmentedView)
        segmentedView.setUpUI()
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        
        baseDataSource = segmentedView.segmentedDataSource
        
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedView.translatesAutoresizingMaskIntoConstraints = false
        segmentedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        segmentedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        segmentedView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        listContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        listContainerView.topAnchor.constraint(equalTo: segmentedView.bottomAnchor).isActive = true
        listContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    }
    
    @objc func changeSegmentViewIndex(notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any], let index = userInfo["index"] as? Int {
            segmentedView.selectItemAt(index: index)
            segmentedView.isContentScrollViewClickTransitionAnimationEnabled = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ITSegmentedContainerViewController: JXSegmentedViewDelegate {
    public func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedView.dataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        delegate?.itSegmentedView(segmentedView as! ITSegmentedView, didSelectedItemAt: index)
    }

//    public func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
//        delegate?.itSegmentedView(segmentedView, didClickSelectedItemAt: index)
//    }
//
//    public func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
//        delegate?.itSegmentedView(segmentedView, didScrollSelectedItemAt: index)
//    }
//
//    public func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
//        return delegate?.itSegmentedView(segmentedView, canClickItemAt: index) ?? true
//    }
//
//    public func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
//        delegate?.itSegmentedView(segmentedView, scrollingFrom: leftIndex, to: rightIndex, percent: percent)
//    }
}

extension ITSegmentedContainerViewController: JXSegmentedListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    public func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return dataSource?.segmentedListContainerView(listContainerView as! ITSegmentedListContainerView, initListAt: index) ?? ITSegmentListViewController()
    }

    public func listContainerView(_ listContainerView: JXSegmentedListContainerView, canInitListAt index: Int) -> Bool {
        return dataSource?.segmentedListContainerView?(listContainerView as! ITSegmentedListContainerView, canInitListAt: index) ?? true
    }
}

open class ITSegmentListViewController: UIViewController, JXSegmentedListContainerViewListDelegate {
    public func listView() -> UIView {
        return view
    }
}

open class ITSegmentedListContainerView: JXSegmentedListContainerView {
    
    public init(dataSource: ITSegmentedListContainerViewDataSource, type: JXSegmentedListContainerType = .scrollView) {
        super.init(dataSource: dataSource, type: type)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
