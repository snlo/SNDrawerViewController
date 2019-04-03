//
//  ViewController.m
//  SNDrawerViewController
//
//  Created by snloveydus on 16/1/22.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import "ViewController.h"

#import "SNDrawerViewController.h"

#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    
//    pod trunk push SNDrawerViewController.podspec --verbose --allow-warnings --use-libraries
	
	SNDrawerViewController *SNDrawerVC = [[SNDrawerViewController alloc] initWithMainViewController:[[MainViewController alloc] init]
                                                                                 leftViewController:[[LeftViewController alloc] init]
                                                                                rightViewController:[[RightViewController alloc] init]];
    /* configure your drawer */
    
	[self addChildViewController:SNDrawerVC];
	[self.view addSubview:SNDrawerVC.view];
    
    
}


@end
