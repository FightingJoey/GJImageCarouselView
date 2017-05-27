//
//  RecommandHeaderView.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/27.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

class RecommandHeaderView: UIView {

    deinit {
        DLog(messge: "RecommandHeaderView销毁了")
    }
    
    var imageCarouselView: GJImageCarouselView?
    var announceView: AnnounceView?
    var mornBtnClickedBlock: MoreBtnClickBlock? = nil
    
    var imageList: Array<String>? {
        didSet {
            self.imageCarouselView?.imageUrlList = imageList
            self.imageCarouselView?.autoScrollInterval = 5
        }
    }
    var announcelist: Array<(String,String)>? {
        didSet {
            self.announceView?.announceList = announcelist
        }
    }
    var imageTapBlock: ImageTapBlock? = nil
    var announceTapBlock: AnnounceTapBlock? = nil
    
    init(frame: CGRect,
         imageTapBlock: @escaping ImageTapBlock,
         announceTapBlock: @escaping AnnounceTapBlock,
         moreBtnClicked: @escaping MoreBtnClickBlock) {
        
        super.init(frame: frame)
        self.imageTapBlock = imageTapBlock
        self.announceTapBlock = announceTapBlock
        self.mornBtnClickedBlock = moreBtnClicked
        self.initView()
    }
    func initView() -> Void {
        self.imageCarouselView = {
            let imageCarouselView = GJImageCarouselView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth/375*180), imageTapBlock: { (index) in
                self.imageTapBlock!(index)
            })
            return imageCarouselView
        }()
        self.addSubview(self.imageCarouselView!)
        self.announceView = {
            let announceView = AnnounceView(frame: CGRect.init(x: 0, y: ScreenWidth/375*180, width: ScreenWidth, height: 34), announceTapBlock: { (index) in
                self.announceTapBlock!(index)
            }, moreBtnClicked: { 
                
            })
            return announceView
        }()
        self.addSubview(self.announceView!)
    }
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

typealias MoreBtnClickBlock = (() -> ())

class AnnounceView: UIView {
    
    var announceList: Array<(String,String)>? {
        didSet {
            self.announceView?.announceList = announceList
            self.announceView?.autoScrollInterval = 3
        }
    }
    
    
    var announceTapBlock: AnnounceTapBlock? = nil
    
    var mornBtnClickedBlock: MoreBtnClickBlock? = nil
    
    var announceView: GJAnnounceCarouselView?
    
    init(frame: CGRect,
         announceTapBlock: @escaping AnnounceTapBlock,
         moreBtnClicked: @escaping MoreBtnClickBlock) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.announceTapBlock = announceTapBlock
        self.mornBtnClickedBlock = moreBtnClicked
        self.initView()
    }
    
    func initView() -> Void {
        let icon: UILabel = {
            let icon = UILabel()
            icon.font = UIFont(name: "iconfont", size: 14)
            icon.text = "\u{e602}"
            icon.textColor = UIColor.DH_SecondWordColor
            return icon
        }()
        self.addSubview(icon)
        
        self.announceView = {
            let view = GJAnnounceCarouselView(frame: CGRect.null, announceTapBlock: { (index) in
                self.announceTapBlock!(index)
            })
            return view
        }()
        self.addSubview(self.announceView!)
        
        let more: UIButton = {
            let btn = UIButton(type: UIButtonType.system)
            btn.titleLabel?.font = UIFont.DH_12Font
            btn.setTitle("更多", for: UIControlState.normal)
            btn.setTitleColor(UIColor.DH_SecondWordColor, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(moreBtnClicked), for: UIControlEvents.touchUpInside)
            return btn
        }()
        self.addSubview(more)
        
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.centerY.equalTo(self)
        }
        self.announceView?.snp.makeConstraints({ (make) in
            make.left.equalTo(icon.snp.right).offset(6)
            make.right.equalTo(more.snp.left).offset(6)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        })
        more.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-16)
            make.width.equalTo(28)
            make.centerY.equalTo(self)
        }
        self.announceView?.layoutIfNeeded()
    }
    
    func moreBtnClicked() -> Void {
        if self.mornBtnClickedBlock != nil {
            self.mornBtnClickedBlock!()
        }
    }
    
    override init(frame: CGRect) {
        fatalError("init(coder:) has not been implemented")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

