//
//  ViewController.m
//  LoopScrollVIewDemo
//
//  Created by 张志勋 on 14-3-31.
//  Copyright (c) 2014年 zhixun_zhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView = [[LoopScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
	_scrollView.loopScrollViewDataSource = self;
    [self.view addSubview:self.scrollView];
}


#pragma mark - LoopScrollViewDataSource

- (NSInteger)numberOfLoopPages{
    return 4;
}

- (UIView *)pagesViewAtIndex:(NSInteger)index{
    UIImageView * v = [[UIImageView alloc]initWithFrame:self.scrollView.bounds];
    v.contentMode = UIViewContentModeScaleAspectFill;
    v.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%d.jpg",index + 1]];
    return v;
}

- (NSString *)textOfDescriptionAtIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"家居小景-%d",index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
