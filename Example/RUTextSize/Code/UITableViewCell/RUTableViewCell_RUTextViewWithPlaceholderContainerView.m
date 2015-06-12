//
//  RUTableViewCell_RUTextViewWithPlaceholderContainerView.m
//  RUTextSize
//
//  Created by Benjamin Maer on 6/11/15.
//  Copyright (c) 2015 Lee Pollard. All rights reserved.
//

#import "RUTableViewCell_RUTextViewWithPlaceholderContainerView.h"
#import "RUTextViewWithPlaceholderContainerView.h"
#import "UIView+RUCommonSizes.h"





@interface RUTableViewCell_RUTextViewWithPlaceholderContainerView ()

@property (nonatomic, readonly) CGRect textViewWithPlaceholderContainerViewFrame;

@end





@implementation RUTableViewCell_RUTextViewWithPlaceholderContainerView

#pragma mark - UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		_textViewWithPlaceholderContainerView = [RUTextViewWithPlaceholderContainerView new];
		[self.textViewWithPlaceholderContainerView setClipsToBounds:YES];
		[self.textViewWithPlaceholderContainerView.layer setBorderWidth:1.0f];
		[self.textViewWithPlaceholderContainerView.layer setBorderColor:[UIColor grayColor].CGColor];
		[self.textViewWithPlaceholderContainerView.textView setFont:[UIFont systemFontOfSize:24.0f]];
		[self.contentView addSubview:self.textViewWithPlaceholderContainerView];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.textViewWithPlaceholderContainerView setFrame:self.textViewWithPlaceholderContainerViewFrame];
}

#pragma mark - Frames
-(CGRect)textViewWithPlaceholderContainerViewFrame
{
	return self.bounds;
}

#pragma mark - Static Height
+(CGFloat)cellHeight
{
	return 88.0f;
}

@end
