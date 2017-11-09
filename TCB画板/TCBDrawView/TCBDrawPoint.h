//
//  TCBDrawPoint.h
//  VictorTu
//
//  Created by VictorTu on 15/11/9.
//  Copyright © 2015年 TCB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TCBDrawPoint : NSObject

+ (instancetype)drawPoint:(CGPoint)point;

@property (nonatomic, strong) NSNumber * x;

@property (nonatomic, strong) NSNumber * y;

@end
