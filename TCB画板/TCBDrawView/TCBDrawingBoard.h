//
//  TCBDrawingBoard.h
//  VictorTu
//
//  Created by VictorTu on 15/11/2.
//  Copyright (c) 2015年 TCB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignEditView.h"
#import "TCBDrawModel.h"
#import "TCBDrawCommon.h"
#import "UIView+WHB.h"
#import "UIColor+help.h"
#import "TCBDrawPoint.h"
#import "MJExtension.h"
#import "NSFileManager+Helper.h"


typedef NS_ENUM(NSInteger, TCBDrawingStatus) {
    TCBDrawingStatusBegin,//准备绘制
    TCBDrawingStatusMove,//正在绘制
    TCBDrawingStatusEnd//结束绘制

};

typedef NS_ENUM(NSInteger, TCBDrawingShapeType) {
    TCBDrawingShapeCurve = 0,//曲线
    TCBDrawingShapeLine,//直线
    TCBDrawingShapeEllipse,//空心椭圆
    TCBDrawingShapeRect,//空心矩形
    TCBDrawingShapeEllipseFull,//实心椭圆
    TCBDrawingShapeRectFull,//实心矩形
    
};


@class TCBDrawingBoard;

@protocol TCBDrawingBoardDelegate <NSObject>

- (void)drawBoard:(TCBDrawingBoard *)drawView;
- (void)drawBoard:(TCBDrawingBoard *)drawView drawingStatus:(TCBDrawingStatus)drawingStatus model:(TCBDrawModel *)model;

@end


@class TCBDrawView;
@interface TCBDrawingBoard : UIView

@property (nonatomic, strong) DesignEditView *editDraw;
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, weak) id<TCBDrawingBoardDelegate> delegate;

/**
 *  根据点的集合绘制      
 *
 *  @param model    ["{x,y}"...]
 *
 *  @return YES -> 绘制完成 model
 */
- (BOOL)drawWithPoints:(TCBDrawModel *)model;

+ (TCBDrawModel *)objectWith:(NSDictionary *)dic;

@end

#pragma mark - TCBPath
@interface TCBPath : NSObject

@property (nonatomic, strong) UIColor *pathColor;//画笔颜色
@property (nonatomic, assign) CGFloat lineWidth;//线宽
@property (nonatomic, assign) BOOL isEraser;//橡皮擦
@property (nonatomic, assign) TCBDrawingShapeType shapType;//绘制样式
@property (nonatomic, copy) NSString *imagePath;//图片路径
@property (nonatomic, strong) UIBezierPath *bezierPath;


+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isEraser:(BOOL)isEraser;//初始化对象
- (void)pathLineToPoint:(CGPoint)movePoint WithType:(TCBDrawingShapeType)shapeType;//画

@end

@interface TCBDrawView : UIView

- (void)setBrush:(TCBPath *)path;

@end

