//
//  TLTabTransitionDelegate.h
//  TLTransition
//
//  Created by hello on 2019/4/12.
//  Copyright © 2019 tanglei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//UITabBarController *tab;
//tab.delegate = [TLTabTransitionDelegate shareInstance];
@interface TLTabTransitionDelegate : UIPercentDrivenInteractiveTransition<UITabBarControllerDelegate>

+ (instancetype)shareInstance;

#if DEBUG
@property (nonatomic ,weak)UITabBarController *tabBarController;


#pragma mark - should
/// 可以屏蔽点击item时的动画效果
@property (nonatomic, assign) BOOL animationControllerForTransition_shouldCheckBeganAndChange;

#endif

@end

NS_ASSUME_NONNULL_END
