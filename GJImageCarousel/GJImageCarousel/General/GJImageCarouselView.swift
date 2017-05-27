//
//  GJImageCarouselView.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/25.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

// 点击事件回调
public typealias ImageTapBlock = ((_ index:Int) -> ())

class GJImageCarouselView: UIView {

    deinit {
        DLog(messge: "GJImageCarouselView销毁了")
    }
    
    enum ImageCarouselViewPage:Int {
        case PreviousPage
        case CurrentPage
        case NextPage
    }
    
    // 占位图
    var placeholderImage: UIImage?
    // 图片填充方式
    var imageContentMode: UIViewContentMode?
    // 当前索引号
    var currentIndex: Int = 0
    // 页码组件
    var pageControl: UIPageControl?
    // 自动滚动间隔(秒)
    var autoScrollInterval: TimeInterval? {
        didSet {
            self.autoScrollImage(true)
        }
    }
    // 图片数量
    var imageCount: Int? = 3
    // 计时器
    var autoScrollTimer: Timer?
    // 图片名称数组
    var imageNameList: Array<String>? {
        didSet {
            self.reloadImageCarouselView(array: imageNameList!)
        }
    }
    // 图片URL数组
    var imageUrlList: Array<String>? {
        didSet {
            self.reloadImageCarouselView(array: imageUrlList!)
        }
    }
    // 点击事件回调
    var imageTapBlock: ImageTapBlock?
    
    var mainScrollView: UIScrollView?
    var previousImageView: UIImageView?
    var currentImageView: UIImageView?
    var nextImageView: UIImageView?
    
    
    // MARK: Method
    init(frame: CGRect,
         placeholderImage: String? = nil,
         contentMode: UIViewContentMode? = UIViewContentMode.scaleAspectFill,
         imageTapBlock: @escaping ImageTapBlock) {
        
        // 初始化
        super.init(frame: frame)
        self.imageContentMode = contentMode
        self.initView()
        self.imageTapBlock = imageTapBlock
        
        // 设置占位图
        if let image = placeholderImage {
            self.placeholderImage = UIImage(named: image)
            self.previousImageView?.image = UIImage(named: image)
            self.currentImageView?.image = UIImage(named: image)
            self.nextImageView?.image = UIImage(named: image)
        }
        // 添加手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTaped))
        self.addGestureRecognizer(tapGesture)
    }
    
    func imageViewDidTaped(tap: UITapGestureRecognizer) -> Void {
        if self.imageTapBlock != nil {
            self.imageTapBlock!(currentIndex)
        }
    }
    
    func initView() -> Void {
        if self.mainScrollView == nil {
            self.mainScrollView = UIScrollView.init(frame: self.bounds)
            self.mainScrollView!.isPagingEnabled = true
            self.mainScrollView!.showsHorizontalScrollIndicator = false
            self.mainScrollView!.showsVerticalScrollIndicator = false
            self.mainScrollView!.delegate = self
            self.mainScrollView!.contentSize = CGSize(width: self.bounds.width*3, height: self.bounds.height)
            self.addSubview(self.mainScrollView!)
        }
        
        self.previousImageView = {
            let imageView = UIImageView()
            imageView.frame = self.bounds
            imageView.contentMode = self.imageContentMode!
            return imageView
        }()
        self.currentImageView = {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: self.bounds.width, y: 0, width: self.bounds.width, height: self.bounds.height)
            imageView.contentMode = self.imageContentMode!
            return imageView
        }()
        self.nextImageView = {
            let imageView = UIImageView()
            imageView.frame = CGRect(x: self.bounds.width*2, y: 0, width: self.bounds.width, height: self.bounds.height)
            imageView.contentMode = self.imageContentMode!
            return imageView
        }()
        
        self.mainScrollView!.addSubview(self.previousImageView!)
        self.mainScrollView!.addSubview(self.currentImageView!)
        self.mainScrollView!.addSubview(self.nextImageView!)
        
        if self.pageControl == nil {
            self.pageControl = {
                let pageControl = UIPageControl()
                pageControl.hidesForSinglePage = true
                pageControl.translatesAutoresizingMaskIntoConstraints = false
                return pageControl
            }()
            self.addSubview(self.pageControl!)
            self.pageControl!.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.bottom.equalTo(-4)
            })
        }
    }
    
    // 刷新
    func reloadImageCarouselView(array: Array<String>) -> Void {
        imageCount = array.count
        currentIndex = 0
        self.pageControl?.numberOfPages = imageCount!
        self.pageControl?.currentPage = currentIndex
        self.mainScrollView!.isScrollEnabled = imageCount! > 1 ? true : false
        self.mainScrollView!.contentOffset = CGPoint(x: self.bounds.width, y: 0)
        
        if imageCount! > 0 {
            self.loadImage(index: 0, page: ImageCarouselViewPage.CurrentPage)
        }
        if imageCount! > 1 {
            self.loadImage(index: 1, page: ImageCarouselViewPage.NextPage)
            self.loadImage(index: imageCount!-1, page: ImageCarouselViewPage.PreviousPage)
        }
    }
    
    func loadImage(index:Int, page: ImageCarouselViewPage) -> Void {
        var imageView: UIImageView? = nil
        switch page {
        case .PreviousPage:
            imageView = self.previousImageView!
        case .CurrentPage:
            imageView = self.currentImageView!
        case .NextPage:
            imageView = self.nextImageView!
        }
        if imageUrlList != nil {
            let url = URL(string: imageUrlList![index])
            imageView?.kf.setImage(with: url, placeholder: self.placeholderImage, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        if imageNameList != nil {
            imageView?.image = UIImage(named: imageNameList![index])!
        }
    }
    
    // 设置自动滚动
    func autoScrollImage(_ autoScroll: Bool) -> Void {
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
        let offSetX = self.mainScrollView!.contentOffset.x
        let scrollViewWidth = self.mainScrollView!.bounds.size.width
        if imageCount! <= 1 {
            return
        }
        if offSetX == scrollViewWidth {
            self.mainScrollView?.setContentOffset(CGPoint(x: scrollViewWidth*2, y: 0), animated: true)
        }
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GJImageCarouselView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.size.width
        let curPage: Int = Int(offsetX / scrollViewWidth)
        
        if curPage == ImageCarouselViewPage.NextPage.rawValue {
            currentIndex += 1
            if currentIndex > imageCount! - 1 {
                currentIndex -= imageCount!
            }
            // 一般情况下更新图片位置以便复用UIImageView
            self.previousImageView!.image = self.currentImageView!.image
            self.currentImageView!.image = self.nextImageView!.image
            self.mainScrollView!.contentOffset = CGPoint(x: scrollViewWidth, y: 0)
            var nextIndex = currentIndex + 1
            if currentIndex >= imageCount! - 1 {
                nextIndex -= imageCount!
            }
            self.loadImage(index: nextIndex, page: ImageCarouselViewPage.NextPage)
        }
        if curPage == ImageCarouselViewPage.PreviousPage.rawValue {
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex += imageCount!
            }
            self.nextImageView!.image = self.currentImageView!.image;
            self.currentImageView!.image = self.previousImageView!.image;
            self.mainScrollView!.contentOffset = CGPoint(x: scrollViewWidth, y: 0)
            var previousIndex = currentIndex - 1
            if currentIndex == 0 {
                previousIndex += imageCount!
            }
            self.loadImage(index: previousIndex, page: ImageCarouselViewPage.PreviousPage)
        }
        self.pageControl?.currentPage = currentIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.autoScrollImage(false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.autoScrollImage(true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
}

