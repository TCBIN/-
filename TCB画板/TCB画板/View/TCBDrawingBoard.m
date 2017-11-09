//
//  TCBDrawingBoard.m
//  VictorTu
//
//  Created by VictorTu on 15/11/2.
//  Copyright (c) 2015年 TCB. All rights reserved.
//

#import "TCBDrawingBoard.h"


@interface TCBDrawingBoard()

@property (nonatomic, strong) UIImageView *drawImage;
@property (nonatomic, strong) TCBDrawView *drawView;
@property (nonatomic, assign) BOOL ise;
@property (nonatomic, assign) TCBDrawingShapeType shapType;
@property (nonatomic, strong) UIColor *lastColor;
@property (nonatomic, assign) CGFloat lastLineWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *tempPoints;
@property (nonatomic, strong) NSMutableArray *tempPath;

@end

#define ThumbnailPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"TCBThumbnail"]

@implementation TCBDrawingBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lastColor = [UIColor whiteColor];
        self.lastLineWidth = 2.0;
        self.ise = YES;
        [self addSubview:self.backImage];
        [self addSubview:self.drawImage];
        [self.drawImage addSubview:self.drawView];
         __weak typeof(self) weakSelf = self;
//        接受画笔修改的通知
        [[NSNotificationCenter defaultCenter] addObserverForName:SendColorAndWidthNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            weakSelf.lineColor = weakSelf.editDraw.lineColor;
//            weakSelf.lineWidth = weakSelf.editDraw.lineWidth;
        }];
    }
    return self;
}
- (void)setEditDraw:(DesignEditView *)editDraw {
    _editDraw = editDraw;
    [_editDraw getSettingType:^(setType type) {
        switch (type) {
            case setTypePen: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeCurve;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeLine: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeLine;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeCircleEmpty: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeEllipse;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeCircleFull: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeEllipseFull;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeRectEmpty: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeRect;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeRectFull: {
                self.ise = NO;
                self.shapType = TCBDrawingShapeRectFull;
                self.lineColor = self.lastColor;
                self.lineWidth = self.lastLineWidth;
            }
                break;
            case setTypeEraser: {
                if (!self.ise) {
                    //保存上次绘制状态
                    self.lastColor = self.lineColor;
                    self.lastLineWidth = self.lineWidth;
                    //设置橡皮擦属性
                    self.lineColor = [UIColor clearColor];
                    self.ise = YES;
                }else{
                    self.ise = NO;
                    self.shapType = TCBDrawingShapeCurve;
                    self.lineColor = self.lastColor;
                    self.lineWidth = self.lastLineWidth;
                }
            }
                break;
            case setTypeBack: {
                if (self.paths.count <= 0) {
                    NSLog(@"已经最后一张了，不能撤退了");
                    return;
                }
                TCBPath *lastpath = [self.paths lastObject];
                [self.tempPath addObject:lastpath];
                [self.paths removeLastObject];
                TCBPath *path = [self.paths lastObject];
                UIImage *getImage = [NSFileManager hb_getImageFileName:[ThumbnailPath stringByAppendingPathComponent:path.imagePath]];
                self.drawImage.image = getImage;
            }
                break;
            case setTyperegeneration: {
                if (self.tempPath.count == 0) {
                    NSLog(@"已经最新一张了，不能回滚了");
                    return;
                }
                TCBPath *lastpath = [self.tempPath lastObject];
                [self.paths addObject:lastpath];
                [self.tempPath removeLastObject];
                TCBPath *path = [self.paths lastObject];
                UIImage *getImage = [NSFileManager hb_getImageFileName:[ThumbnailPath stringByAppendingPathComponent:path.imagePath]];
                self.drawImage.image = getImage;
                
            }
                break;
            case setTypeClearAll: {
                [self.paths removeAllObjects];
                [self.tempPath removeAllObjects];
                [self.tempPoints removeAllObjects];
                [NSFileManager deleteFile:ThumbnailPath];
                self.drawImage.image = nil;
            }
                break;
                
            default:
                break;
        }
    }];
}


#pragma mark - Public_Methd
- (BOOL)drawWithPoints:(TCBDrawModel *)model{

    self.userInteractionEnabled = NO;
    
    //比值
    CGFloat xPix = ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale);
    CGFloat yPix = ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale);
    CGFloat xp = model.width.floatValue / xPix;
    CGFloat yp = model.height.floatValue / yPix;
    
    TCBDrawPoint *point = [model.pointList firstObject];
    
    TCBPath *path = [TCBPath pathToPoint:CGPointMake(point.x.floatValue * xp , point.y.floatValue * yp) pathWidth:model.paintSize.floatValue isEraser:model.isEraser.boolValue];
    path.pathColor = [UIColor colorWithHexString:model.paintColor];
    
    [self.paths addObject:path];
    
    NSMutableArray *marray = [model.pointList mutableCopy];
    
    [marray removeObjectAtIndex:0];

    [marray enumerateObjectsUsingBlock:^(TCBDrawPoint *point, NSUInteger idx, BOOL *stop) {
        
        [path pathLineToPoint:CGPointMake(point.x.floatValue * xp , point.y.floatValue * yp) WithType:TCBDrawingShapeCurve];
        
        [self.drawView setBrush:path];
        
    }];
    
    self.userInteractionEnabled = YES;
    return YES;
}
+ (TCBDrawModel *)objectWith:(NSDictionary *)dic
{
    return [TCBDrawModel objectWithKeyValues:dic];
}

#pragma mark - CustomMethd
- (CGPoint)getTouchSet:(NSSet *)touches{
    
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];

}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [self getTouchSet:touches];

    TCBPath *path = [TCBPath pathToPoint:point pathWidth:_lineWidth isEraser:self.ise];

    path.pathColor = _lineColor;
    
    path.imagePath = [NSString stringWithFormat:@"%@.png",[self getTimeString]];
    
    [self.paths addObject:path];

    [self.tempPoints addObject:[TCBDrawPoint drawPoint:point]];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:TCBDrawingStatusBegin model:nil];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    CGPoint point = [self getTouchSet:touches];

    TCBPath *path = [self.paths lastObject];
    
    [path pathLineToPoint:point WithType:self.shapType];
    
    if (self.ise) {
        [self setEraseBrush:path];
    }else{
        [self.drawView setBrush:path];
    }
    
    [self.tempPoints addObject:[TCBDrawPoint drawPoint:point]];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:TCBDrawingStatusMove model:nil];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    
    TCBPath *path = [self.paths lastObject];
    
    UIImage *image = [self screenshot:self.drawImage];
    
    self.drawImage.image = image;
    
    [self.drawView setBrush:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 0.4);
    
    NSString *filePath = [ThumbnailPath stringByAppendingPathComponent:path.imagePath];

    BOOL isSave = [NSFileManager hb_saveData:imageData filePath:filePath];
    
    if (isSave) {
        
        NSLog(@"%@", [NSString stringWithFormat:@"保存成功: %@",filePath]);
    }
    TCBDrawModel *model = [[TCBDrawModel alloc] init];
    model.paintColor = [_lineColor toColorString];
    model.paintSize = @(_lineWidth);
    model.isEraser = [NSNumber numberWithBool:path.isEraser];
    model.pointList = self.tempPoints;
    model.shapType = [NSNumber numberWithInteger:self.shapType];
    
    if ([self.delegate respondsToSelector:@selector(drawBoard:drawingStatus:model:)]) {
        [self.delegate drawBoard:self drawingStatus:TCBDrawingStatusEnd model:model];
    }

    //清空
    [self.tempPoints removeAllObjects];

}
- (void)setEraseBrush:(TCBPath *)path{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0);
    
    [self.drawImage.image drawInRect:self.bounds];
    
    [[UIColor clearColor] set];
    
    path.bezierPath.lineWidth = _lineWidth;
    
    [path.bezierPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    
    [path.bezierPath stroke];
    
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
}
- (UIImage *)screenshot:(UIView *)shotView{
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [shotView.layer renderInContext:context];
    
    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return getImage;
}
- (NSString *)getTimeString{
    
    NSDateFormatter  *dateformatter = nil;
    if (!dateformatter) {
        dateformatter = [[NSDateFormatter alloc] init];
    }
    
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSSS"];
    
    return [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}

#pragma mark - Lazying
- (NSMutableArray *)paths{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}
- (NSMutableArray *)tempPoints{
    if (!_tempPoints) {
        _tempPoints = [NSMutableArray array];
    }
    return _tempPoints;
}
- (NSMutableArray *)tempPath{
    if (!_tempPath) {
        _tempPath = [NSMutableArray array];
    }
    return _tempPath;
}
- (void)setShapType:(TCBDrawingShapeType)shapType{
    if (self.ise) {
        return;
    }
    _shapType = shapType;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (self.ise) {
        
        _lastColor = lineColor;
        
        return;
    }
    
    _lineColor = lineColor;
}
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _lastLineWidth = lineWidth;
}
- (UIImageView *)backImage
{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImage.image = [UIImage imageNamed:@"design_clothes_sleeves_man_front_gray"];
    }
    return _backImage;
}
- (UIImageView *)drawImage {
    if (!_drawImage) {
        _drawImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _drawImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _drawImage;
}
- (TCBDrawView *)drawView{
    if (!_drawView) {
        _drawView = [TCBDrawView new];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.frame = self.bounds;
        
    }
    return _drawView;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendColorAndWidthNotification object:nil];
}
@end

#pragma mark - TCBPath
@interface TCBPath()

@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;

@end

@implementation TCBPath

+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth isEraser:(BOOL)isEraser {
    TCBPath *path = [[TCBPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth = pathWidth;
    path.isEraser = isEraser;

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = pathWidth;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath moveToPoint:beginPoint];
    path.bezierPath = bezierPath;
    
    return path;
}
//TCBDrawingShapeCurve = 0,//曲线
//TCBDrawingShapeLine,//直线
//TCBDrawingShapeEllipse,//椭圆
//TCBDrawingShapeRect,//矩形
//TCBDrawingShapeEllipseFull,//实心椭圆
//TCBDrawingShapeRectFull,//实心矩形
- (void)pathLineToPoint:(CGPoint)movePoint WithType:(TCBDrawingShapeType)shapeType {
    //判断绘图类型
    _shapType = shapeType;
    switch (shapeType) {
        case TCBDrawingShapeCurve:
            [self.bezierPath addLineToPoint:movePoint];
            break;
        case TCBDrawingShapeLine:
            self.bezierPath = [UIBezierPath bezierPath];
            self.bezierPath.lineCapStyle = kCGLineCapRound;
            self.bezierPath.lineJoinStyle = kCGLineJoinRound;
            self.bezierPath.lineWidth = self.pathWidth;
            [self.bezierPath moveToPoint:self.beginPoint];
            [self.bezierPath addLineToPoint:movePoint];
            break;
        case TCBDrawingShapeRect:
            [self shapeRect:movePoint];
            break;
        case TCBDrawingShapeEllipse:
            [self shapeEllipse:movePoint];
            break;
        case TCBDrawingShapeRectFull:
            [self shapeRect:movePoint];
            break;
        case TCBDrawingShapeEllipseFull:
            [self shapeEllipse:movePoint];
            break;
        default:
            break;
    }
}

- (void)shapeRect:(CGPoint)movePoint {
    self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
    self.bezierPath.lineCapStyle = kCGLineCapRound;
    self.bezierPath.lineJoinStyle = kCGLineJoinRound;
    self.bezierPath.lineWidth = self.pathWidth;
}
- (void)shapeEllipse:(CGPoint)movePoint {
    self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:[self getRectWithStartPoint:self.beginPoint endPoint:movePoint]];
    self.bezierPath.lineCapStyle = kCGLineCapRound;
    self.bezierPath.lineJoinStyle = kCGLineJoinRound;
    self.bezierPath.lineWidth = self.pathWidth;
}

- (CGRect)getRectWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint orignal = startPoint;
    if (startPoint.x > endPoint.x) {
        orignal = endPoint;
    }
    CGFloat width = fabs(startPoint.x - endPoint.x);
    CGFloat height = fabs(startPoint.y - endPoint.y);
    return CGRectMake(orignal.x , orignal.y , width, height);
}

@end

@implementation TCBDrawView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)setBrush:(TCBPath *)path {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    
    shapeLayer.strokeColor = path.pathColor.CGColor;
    if (path.shapType==TCBDrawingShapeRectFull||path.shapType==TCBDrawingShapeEllipseFull) {
        shapeLayer.fillColor = path.pathColor.CGColor;
    }else {
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
    }
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = path.bezierPath.lineWidth;
    ((CAShapeLayer *)self.layer).path = path.bezierPath.CGPath;

}


@end
