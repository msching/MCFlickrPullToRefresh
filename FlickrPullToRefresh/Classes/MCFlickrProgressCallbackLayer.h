//
//  MCFlickrProgressCallbackLayer.h
//  MCFlickrPullToRefresh
//
//  Created by Chengyin on 16/3/21.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol MCFlickrProgressCallbackDelegate <NSObject>
- (void)progressUpdatedTo:(float)progress;
@end


@interface MCFlickrProgressCallbackLayer : CALayer

@property (nonatomic,assign) float progress;
@property (nonatomic,weak) id<MCFlickrProgressCallbackDelegate> callbackDelegate;

@end
