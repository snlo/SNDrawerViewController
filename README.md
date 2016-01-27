# SNDrawerViewController
##需求
    左右两侧都有滑动式的抽屉效果。
##实现原理
    在更控制器上有三个子控制器，分别是主页、左抽屉、右抽屉。当触发左右边缘手势时，主页下面的子控制器分别以抽屉的的形式展现出来。
###难点一
    各个控制器之间的关系。
###难点二
    抽屉手势的与外界手势的冲突先处理。
##主要特色
    1、使用简单，方便
    2、个性化定制接口比较多，可以随意定制抽屉大小样式，以及主页缩放模式
    3、可维护性高
---
//我的头像动画
 - (void)meViewAnimation {
	[self rotatingAnimationWithHeadImageView:self.meView startAngle:M_PI_2 rate:0.2];
}
---
