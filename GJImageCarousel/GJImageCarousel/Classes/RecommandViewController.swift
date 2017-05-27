//
//  RecommandViewController.swift
//  DHFinancial
//
//  Created by Joy on 2017/5/22.
//  Copyright © 2017年 zhengtouwang. All rights reserved.
//

import UIKit

class RecommandViewController: UIViewController {

    var headerView: RecommandHeaderView?
    
    var navBackView: UIView?
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.initView()
        
        DLog(messge: "哈哈哈哈")
    }
    
    func initView() -> Void {

        self.headerView = {
            let headerView = RecommandHeaderView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth/375*180+34), imageTapBlock: { (index) in
                
            }, announceTapBlock: { (index) in
                
            }, moreBtnClicked: {
                
            })
            headerView.announcelist = [("阿萨德立刻就拉上","[23-34]"),("你问日内瓦","[23-29]"),("收代理费没空理你","[90-54]")]
            headerView.imageList = ["https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-1.jpg",
                                    "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-2.jpg",
                                    "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-3.jpg"]
            return headerView
        }()
        
        self.tableView = {
            let tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 49), style: UITableViewStyle.grouped)
            tableView.tableHeaderView = self.headerView!
            tableView.delegate = self
            tableView.dataSource = self
            return tableView
        }()
        self.view.addSubview(self.tableView!)
        
        self.navBackView = {
            let navigationBarBackgroundView = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 64))
            navigationBarBackgroundView.backgroundColor = UIColor.DH_Red
            navigationBarBackgroundView.alpha = 0
            
            let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.text = "大河金服"
            label.center = CGPoint.init(x: ScreenWidth/2, y: 42)
            navigationBarBackgroundView.addSubview(label)
            
            return navigationBarBackgroundView
        }()
        self.view.addSubview(self.navBackView!)
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

extension RecommandViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alpha = scrollView.contentOffset.y/(ScreenWidth/375*180-64)
        self.navBackView!.alpha = alpha;
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.headerView?.imageCarouselView?.autoScrollImage(false)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.headerView?.imageCarouselView?.autoScrollImage(true)
    }
}
extension RecommandViewController: UITableViewDelegate {
    
}
extension RecommandViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
