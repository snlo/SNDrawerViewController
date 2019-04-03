//
//  SNDrawerViewController.h
//  DrawerTest
//
//  Created by snloveydus on 16/1/4.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SNDrawerViewState) {
    SNDrawerViewStateNone,          //默认，尚未开起抽屉的状态
    SNDrawerViewStateLeftOpening,   //左抽屉开起状态
    SNDrawerViewStateRightOpening   //右抽屉开起状态
};

@interface SNDrawerViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *mainViewController;
@property (nonatomic, strong, readonly) UIViewController *leftViewController;
@property (nonatomic, strong, readonly) UIViewController *rightViewController;

/**
 抽屉的宽，默认是当前屏幕的宽的0.8倍
 */
@property (nonatomic, assign) CGFloat drawerWidth;

/**
 抽屉打开状态下，主页的起始坐标的高度
 */
@property (nonatomic, assign) CGFloat mainYOfOpeningDrawer;

/**
 主页蒙版透明度，默认值为0.1f
 */
@property (nonatomic, assign) CGFloat maskAlpha;

/**
 左右抽屉透明度，默认值为0.1f。
 */
@property (nonatomic, assign) CGFloat drawerAlpha;

/**
 抽屉缩放比例。0 ~ 1,
 */
@property (nonatomic, assign) CGFloat drawerScale;

/**
 主页阴影，默认值为1.0f，当maskAlpha被修改后默认值为0.0f
 */
@property (nonatomic, assign) CGFloat mainShadowOpacity;

/**
 抽屉开起状态。
 */
@property (nonatomic, assign) SNDrawerViewState drawerState;

/**
 屏幕边缘手势，用于打开左右抽屉。
 */
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureOfOpeningLeftDrawer;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureOfOpeningRightDrawer;

/**
 左右抽屉拖拽手势，用于打开左右抽屉，加载在viewcontroller上的。
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureOfOpeningLeftDrawer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureOfOpeningRightDrawer;


/**
 左右抽屉初始化
 
 @param mainViewController 主视图控制器
 @param leftViewController 左抽屉控制器
 @param rightViewController 右抽屉控制器
 @return SNDrawerViewController
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;

/**
 左抽屉初始化
 
 @param mainViewController 主视图控制器
 @param leftViewController 左抽屉控制器
 @return SNDrawerViewController
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController;

/**
 右抽屉控制器
 
 @param mainViewController 主视图控制器
 @param rightViewController 右抽屉控制器
 @return SNDrawerViewController
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController rightViewController:(UIViewController *)rightViewController;

/**
 快速打开左抽屉捷径
 */
- (void)openLeftDrawer;

/**
 快速打开右抽屉捷径
 */
- (void)openRightDrawer;

/**
 快速关闭左抽屉捷径
 */
- (void)closeLeftDrawer;

/**
 快速关闭右抽屉捷径
 */
- (void)closeRightDrawer;

@end
