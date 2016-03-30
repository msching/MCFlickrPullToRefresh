//
//  MCFlickrDragIndicateLayer.h
//  MCFlickrPullToRefresh
//
//  Created by Chengyin on 16/3/17.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface MCFlickrDragIndicateLayer : CALayer

@property (nonatomic,assign) float progress;
@property (nonatomic,strong) UIColor *fillColor;

@end
