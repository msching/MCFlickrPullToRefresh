//
//  MCProgressCallbackLayer.h
//
//  Created by Chengyin on 16/3/21.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol MCProgressLayerCallbackDelegate <NSObject>
- (void)progressUpdatedTo:(float)progress;
@end


@interface MCProgressCallbackLayer : CALayer

@property (nonatomic,assign) float progress;
@property (nonatomic,weak) id<MCProgressLayerCallbackDelegate> callbackDelegate;

@end
