//
//  GameModel.swift
//  2048PracticeSwift
//
//  Created by D.xin on 16/9/22.
//  Copyright © 2016年 D.xin. All rights reserved.
//

import UIKit

class GameModel: NSObject {

    var dismension:Int = 0;//纬度
    var tiles:Array <Int>; //数组
    
    //定义通关的最大值
    var maxNumber :Int = 0{
    
        didSet{
        
            print("被设置",maxNumber);
        }
        
    }
    
    //保存重排数据的数组
    var mtile :Array<Int>!
    
    
    init(dismension:Int,maxNumber:Int){
        self.maxNumber = maxNumber;
        self.dismension = dismension;
        self.tiles = Array<Int>(repeating:0, count:self.dismension * self.dismension);
        self.mtile = Array<Int>(repeating:0 ,
                                count:self.dismension * dismension);
        
//        initTiles();
        /*
            通过数组的索引来标识16个方格的位置，该位置对应的值就会保存在数组对应的位置，对于空白位置，直接使用0表示，只要该位置的Value 是大于0的，就说明这个位置是有值的。
         */
    }
    
    func initTiles(){
        self.tiles = Array<Int>(repeating:0, count:self.dismension * self.dismension);
        self.mtile = Array<Int>(repeating:0 ,
                                count:self.dismension * dismension);
    }
    
    
    //判断某一个位置是否有值，false表示有值  true 表示没有值
    func setPosition(row:Int,col:Int,value:Int) ->Bool{
        //(assert)断言， 满足一定的条件保证程序执行，如果不满足程序就会被终止
        assert(row >= 0 && row < dismension);
        
        assert(col >= 0 && col < dismension);
        
        let index  = self.dismension * row + col;
        
        let val = tiles[index];
        //说明有值
        if val > 0 {
            print("该位置已经有值了");
            return false;
        }
        //如果没有值，就把值赋给当前位置
        tiles[index] = value;
        return true;
    }
    //定义一个检测空位置的方法
    func emptyPosition()->[Int]{
    
        var emptytiles = Array<Int>();
        
        for i in 0..<dismension * dismension{
            if tiles[i] == 0{
                emptytiles.append(i);//记录为0的位置就可以
            }
        }
        
        return emptytiles;

        
}
    //定义一个检测方块地图是否满了的方法，通过空位置数组的个数进行判断，只要没有空位置就表示满了
    func isFull()->Bool{
        
        if emptyPosition().count == 0{

            return true;
        }
        return false;
    }
    
    
    //定义两个方法，把tiles的数据跟mtile数据交换
    //将tile值搬到mtile里面
    func  copyToMitiles(){
        for i in 0..<self.dismension * self.dismension{
        
            mtile[i] = tiles[i];
        }
    }
    
    
    
    
    //将mtile里面的值copy 到tile
    func   copeTotile(){
        for i in 0..<self.dismension * self.dismension{
        tiles[i] = mtile[i];
        }
    }
    

    
    
    //向上重排
    func reflowUp(){
        //数据放到重排数组
        copyToMitiles();
        var index : Int
        for temp in 1...(dismension - 1){
            let i = dismension - temp;
            //要执行4次，用于控制列数
            for j in 0..<dismension{
                index = self.dismension * i + j
                //如果当前有值，上一行没有值
                if((mtile[index - self.dismension] == 0) && (mtile[index]>0)){
                    //直接把当前行的值赋值给上一行
                    mtile[index - self.dismension] = mtile[index];
                    //当前行的数置0
                    mtile[index] = 0;
                    //滑动重排之后，得让后面的行跟上
                    var subindex :Int = index;
                    while (subindex + self.dismension < mtile.count) {
                        
                        //如果下面的有值
                        if mtile[subindex + self.dismension] > 0{
                            //把下面的值赋值给当前位置
                            mtile[subindex] = mtile[subindex + self.dismension]
                            //下面的值变成0
                            mtile[subindex  + self.dismension] = 0;
                        }
                        subindex += self.dismension;
                    }
                }
            }
        
        }
        
        //在最后把数据copy到tile数组中去
        copeTotile();

    }
    
    
    //数据向下重排
    func reflowDown(){
        //把元数据放到操作数组中防止数据混乱
        copyToMitiles();
        
        var index:Int;
        //从第0行开始往下找，只需要找到dimesion-1 行因为最后一行不需要移动
        for i in 0..<dismension - 1{
            
            for j in 0..<dismension{
                index = self.dismension * i + j;
                //如果当前位置有值，下一行对应的位置没有值
                if((mtile[index]>0) && (mtile[index + dismension] == 0)){
                   //将当前行的数据复制给下一行
                    mtile[index + dismension] = mtile[index];
                    mtile[index] = 0;
                    var subIndex:Int = index;
                    //当上面的行发生了移动，上面的行得跟上
                    //否则滑动重排之后会出现空隙
                    while(subIndex - self.dismension >= 0){
                        //如果上一行对应位置不是空的
                        if mtile[subIndex - self.dismension] > 0{
                            //上一行数据复制给当前行
                            mtile[subIndex] = mtile[subIndex - dismension];
                            mtile[subIndex - self.dismension] = 0;
                        }
                        subIndex -= self.dismension;
                    }
                    
                }
            }
        }
        
        //把数据放回原来数据数组
        copeTotile();
        
    }
    
    
    
    //数据向左重排
    func reflowLeft(){
        //首先把数据存到操作数组
        copyToMitiles();
        //重左向右开始检索
        var  index : Int ;
        //确定位置
        for i in 0..<dismension{
            for temp in 1...dismension-1{
                let j  = dismension - temp;
                //计算得出当前位置
                index = self.dismension * i  + j ;
                //如果当前位置有值，其左侧没有值，向左移动
                if(mtile[index - 1] == 0)&&(mtile[index]>0){
                    //执行赋值
                    mtile[index - 1] = mtile[index];
                    mtile[index] = 0;
                    var subIndex :Int = index;
                    while  (subIndex + 1 < i * dismension + dismension) {
                        if mtile[subIndex + 1] > 0{
                            mtile[subIndex] = mtile[subIndex + 1];
                            mtile[subIndex + 1] = 0;
                        }
                        subIndex += 1;
                    }
               }
            }
        }
        copeTotile();
    }
    
    //数据向右重排
    func reflowRight(){
        copyToMitiles();
        var index:Int;
        for i in 0..<dismension{
            for j in 0..<dismension - 1{
                index = self.dismension * i + j;
                //如果当前位置有值但是右侧没有值，向右移动
                if(mtile[index]>0)&&(mtile[index+1] == 0){
                    mtile[index + 1] = mtile[index];
                    mtile[index] = 0;
                    
                    var subindex:Int = index;
                    //对左边的位置进行检查
                    while (subindex - 1 > i * dismension-1) {
                        if mtile[subindex - 1] > 0{
                            mtile[subindex] = mtile[subindex - 1];
                            mtile[subindex - 1] = 0;
                        }
                        subindex -= 1;
                    }
                }
                
            }
        
        }
        
        copeTotile();
    
    }
    
    //数字的合并
    //向上合并
    func mergeUp(){
    
        copyToMitiles();
        var index:Int
        //从下向上合并
        for temp in 1...(dismension - 1){
        
        let i = dismension - temp
            for j in 0..<dismension{
                index = self.dismension * i + j ;
                //如果当前行有值而且和上一行的数值相等，
                if (mtile[index]>0)&&(mtile[index - self.dismension] == mtile[index]){
                    //将上一行的值变为当前值的两倍当前值置为0
                    mtile[index - self.dismension] = mtile[index] * 2;
                    mtile[index] = 0;
                }
            }
        }
        copeTotile();
    }
    
    
    //向下合并
    func mergeDown(){
        copyToMitiles();
        var index:Int;
        //从上向下合并
        for i in 0..<dismension-1{
            for j in 0..<dismension{
             index = self.dismension * i + j;
                //如果当前位置有值并且当前位置的下面一个位置相等
                if(mtile[index]>0)&&(mtile[index+self.dismension] == mtile[index]){
                    //把下一个位置值乘以2并且当前位置变为0
                    mtile[index + self.dismension] = mtile[index] * 2;
                    mtile[index] = 0;
                }
            }
        }
        copeTotile();
    }
    
    
    //向左合并f
    func mergeLeft(){
        copyToMitiles();
        var index:Int
        //从右向左合并
        for i in 0..<dismension{
            for temp in 1...(dismension - 1){
                let j = dismension - temp;
                index = self.dismension * i + j;
                //如果右边和左边的数字相邻相等则合并
                if(mtile[index] == mtile[index - 1])&&(mtile[index]>0){
                    mtile[index - 1] = mtile[index] * 2
                    mtile[index] = 0;
                }
            }
        }
        copeTotile();
    }
    
    
    //向右合并
    func mergeRight(){
        copyToMitiles();
        //从左向右合并 
        var index :Int;
        for i in 0..<dismension{
            for j in 0..<dismension-1{
                index = self.dismension * i + j;
                //如果左边和右边数字相邻相等则合并
                if(mtile[index] > 0) && (mtile[index+1] == mtile[index]){
                    mtile[index + 1] = mtile[index] * 2;
                    mtile[index] = 0;
                }
            }
        }
        copeTotile();
    }
    
    
    //定义 一个检测最大值的方法，用于检测是否通关
    func isSuccess()->Bool{
        print(self.maxNumber);
            for i in 0..<dismension * dismension{
            if tiles[i] >= maxNumber{
                return true;
            }
        }
        return false ;
    }
    
    
    //定义一个检测游戏是否结束的方法
    //垂直方向检查
    func checkVertical()->Bool{
        var index = 0;
        
        //从下向上检查
        for temp in 1...(dismension - 1){
            
            let i  = dismension - temp;
            for j in 0..<dismension{
                index = self.dismension * i + j;
                //如果当前行和上一行值相等，返回false
                while (mtile[index - self.dismension] == mtile[index]){
                
                        //没有失败
                    return false;
                }
            }
        }
        return true;
    }
    
    
    
    //水平方向检查
    func checkHorizontal()->Bool{
        var index = 0;
        
        //从右向左检查
        for  i in 0..<dismension{
            for temp in 1...(dismension - 1){
              let j = dismension - temp
                index = self.dismension * i + j;
                //如果当前列和左侧一列值相等，返回false
                while (mtile[index - 1] == mtile[index]) {
                    return false;
                }
            }
        }
        return true;
    }
    
    //检测游戏是否失败
    func isFailure()->Bool{
        if isFull() == true{
        
            if (checkVertical() == true) && (checkHorizontal() == true){
            
                return true;
            }
            
        }
        //没有失败
        return false;
    }
    
    
    
  }



















