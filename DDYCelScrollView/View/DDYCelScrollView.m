//
//  DDYCelScrollView.m
//  AH_Enterprise
//
//  Created by AOHY on 2017/12/14.
//  Copyright © 2017年 Mr.Yang. All rights reserved.
//

#import "DDYCelScrollView.h"

#define DDYCLEINDEX_CALCULATE(x,y) (x+y)%y  //计算循环索引
#define DDYDEFAULT_DURATION_TIME 4.0f         //默认持续时间
#define DDYDEFAULT_DURATION_FRAME CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/4)

@interface DDYCelScrollView ()<UIScrollViewDelegate,CAAnimationDelegate>{
    CGFloat h1;
    CGFloat h2;
    NSInteger timeH;
}


@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * middleImageView;
@property (nonatomic, strong) UIImageView * rightImageView;
@property (nonatomic, strong) UIScrollView * containerView;

/**
 计时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 当前滑动到的数量
 */
@property NSInteger currentNumber;

/// 确定
@property (nonatomic, copy) void (^clickActionBlock)(NSInteger index);

@end

@implementation DDYCelScrollView

#pragma mark - init function
- (instancetype)initWithImages:(NSArray *)images
{
    return [self initWithImages:images withFrame:DDYDEFAULT_DURATION_FRAME];
}

- (instancetype)initWithImages:(NSArray *)images withFrame:(CGRect)frame{
    return [self initWithImages:images titles:self.pageDescrips withPageViewLocation:DDYcleScrollPageViewPositionBottomCenter withPageChangeTime:DDYDEFAULT_DURATION_TIME withFrame:frame isShrink:YES clickAction:self.clickActionBlock];
}

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles withPageViewLocation:(DDYcleScrollPageViewPosition)pageLocation withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame isShrink:(BOOL)isShrink clickAction:(void (^)(NSInteger index))clickActionIndex{
    self = [super init];
    if (self) {
        h1 = 0.9;
        h2 = 10.0 / 9.0;
        timeH = 40;
        self.frame = frame;
        _images = [[NSArray alloc]initWithArray:images];
        _pageLocation = pageLocation;
        _pageChangeTime = changeTime;
        _pageDescrips = titles;
        _isShrink = isShrink;
        _currentNumber = 0;
        self.clickActionBlock = clickActionIndex;
        [self cycleViewConfig];
        //配置pageControl 初始化等
        [self pageControlCongfig];
        //初始化图片描述
        [self pageImageDescriLabelConfig];
        //设置三个imageview的初始image，如果没有设置image 则直接跳过
        [self cycleImageViewConfig];
        
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(clickPageAction)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

#pragma mark -init configure
- (void)cycleViewConfig
{
    //self.frame = frame;
    //设置三个imageview的位置
    
    //初始化容器ScrollView和三个imageview
    _containerView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _containerView.contentSize = CGSizeMake(3*_containerView.frame.size.width, _containerView.frame.size.height);
    _containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y)//显示中间图片
    ;
    _containerView.backgroundColor = [UIColor grayColor];
    self.leftImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0  , _containerView.frame.size.width, _containerView.frame.size.height)];
    
    self.middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_containerView.frame.size.width, 0  , _containerView.frame.size.width, _containerView.frame.size.height)];
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*_containerView.frame.size.width, 0, _containerView.frame.size.width, _containerView.frame.size.height)];
    
    _containerView.delegate = self;
    [_containerView addSubview:_leftImageView];
    [_containerView addSubview:_rightImageView];
    [_containerView addSubview:_middleImageView];
    _containerView.scrollEnabled = YES;
    _containerView.showsHorizontalScrollIndicator = NO;
    _containerView.showsVerticalScrollIndicator = NO;
    _containerView.pagingEnabled = YES;
    
    [self addSubview:_containerView];
}

- (void)pageControlCongfig
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPage = 0;
    [self pageControlPosition:_pageLocation];
    [self addSubview:_pageControl];
    _pageControl.numberOfPages = _images.count;
}

- (void)pageImageDescriLabelConfig
{
    _pageDescripsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_pageControl.frame.origin.y -10, self.frame.size.width, 40)];
    [_pageDescripsLabel setTextAlignment:NSTextAlignmentRight];
    _pageDescripsLabel.backgroundColor = [UIColor clearColor];
    _pageDescripsLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    [self addSubview:_pageDescripsLabel];
}

- (void)cycleImageViewConfig
{
    if ([_images count] == 0) {
        NSLog(@"cycleImageViewConfig:images is empty!");
        return;
    }
    
    _middleImageView.image = (UIImage *)_images[DDYCLEINDEX_CALCULATE(_currentNumber,_images.count)];
    _leftImageView.image = (UIImage *)_images[DDYCLEINDEX_CALCULATE(_currentNumber - 1,_images.count)];
    _rightImageView.image = (UIImage *)_images[DDYCLEINDEX_CALCULATE(_currentNumber + 1,_images.count)];
    
    [self timeSetter];
}

/**
 手指点击要走的方法
 */
- (void)clickPageAction{
    if (self.clickActionBlock) {
        self.clickActionBlock(self.currentNumber);
    }
}



#pragma mark - timer configure
//设置定时器
- (void)timeSetter
{
    //将定时器放入当前RUNLOOP中，可能会导致定时器的失效
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pageChangeTime target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    
    //将定时器放入主进程的RunLoop中
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
- (void)timeChanged{
    timeH = timeH - 1;
    if (timeH == 10) {
        if (_isShrink) {
            [UIView animateWithDuration:0.3 animations:^{
                CGAffineTransform newTransform =
                CGAffineTransformScale(self.middleImageView.transform, h1, h1);
                [self.middleImageView setTransform:newTransform];
            } completion:^(BOOL finished) {
                CGAffineTransform newTransform =
                CGAffineTransformScale(self.leftImageView.transform, h1, h1);
                [self.leftImageView setTransform:newTransform];
            }];
        }
    }
    if (timeH == 6) {
        if (_images.count == 0) {
            NSLog(@"timeChanged:images is empty!");
            return;
        }
        self.currentNumber =  DDYCLEINDEX_CALCULATE(_currentNumber+1,_images.count);
        self.pageControl.currentPage = self.currentNumber;
        [self setPageDescripText];
        [self pageChangeAnimationType:1];
        [self changeImageViewWith:self.currentNumber];
        self.containerView.contentOffset = CGPointMake(_containerView.frame.origin.x, _containerView.frame.origin.y);
    }
    if (timeH == 0) {
        if (_isShrink) {
            [UIView animateWithDuration:0.3 animations:^{
                CGAffineTransform newTransform =CGAffineTransformScale(self.middleImageView.transform, h2, h2);
                [self.middleImageView setTransform:newTransform];
            } completion:^(BOOL finished) {
                CGAffineTransform newTransform =
                CGAffineTransformScale(self.leftImageView.transform, h2, h2);
                [self.leftImageView setTransform:newTransform];
            }];
        }
        timeH = 40;
    }
}

#pragma mark - ScrollView  Delegate
//当用户手动个轮播时 关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

//当用户手指停止滑动图片时 启动定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self timeSetter];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = [self.containerView contentOffset];
    if (offset.x == 2*_containerView.frame.size.width) {
        self.currentNumber = DDYCLEINDEX_CALCULATE(_currentNumber  + 1,_images.count);
    } else if (offset.x == 0){
        self.currentNumber = DDYCLEINDEX_CALCULATE(_currentNumber  - 1,_images.count);
    }else{
        return;
    }
    
    self.pageControl.currentPage = self.currentNumber;
    [self changeImageViewWith:self.currentNumber];
    [self setPageDescripText];
    self.containerView.contentOffset = CGPointMake(_containerView.frame.size.width, _containerView.frame.origin.y);
    
}

#pragma mark - judge the pageControl's position
/**
 *  确定pageControl的位置，可以自定义设置
 *
 *  @param position 有三个位置：下左，下中，下右
 */
- (void)pageControlPosition:(DDYcleScrollPageViewPosition)position
{
    
    if (position == DDYcleScrollPageViewPositionBottomCenter ) {
        _pageControl.frame = CGRectMake(self.center.x - 50, self.frame.size.height -30, 100, 30);
    }else if (position == DDYcleScrollPageViewPositionBottomLeft)
    {
        _pageControl.frame = CGRectMake(50, self.frame.size.height -30, 100, 30);
        
    }else if (position == DDYcleScrollPageViewPositionBottomRight)
    {
        _pageControl.frame = CGRectMake(self.frame.size.width - 100-20, self.frame.size.height -30, 100, 30);
    }
    
}

#pragma mark - iamgeView cycle changed
/**
 *  改变轮播的图片
 *
 *  @param imageNumber 设置当前，前，后的图片
 */
- (void)changeImageViewWith:(NSInteger)imageNumber
{
    self.middleImageView.image = self.images[DDYCLEINDEX_CALCULATE(imageNumber,self.images.count)];
    self.leftImageView.image = self.images[DDYCLEINDEX_CALCULATE(imageNumber - 1,self.images.count)];
    self.rightImageView.image = self.images[DDYCLEINDEX_CALCULATE(imageNumber + 1,self.images.count)];
}


#pragma mark - property setter
- (void)setPageLocation:(DDYcleScrollPageViewPosition)pageLocation
{
    [self pageControlPosition:pageLocation];
}

- (void)setPageDescrips:(NSArray *)pageDescrips
{
    _pageDescrips = [[NSArray alloc]initWithArray:pageDescrips];
    [self setPageDescripText];
}

- (void)setPageDescripText
{
    self.pageDescripsLabel.text = self.pageDescrips[self.currentNumber];
    [self.pageDescripsLabel sizeToFit];
}

- (void)setPageChangeTime:(NSTimeInterval)duration
{
    _pageChangeTime = duration;
    [_timer invalidate];
    [self timeSetter];
}

#pragma mark - page change animation type
- (void)pageChangeAnimationType:(NSInteger)animationType
{
    if (animationType == 0) {
        return;
    }else if (animationType == 1) {
        [self.containerView setContentOffset:CGPointMake(2*self.containerView.frame.size.width, 0) animated:YES];
    }else if (animationType == 2){
        self.containerView.contentOffset = CGPointMake(2*self.frame.size.width, 0);
        [UIView animateWithDuration:self.pageChangeTime delay:0.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)setIsShrink:(BOOL)isShrink{
    _isShrink = isShrink;
}

@end
