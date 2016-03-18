//
//  FlickrHeaderView.h
//  FlickrPullToRefresh
//
//  Created by Chengyin on 16/3/17.
//  Copyright © 2016年 Chengyin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^FlickrHeaderViewTriggerLoadBlock)(void);
typedef void (^FlickrHeaderViewLoadFinishBlock)(void);
FOUNDATION_EXTERN const NSTimeInterval FlickrRefreshAnimationDuration;

@interface FlickrHeaderView : UIView

/**
 *  avatar image
 */
@property (nonatomic,strong) UIImage *image;

/**
 *  binded scrollview.
 */
@property (nonatomic,weak) UIScrollView *scrollView;

/**
 *  callback when animation is about to start
 *
 *  @param triggerLoadBlock callback, return YES if animation should start, NO if should not.
 */
- (void)setTriggerLoadBlock:(FlickrHeaderViewTriggerLoadBlock)triggerLoadBlock;

/**
 *  callback when animation finished. (after -setFinishLoad is called)
 *
 *  @param loadFinishBlock callback.
 */
- (void)setLoadFinishBlock:(FlickrHeaderViewLoadFinishBlock)loadFinishBlock;

/**
 *  should call when loading data finished. After calling this function, the animation will end after finish current loop.
 */
- (void)setFinishLoad;
@end
