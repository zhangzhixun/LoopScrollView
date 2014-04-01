//
//  LoopScrollView.m
//  LoopScrollVIewDemo
//
//  Created by 张志勋 on 14-3-31.
//  Copyright (c) 2014年 zhixun_zhang. All rights reserved.
//

#import "LoopScrollView.h"

@implementation LoopScrollView

@synthesize loopScrollViewDataSource = _loopScrollViewDataSource;
@synthesize autoScrollEnabled = _autoScrollEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        myScrollView.backgroundColor = [UIColor lightGrayColor];
        myScrollView.delegate = self;
        myScrollView.pagingEnabled = YES;
        myScrollView.scrollEnabled = YES;
        myScrollView.showsHorizontalScrollIndicator = NO;
        myScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:myScrollView];
        
        pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 15, CGRectGetWidth(frame), 10)];
        pageControl.userInteractionEnabled = NO;
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        [self addSubview:pageControl];
        self.userInteractionEnabled = YES;
        
        self.scrollTimeInterval = 3.0;
        self.autoScrollEnabled = YES;
        
        _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20)];
        _descriptionLabel.hidden = NO;
        _descriptionLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_descriptionLabel];
        
        [self bringSubviewToFront:pageControl];
    }
    return self;
}

- (void)setLoopScrollViewDataSource:(id<LoopScrollViewDataSource>)loopScrollViewDataSource{
    _loopScrollViewDataSource = loopScrollViewDataSource;
    [self setupPagesView];
    [self setupDescription];
}

- (void)setAutoScrollEnabled:(BOOL)autoScrollEnabled{
    _autoScrollEnabled = autoScrollEnabled;
    if (autoScrollEnabled) {
        timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollTimeInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    }else{
        if (timer) {
            [self invalidateTimer];
        }
    }
}

- (void)setDescriptionEnabled:(BOOL)descriptionEnabled{
    _descriptionLabel.hidden = !descriptionEnabled;
}

- (void)setupPagesView{
    NSMutableArray *tempPage = [NSMutableArray array];
    
    if ([self.loopScrollViewDataSource respondsToSelector:@selector(numberOfLoopPages)]) {
        totalPages = [self.loopScrollViewDataSource numberOfLoopPages];
    }
    if ([self.loopScrollViewDataSource respondsToSelector:@selector(pagesViewAtIndex:)]) {
        for (int i = 0; i < totalPages; i++) {
            [tempPage addObject:[self.loopScrollViewDataSource pagesViewAtIndex:i]];
        }
        // copy is shallow copy, that means we only copy the indicator of the objects rather than the objects.
        // when modify the frame of UIView, the two objects whose indicator is the same will make no diffience.
        // so this is a solution to deep copy UIView here.
        UIView *firstView = [tempPage firstObject];
        UIView *lastView = [tempPage lastObject];
        UIView *newFirstView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:firstView]];
        UIView *newLastView = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:lastView]];
        [tempPage insertObject:newFirstView atIndex:[tempPage count]];
        [tempPage insertObject:newLastView atIndex:0];
        pagesView = tempPage;
    }
    //setup the view's frame in scroll view
    CGRect frame;
    for (int i = 0 ; i < [pagesView count] ; i++) {
        UIView *v = [pagesView objectAtIndex:i];
        frame = self.bounds;
        v.frame = CGRectOffset(v.frame, self.bounds.size.width * i, 0);
        [myScrollView addSubview:v];
    }
    currentPageIndex = 0;
    [pageControl setNumberOfPages:totalPages];
    [pageControl setCurrentPage:currentPageIndex];
    myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * (totalPages + 2), CGRectGetHeight(self.frame));
    myScrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}

- (void)setupDescription{
    NSMutableArray *tempDescription = [NSMutableArray array];
    if ([self.loopScrollViewDataSource respondsToSelector:@selector(textOfDescriptionAtIndex:)]) {
        for (int i = 0; i < totalPages; i++) {            
            [tempDescription addObject:[self.loopScrollViewDataSource textOfDescriptionAtIndex:i]];
        }
        descriptions = tempDescription;
        _descriptionLabel.text = [descriptions objectAtIndex:currentPageIndex];
    }
}

- (void)setPageControlAndDescription{
    [pageControl setCurrentPage:currentPageIndex];        
    if (!_descriptionLabel.hidden) {
        [_descriptionLabel setText:[descriptions objectAtIndex:currentPageIndex]];
    }
}

- (void)invalidateTimer{
    [timer invalidate];
    timer = nil;
}

// auto scroll method
- (void)scrollToNextPage{
    currentPageIndex++;
    [myScrollView setContentOffset:CGPointMake(myScrollView.bounds.size.width * (currentPageIndex + 1), 0) animated:YES];
    if (currentPageIndex >= totalPages) {
        currentPageIndex = 0;
    }
    [self setPageControlAndDescription];
}

- (int)getTempPage:(UIScrollView *)scrollView{
    int xValue = scrollView.contentOffset.x;
    int width = scrollView.bounds.size.width;
    int page = xValue / width;
    if ((xValue % width) >= width / 2) {
        page++;
    }
    return page;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.autoScrollEnabled = NO;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.autoScrollEnabled = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = [self getTempPage:scrollView];
    int width = scrollView.bounds.size.width;
    
    [scrollView setContentOffset:CGPointMake(width * page, 0) animated:YES];
    if (page == 0) {
        
        [scrollView setContentOffset:CGPointMake(width * totalPages, 0) animated:NO];
    }
    if (page == totalPages + 1) {
        
        [scrollView setContentOffset:CGPointMake(width , 0) animated:NO];
    }
    currentPageIndex = scrollView.contentOffset.x / self.frame.size.width - 1;
    [self setPageControlAndDescription];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (currentPageIndex  == 0) {
        [myScrollView setContentOffset:CGPointMake(myScrollView.bounds.size.width * (currentPageIndex + 1), 0) animated:NO];
    }
}

@end
