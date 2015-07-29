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

#import <UIFont+RUHelvetica.h>





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
		[self.textViewWithPlaceholderContainerView setBackgroundColor:[UIColor clearColor]];
		[self.textViewWithPlaceholderContainerView.textView setFont:[UIFont ru_helveticaFontWithType:RU_UIFont_Helvetica_type_regular size:14.0f]];
		[self.textViewWithPlaceholderContainerView.textView setTextColor:[UIColor blackColor]];
		[self.textViewWithPlaceholderContainerView.textView setTextAlignment:NSTextAlignmentCenter];
		[self.textViewWithPlaceholderContainerView setCenterTextVertically:YES];
		[self.textViewWithPlaceholderContainerView.textViewPlaceholderLabel setFont:[UIFont ru_helveticaFontWithType:RU_UIFont_Helvetica_type_regular size:14.0f]];
		[self.textViewWithPlaceholderContainerView.textViewPlaceholderLabel setTextColor:[UIColor grayColor]];
		[self.textViewWithPlaceholderContainerView.textViewPlaceholderLabel setTextAlignment:NSTextAlignmentCenter];
		[self.textViewWithPlaceholderContainerView.textViewPlaceholderLabel setText:@"Placeholder"];
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
