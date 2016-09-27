//
//  ControlView.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

class ControlView{
    //静态的方法  创建按钮
    class func createButton(_action:Selector,sender:UIViewController)->UIButton {
        let button = UIButton();
        button.setBackgroundImage(UIImage(named:"icon_my_grey"),for:UIControlState());
        button.addTarget(sender, action: _action, for: UIControlEvents.touchUpInside);
        button.layer.cornerRadius = 16;
        return button;
    }
    
    //创建textField
    class func createTextFirld(value:String,action:Selector,sender:UITextFieldDelegate)->UITextField{
    
        let textField = UITextField();
        textField.backgroundColor = UIColor.white;
        //设置textField的边框的粗细
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 15;
        textField.layer.masksToBounds = true;
        textField.layer.borderColor = UIColor(red:254.0/255.0,green:204.0/255.0,blue:57.0/255.0,alpha:1.0).cgColor;
        textField.textColor = UIColor .black;
        textField.text = value;
        textField.adjustsFontSizeToFitWidth = true;//设置字体的尺寸来适应宽度
        textField.delegate = sender;
        return textField;
    }
    
    //创建分段控件的方法
    class   func createSengment(items:[String],action:Selector,sender:UIViewController)->UISegmentedControl{
        //分段控件的选项
        let segment = UISegmentedControl(items:items);
        //按钮点击之后是否恢复原样
        segment.isMomentary = false;
        segment.addTarget(sender, action: action, for: UIControlEvents.valueChanged);
        return segment;
    }
    
    //创建标签控件
    class func createLabel(_title:String)->UILabel{
    
        let label = UILabel();
        label.textColor = UIColor.black;
        label.text = _title;
        label.font = UIFont(name:"HelveticalNeue-Blod",size:16);
        return label;
    }

}

  
