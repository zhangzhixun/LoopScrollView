//
//  LoopScrollView.h
//  LoopScrollVIewDemo
//
//  Created by 张志勋 on 14-3-31.
//  Copyright (c) 2014年 zhixun_zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoopScrollViewDataSource;

@interface LoopScrollView : UIView <UIScrollViewDelegate>{
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
    UILabel *_descriptionLabel;
    
    NSArray *pagesView;
    NSArray *descriptions;
    
    NSInteger currentPageIndex;
    NSInteger totalPages;// displayed pages
    
    NSTimer *timer;
}

@property (nonatomic,weak)id<LoopScrollViewDataSource> loopScrollViewDataSource;
@property (nonatomic) BOOL autoScrollEnabled;//is auto scrolled
@property (nonatomic) NSInteger scrollTimeInterval;// auto scrolling interval
@property (nonatomic) BOOL descriptionEnabled;

@end

@protocol LoopScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfLoopPages;
- (UIView *)pagesViewAtIndex:(NSInteger)index;

@optional
- (NSString *)textOfDescriptionAtIndex:(NSInteger)index;

@end
