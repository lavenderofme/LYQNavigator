//
//  LYQViewController.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQViewController.h"

@interface LYQViewController () <UIGestureRecognizerDelegate>

@end

@implementation LYQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationItem setLeftBarButtonItem:[self backBarButtonItem]]; // 设置返回按钮图片
    }
}

+ (BOOL)isSingleton
{
    return NO;
}

+ (BOOL)isModalView
{
    return NO;
}

- (BOOL)canSlideBack {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(gestureBackToPreviousViewController:)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.interactivePopGestureRecognizer removeTarget:self action:@selector(gestureBackToPreviousViewController:)];
}

- (UIBarButtonItem *)backBarButtonItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *backImage = @"xbl_back";
    UIImage *image = [UIImage imageNamed:backImage];
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, MAX(30, image.size.width), 44);// 放大点击区
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(backToPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        return nil;
    }
}

- (void)gestureBackToPreviousViewController:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat translationDistance = [gesture translationInView:self.view].x;
        if (translationDistance >= [UIScreen mainScreen].bounds.size.width / 2) {
            [self.navigationController.interactivePopGestureRecognizer removeTarget:self action:@selector(gestureBackToPreviousViewController:)];
            self.isGestureBack = YES;
            [self backToPreviousViewController];
        }
    }
}

- (BOOL)handleWithURLAction:(LYQURLAction *)urlAction {
    self.urlAction = urlAction;
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self canSlideBack];
}

@end
