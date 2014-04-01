//
//  ViewController.h
//  LoopScrollVIewDemo
//
//  Created by 张志勋 on 14-3-31.
//  Copyright (c) 2014年 zhixun_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopScrollView.h"

@interface ViewController : UIViewController<LoopScrollViewDataSource>{
    LoopScrollView *_scrollView;
}

@property (nonatomic,strong)LoopScrollView *scrollView;

@end
