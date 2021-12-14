//
//  TLTabTransitionDelegate.m
//  TLTransition
//
//  Created by hello on 2019/4/12.
//  Copyright © 2019 tanglei. All rights reserved.
//

#import "TLTabTransitionDelegate.h"
#import "TLAnimationTabScrollStyle.h"
//
//#import "TransitionController.h"
//#import "TransitionAnimation.h"


@interface TLTabTransitionDelegate ()

#pragma mark -  pan
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

#pragma mark - TransitionController
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, readwrite) CGPoint initialTranslationInContainerView;

@end


@implementation TLTabTransitionDelegate

+ (instancetype)shareInstance{
    
    static TLTabTransitionDelegate *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [TLTabTransitionDelegate new];
    });
    return _instance;
}

// setter
- (void)setTabBarController:(UITabBarController *)tabBarController {
    _tabBarController = tabBarController;
    [self addPanGestureForViewController:tabBarController];
}

#if DEBUG // 或者使用这样
#pragma mark 是否识别多手势

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return YES;
//}

// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 根viewContrller才可以滑动tab
    if (self.tabBarController.selectedViewController.navigationController.topViewController != self.tabBarController.selectedViewController.navigationController.viewControllers[0]) {
        return NO;
    } else {
        if (self.tabBarController.selectedViewController.navigationController.topViewController) {
            
        }
        
        
        return YES;
    }
    //
    return YES;
}
#endif

#pragma mark - 系统手势
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
#if DEBUG
    pan.delegate = (id<UIGestureRecognizerDelegate>) self;
#endif
    self.panGestureRecognizer = pan;
    [viewController.view addGestureRecognizer:pan];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    if (self.tabBarController.transitionCoordinator) {
        return;
    }

    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged){
        [self beginInteractiveTransitionIfPossible:pan];
    }
    
    // zz直接放这个方法里面任何位置都不行X
    //[self gestureRecognizeDidUpdate:pan];
}

- (void)beginInteractiveTransitionIfPossible:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.tabBarController.view];
    if (translation.x > 0.f && self.tabBarController.selectedIndex > 0) {
        self.tabBarController.selectedIndex --;
    }
    else if (translation.x < 0.f && self.tabBarController.selectedIndex + 1 < self.tabBarController.viewControllers.count) {
        self.tabBarController.selectedIndex ++;
    }
}


#pragma mark -

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (self.animationControllerForTransition_shouldCheckBeganAndChange == NO) {
        //NSArray *viewControllers = tabBarController.viewControllers;
        //if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        //    return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
        //}
        //else {
        //    return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
        //}
        return [TLAnimationTabScrollStyle new];
    }
    
    // 打开注释 可以屏蔽点击item时的动画效果
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        //NSArray *viewControllers = tabBarController.viewControllers;
        //if ([viewControllers indexOfObject:toVC] > [viewControllers indexOfObject:fromVC]) {
        //    return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeLeft];
        //}
        //else {
        //    return [[TransitionAnimation alloc] initWithTargetEdge:UIRectEdgeRight];
        //}
        return [TLAnimationTabScrollStyle new];
    }
    else{
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                      interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController API_AVAILABLE(ios(7.0))
{
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan || self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) { // isInteraction
        [self.panGestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
        [self.panGestureRecognizer addTarget:self action:@selector(gestureRecognizeDidUpdate:)];
        return self;
        //return [[TransitionController alloc] initWithGestureRecognizer:self.panGestureRecognizer];
    }
    else {
        return nil;
    }
    return nil;
}


#pragma mark -
#pragma mark - TransitionController

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    self.initialTranslationInContainerView = [self.panGestureRecognizer translationInView:transitionContext.containerView];
    [super startInteractiveTransition:transitionContext];
}

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture{
    UIView *transitionContainerView = self.transitionContext.containerView;
    CGPoint translation = [gesture translationInView:gesture.view.superview];
    if ((translation.x > 0.f && self.initialTranslationInContainerView.x < 0.f) ||
        (translation.x < 0.f && self.initialTranslationInContainerView.x > 0.f)){
        return -1.f;
    }
    return fabs(translation.x)/CGRectGetWidth(transitionContainerView.bounds);
}

- (void)gestureRecognizeDidUpdate:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            if ([self percentForGesture:gestureRecognizer] < 0.f) {
                [self cancelInteractiveTransition];
                [self.panGestureRecognizer removeTarget:self action:@selector(gestureRecognizeDidUpdate:)];
            }
            else {
                [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self percentForGesture:gestureRecognizer] >= 0.4f){
                [self finishInteractiveTransition];
            }
            else{
                [self cancelInteractiveTransition];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

@end
