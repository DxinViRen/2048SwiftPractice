


//
//  MainTabBarViewController.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    init() {
        
        super.init(nibName:nil ,bundle:nil);
        let mainVc = MainViewController();
        mainVc.title = "游戏";
        mainVc.tabBarItem.image = UIImage(named:"icon_bill_green");//设置游戏图标
        let setVc = SettingViewController();
        setVc.title = "设置";
        setVc.tabBarItem.image = UIImage(named:"icon_home_green");
        let main = UINavigationController(rootViewController: mainVc);
        let set = UINavigationController(rootViewController:setVc);
        self.viewControllers = [main,set];
        self.tabBar.tintColor = UIColor.orange;//设置图标的颜色为橙色
    
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
