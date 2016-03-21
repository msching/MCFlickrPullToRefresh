//
//  FlickrProgressCallbackLayer.h
//  FlickrPullToRefresh
//
//  Created by Chengyin on 16/3/21.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol FlickrProgressCallbackDelegate <NSObject>
- (void)progressUpdatedTo:(float)progress;
@end


@interface FlickrProgressCallbackLayer : CALayer

@property (nonatomic,assign) float progress;
@property (nonatomic,weak) id<FlickrProgressCallbackDelegate> callbackDelegate;

@end
