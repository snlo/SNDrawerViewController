# **SNDrawerViewController**

SNDrawerViewController 支持左抽屉，支持右抽屉，支持左右双抽屉。并且可以定制抽屉大小以及主界面的尺寸，因为它只是一个抽屉控制器框架没有任何的子视图，所以它的外观完全需要定制。

![](https://github.com/snlo/SNDrawerViewController/blob/master/SNDrawerViewController/Resources/DrawerExhibition.gif)

## Installation

SNDrawerViewController 可以通过[CocoaPods](https://cocoapods.org/?q=SNDrawerViewController)获得。在您的Podfile中：

```
pod 'SNDrawerViewController'
```

或者找到文件‘Drawers’直接拖入您的工程

## Requirements

- iOS 7.0以上版本
- Xcode 8.0+

## Introduce

SNDrawerViewController是由一个根控制器分别持有左抽屉控制器、主页控制器、右抽屉控制器组成。以屏幕边缘手势来控制两个抽屉的出现，同时支持拖拽手势。主页和抽屉控制器均交于外部实现，增强了扩展性。并且提供了一套基础设置API。

## usage

首先import ‘SNDrawerFramework.h’。创建主页和抽屉的Controller，并加载。

```objective-c
SNDrawerViewController *SNDrawerVC = [[SNDrawerViewController alloc] initWithMainViewController:[[MainViewController alloc] init]
                                                                                 leftViewController:[[LeftViewController alloc] init]
                                                                                rightViewController:[[RightViewController alloc] init]];
    /* configure your drawer */
    
	[self addChildViewController:SNDrawerVC];
	[self.view addSubview:SNDrawerVC.view];
```

如果只有左抽屉，请使用一下API

```objective-c
/**
 左抽屉初始化
 
 @param mainViewController 主视图控制器
 @param leftViewController 左抽屉控制器
 @return SNDrawerViewController
 */
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController;
```

然后分别在你所创建的主页和抽屉Controller中去编写你的界面逻辑。

以下API是用于解决外部手势冲突所抛出的

```objective-c
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
```

## License

SNDrawerViewController是根据MIT许可证发布的。有关详细信息，请参阅LICENSE。