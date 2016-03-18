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

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign,readonly) float progress;
@property (nonatomic,weak) UIScrollView *scrollView;

- (void)setTriggerLoadBlock:(FlickrHeaderViewTriggerLoadBlock)triggerLoadBlock;
- (void)setLoadFinishBlock:(FlickrHeaderViewLoadFinishBlock)loadFinishBlock;
- (void)setFinishLoad;
@end
