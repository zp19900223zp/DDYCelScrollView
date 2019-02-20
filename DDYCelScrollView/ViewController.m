//
//  ViewController.m
//  DDYCelScrollView
//
//  Created by AOHY on 2019/2/20.
//  Copyright © 2019年 Config. All rights reserved.
//

#import "ViewController.h"
#import "DDYCelScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self colorWithHexString:@"#c0c0c0"];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= 6; ++i) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cycle_image%ld",(long)i]];
        [images addObject:image];
    }
    NSArray *titles = @[@"大海",@"花",@"长灯",@"阳光下的身影",@"秋树",@"摩天轮"];
    DDYCelScrollView *cyclePlayView = [[DDYCelScrollView alloc] initWithImages:images titles:titles withPageViewLocation:DDYcleScrollPageViewPositionBottomRight withPageChangeTime:3.0f withFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/4) isShrink:YES clickAction:^(NSInteger index) {
        NSLog(@"+++++++%ld", index);
    }];
    [self.view addSubview:cyclePlayView];
}

- (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1.0];
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if(NO == flag)
        return [UIColor clearColor];
    float r, g, b, a;
    a = alpha;
    b = value & 0x0000FF;
    value = value >> 8;
    g = value & 0x0000FF;
    value = value >> 8;
    r = value;
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

@end
