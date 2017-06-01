//
//  RUTableViewCell_LabelSizedToText.m
//  RUTextSize
//
//  Created by Benjamin Maer on 3/4/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUTableViewCell_LabelSizedToText.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/UIView+RUUtility.h>
#import <ResplendentUtilities/RUConstants.h>

#import <RUTextSize/UILabel+RUTextSize.h>





@interface RUTableViewCell_LabelSizedToText ()

#pragma mark - labelSizedToText
-(CGRect)labelSizedToTextFrame;

@end





@implementation RUTableViewCell_LabelSizedToText

#pragma mark - UIView
-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.labelSizedToText setFrame:self.labelSizedToTextFrame];
}

#pragma mark - labelSizedToText
-(void)setLabelSizedToText:(UILabel *)labelSizedToText
{
	kRUConditionalReturn(self.labelSizedToText == labelSizedToText, NO);

	if (self.labelSizedToText != nil)
	{
		[self.labelSizedToText removeFromSuperview];
	}

	_labelSizedToText = labelSizedToText;

	if (self.labelSizedToText != nil)
	{
		[self.contentView addSubview:self.labelSizedToText];
		[self setNeedsLayout];
	}
}

-(CGRect)labelSizedToTextFrame
{
	CGFloat labelSizedToText_padding_left = self.labelSizedToText_padding_left;
	CGFloat labelSizedToText_padding_right = self.labelSizedToText_padding_right;
	CGFloat constrainedWidth = CGRectGetWidth(self.contentView.bounds) - labelSizedToText_padding_left - labelSizedToText_padding_right;
	
	CGSize textSize = [self.labelSizedToText ruTextSizeConstrainedToWidth:constrainedWidth];

	return CGRectCeilOrigin((CGRect){
		.origin.x	= CGRectGetHorizontallyAlignedXCoordForWidthOnWidth(textSize.width, CGRectGetWidth(self.contentView.bounds)),
		.origin.y	= CGRectGetVerticallyAlignedYCoordForHeightOnHeight(textSize.height, CGRectGetHeight(self.contentView.bounds)),
		.size	= textSize,
	});
}

-(void)setLabelSizedToText_padding_left:(CGFloat)labelSizedToText_padding_left
{
	kRUConditionalReturn(self.labelSizedToText_padding_left == labelSizedToText_padding_left, NO);
	
	_labelSizedToText_padding_left = labelSizedToText_padding_left;
	
	[self setNeedsLayout];
}

-(void)setLabelSizedToText_padding_right:(CGFloat)labelSizedToText_padding_right
{
	kRUConditionalReturn(self.labelSizedToText_padding_right == labelSizedToText_padding_right, NO);
	
	_labelSizedToText_padding_right = labelSizedToText_padding_right;
	
	[self setNeedsLayout];
}

#if DEBUG
#pragma mark - Unit Testing
-(BOOL)DEBUG__NSAttributedString_RUTextSize_unitTest
{
	NSString* DEBUG__unitTest_errorMessage = [self DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage];
	if (DEBUG__unitTest_errorMessage)
	{
		NSAssert(false, DEBUG__unitTest_errorMessage);
		return NO;
	}
	
	return YES;
}

-(nullable NSString*)DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage
{
	CGRect labelSizedToText_frame = self.labelSizedToText.frame;
	CGRect labelSizedToText_frame_shouldBeHeight = UIEdgeInsetsInsetRect(self.contentView.bounds, (UIEdgeInsets){
		.top		= self.expectedDebugValue_topPadding,
		.left		= self.labelSizedToText_padding_left,
	});

	return (CGRectGetHeight(labelSizedToText_frame) == CGRectGetHeight(labelSizedToText_frame_shouldBeHeight) ?
			nil :
			RUStringWithFormat(@"labelSizedToText_frame %@ should have the same height as labelSizedToText_frame_shouldBe %@",NSStringFromCGRect(labelSizedToText_frame),NSStringFromCGRect(labelSizedToText_frame_shouldBeHeight)));
}
#endif

@end
