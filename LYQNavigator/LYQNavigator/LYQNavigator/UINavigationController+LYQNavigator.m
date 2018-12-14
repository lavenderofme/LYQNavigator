//
//  UINavigationController+LYQNavigator.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "UINavigationController+LYQNavigator.h"
#import "LYQURLMapping.h"
#import "LYQNavigatorViewControllerProtocal.h"
#import "UIViewController+LYQNavigator.h"
#import "NSArray+XBLFunctional.h"

@implementation UINavigationController (LYQNavigator)

- (void)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller{
    if (!urlString.length) {
        return;
    }
    [self openURLAction:[[LYQURLAction alloc] initWithUrlString:urlString]  fromViewController:controller];
}

- (void)openURL:(NSURL *)url fromViewController:(UIViewController *)controller{
    if (!url) {
        return;
    }
    [self openURLAction:[[LYQURLAction alloc] initWithUrl:url] fromViewController:controller];
}

- (void)openURLAction:(LYQURLAction *)urlAction fromViewController:(UIViewController *)controller {
    UIViewController *viewController = [self getTargetViewController:urlAction];
    if (!viewController) {
        return;
    }
    viewController.urlAction = urlAction;
    if ([viewController respondsToSelector:@selector(handleWithURLAction:)]) {
        if (![((id<LYQNavigatorViewControllerProtocal>)viewController) handleWithURLAction:urlAction]) {
            // handleWithURLAction returns NO
            return;
        }
    }
    
    BOOL isSingleton = NO;
    if ([[viewController class] respondsToSelector:@selector(isSingleton)]) {
        isSingleton = [[viewController class] isSingleton];
    }
    
    BOOL isModalView = NO;
    if ([[viewController class] respondsToSelector:@selector(isModalView)]) {
        isModalView = [[viewController class] isModalView];
    }
    
    if (isModalView) {
        [self presentViewController:viewController animated:YES completion:nil];
    } else if (isSingleton) {
        [self pushSingletonViewController:viewController withURLAction:urlAction];
    } else {
        [self pushViewController:viewController animated:YES];
    }
}

- (void)pushSingletonViewController:(UIViewController *)controller withURLAction:(LYQURLAction *)urlAction {
    if (!controller) {
        return;
    }
    
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];
    if ([controllers xblf_existObjectMatch:^BOOL(UIViewController *obj) {
        return (obj == controller);
    }]) {
        if (controller != [controllers lastObject]) {
            //the bottom one is always HomeMainViewController, can't be removed
            while (controllers.count > 1) {
                [controllers removeLastObject];
                if(controller == [controllers lastObject]){
                    break;
                }
            }
            
            [self setViewControllers:controllers animated:NO];
            //[self pushViewController:controller withURLAction:urlAction];
        }
        else {
            [controller viewWillAppear:NO];
            [controller viewDidAppear:NO];
            
        }
    } else {
        [self pushViewController:controller animated:YES];
    }
}


- (UIViewController *)getTargetViewController:(LYQURLAction *)urlAction {
    if (!urlAction || !urlAction.url || !urlAction.url.scheme.length || !urlAction.url.host.length) {
        return nil;
    }
    Class class = [[LYQURLMapping instance] obtainControllerWithHost:urlAction.url.host];
    if (!class) {
        return nil;
    }
    if ([class respondsToSelector:@selector(isSingleton)] && [class isSingleton]) {
        UIViewController *controller = [self.viewControllers xblf_match:^BOOL(UIViewController *controller) {
            return [controller isKindOfClass:class];
        }];
        return controller ?: [class new];
    }
    return [class new];
}

- (BOOL)pop2Scheme:(NSString *)scheme {
    if (scheme.length) {
        return [self pop2AnyScheme:@[scheme]];
    }
    return NO;
}

- (BOOL)pop2AnyScheme:(NSArray *)schemeArray
{
    if (schemeArray.count == 0) {
        return NO;
    }
    
    for (NSInteger i = self.viewControllers.count - 1; i >= 0; i--) {
        for (NSString *scheme in schemeArray) {
            Class class = [[LYQURLMapping instance] obtainControllerWithHost:scheme];
            if (class == nil) {
                return NO;
            }
            if ([self.viewControllers[i] isKindOfClass:class]) {
                [self popToViewController:self.viewControllers[i] animated:YES];
                return YES;
            }
            
        }
    }
    return NO;
}


@end
