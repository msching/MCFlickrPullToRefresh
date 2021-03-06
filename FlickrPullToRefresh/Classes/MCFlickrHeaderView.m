//
//  MCFlickrHeaderView.m
//  MCFlickrPullToRefresh
//
//  Created by Chengyin on 16/3/17.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import "MCFlickrHeaderView.h"
#import "MCFlickrDragIndicateLayer.h"
#import "MCProgressCallbackLayer.h"

static const CGFloat avatarSize = 50;
static const CGFloat progressSize = 60;
const NSTimeInterval MCFlickrRefreshAnimationDuration = 2.5;

@interface MCFlickrHeaderView ()<MCProgressLayerCallbackDelegate>
{
@private
    CALayer *_imageLayer;
    MCFlickrDragIndicateLayer *_dragIndicateLayer;
    MCProgressCallbackLayer *_callbackLayer;
    UIActivityIndicatorView *_waitingView;
    
    BOOL _animating;
    BOOL _shouldFinishAnimation;
    BOOL _point1Checked;
    BOOL _point2Checked;
    BOOL _oneceMore;
    
    MCFlickrHeaderViewTriggerLoadBlock _loadBlock;
    MCFlickrHeaderViewLoadFinishBlock _finishBlock;
}
@property (nonatomic,assign,readonly) float progress;
@end

@implementation MCFlickrHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dragIndicateLayer = [[MCFlickrDragIndicateLayer alloc] init];
        _dragIndicateLayer.bounds = CGRectMake(0, 0, progressSize, progressSize);
        [self.layer addSublayer:_dragIndicateLayer];
        
        _imageLayer = [CALayer layer];
        _imageLayer.bounds = CGRectMake(0, 0, avatarSize, avatarSize);
        _imageLayer.zPosition = 1;
        _imageLayer.cornerRadius = avatarSize / 2;
        _imageLayer.borderWidth = 1;
        _imageLayer.borderColor = [UIColor whiteColor].CGColor;
        _imageLayer.masksToBounds = YES;
        _imageLayer.backgroundColor = [UIColor colorWithRed:0.96 green:0.12 blue:0.48 alpha:1].CGColor;
        [self.layer addSublayer:_imageLayer];
        
        _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _waitingView.layer.position = CGPointMake(avatarSize / 2, avatarSize / 2);
        [_imageLayer addSublayer:_waitingView.layer];
        
        _callbackLayer = [[MCProgressCallbackLayer alloc] init];
        _callbackLayer.callbackDelegate = self;
        _callbackLayer.frame = CGRectMake(0, -1, 1, 1);
        [self.layer addSublayer:_callbackLayer];
    }
    return self;
}

- (void)dealloc
{
    [self removeScrollViewObserver];
    _scrollView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _dragIndicateLayer.position = _imageLayer.position;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (!_animating)
    {
        _imageLayer.contents = (id)_image.CGImage;
    }
}

- (float)progress
{
    return _dragIndicateLayer.progress;
}

- (void)setTriggerLoadBlock:(MCFlickrHeaderViewTriggerLoadBlock)triggerLoadBlock
{
    _loadBlock = [triggerLoadBlock copy];
}

- (void)setLoadFinishBlock:(MCFlickrHeaderViewLoadFinishBlock)loadFinishBlock
{
    _finishBlock = [loadFinishBlock copy];
}

- (void)setFinishLoad
{
    _shouldFinishAnimation = YES;
    if (_point2Checked)
    {
        _oneceMore = YES;
    }
}

- (void)startLoadingAnimation
{
    [_dragIndicateLayer removeAllAnimations];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _dragIndicateLayer.progress = 1;
    [CATransaction commit];
    
    CGFloat offset = 40;
    
    CAKeyframeAnimation *zPosition = [CAKeyframeAnimation animation];
    zPosition.keyPath = @"zPosition";
    zPosition.values = @[@1, @-1, @-1, @1, @1, @-1, @-1, @1];
    zPosition.keyTimes = @[@(1.0/8),@(1.0/8),@(3.0/8),@(3.0/8),@(5.0/8),@(5.0/8),@(7.0/8),@(7.0/8)];
    
    CAKeyframeAnimation *scale1 = [CAKeyframeAnimation animation];
    scale1.keyPath = @"transform.scale";
    scale1.values = @[@1, @0.4, @0.6, @1];
    scale1.keyTimes = @[@0,@(1.0/2),@(3.0/4),@1];
    
    CAKeyframeAnimation *move1 = [CAKeyframeAnimation animation];
    move1.keyPath = @"position.x";
    move1.values = @[@0, @(offset), @0, @(-offset/2), @0, @(offset/2), @0, @(-offset), @0];
    move1.keyTimes = @[@0,@(1.0/8),@(1.0/4),@(3.0/8),@(1.0/2),@(5.0/8),@(3.0/4),@(7.0/8),@1];
    move1.additive = YES;
    
    CAAnimationGroup *group1 = [[CAAnimationGroup alloc] init];
    group1.animations = @[zPosition,scale1,move1];
    group1.duration = MCFlickrRefreshAnimationDuration;
    if (!_animating)
    {
        group1.timingFunction = [CAMediaTimingFunction functionWithControlPoints: 0.500000 : 0.583333 : 0.433333 : 0.383333];
    }
    
    CAKeyframeAnimation *move2 = [CAKeyframeAnimation animation];
    move2.keyPath = move1.keyPath;
    move2.values = @[@0, @(_animating ? (-offset/2) : (-offset)), @0, @(offset/2), @0, @(-offset/2), @0, @(offset/3), @0];
    move2.keyTimes = move1.keyTimes;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    move2.additive = move1.additive;
    
    CAKeyframeAnimation *scale2 = [CAKeyframeAnimation animation];
    scale2.keyPath = scale1.keyPath;
    scale2.values = @[@(_animating ? 0.6 : 1.0), @0.3, @0.6];
    scale2.keyTimes = scale1.keyTimes;
    
    CAAnimationGroup *group2 = [[CAAnimationGroup alloc] init];
    group2.animations = @[scale2,move2];
    group2.duration = group1.duration;
    group2.fillMode = kCAFillModeForwards;
    group2.removedOnCompletion = NO;
    group2.timingFunction = group1.timingFunction;
    
    CABasicAnimation *progress = [CABasicAnimation animationWithKeyPath:@"progress"];
    progress.duration = group1.duration;
    progress.fromValue = @0;
    progress.toValue = @1;
    progress.fillMode = kCAFillModeForwards;
    progress.removedOnCompletion = NO;
    progress.timingFunction = group1.timingFunction;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (_shouldFinishAnimation && !_oneceMore)
        {
            [self finishLoadingAnimation];
        }
        else
        {
            _oneceMore = NO;
            [self startLoadingAnimation];
        }
    }];
    [_imageLayer addAnimation:group1 forKey:@"loading"];
    [_dragIndicateLayer addAnimation:group2 forKey:@"loading"];
    [_callbackLayer addAnimation:progress forKey:@"progress"];
    [CATransaction commit];
    _animating = YES;
    
    _point1Checked = NO;
    _point2Checked = NO;
}

- (void)finishLoadingAnimation
{
    [_dragIndicateLayer removeFromSuperlayer];
    [_dragIndicateLayer removeAllAnimations];
    _dragIndicateLayer.progress = 0;
    [_dragIndicateLayer setNeedsDisplay];
    [_dragIndicateLayer displayIfNeeded];
    [_dragIndicateLayer setValue:@(1) forKeyPath:@"transform.scale"];
    [_callbackLayer removeAllAnimations];
    _callbackLayer.progress = 0;
    _animating = NO;
    _shouldFinishAnimation = NO;
    if (_finishBlock)
    {
        _finishBlock();
    }
}

- (void)progressUpdatedTo:(float)progress
{
    if (!_point1Checked && progress > 0.24)
    {
        [self stepPoint1];
    }
    
    if (!_point2Checked && progress > 0.74)
    {
        [self stepPoint2];
    }
}

- (void)stepPoint1
{
    _point1Checked = YES;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageLayer.contents = nil;
    [_waitingView startAnimating];
    [CATransaction commit];
}

- (void)stepPoint2
{
    _point2Checked = YES;
    if (_shouldFinishAnimation)
    {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _imageLayer.contents = (id)_image.CGImage;
        [_waitingView stopAnimating];
        [CATransaction commit];
    }
}

#pragma mark - scrollview
- (void)removeScrollViewObserver
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollView removeObserver:self forKeyPath:@"pan.state"];
}

- (void)addScrollViewObserver
{
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView)
    {
        [self removeScrollViewObserver];
    }
    _scrollView = scrollView;
    [self addScrollViewObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == _scrollView)
    {
        if ([keyPath isEqualToString:@"contentOffset"])
        {
            if (!_dragIndicateLayer.superlayer)
            {
                [self.layer addSublayer:_dragIndicateLayer];
            }
            NSValue *value = change[NSKeyValueChangeNewKey];
            CGPoint contentOffset = [value CGPointValue];
            CGFloat offset = contentOffset.y + _scrollView.contentInset.top;
            if (offset <= 0.0 && !_animating)
            {
                CGFloat startLoadingThreshold = 60.0;
                CGFloat fractionDragged = -offset/startLoadingThreshold;
                _dragIndicateLayer.progress = MIN(MAX(0.0, fractionDragged),1);
            }
        }
        else if ([keyPath isEqualToString:@"pan.state"])
        {
            NSNumber *number = change[NSKeyValueChangeNewKey];
            UIGestureRecognizerState state = [number integerValue];
            if (_dragIndicateLayer.progress >= 1.0 && state == UIGestureRecognizerStateEnded)
            {
                if (!_animating && _loadBlock)
                {
                    if (_loadBlock())
                    {
                        [self startLoadingAnimation];
                    }
                }
            }
        }
    }
}
@end
