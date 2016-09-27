//
//  TitleView.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit
class TitleView: UIView {

    //不同的数字映射不同的颜色，用字典来映射这种关系
    let colorMap = [
        2:UIColor(red:235.0/255.0,green:235.0/255.0,blue:75.0/255.0,alpha:1.0),
        4:UIColor(red:190.0/255.0,green:235.0/255.0,blue:50.0/255.0,alpha:1.0),
        8:UIColor(red:95.0/255.0,green:235.0/255.0,blue:100.0/255.0,alpha:1.0),
        16:UIColor(red:0.0/255.0,green:235.0/255.0,blue:200.0/255.0,alpha:1.0),
        32:UIColor(red:70/255.0,green:200.0/255.0,blue:250.0/255.0,alpha:1.0),
        64:UIColor(red:70.0/255.0,green:165.0/255.0,blue:250.0/255.0,alpha:1.0),
        128:UIColor(red:180.0/255.0,green:110.0/255.0,blue:255.0/255.0,alpha:1.0),
        256:UIColor(red:235.0/255.0,green:95.0/255.0,blue:250.0/255.0,alpha:1.0),
        512:UIColor(red:240.0/255.0,green:90.0/255.0,blue:155.0/255.0,alpha:1.0),
        1024:UIColor(red:235.0/255.0,green:70.0/255.0,blue:75.0/255.0,alpha:1.0),
        2048:UIColor(red:255.0/255.0,green:135.0/255.0,blue:50.0/255.0,alpha:1.0),
        ];
    
    //数字标签
    var numlabel:UILabel;
    
   //检测颜色和文字的变化
    //属性观察器
    var value :Int = 0{
        didSet{
            backgroundColor = colorMap[value];
            numlabel.text = "\(value)";
        }
    }
    
   
    init (pos:CGPoint,width:CGFloat,value:Int){
        
        numlabel = UILabel(frame:CGRect(x:0,y:0,width:width,height:width))
        numlabel.textAlignment = NSTextAlignment.center;
        numlabel.minimumScaleFactor = 0.5;//设置最小的收缩比例
        numlabel.font = UIFont(name:"HelveticalNeue-Bold",size:20);//设置字体
        numlabel.text = "\(value)";//设置文本内容
        super.init(frame: CGRect(x:pos.x,y:pos.y,width:width,height:width));
        addSubview(numlabel);
        self.value  = value;
        backgroundColor = colorMap[value];
        
        switch value {
        case 2,4:
            //2,4字体是深灰色
            numlabel.textColor = UIColor(red:119.0/255,green:110.0/255.0,blue:101.0/255.0,alpha:1.0);
            break;
        default:
            //其他的均是白色
            numlabel.textColor = UIColor.white;
            break;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    

    
}






