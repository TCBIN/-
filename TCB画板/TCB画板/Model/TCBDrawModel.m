//
//  TCBDrawModel.m
//  VictorTu
//
//  Created by VictorTu on 15/11/9.
//  Copyright © 2015年 TCB. All rights reserved.
//

#import "TCBDrawModel.h"
#import "TCBDrawPoint.h"
#import "MJExtension.h"
#import "TCBDrawCommon.h"


@implementation TCBDrawModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = Action_playing;
        self.width = @([UIScreen mainScreen].bounds.size.width);
        self.height = @([UIScreen mainScreen].bounds.size.height);
        
    }
    return self;
}
+ (NSDictionary *)objectClassInArray
{
    return @{@"pointList": [TCBDrawPoint class]};
}

@end
