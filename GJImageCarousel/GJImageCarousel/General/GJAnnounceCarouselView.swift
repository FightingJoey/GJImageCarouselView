//
//  GJAnnounceCarouselView.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/26.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit
// 点击事件回调
public typealias AnnounceTapBlock = ((_ index:Int) -> ())

class GJAnnounceCarouselView: UIView {

    deinit {
        DLog(messge: "GJAnnounceCarouselView销毁了")
    }
    enum AnnounceCarouselViewPage:Int {
        case PreviousPage
        case CurrentPage
        case NextPage
    }
    
    class AnnounceView: UIView {
        var titleLabel:UILabel = {
            let label = UILabel()
            label.font = UIFont.DH_12Font
            return label
        }()
        var timeLabel:UILabel = {
            let label = UILabel()
            label.font = UIFont.DH_12Font
            return label
        }()
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.addSubview(self.titleLabel)
            self.addSubview(self.timeLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // 当前索引号
    var currentIndex: Int = 0
    // 自动滚动间隔(秒)
    var autoScrollInterval: TimeInterval? {
        didSet {
            self.autoScroll(true)
        }
    }
    // 公告数量
    var announceCount: Int?
    // 计时器
    var autoScrollTimer: Timer?
    // 公告数组
    var announceList: Array<(String,String)>? {
        didSet {
            self.reloadAnnounceCarouselView(array: announceList!)
        }
    }
    var announceTapBlock: AnnounceTapBlock?
    var mainScrollView: UIScrollView?
    var previousView: AnnounceView?
    var currentView: AnnounceView?
    var nextView: AnnounceView?
    
    init(frame: CGRect,
         announceTapBlock: @escaping AnnounceTapBlock) {
        super.init(frame: frame)
        self.initView()
        self.announceTapBlock = announceTapBlock
        
        // 添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTaped))
        self.addGestureRecognizer(tapGesture)
    }
    
    func viewDidTaped(tap: UITapGestureRecognizer) -> Void {
        if self.announceTapBlock != nil {
            self.announceTapBlock!(currentIndex)
        }
    }
    
    func initView() -> Void {
        if self.mainScrollView == nil {
            self.mainScrollView = UIScrollView.init(frame: self.bounds)
            self.mainScrollView!.isPagingEnabled = true
            self.mainScrollView!.showsHorizontalScrollIndicator = false
            self.mainScrollView!.showsVerticalScrollIndicator = false
            self.mainScrollView!.delegate = self
            self.mainScrollView!.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height*3)
            self.addSubview(self.mainScrollView!)
        }
        
        self.previousView = {
            let view = AnnounceView()
            view.frame = self.bounds
            return view
        }()
        self.currentView = {
            let view = AnnounceView()
            view.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height)
            return view
        }()
        self.nextView = {
            let view = AnnounceView()
            view.frame = CGRect(x: 0, y: self.bounds.height*2, width: self.bounds.width, height: self.bounds.height)
            return view
        }()

        self.mainScrollView!.addSubview(self.previousView!)
        self.mainScrollView!.addSubview(self.currentView!)
        self.mainScrollView!.addSubview(self.nextView!)
    }
    
    // 刷新
    func reloadAnnounceCarouselView(array: Array<(String,String)>) -> Void {
        announceCount = array.count
        currentIndex = 0
        self.mainScrollView!.isScrollEnabled = announceCount! > 1 ? true : false
        self.mainScrollView!.contentOffset = CGPoint(x: 0, y: self.bounds.height)
        
        if announceCount! > 0 {
            self.loadAnnounce(index: 0, page: AnnounceCarouselViewPage.CurrentPage)
        }
        if announceCount! > 1 {
            self.loadAnnounce(index: 1, page: AnnounceCarouselViewPage.NextPage)
            self.loadAnnounce(index: announceCount!-1, page: AnnounceCarouselViewPage.PreviousPage)
        }
    }
    
    func loadAnnounce(index:Int, page: AnnounceCarouselViewPage) -> Void {
        var view: AnnounceView? = nil
        switch page {
        case .PreviousPage:
            view = self.previousView
        case .CurrentPage:
            view = self.currentView
        case .NextPage:
            view = self.nextView
        }
        
        if announceList != nil {
            self.setAnnounceView(view: view!, index: index)
        }
    }
    
    func setAnnounceView(view: AnnounceView, index: Int) -> Void {
        let (title,time) = announceList![index]
        view.titleLabel.text = title
        view.timeLabel.text = time
        let width = title.width(font: UIFont.DH_12Font)
        let height = self.bounds.size.height
        if width > self.bounds.size.width - 60 {
            view.titleLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width - 60, height: height)
            view.timeLabel.frame = CGRect(x: self.bounds.size.width - 60+6, y: 0, width: 54, height: height)
        }else {
            view.titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.timeLabel.frame = CGRect(x: width+6, y: 0, width: 54, height: height)
        }
    }
    
    // 设置自动滚动
    func autoScroll(_ autoScroll: Bool) -> Void {
        if autoScroll && self.autoScrollInterval != nil {
            if autoScrollTimer != nil {
                autoScrollTimer!.invalidate()
            }
            autoScrollTimer = Timer.scheduledTimer(timeInterval: self.autoScrollInterval!, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
            RunLoop.main.add(autoScrollTimer!, forMode: RunLoopMode.commonModes)
        }else {
            autoScrollTimer?.invalidate()
            autoScrollTimer = nil
        }
    }
    
    func autoScrollAction() -> Void {
        let offSetY = self.mainScrollView!.contentOffset.y
        let scrollViewHeight = self.mainScrollView!.bounds.size.height
        if announceCount! <= 1 {
            return
        }
        if offSetY == scrollViewHeight {
            self.mainScrollView?.setContentOffset(CGPoint(x: 0, y: scrollViewHeight*2), animated: true)
        }
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.mainScrollView!.contentSize = CGSize(width: self.bounds.width, height: self.bounds.height*3)
        self.mainScrollView?.frame = self.bounds
        self.previousView?.frame = self.bounds
        self.currentView?.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height)
        self.nextView?.frame = CGRect(x: 0, y: self.bounds.height*2, width: self.bounds.width, height: self.bounds.height)
    }
}

extension GJAnnounceCarouselView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let scrollViewHeight = self.mainScrollView!.bounds.size.height
        let curPage: Int = Int(offsetY / scrollViewHeight)
        
        if curPage == AnnounceCarouselViewPage.NextPage.rawValue {
            currentIndex += 1
            if currentIndex > announceCount! - 1 {
                currentIndex -= announceCount!
            }
            // 一般情况下更新图片位置以便复用UIImageView
            self.previousView?.titleLabel.text = self.currentView?.titleLabel.text
            self.previousView?.timeLabel.text = self.currentView?.timeLabel.text
            
            self.currentView?.titleLabel.text = self.nextView?.titleLabel.text
            self.currentView?.timeLabel.text = self.nextView?.timeLabel.text
            
            self.mainScrollView!.contentOffset = CGPoint(x: 0, y: scrollViewHeight)
            var nextIndex = currentIndex + 1
            if currentIndex >= announceCount! - 1 {
                nextIndex -= announceCount!
            }
            self.loadAnnounce(index: nextIndex, page: AnnounceCarouselViewPage.NextPage)
            self.setAnnounceView(view: self.currentView!, index: currentIndex)
        }
        if curPage == AnnounceCarouselViewPage.PreviousPage.rawValue {
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex += announceCount!
            }
            self.nextView?.titleLabel.text = self.currentView?.titleLabel.text
            self.nextView?.timeLabel.text = self.currentView?.timeLabel.text
            self.currentView?.titleLabel.text = self.previousView?.titleLabel.text
            self.currentView?.timeLabel.text = self.previousView?.timeLabel.text
            self.mainScrollView!.contentOffset = CGPoint(x: 0, y: scrollViewHeight)
            var previousIndex = currentIndex - 1
            if currentIndex == 0 {
                previousIndex += announceCount!
            }
            self.loadAnnounce(index: previousIndex, page: AnnounceCarouselViewPage.PreviousPage)
            self.setAnnounceView(view: self.currentView!, index: currentIndex)
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.autoScroll(false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.autoScroll(true)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
}
