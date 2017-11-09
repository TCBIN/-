//
//  ViewController.m
//  TCB画板
//
//  Created by WebUser on 2017/10/31.
//  Copyright © 2017年 yswl. All rights reserved.
//
#pragma mark - 屏幕尺寸
#define kScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ThumbnailPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"HBThumbnail"]

#import "ViewController.h"
#import "DesignEditView.h"
#import "TCBDrawingBoard.h"

@interface ViewController ()

@property(nonatomic, strong) TCBDrawingBoard *drawBoard;
@property(nonatomic, strong) DesignEditView *editView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.editView];
    [self.view addSubview:self.drawBoard];
    self.drawBoard.editDraw = self.editView;
}

- (DesignEditView *)editView
{
    if (!_editView) {
        _editView = [[DesignEditView alloc] initWithFrame:CGRectMake(0, kScreenHeight-240, kScreenWidth, 200)];
    }
    return _editView;
}
- (TCBDrawingBoard *)drawBoard
{
    if (!_drawBoard) {
        _drawBoard = [[TCBDrawingBoard alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenWidth)];
    }
    return _drawBoard;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
