//
//  SelectColorPickerView.m
//  boxasst_iosphone
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 taixin. All rights reserved.
//

#import "SelectColorPickerView.h"


@interface SelectColorPickerView ()
{
    CGFloat MY_WIDTH;
    CGFloat MY_HEIGHT;
    CGPoint MY_CENTER;
}

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *centerImageView;

@end

@implementation SelectColorPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        MY_WIDTH = frame.size.width;
        MY_HEIGHT = frame.size.height;
        MY_CENTER = CGPointMake(MY_HEIGHT * 0.5, MY_HEIGHT * 0.5);
        UIImage *centerImage = [UIImage imageNamed:@"ColorPalette.png"];
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MY_WIDTH, MY_HEIGHT)];
        self.bgImageView.image = centerImage;
        [self addSubview:self.bgImageView];
        self.centerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"point.png"]];
        self.centerImageView.bounds = CGRectMake(0, 0, 30, 30);
        self.centerImageView.center = MY_CENTER;
        [self addSubview:self.centerImageView];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat chassRadius = (MY_WIDTH - 15)*0.5;
    CGFloat absDistanceX = fabs(currentPoint.x - MY_CENTER.x);
    CGFloat absDistanceY = fabs(currentPoint.y - MY_CENTER.y);
    CGFloat currentToPointRadius = sqrtf(absDistanceX *absDistanceX + absDistanceY *absDistanceY);
    if (currentToPointRadius < chassRadius) {
        self.centerImageView.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]) {
            [self.delegate getCurrentColor:color];
        }
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat chassisRadius = (MY_WIDTH - 15)*0.5;
    CGFloat absDistanceX = (currentPoint.x - MY_CENTER.x);
    CGFloat absDistanceY = (currentPoint.y - MY_CENTER.y);
    CGFloat currentTopointRadius = sqrtf(absDistanceX * absDistanceX + absDistanceY *absDistanceY);
    if (currentTopointRadius <chassisRadius) {
        //取色
        self.centerImageView.center = currentPoint;
        UIColor *color = [self getPixelColorAtLocation:currentPoint];
        if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]){
            [self.delegate getCurrentColor:color];
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIColor *color = [self getPixelColorAtLocation:self.centerImageView.center];
    if(self.delegate && [self.delegate respondsToSelector:@selector(getCurrentColor:)]){
        [self.delegate getCurrentColor:color];
    }
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = nil;
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef inImage = viewImage.CGImage;
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }
    size_t w = self.bounds.size.width;
    size_t h = self.bounds.size.height;
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, inImage);
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        NSInteger offset = 4*((w*round(point.y))+round(point.x));
        NSInteger alpha =  data[offset];
        NSInteger red = data[offset+1];
        NSInteger green = data[offset+2];
        NSInteger blue = data[offset+3];
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    CGContextRelease(cgctx);
    if (data) { free(data); }
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    NSInteger bitmapByteCount;
    NSInteger bitmapBytesPerRow;
    size_t pixelsWide = self.bounds.size.width;
    size_t pixelsHigh = self.bounds.size.height;
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL){
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL){
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,pixelsWide,pixelsHigh,8, bitmapBytesPerRow,
                        colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL){
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    return context;
}

@end
