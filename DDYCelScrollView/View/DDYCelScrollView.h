//
//  DDYCelScrollView.h
//  AH_Enterprise
//
//  Created by AOHY on 2017/12/14.
//  Copyright © 2017年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 滑动图片位置的显示
 */
typedef enum : int {
    DDYcleScrollPageViewPositionBottomLeft = 0,
    DDYcleScrollPageViewPositionBottomCenter = 1,//默认在底部中间
    DDYcleScrollPageViewPositionBottomRight = 2,
}DDYcleScrollPageViewPosition;

@interface DDYCelScrollView : UIView

/**
 存放图片的数组
 */
@property (nonatomic, strong) NSArray *images;

/**
 存放图片的标题
 */
@property (nonatomic, strong) NSArray *pageDescrips;

/**
 显示图片的label
 */
@property (nonatomic, strong) UILabel *pageDescripsLabel;

/**
 滑动图片的位置
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 每张图片停留的时间
 */
@property (nonatomic, assign) NSTimeInterval  pageChangeTime;

/**
 每张图片滑动过程中是否缩小
 */
@property (nonatomic, assign) BOOL isShrink;

@property (nonatomic, assign) DDYcleScrollPageViewPosition pageLocation;

- (instancetype)initWithImages:(NSArray *)images;
- (instancetype)initWithImages:(NSArray *)images withFrame:(CGRect)frame;

/**
 iamges : 图片数组
 titles : 标题数组
 pageLocation : 滑动图片的位置显示
 changeTime : 每张图片停留的时间
 isShrink : 移动过程中图片是否缩小
 clickActionIndex : 每个图片被点击的回调
 */
- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles withPageViewLocation:(DDYcleScrollPageViewPosition)pageLocation withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame isShrink:(BOOL)isShrink clickAction:(void (^)(NSInteger index))clickActionIndex;


@end
