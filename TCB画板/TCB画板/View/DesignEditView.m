//
//  DesignEditView.m
//  DesignClothing
//
//  Created by WebUser on 17/8/3.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "DesignEditView.h"
#import "DesignUIButton.h"
#import "SelectColorPickerView.h"
#import "MyLayout.h"
#import "UIView+WHB.h"

#define kScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                        [[UIScreen mainScreen] bounds].size.height

@interface DesignEditView ()<SelectColorPickerViewDelegate>
{
    CGPoint MY_CENTER;
    CGFloat MY_RADIUS;
    CGFloat deltaAngle;
}

@property(nonatomic, strong) SelectColorPickerView *selectColorView;
@property(nonatomic, strong) UIView *bgBtn;

@property (nonatomic, copy) boardSettingBlock stype;

@end


@implementation DesignEditView

- (void)getSettingType:(boardSettingBlock)type {
    self.stype = type;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        MyRelativeLayout *topLayout = [[MyRelativeLayout alloc] init];
        topLayout.myLeft = topLayout.myRight = 0;
        topLayout.myHeight = 40.5;
        topLayout.topBorderline = [[MyBorderline alloc] initWithColor:[UIColor lightGrayColor]];
        [self addSubview:topLayout];
        [self addSubview:self.selectColorView];
        
        UIButton *backwards = [UIButton buttonWithType:UIButtonTypeCustom];
        [backwards setImage:[UIImage imageNamed:@"icon_backwards"] forState:UIControlStateNormal];
        [backwards addTarget:self action:@selector(backwardsClick:) forControlEvents:UIControlEventTouchUpInside];
        [topLayout addSubview:backwards];
        
        UIButton *goahead = [UIButton buttonWithType:UIButtonTypeCustom];
        [goahead setImage:[UIImage imageNamed:@"icno_go_ahead"] forState:UIControlStateNormal];
        [goahead addTarget:self action:@selector(goaheadClick:) forControlEvents:UIControlEventTouchUpInside];
        [topLayout addSubview:goahead];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [topLayout addSubview:delete];
        
        backwards.myWidth = delete.myWidth = frame.size.width/3;
        backwards.myHeight = goahead.myHeight = delete.myHeight = 40.f;
        backwards.myLeft = backwards.myTop = 0;
        delete.myRight = delete.myTop = 0;
        goahead.myTop = 0;
        goahead.leftPos.equalTo(backwards.rightPos);
        goahead.rightPos.equalTo(delete.leftPos);
        
        MY_RADIUS = 60;
        UIView *bgBtn = [[UIView alloc] init];
        bgBtn.bounds = CGRectMake(0, 0, MY_RADIUS*2+25, MY_RADIUS*2+25);
        bgBtn.center = CGPointMake(20, (frame.size.height-40.5)/2+40.5);
        bgBtn.userInteractionEnabled = YES;
        [bgBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [bgBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)]];
        [self addSubview:bgBtn];
        self.bgBtn = bgBtn;
        NSArray *btns = @[@"design_fragment_draw_circle_empty",
                          @"design_fragment_draw_circle_full",
                          @"design_fragment_draw_eraser",
                          @"design_fragment_draw_line",
                          @"design_fragment_draw_pen",
                          @"design_fragment_draw_rect_empty",
                          @"design_fragment_draw_rect_full"];
        MY_CENTER = CGPointMake(bgBtn.frame.size.width/2, bgBtn.frame.size.height/2);
        for (int i=0; i<btns.count; i++) {
            DesignUIButton *btn = [DesignUIButton buttonWithType:UIButtonTypeCustom];
            btn.bounds = CGRectMake(0, 0, 44, 44);
            btn.angle = i*(360/btns.count);
            CGFloat x = MY_CENTER.x +MY_RADIUS *cos(btn.angle/180*M_PI);
            CGFloat y = MY_CENTER.y +MY_RADIUS *sin(btn.angle/180*M_PI);
            btn.center = CGPointMake(x, y);
            btn.tag = i+1;
            [btn setImage:[UIImage imageNamed:btns[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pathsStyle:) forControlEvents:UIControlEventTouchUpInside];
            [bgBtn addSubview:btn];
        }
//        deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
//                           self.frame.origin.x - self.center.x);
    }
    return self;
}
- (void)tap:(UITapGestureRecognizer *)recognizer {
//    CGPoint startPoint = [recognizer locationInView:self.bgBtn.superview];
    deltaAngle = atan2(self.bgBtn.frame.origin.y+self.bgBtn.frame.size.height - self.bgBtn.center.y, self.bgBtn.frame.origin.x+self.bgBtn.frame.size.width - self.bgBtn.center.x);
}
- (void)rotation:(UIPanGestureRecognizer *)recognizer {
    /* Rotation */
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        deltaAngle = atan2([recognizer locationInView:self.bgBtn.superview].y - self.bgBtn.center.y, [recognizer locationInView:self.bgBtn.superview].x - self.bgBtn.center.x);
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat ang = atan2([recognizer locationInView:self.bgBtn.superview].y - self.bgBtn.center.y, [recognizer locationInView:self.bgBtn.superview].x - self.bgBtn.center.x);
        CGFloat angleDiff = deltaAngle - ang;
        self.bgBtn.transform = CGAffineTransformMakeRotation(-angleDiff);
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        deltaAngle = atan2([recognizer locationInView:self.bgBtn.superview].y - self.bgBtn.center.y, [recognizer locationInView:self.bgBtn.superview].x - self.bgBtn.center.x);
    }
    [self setNeedsDisplay];
}

- (void)pathsStyle:(DesignUIButton *)sender {
    if (sender.tag == 1) {
        if (self.stype) {
            self.stype(setTypeCircleEmpty);
        }
    }else if (sender.tag == 2) {
        if (self.stype) {
            self.stype(setTypeCircleFull);
        }
    }else if (sender.tag == 3) {
        if (self.stype) {
            self.stype(setTypeEraser);
        }
    }else if (sender.tag == 4) {
        if (self.stype) {
            self.stype(setTypeLine);
        }
    }else if (sender.tag == 5) {
        if (self.stype) {
            self.stype(setTypePen);
        }
    }else if (sender.tag == 6) {
        if (self.stype) {
            self.stype(setTypeRectEmpty);
        }
    }else if (sender.tag == 7) {
        if (self.stype) {
            self.stype(setTypeRectFull);
        }
    }
}

- (void)backwardsClick:(UIButton *)sender {
    if (self.stype) {
        self.stype(setTypeBack);
    }
}
- (void)goaheadClick:(UIButton *)sender {
    if (self.stype) {
        self.stype(setTyperegeneration);
    }
}
- (void)deleteClick:(UIButton *)sender {
    if (self.stype) {
        self.stype(setTypeClearAll);
    }
}
#pragma mark - 选色代理
-(void)getCurrentColor:(UIColor *)color{
    self.lineColor = color;
    [[NSNotificationCenter defaultCenter] postNotificationName:SendColorAndWidthNotification object:nil];
}
-(SelectColorPickerView *)selectColorView{
    if(!_selectColorView){
        _selectColorView=[[SelectColorPickerView alloc] initWithFrame:CGRectMake((kScreenWidth/2-100)/2+kScreenWidth/2, 50, 100, 100)];
        _selectColorView.delegate = self;
    }
    return  _selectColorView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
