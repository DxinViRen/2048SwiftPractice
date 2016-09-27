//
//  GuideViewController.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController,UIScrollViewDelegate {
   //设置滚动视图中图片的页数
    var numPages = 4;
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.bounds;
        //初始化scrollViwe
        let scrollView = UIScrollView();
        scrollView.frame = frame;
        //设置scrollView的滚动区域
        scrollView.contentSize = CGSize(width:frame.size.width * CGFloat(numPages),height:frame.size.height);
        //设置分页
        scrollView.isPagingEnabled = true;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        
        //for循环创建一个ScrollView图片视图
        for i in 0..<numPages{
           //图片名称
            var  imageFileName = "\(i)_guide";
          //imageView
            var image  = UIImage(named :imageFileName);
          
            var imageView = UIImageView(image:image);
            
            //设置imageView的frame
            imageView.frame = CGRect(x:frame.size.width * CGFloat(i),y:CGFloat(0),width:frame.size.width,height:frame.size.height);
            scrollView.addSubview(imageView);
        }
        
        scrollView.contentOffset = CGPoint.zero;
        self.view.addSubview(scrollView);
        
    }
    
     //ScrollView的delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let twidth = CGFloat(numPages) * self.view.bounds.width;
        
        //当滚动视图滑动超出范围时候就跳转到主页面
        if scrollView.contentOffset.x>twidth{
            
            let TBViewController = MainTabBarViewController()
            //弹出主视图
            self.present(TBViewController, animated: true, completion: nil);
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
