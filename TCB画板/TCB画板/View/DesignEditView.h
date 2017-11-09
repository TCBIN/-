//
//  DesignEditView.h
//  DesignClothing
//
//  Created by WebUser on 17/8/3.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCBDrawCommon.h"

typedef NS_ENUM(NSInteger,setType) {
    setTypePen,
    setTypeLine,
    setTypeCircleEmpty,
    setTypeCircleFull,
    setTypeRectEmpty,
    setTypeRectFull,
    setTypeEraser,
    setTypeBack,
    setTyperegeneration,
    setTypeClearAll
};

typedef void(^boardSettingBlock)(setType type);

@interface DesignEditView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

- (void)getSettingType:(boardSettingBlock)type;

@end
