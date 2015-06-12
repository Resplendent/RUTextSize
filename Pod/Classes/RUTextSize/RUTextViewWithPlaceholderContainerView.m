//
//  RUTextViewWithPlaceholderContainerView.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/17/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "RUTextViewWithPlaceholderContainerView.h"
#import "UILabel+RUTextSize.h"
#import "UIView+RUUtility.h"
#import "RUConditionalReturn.h"
#import "UITextView+RUTextSize.h"





static void* kRUTextViewWithPlaceholderContainerView__KVOContext = &kRUTextViewWithPlaceholderContainerView__KVOContext;





@interface RUTextViewWithPlaceholderContainerView ()

@property (nonatomic, readonly) UITapGestureRecognizer* tapGesture;
-(void)didTap_tapGesture;

@property (nonatomic, readonly) UIEdgeInsets textViewContentInset;


-(void)ru_setRegisteredToTextView:(BOOL)registered;

@end





@implementation RUTextViewWithPlaceholderContainerView

#pragma mark - NSObject
-(void)dealloc
{
	[self ru_setRegisteredToTextView:NO];
}

#pragma mark - UIView
-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		_tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap_tapGesture)];
		[self addGestureRecognizer:self.tapGesture];
		
		_textView = [UITextView new];
		[self.textView setDelegate:self];
		[self addSubview:self.textView];

		_textViewPlaceholderLabel = [UILabel new];
		[self addSubview:self.textViewPlaceholderLabel];

		[self ru_setRegisteredToTextView:YES];
	}

	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	[self.textView setFrame:self.textViewFrame];
	[self.textView setContentInset:self.textViewContentInset];

	[self.textViewPlaceholderLabel setFrame:self.textViewPlaceholderLabelFrame];
}

#pragma mark - Frames
-(CGRect)textViewFrame
{
	return self.bounds;
}

-(UIEdgeInsets)textViewContentInset
{
	kRUConditionalReturn_ReturnValue(self.centerTextVertically == false, NO, UIEdgeInsetsZero);
	
	CGFloat deadSpace = (CGRectGetHeight(self.textView.bounds) - self.textView.contentSize.height);
	CGFloat inset = MAX(0, deadSpace / 2.0f);
	return (UIEdgeInsets){
		.top		= inset,
		.left		= self.textView.contentInset.left,
		.bottom		= inset,
		.right		= self.textView.contentInset.right,
	};
}

-(CGRect)textViewPlaceholderLabelFrame
{
	CGSize textSize = [self.textViewPlaceholderLabel ruTextSize];

	CGFloat yCoord = (self.centerTextVertically ?
					  CGRectGetVerticallyAlignedYCoordForHeightOnHeight(textSize.height, CGRectGetHeight(self.bounds)) :
					  0.0f);

	return CGRectCeilOrigin((CGRect){
		.origin.y		= yCoord,
		.size.width		= CGRectGetWidth(self.bounds),
		.size.height	= textSize.height,
	});
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
	[self updateTextViewPlaceholderLabelVisilibity];
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self.textDelegate textViewWithPlaceholderContainerView:self textViewDidChangeText:self.textView.text];
}

#pragma mark - Update Content
-(void)updateTextViewPlaceholderLabelVisilibity
{
	[self.textViewPlaceholderLabel setHidden:((self.textView.text.length > 0) || self.textView.isFirstResponder)];
}

#pragma mark - KVO
-(void)ru_setRegisteredToTextView:(BOOL)registered
{
	kRUConditionalReturn(self.textView == nil, NO);
	
	static NSArray* propertiesToObserve;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		propertiesToObserve = @[
								@"text",
								@"contentSize",
								];
	});
	
	for (NSString* propertyToObserve in propertiesToObserve)
	{
		if (registered)
		{
			[self.textView addObserver:self forKeyPath:propertyToObserve options:(NSKeyValueObservingOptionInitial) context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
		else
		{
			[self.textView removeObserver:self forKeyPath:propertyToObserve context:&kRUTextViewWithPlaceholderContainerView__KVOContext];
		}
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == kRUTextViewWithPlaceholderContainerView__KVOContext)
	{
		if (object == self.textView)
		{
			if ([keyPath isEqualToString:@"text"])
			{
				[self updateTextViewPlaceholderLabelVisilibity];
			}
			else if ([keyPath isEqualToString:@"contentSize"])
			{
				[self setNeedsLayout];
			}
			else
			{
				NSAssert(false, @"unhandled");
			}
		}
		else
		{
			NSAssert(false, @"unhandled");
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - textView_centerTextVertically
-(void)setCenterTextVertically:(BOOL)centerTextVertically
{
	kRUConditionalReturn(self.centerTextVertically == centerTextVertically, NO);

	_centerTextVertically = centerTextVertically;

	[self setNeedsLayout];
}

#pragma mark - Gesture Actions
-(void)didTap_tapGesture
{
	[self.textView becomeFirstResponder];
}

@end
