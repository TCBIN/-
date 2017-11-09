//
//  TCBDrawModel.h
//  VictorTu
//
//  Created by VictorTu on 15/11/9.
//  Copyright © 2015年 TCB. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TCBDrawModel : NSObject
/*
    pointList;
	private String paintColor;
	private String background;
	private int paintSize;
	private String action;  com.changebackground.doodle  com.playing.doodle
	public float width;
	public float hight;
	private String from;
	private boolean isEraser=false;
 */
@property (nonatomic, strong) NSArray * pointList;
@property (nonatomic, copy) NSString * paintColor;
@property (nonatomic, copy) NSString * background;
@property (nonatomic, copy) NSString * action;
@property (nonatomic, strong) NSNumber * paintSize;
@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSNumber * isEraser;
@property (nonatomic, strong) NSNumber * shapType;
@end
