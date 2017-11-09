//
//  SelectColorEasyView.m
//  TestOC
//
//  Created by 李亚军 on 2017/2/8.
//  Copyright © 2017年 zyyj. All rights reserved.
//

#import "SelectColorEasyView.h"
#import "UIImage+ColorSelect.h"
#import "UIView+WHB.h"


@implementation SelectColorEasyView{
    NSMutableArray *colors;
    UIButton *btnClose;
    
    UIButton *lastBtnSelected;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        //最好不要超过7个，不然要重新布局
        colors = [NSMutableArray arrayWithObjects:@"#000000",@"#555555",@"#7788ee",@"#fff444",@"#3ef888", nil];
        
        [self initViews];
    }
    return self;
}


-(void)initViews{
    for (int i = 0; i<colors.count; i++) {
        UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.backgroundColor = [self colorWithHex:colors[i]];
        view.center = CGPointMake(20 + i*(30+15)+15, 22);
        [self addSubview:view];
        view.tag = i + 1000;
        [view addTarget:self action:@selector(colorSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    [btnClose setTitle:@"×" forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnClose.titleLabel.font = [UIFont systemFontOfSize:40];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClose];
    
}

-(void)closeView{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, 0, self.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0;
    }];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    btnClose.frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
}

-(void)colorSelect:(UIButton *)sender{
    UIColor *color = [self colorWithHex:colors[sender.tag-1000]];
    

    //选中效果
    sender.layer.borderColor = [UIColor redColor].CGColor;
    sender.layer.borderWidth = 2;
    
    if (lastBtnSelected) {
        lastBtnSelected.layer.borderWidth = 0;
    }
  
    
    if ([self.delegate respondsToSelector:@selector(SelectColorEasyViewDidSelectColor:)]) {
        [self.delegate SelectColorEasyViewDidSelectColor:color];
    }
    
    lastBtnSelected = sender;
}

-(UIColor *)colorWithHex:(NSString *)str {
    NSString *cString = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
