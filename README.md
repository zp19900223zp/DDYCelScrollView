# DDYCelScrollView
DDYCelScrollView主要适用于首页banner页
## 快照
![](https://github.com/zp19900223zp/DDYCelScrollView/blob/master/DDYCelScrollView1.gif)
![](https://github.com/zp19900223zp/DDYCelScrollView/blob/master/DDYCelScrollView2.gif)

## 特性
/**
 iamges : 图片数组
 titles : 标题数组
 pageLocation : 滑动图片的位置显示
 changeTime : 每张图片停留的时间
 isShrink : 移动过程中图片是否缩小
 clickActionIndex : 每个图片被点击的回调
 */
- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles withPageViewLocation:(DDYcleScrollPageViewPosition)pageLocation withPageChangeTime:(NSTimeInterval)changeTime withFrame:(CGRect)frame isShrink:(BOOL)isShrink clickAction:(void (^)(NSInteger index))clickActionIndex;
