//
//  FlickrDragIndicateLayer.m
//  FlickrPullToRefresh
//
//  Created by Chengyin on 16/3/17.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import "FlickrDragIndicateLayer.h"

@implementation FlickrDragIndicateLayer

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[FlickrDragIndicateLayer class]])
        {
            FlickrDragIndicateLayer *otherLayer = (FlickrDragIndicateLayer *)layer;
            self.progress = otherLayer.progress;
            self.fillColor = otherLayer.fillColor;
        }
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _fillColor = [UIColor colorWithRed:0.02 green:0.40 blue:0.92 alpha:1];
    }
    return self;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)display
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    float angle = self.progress * 2.0 * M_PI;
    CGFloat radius = self.bounds.size.width / 2 - 1;
    CGContextSetFillColorWithColor(ctx, _fillColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, _fillColor.CGColor);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddArc(ctx, center.x, center.y, radius, -M_PI_2, angle - M_PI_2,0);
    CGContextAddLineToPoint(ctx, center.x, center.y);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    self.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}
@end
