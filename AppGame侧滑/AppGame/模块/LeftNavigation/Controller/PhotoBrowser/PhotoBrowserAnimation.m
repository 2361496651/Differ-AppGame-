//
//  PhotoBrowserAnimation.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "PhotoBrowserAnimation.h"

@implementation PhotoBrowserAnimation




- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}



//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    
//}
//
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
//{
//    
//}
//
//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0)
//{
//    
//}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.isPresented ? [self animationForPresentedView:transitionContext] : [self animationForDismissView:transitionContext];
}

- (void)animationForPresentedView:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:presentedView];
    
    CGRect startRect = [self.presentedDelegate startRect:self.indexPath];
    UIImageView *imageView = [self.presentedDelegate imageView:self.indexPath];
    [transitionContext.containerView addSubview:imageView];
    imageView.frame = startRect;
    
    presentedView.alpha = 0.0;
    transitionContext.containerView.backgroundColor = [UIColor blackColor];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = [self.presentedDelegate endRect:self.indexPath];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        presentedView.alpha = 1.0;
        transitionContext.containerView.backgroundColor = [UIColor clearColor];
        [transitionContext completeTransition:YES];
    }];
    
    
}
- (void)animationForDismissView:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [dismissView removeFromSuperview];
    
    
    UIImageView *imageView = [self.dismissDelegate imageViewForDismissView];
    [transitionContext.containerView addSubview:imageView];
    
    NSIndexPath *indexPath = [self.dismissDelegate indexPathForDismissView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageView.frame = [self.presentedDelegate startRect:indexPath];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}










@end
