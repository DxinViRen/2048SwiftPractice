

//
//  MainViewController.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

enum AnimateionSlipType{
    
    case none  //无动画
    
    case  new //新出现动画
    
    case  merge //合并动画
    
}

class MainViewController: UIViewController {

    var imageView :UIImageView //存储属性，游戏标题
    var reTryButton:UIButton; //重新开始按钮，存储属性
    
    //游戏方格的纬度,设定初始值是4
    var dimension :Int  = 4 ;
    
    //数字格子的宽度
    var width :CGFloat  = 58;
    
    //格子与格子的间隙
    var padding:CGFloat = 7;
    
    //保存背景图数据
    var backgrounds:Array<UIView>;
    
    //白色方块底图
    var whiteView:UIView
    
    //游戏数据模型
    var  gameModel:GameModel;
    
    //保存界面的标签
    var tiles :Dictionary<IndexPath,TitleView>;
    
    //保存界面的数字
    var tileVals:Dictionary<IndexPath,Int>;
    
    //游戏通关的最大值
    var maxNumber:Int = 2048{
        didSet{
            
            
            gameModel.maxNumber = maxNumber;
        }
        
    }
    
    
    
    
    init(){
        //实例化属性
        self.reTryButton = UIButton();
        self.imageView = UIImageView();
       
        //数组的初始化
        self.backgrounds = Array<UIView>();
        self.whiteView = UIView();
        
        self.gameModel = GameModel (dismension:self.dimension,maxNumber:maxNumber);
        self.tiles  = Dictionary();
        self.tileVals = Dictionary();
         super.init(nibName:nil,bundle:nil);
    }
    
    //创建半透明的方块底图 背景图片永远书评居中
    func setupWhiteView(){
        let rect = UIScreen.main.bounds;
        let w :CGFloat = rect.width;
        let backWidth = width * CGFloat(dimension) + padding * CGFloat(dimension-1)+20;
        let backX = (w - backWidth)/2;
        self.whiteView.frame = CGRect(x:backX,y:208,width:backWidth,height:backWidth);
        self.whiteView.backgroundColor = UIColor(red:255.0/255.0,green:255.0/255.0,blue:255.0/255.0,alpha:0.6);
        self.view.addSubview(self.whiteView);
    }

    
    //创建主界面上的标题图片和按钮
    func  setupTitleView(){
        imageView.image = UIImage(named:"icon_my_green");
        imageView.frame = CGRect(x:32,y:96,width:50,height:50);
        self.view.addSubview(imageView);
    }
    
    func setupTryButton(){
        reTryButton  = ControlView.createButton(_action:#selector(MainViewController.retart), sender: self);
        reTryButton.frame = CGRect(x:290,y:96,width:50,height:50);
        self.view.addSubview(reTryButton);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新启动方法
    func retart(){
        
    }
    
    
    //定义一个创建方格地图的方法，通过控制嵌套for 循环的方式，绘制一个4*4的方格地图背景
    func setupBackground(){
        //设置白色地图背景
        setupWhiteView();
        //根据屏幕尺寸计算插入的位置
        var x:CGFloat = 10;
        var y:CGFloat = 10;
        //竖行逐一排列
        for i in 0..<dimension{
            y = 10;
            for j in 0..<dimension{
                //添加方格地图背景
                print(i,j);
                let backgroundView = UIView(frame:CGRect(x:x,y:y,width:width,height:width));
                backgroundView.backgroundColor = UIColor(red:210.0/255.0,green:210.0/255.0,blue:210.0/255.0,alpha:1.0);
                backgroundView.layer.cornerRadius = 4;
                self.whiteView.addSubview(backgroundView);
                backgrounds.append(backgroundView);
                y +=  padding + width;
            }
            x += padding + width ;
            
        }
    }
    
    //定义一个可以随机生成数值的函数，生成2的概率为0.9，生成4的概率为0.1
    func  genRandom(){
    
        let radomNum = Int(arc4random_uniform(10));
        
        var seed :Int = 2;
        
        if radomNum == 1{
            seed = 4;
        }
        
        
        //根据纬度来确定显示的位置
        
        let  row = Int(arc4random_uniform(UInt32(dimension)));
        let  col  = Int(arc4random_uniform(UInt32(dimension)));
        
        //在插入之前要检测是否已经满了
        if gameModel.isFull(){
            return;
        }
        
        if gameModel.setPosition(row: row, col: col, value: seed) == false{
            //递归调用
            genRandom();
            return;
        }
        
        //插入之前需要检测游戏是否已经结束
        if gameModel.isFailure() == true{
            let alerterVc = UIAlertController(title:"游戏结束",message:"鑫哥你输了",preferredStyle:UIAlertControllerStyle.alert);
            let rety = UIAlertAction(title:"请鑫哥哥再来一次",style:UIAlertActionStyle.default){
                (action:UIAlertAction!) ->Void in
                
                self.reStart();
                
                self.reStart()
            }
            alerterVc.addAction(rety);
            self.present(alerterVc, animated: true, completion: nil);
        }
        
        
        
        
        //插入新的随机产生的数据
        insetTail(_pos: (row,col),value: seed,aType: AnimateionSlipType.new);
    }
    
    
    
    
    
    func insetTail(_pos:(Int,Int),value:Int,aType:AnimateionSlipType){
        let (row,col) = _pos;
        let x = 10 + CGFloat(col)*(width + padding)
        let y = 10 + CGFloat(row)*(width + padding)
        
        //插入数字块
        let tile = TitleView(pos:CGPoint(x:x,y:y),width:width,value:value);
        tile.layer.cornerRadius = 4;
        //把实例化的新的块放到WhiteView上
        self.whiteView.addSubview(tile);
        self.view.bringSubview(toFront: tile);
        
        //先将数字快大小置为原始尺寸的1\10，
        tile.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1,y: 0.1));
        
        //将tile 保存到字典
        let index = IndexPath(row : row,section:col); //key
        
        tiles[index] = tile;
        tileVals[index] = value;
        
        
        if aType == AnimateionSlipType.none{
            return;
        }else if aType == AnimateionSlipType.new{
        
            tile.layer.setAffineTransform(CGAffineTransform(scaleX :0.1,y:0.1));
        }else if aType == AnimateionSlipType.merge{
            tile.layer.setAffineTransform(CGAffineTransform(scaleX:0.8,y:0.8));
        }
        
        //设置动画效果
        UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions(), animations:{
            ()->Void in
            
            tile.layer.setAffineTransform(CGAffineTransform(scaleX:1,y:1));
            
            }) { (true) in
                
                UIView.animate(withDuration: 0.08, animations: { 
                    
                    }, completion: { (true) in
                        
                        tile.layer.setAffineTransform(CGAffineTransform.identity);
                })
        }
    }
    
    
    //创建手势识别器
    func setupSwipeGuesture(){
        
        
        //向上
        let upSwip = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipup));
        upSwip.numberOfTouchesRequired = 1;
        upSwip.direction = UISwipeGestureRecognizerDirection.up;
        self.view.addGestureRecognizer(upSwip);
        
        
        //向下
        let downSwip = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipDown));
        downSwip.numberOfTouchesRequired = 1;
        downSwip.direction = UISwipeGestureRecognizerDirection.down;
        self.view.addGestureRecognizer(downSwip);
        
        
        
        
        //向左
        let leftSwip = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipleft));
        leftSwip.numberOfTouchesRequired = 1;
        leftSwip.direction = UISwipeGestureRecognizerDirection.left;
        self.view.addGestureRecognizer(leftSwip);
        
        
        
        //向右
        let rightSwip = UISwipeGestureRecognizer(target:self,action:#selector(MainViewController.swipright));
        rightSwip.numberOfTouchesRequired = 1;
        rightSwip.direction = UISwipeGestureRecognizerDirection.right;
        self.view.addGestureRecognizer(rightSwip);

        
    

    }

    
    
    //更加直观的观测数据的变化情况，按照4*4方格的样式打印输出重排前与重排后的数据
    func printTiles(tiles:Array<Int>){
        
        let count = tiles.count;
        for i in 0..<count{
            if (i+1) % Int(dimension) == 0{
                print(tiles[i]);
            }else{
                print(tiles[i],separator:"",terminator:"\t");
            }
        }
        
        print("");
    }

    
    //向上滑动
    func swipup(){
        if(!gameModel.isSuccess()){
        printTiles(tiles: gameModel.tiles);
        //向上重排
        gameModel.reflowUp();
        gameModel.mergeUp();
        gameModel.reflowUp();

        printTiles(tiles: gameModel.tiles);
        print("向上")
        resetUI();
        initUI();
        
        genRandom();
     }
    }
    
    //向下滑动
    func swipDown(){
        
        if(!gameModel.isSuccess()){
        printTiles(tiles: gameModel.tiles);
        gameModel.reflowDown();
        gameModel.mergeDown();
        gameModel.reflowDown();

        printTiles(tiles: gameModel.tiles);
        
        print("向下");
        resetUI();
        initUI();
        genRandom();
      }
    }
    
    //向左滑动
    func swipleft(){
        if(!gameModel.isSuccess()){
        printTiles(tiles: gameModel.tiles);
        gameModel.reflowLeft();
        gameModel.mergeLeft();
        gameModel.reflowLeft();
        printTiles(tiles: gameModel.tiles);
        print("向左");
        resetUI();
        initUI();
        genRandom();
        }
      
    
    }
    
    
    //向右滑动
    func swipright() {
        if(!gameModel.isSuccess()){
        printTiles(tiles: gameModel.tiles);
        gameModel.reflowRight();
        gameModel.mergeRight();
        gameModel.reflowRight();

        printTiles(tiles: gameModel.tiles);
        print("向右");
        resetUI();
        initUI();
        genRandom();
        }
    }
    
    
    //将所有的数字块从地图上删除
    func resetUI(){
        for (key ,tile) in tiles{
            tile.removeFromSuperview();
        }
        tiles.removeAll(keepingCapacity: true);
        tileVals.removeAll(keepingCapacity: true);
    }
    
    //根据模型数据更新界面
    func initUI(){
//        for i in 0..<dimension{
//            for j in 0..<dimension{
//                let index = i * self.dimension + j;
//                if gameModel.tiles[index] != 0{
//                    insetTail(_pos: (i, j), value: gameModel.tiles[index],aType: AnimateionSlipType.merge);
//                }
//            }
//        }
        var index:Int  //在模型数组中的序号
        
        var  key :IndexPath//在视图数组中的路径
        
        var tile:TitleView  //格子的数字视图
        
        var  tileVal:Int   //格子的数字
        
        for i in 0..<dimension{
            for j in 0..<dimension{
                index = i*self.dimension + j;
                key = IndexPath(row : i ,section:j);
                
                //原来的界面没有值，模型数据中有
                if gameModel.tiles[index] > 0 && tileVals.index(forKey: key) == nil{
                    insetTail(_pos: (i,j), value: gameModel.tiles[index], aType: AnimateionSlipType.merge);
                }
                
                //原来界面中有值，现在模型数据中没有值
                if gameModel.tiles[index] == 0 && tiles.index(forKey: key) != nil{
                    tile = tiles[key]!;
                    tile.removeFromSuperview();
                    tiles.removeValue(forKey: key);
                    tileVals.removeValue(forKey: key);
                }
                
                //原来有值，现在仍然有值
                if(gameModel.tiles[index]>0 && tileVals.index(forKey: key) != nil){
                      //如果不相等，直接换掉就可以
                    tileVal = tileVals[key]!;
                    if   tileVal != gameModel.tiles[index]{
                        tile = tiles[key]!;
                        tile.removeFromSuperview();
                        tiles.removeValue(forKey: key);
                        tileVals.removeValue(forKey: key);
                        insetTail(_pos: (i, j), value: gameModel.tiles[index], aType: AnimateionSlipType.merge);
                    }
                    
                }
                
            }
        }
        
        //
        if gameModel.isSuccess(){
            
            
            //恭喜过关
            let  alertV = UIAlertController(title:"恭喜过关",message:"太棒了，您过关了",preferredStyle:UIAlertControllerStyle.alert);
            let makeAction = UIAlertAction(title:"确定",style:UIAlertActionStyle.default){
                (action:UIAlertAction) ->Void   in
            }
            let  reTry = UIAlertAction(title:"再玩一次",style:UIAlertActionStyle.default){
                (action:UIAlertAction!) ->Void in
                self.reStart();
            };
            alertV.addAction(makeAction);
            alertV.addAction(reTry);
            self.present(alertV,animated:true, completion:nil);
            return;
        }
}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:240/255.0,green:240/255.0,blue:240/255.0,alpha:1);
        //创建游戏图片
        setupTitleView();
        ////创建按钮
        setupTryButton();
      
        //设置背景图
        setupBackground();
        
        for i in 0..<2
        {
            print(i);
            genRandom();
        }
        
        setupSwipeGuesture();
        
        // Do any additional setup after loading the view.
    }

       //定义检测通关的方法

    
    //添加再玩一次的方法
    func reStart(){
        //重设界面
        resetUI();
//        reStart();
        //同步数据
        gameModel.initTiles();
        //重新生成两个随机数
        for _ in 0..<2{
            genRandom();
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
