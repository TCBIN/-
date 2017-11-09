//
//  TCBDrawPoint.m
//  VictorTu
//
//  Created by VictorTu on 15/11/9.
//  Copyright © 2015年 TCB. All rights reserved.
//

#import "TCBDrawPoint.h"


@implementation TCBDrawPoint
+ (instancetype)drawPoint:(CGPoint)point
{
    TCBDrawPoint *drawPoint = [[TCBDrawPoint alloc] init];
    drawPoint.x = @(point.x);
    drawPoint.y = @(point.y);
    return drawPoint;
}

@end
