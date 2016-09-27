

//
//  SettingViewController.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITextFieldDelegate {

    var  txtNum :UITextField!;
    var segDimension:UISegmentedControl!;
    
    //初始化试图控制器
    var mainViewController = MainViewController();
    init(mainView:MainViewController){
        self.mainViewController = mainView;
        super.init(nibName: nil, bundle: nil);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupControls(){
        //设置阈值Label
        let labelNum = ControlView.createLabel(_title: "阈值");
        //设置Label的位置和大小
        labelNum.frame = CGRect(x:30,y:100,width:60,height:30);
        self.view.addSubview(labelNum);
        
        //创建文本输入框
        txtNum = ControlView.createTextFirld(value: "\(mainViewController.maxNumber )", action: Selector(("numChange")), sender: self);
        txtNum.frame = CGRect(x:90,y:100,width:160,height:30);
        //设置返回键的类型
        txtNum.delegate = self;
        txtNum.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(txtNum);
        
        //创建纬度label
        let labelDm = ControlView.createLabel(_title: "维度:")
        labelDm.frame = CGRect(x:30,y:150,width:60,height:30);
        self.view.addSubview(labelDm);
        
        
        //创建分段单选控件
        segDimension =  ControlView.createSengment(items: ["3X3","4X4","5X5"], action: #selector(SettingViewController.dimentionChanged), sender: self);
        segDimension.frame = CGRect(x:90,y:150,width:255,height:30);
        segDimension.tintColor = UIColor.orange;
        segDimension.selectedSegmentIndex = 1;
        self.view.addSubview(segDimension);
    }
    
    //segment的点击事件
    func dimentionChanged(){
    
        
    }
    
    //点击屏幕可以收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtNum.resignFirstResponder();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //textField的代理方法
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField放弃第一响应者
        textField.resignFirstResponder();
        if textField.text != "\(mainViewController.maxNumber)"{
            let num = Int(textField.text!);
            mainViewController.maxNumber = num!;
        }
        
        return true;
    }

}
