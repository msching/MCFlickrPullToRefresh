//
//  FlickrProgressCallbackLayer.m
//  FlickrPullToRefresh
//
//  Created by Chengyin on 16/3/21.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import "FlickrProgressCallbackLayer.h"

@implementation FlickrProgressCallbackLayer
- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[FlickrProgressCallbackLayer class]])
        {
            FlickrProgressCallbackLayer *otherLayer = (FlickrProgressCallbackLayer *)layer;
            self.progress = otherLayer.progress;
            self.callbackDelegate = otherLayer.callbackDelegate;
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString*)key
{
    if ([key isEqualToString:@"progress"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.callbackDelegate)
    {
        [self.callbackDelegate progressUpdatedTo:self.progress];
    }
}
@end
