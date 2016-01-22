//
//  SNDrawerViewController.m
//  DrawerTest
//
//  Created by snloveydus on 16/1/4.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import "SNDrawerViewController.h"

@interface SNDrawerViewController ()

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureOfOpeningLeftDrawer;
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureOfOpeningRightDrawer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureOfOpeningLeftDrawer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureOfOpeningRightDrawer;

@property (nonatomic, strong) UIView *maskView;

/**
 *  是否应该打开抽屉，当用户的手指一开始向左的时候，不应该再响应手势的任何状态了
 */
@property (nonatomic, assign) BOOL shouldBeginOpenning;

- (void)handleDrawerForLeft:(BOOL)isLeft open:(BOOL)isOpen;
- (void)initializeAppearance;
/**
 *  线性插值
 *
 *  @param from    起始值
 *  @param to      结束值
 *  @param percent 另一个变量当前变化值占总可变值的百分比
 *
 *  @return 插值结果
 */
- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent;
@end

static const CGFloat leftScale_ = 0.8f;
static const CGFloat damping_ = 1.f;
static const CGFloat duration_ = 0.4f;
static const CGFloat velocity_ = 10.f;

@implementation SNDrawerViewController
#pragma mark --intilate
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController {
	self = [super init];
	if (self) {
		self.mainViewController = mainViewController;
		self.leftViewController = leftViewController;
		self.rightViewController = rightViewController;
	}
	return self;
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController {
	return [self initWithMainViewController:mainViewController leftViewController:leftViewController rightViewController:nil];
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController rightViewController:(UIViewController *)rightViewController {
	return [self initWithMainViewController:mainViewController leftViewController:nil rightViewController:rightViewController];
}
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor blueColor];
	[self initializeAppearance];
}
#pragma mark -- private methods
- (void)initializeAppearance {
	//加载左抽屉
	if (self.leftViewController) {
		[self.view addGestureRecognizer:self.gestureOfOpeningLeftDrawer];
		[self addChildViewController:self.leftViewController];
		[self.leftViewController didMoveToParentViewController:self];
		self.leftViewController.view.transform = CGAffineTransformMakeScale(leftScale_, leftScale_);
	}
	//加载右抽屉
	if (self.rightViewController) {
		[self.view addGestureRecognizer:self.gestureOfOpeningRightDrawer];
		[self addChildViewController:self.rightViewController];
		[self.rightViewController didMoveToParentViewController:self];
		self.rightViewController.view.transform = CGAffineTransformMakeScale(leftScale_, leftScale_);
	}
	//加载主控制器
	[self addChildViewController:self.mainViewController];
	[self.view addSubview:self.mainViewController.view];
	self.mainViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
	self.mainViewController.view.layer.shadowRadius = 10;
	[self.mainViewController didMoveToParentViewController:self];
}

- (void)handleDrawerForLeft:(BOOL)isLeft open:(BOOL)isOpen {
	CGRect frame = CGRectZero;
	CGFloat scale;
	CGFloat maskAlpha;
	CGFloat drawerAlpha;
	CGFloat mainShadowOpacity;
	void (^completionBlock)(BOOL) = nil;
	if (isLeft && isOpen) {
		//打开左抽屉
		[self.view insertSubview:self.leftViewController.view belowSubview:self.mainViewController.view];
		[self.leftViewController.view addGestureRecognizer:self.panGestureOfOpeningLeftDrawer];
		[self.mainViewController.view addSubview:self.maskView];
		frame = CGRectMake(self.drawerWidth, self.mainYOfOpeningDrawer, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 2*self.mainYOfOpeningDrawer);
		scale = 1;
		maskAlpha = self.maskAlpha;
		drawerAlpha = 1;
		mainShadowOpacity = self.mainShadowOpacity;
		[self.view removeGestureRecognizer:self.gestureOfOpeningLeftDrawer];
		if (self.rightViewController) {
			[self.view removeGestureRecognizer:self.gestureOfOpeningRightDrawer];
		}
	} else if (isLeft && !isOpen) {
		//关闭左抽屉
		frame = self.view.bounds;
		scale = leftScale_;
		maskAlpha = 0;
		drawerAlpha = self.maskAlpha;
		mainShadowOpacity = 0;
		completionBlock = ^(BOOL flag) {
			[self.leftViewController.view removeGestureRecognizer:self.panGestureOfOpeningLeftDrawer];
			[self.leftViewController.view removeFromSuperview];
			[self.maskView removeFromSuperview];
			[self.view addGestureRecognizer:self.gestureOfOpeningLeftDrawer];
			if (self.rightViewController) {
				[self.view addGestureRecognizer:self.gestureOfOpeningRightDrawer];
			}
		};
	} else if (!isLeft && isOpen) {
		//打开右抽屉
		[self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
		[self.rightViewController.view addGestureRecognizer:self.panGestureOfOpeningRightDrawer];
		[self.mainViewController.view addSubview:self.maskView];
		[self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
		[self.mainViewController.view addSubview:self.maskView];
		frame = CGRectMake(-self.drawerWidth, self.mainYOfOpeningDrawer, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 2*self.mainYOfOpeningDrawer);
		scale = 1;
		maskAlpha = self.maskAlpha;
		drawerAlpha = 1;
		mainShadowOpacity = self.mainShadowOpacity;
		[self.view removeGestureRecognizer:self.gestureOfOpeningRightDrawer];
		if (self.leftViewController) {
			[self.view removeGestureRecognizer:self.gestureOfOpeningLeftDrawer];
		}
	} else {
		//关闭右抽屉
		frame = self.view.bounds;
		scale = leftScale_;
		maskAlpha = 0;
		drawerAlpha = self.maskAlpha;
		mainShadowOpacity = 0;
		completionBlock = ^(BOOL flag) {
			[self.rightViewController.view removeGestureRecognizer:self.panGestureOfOpeningRightDrawer];
			[self.rightViewController.view removeFromSuperview];
			[self.maskView removeFromSuperview];
			[self.view addGestureRecognizer:self.gestureOfOpeningRightDrawer];
			if (self.leftViewController) {
				[self.view addGestureRecognizer:self.gestureOfOpeningLeftDrawer];
			}
		};
	}
	[UIView animateWithDuration:duration_ delay:0 usingSpringWithDamping:damping_ initialSpringVelocity:velocity_ options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainViewController.view.frame = frame;
		self.mainViewController.view.layer.shadowOpacity = mainShadowOpacity;
		self.maskView.frame = self.mainViewController.view.bounds;
		if (isLeft) {
			self.leftViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
			self.leftViewController.view.alpha = drawerAlpha;
		} else {
			self.rightViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
			self.rightViewController.view.alpha = drawerAlpha;
		}
		self.maskView.alpha = maskAlpha;
	} completion:completionBlock];
}

- (CGFloat)interpolateFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
	return from + (to - from) * percent;
}
#pragma mark -- interface methods
- (void)openLeftDrawer {
	[self handleDrawerForLeft:YES open:YES];
}
- (void)closeLeftDrawer {
	[self handleDrawerForLeft:YES open:NO];
}

- (void)openRightDrawer {
	[self handleDrawerForLeft:NO open:YES];
}
- (void)closeRightDrawer {
	[self handleDrawerForLeft:NO open:NO];
}

#pragma mark -- callblock / action
- (void)responsToGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
	
	if (gesture.edges == UIRectEdgeLeft) {
		if (gesture.state == UIGestureRecognizerStateBegan) {
			[self.view insertSubview:self.leftViewController.view belowSubview:self.mainViewController.view];
			[self.mainViewController.view addSubview:self.maskView];
		} else if (gesture.state == UIGestureRecognizerStateChanged) {
			CGPoint translation = [gesture translationInView:gesture.view];
			if (translation.x > 0) {
				CGFloat percent = translation.x / 250.f;
				if (percent > 1) {
					percent = 1;
				}
				CGFloat scale = [self interpolateFrom:leftScale_ to:1 percent:percent];
				CGFloat x = [self interpolateFrom:0 to:self.drawerWidth percent:percent];
				CGFloat y = [self interpolateFrom:0 to:self.mainYOfOpeningDrawer percent:percent];
				CGFloat heigh = [self interpolateFrom:CGRectGetHeight(self.view.bounds) to:CGRectGetHeight(self.view.bounds)-2*self.mainYOfOpeningDrawer percent:percent];
				CGFloat maskAlpha = [self interpolateFrom:0 to:self.maskAlpha percent:percent];
				CGFloat drawerViewAlpha = [self interpolateFrom:self.maskAlpha to:1 percent:percent];
				CGFloat mainShadowOpacity = [self interpolateFrom:0 to:self.mainShadowOpacity percent:percent];
				self.leftViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
				self.leftViewController.view.alpha = drawerViewAlpha;
				self.mainViewController.view.frame = CGRectMake(x, y, CGRectGetWidth(self.view.bounds), heigh);
				self.mainViewController.view.layer.shadowOpacity = mainShadowOpacity;
				self.maskView.alpha = maskAlpha;
				self.maskView.frame = self.mainViewController.view.bounds;
			}
		} else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
			CGPoint velocity = [gesture velocityInView:gesture.view];
			if (velocity.x > 0) {
				[self openLeftDrawer];
			} else {
				[self closeLeftDrawer];
			}
		}
		
	} else if (gesture.edges == UIRectEdgeRight) {
		if (gesture.state == UIGestureRecognizerStateBegan) {
			[self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
			[self.mainViewController.view addSubview:self.maskView];
		} else if (gesture.state == UIGestureRecognizerStateChanged) {
			CGPoint translation = [gesture translationInView:gesture.view];
			if (translation.x < 0) {
				CGFloat percent = translation.x / -250.f;
				if (percent > 1) {
					percent = 1;
				}
				CGFloat scale = [self interpolateFrom:leftScale_ to:1 percent:percent];
				CGFloat x = [self interpolateFrom:0 to:self.drawerWidth percent:-percent];
				CGFloat y = [self interpolateFrom:0 to:self.mainYOfOpeningDrawer percent:percent];
				CGFloat heigh = [self interpolateFrom:CGRectGetHeight(self.view.bounds) to:CGRectGetHeight(self.view.bounds)-2*self.mainYOfOpeningDrawer percent:percent];
				CGFloat maskAlpha = [self interpolateFrom:0 to:self.maskAlpha percent:percent];
				CGFloat drawerViewAlpha = [self interpolateFrom:self.maskAlpha to:1 percent:percent];
				CGFloat mainShadowOpacity = [self interpolateFrom:0 to:self.mainShadowOpacity percent:percent];
				self.rightViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
				self.rightViewController.view.alpha = drawerViewAlpha;
				self.mainViewController.view.frame = CGRectMake(x, y, CGRectGetWidth(self.view.bounds), heigh);
				self.mainViewController.view.layer.shadowOpacity = mainShadowOpacity;
				self.maskView.alpha = maskAlpha;
				self.maskView.frame = self.mainViewController.view.bounds;
			}
		} else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
			CGPoint velocity = [gesture velocityInView:gesture.view];
			if (velocity.x < 0) {
				[self openRightDrawer];
			} else {
				[self closeRightDrawer];
			}
		}
	} else {
		return;
	}
}

- (void)tapOnMaskView:(UITapGestureRecognizer *)gesture {
	if (self.mainViewController.view.center.x < CGRectGetWidth(self.view.bounds)/2) {
		[self closeRightDrawer];
	} else {
		[self closeLeftDrawer];
	}
}
- (void)panOnMaskView:(UIPanGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) {
		CGPoint velocity = [gesture velocityInView:self.view];
		if (self.mainViewController.view.center.x < CGRectGetWidth(self.view.bounds)/2) {
			self.shouldBeginOpenning = (velocity.x > 0);
		} else {
			self.shouldBeginOpenning = (velocity.x < 0);
		}
	} else if (gesture.state == UIGestureRecognizerStateChanged) {
		if (!self.shouldBeginOpenning) {
			return;
		}
		// 控制抽屉vc的动画进程
		CGPoint translation = [gesture translationInView:self.view];
		CGFloat percent;
		if (self.mainViewController.view.center.x < CGRectGetWidth(self.view.bounds)/2) {
			percent = translation.x / 250.f;
		} else {
			percent = translation.x / -250.f;
		}
		if (percent > 1) {
			percent = 1;
			return;
		}
		CGFloat x;
		CGFloat heigh = [self interpolateFrom:CGRectGetHeight(self.view.bounds)-2*self.mainYOfOpeningDrawer to:CGRectGetHeight(self.view.bounds) percent:percent];
		CGFloat y = [self interpolateFrom:self.mainYOfOpeningDrawer to:0 percent:percent];
		CGFloat scale = [self interpolateFrom:1 to:leftScale_ percent:percent];
		CGFloat drawerViewAlpha = [self interpolateFrom:1 to:self.maskAlpha percent:percent];
		CGFloat mainShadowOpacity = [self interpolateFrom:self.mainShadowOpacity to:0 percent:percent];
		CGFloat alpha = [self interpolateFrom:self.maskAlpha to:0 percent:percent];
		if (self.mainViewController.view.center.x < CGRectGetWidth(self.view.bounds)/2) {
			x = [self interpolateFrom:-self.drawerWidth to:0 percent:percent];
			self.rightViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
			self.rightViewController.view.alpha = drawerViewAlpha;
		} else {
			x = [self interpolateFrom:self.drawerWidth to:0 percent:percent];
			self.leftViewController.view.transform = CGAffineTransformMakeScale(scale, scale);
			self.leftViewController.view.alpha = drawerViewAlpha;
		}
		self.mainViewController.view.frame = CGRectMake(x, y, CGRectGetWidth(self.view.bounds), heigh);
		self.mainViewController.view.layer.shadowOpacity = mainShadowOpacity;
		self.maskView.alpha = alpha;
		self.maskView.frame = self.mainViewController.view.bounds;
	} else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
		if (!self.shouldBeginOpenning) {
			return;
		}
		CGPoint velocity = [gesture velocityInView:self.view];
		if (self.mainViewController.view.center.x < CGRectGetWidth(self.view.bounds)/2) {
			if (velocity.x < 0) {
				[self openRightDrawer];
			} else {
				[self closeRightDrawer];
			}
		} else {
			if (velocity.x > 0) {
				[self openLeftDrawer];
			} else {
				[self closeLeftDrawer];
			}
		}
	}
}

#pragma mark -- get

- (UIScreenEdgePanGestureRecognizer *)gestureOfOpeningLeftDrawer {
	if (!_gestureOfOpeningLeftDrawer) {
		_gestureOfOpeningLeftDrawer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(responsToGesture:)];
		_gestureOfOpeningLeftDrawer.edges = UIRectEdgeLeft;
	}
	return _gestureOfOpeningLeftDrawer;
}
- (UIScreenEdgePanGestureRecognizer *)gestureOfOpeningRightDrawer {
	if (!_gestureOfOpeningRightDrawer) {
		_gestureOfOpeningRightDrawer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(responsToGesture:)];
		_gestureOfOpeningRightDrawer.edges = UIRectEdgeRight;
	}
	return _gestureOfOpeningRightDrawer;
}
- (UIPanGestureRecognizer *)panGestureOfOpeningLeftDrawer {
	if (!_panGestureOfOpeningLeftDrawer) {
		_panGestureOfOpeningLeftDrawer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnMaskView:)];
	}
	return _panGestureOfOpeningLeftDrawer;
}
- (UIPanGestureRecognizer *)panGestureOfOpeningRightDrawer {
	if (!_panGestureOfOpeningRightDrawer) {
		_panGestureOfOpeningRightDrawer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnMaskView:)];
	}
	return _panGestureOfOpeningRightDrawer;
}
- (UIView *)maskView {
	if (!_maskView) {
		_maskView = [[UIView alloc]init];
		_maskView.frame = self.mainViewController.view.bounds;
		_maskView.alpha = 0;
		_maskView.backgroundColor = [UIColor blackColor];
		[_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMaskView:)]];
		[_maskView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnMaskView:)]];
	}
	return _maskView;
}

- (CGFloat)drawerWidth {
	if (!_drawerWidth) {
		_drawerWidth = CGRectGetWidth(self.view.bounds)*0.8;
	}
	return _drawerWidth;
}
- (CGFloat)mainYOfOpeningDrawer {
	if (!_mainYOfOpeningDrawer) {
		_mainYOfOpeningDrawer = 0.f;
	}
	return _mainYOfOpeningDrawer;
}
- (CGFloat)maskAlpha {
	if (!_maskAlpha) {
		_maskAlpha = 0.1f;
	}
	return _maskAlpha;
}
- (CGFloat)mainShadowOpacity {
	if (!_mainShadowOpacity) {
		if (_maskAlpha != 0.1f) {
			_mainShadowOpacity = 0.0f;
		} else {
			_mainShadowOpacity = 1.0f;
		}
	}
	return _mainShadowOpacity;
}
@end
