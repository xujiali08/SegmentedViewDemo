//
//  ITSegmentedView.swift
//  ITService
//
//  Created by jiali on 2020/12/1.
//  Copyright © 2020 italki. All rights reserved.
//

import UIKit

open class ITSegmentedView: JXSegmentedView {

    public var titles: [String] {
        get {
            segmentedDataSource.titles
        }
        set {
            segmentedDataSource.titles = newValue
        }
    }
    
    public let segmentedDataSource = ITSegmentedTitleDataSource()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    public init(titles: [String], frame: CGRect  = CGRect.zero) {
        super.init(frame: frame)
        self.titles = titles
        setUpUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    func setUpUI() {
        backgroundColor = UIColor.systemPink

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.brown
        lineView.indicatorHeight = 2
        lineView.indicatorWidth = 32
        self.indicators = [lineView]
        
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titles = titles
        segmentedDataSource.titleNormalColor = UIColor.systemGray
        segmentedDataSource.titleSelectedColor = UIColor.systemRed
        if titles.count > 4 {
            segmentedDataSource.itemWidth = self.frame.width / CGFloat(4.0)
        }
        self.dataSource = segmentedDataSource
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
}
