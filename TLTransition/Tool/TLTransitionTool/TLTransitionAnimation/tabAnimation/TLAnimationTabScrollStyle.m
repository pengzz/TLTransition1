//
//  TLAnimationTabScrollStyle.m
//  zhuanchang
//
//  Created by Mac on 2019/2/1.
//  Copyright © 2019年 tanglei. All rights reserved.
//

#define TLTransitionTime 0.5

#import "TLAnimationTabScrollStyle.h"
#import "UIViewController+TLTransition.h"

@implementation TLAnimationTabScrollStyle


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return TLTransitionTime;
}

- (void)animateTransition_old:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UINavigationController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UINavigationController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromV = fromVc.view;
    UIView *toV = toVc.view;
    
    
    // 转场环境
    UIView *containView = [transitionContext containerView];
    
    if (toVc.index > fromVc.index) {
        
        toV.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, containView.frame.size.width, containView.frame.size.height);
        
        [containView addSubview:toV];
        // 动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromV.transform = CGAffineTransformTranslate(fromV.transform, -[UIScreen mainScreen].bounds.size.width,0);
            toV.transform = CGAffineTransformTranslate(toV.transform, -[UIScreen mainScreen].bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
        
        
    }else if (toVc.index < fromVc.index) {
        
        toV.frame = CGRectMake(- [UIScreen mainScreen].bounds.size.width, 0, containView.frame.size.width, containView.frame.size.height);
        
        [containView addSubview:toV];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromV.transform = CGAffineTransformTranslate(fromV.transform, [UIScreen mainScreen].bounds.size.width,0);
            toV.transform = CGAffineTransformTranslate(toV.transform, [UIScreen mainScreen].bounds.size.width, 0);
            
        } completion:^(BOOL finished) {
            
            [fromV removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

#if DEBUG
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
//    UINavigationController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UINavigationController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    UIView *fromV = fromVc.view;
//    UIView *toV = toVc.view;
//
//
//    // 转场环境
//    UIView *containView = [transitionContext containerView];
//
//    if (toVc.index > fromVc.index) {
//
//        toV.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, containView.frame.size.width, containView.frame.size.height);
//
//        [containView addSubview:toV];
//        // 动画
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//
//            fromV.transform = CGAffineTransformTranslate(fromV.transform, -[UIScreen mainScreen].bounds.size.width,0);
//            toV.transform = CGAffineTransformTranslate(toV.transform, -[UIScreen mainScreen].bounds.size.width, 0);
//
//        } completion:^(BOOL finished) {
//
//            [transitionContext completeTransition:YES];
//        }];
//
//
//    }else if (toVc.index < fromVc.index) {
//
//        toV.frame = CGRectMake(- [UIScreen mainScreen].bounds.size.width, 0, containView.frame.size.width, containView.frame.size.height);
//
//        [containView addSubview:toV];
//
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//
//            fromV.transform = CGAffineTransformTranslate(fromV.transform, [UIScreen mainScreen].bounds.size.width,0);
//            toV.transform = CGAffineTransformTranslate(toV.transform, [UIScreen mainScreen].bounds.size.width, 0);
//
//        } completion:^(BOOL finished) {
//
//            [fromV removeFromSuperview];
//            [transitionContext completeTransition:YES];
//        }];
//    }
    
    
    UINavigationController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGVector offset;
    if (toViewController.index > fromViewController.index) {
//    if (self.targetEdge == UIRectEdgeLeft){
        offset = CGVectorMake(-1.f, 0.f);
    }
//    else if (self.targetEdge == UIRectEdgeRight){
    else if (toViewController.index < fromViewController.index) {
        offset = CGVectorMake(1.f, 0.f);
    }
    else{
        NSAssert(NO, @"targetEdge must be one of UIRectEdgeLeft, or UIRectEdgeRight.");
    }
    
    fromView.frame = fromFrame;
    toView.frame = CGRectOffset(toFrame,
                                toFrame.size.width * offset.dx * -1,
                                toFrame.size.height * offset.dy * -1);
    
    [transitionContext.containerView addSubview:toView];
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.frame = CGRectOffset(fromFrame,
                                      fromFrame.size.width * offset.dx,
                                      fromFrame.size.height * offset.dy);
        toView.frame = toFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
#endif

@end
