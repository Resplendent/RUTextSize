//
//  RUNavigationController.m
//  RUTextSize
//
//  Created by Benjamin Maer on 3/4/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUNavigationController.h"
#import "RUViewController.h"





@implementation RUNavigationController

#pragma mark - NSObject
-(instancetype)init
{
	return (self = [self initWithRootViewController:[RUViewController new]]);
}

@end
