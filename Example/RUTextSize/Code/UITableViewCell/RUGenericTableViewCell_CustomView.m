//
//  RUGenericTableViewCell_CustomView.m
//  RUTextSize
//
//  Created by Benjamin Maer on 3/2/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUGenericTableViewCell_CustomView.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation RUGenericTableViewCell_CustomView

#pragma mark - UIView
-(void)layoutSubviews
{
	[super layoutSubviews];

	if (self.customView)
	{
		[self.customView setFrame:self.contentView.bounds];
	}
}

#pragma mark - customView
-(void)setCustomView:(UIView *)customView
{
	kRUConditionalReturn(self.customView == customView, NO);

	if (self.customView)
	{
		[self.customView removeFromSuperview];
	}

	_customView = customView;

	if (self.customView)
	{
		[self.contentView addSubview:self.customView];
	}
}

@end
