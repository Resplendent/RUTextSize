//
//  NSAttributedString+RUTextSize.m
//  Shimmur
//
//  Created by Benjamin Maer on 11/4/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import "NSAttributedString+RUTextSize.h"

#import <ResplendentUtilities/RUConstants.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation NSAttributedString (RUTextSize)

#pragma mark - Text Size
- (CGSize)ru_textSizeWithBoundingWidth:(CGFloat)boundingWidth
{
	if ([self respondsToSelector:@selector(boundingRectWithSize:options:context:)])
	{
		CGSize boundingSize = (CGSize){
			.width		= boundingWidth,
			.height		= CGFLOAT_MAX,
		};
		
		NSStringDrawingOptions options = (NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine);
		CGRect textBoundingRect = [self boundingRectWithSize:boundingSize options:options context:nil];
		
		NSAssert([self DEBUG__NSAttributedString_RUTextSize_unitTest_withBoundingSize:boundingSize
																	 textBoundingRect:textBoundingRect
																			  options:options], @"unhandled");
		
		return (CGSize){
			.width	= CGRectGetMaxX(textBoundingRect),
			.height = CGRectGetMaxY(textBoundingRect)
		};
	}
	else
	{
		NSAssert(false, @"not supported");
		return CGSizeZero;
	}
	
}

#pragma mark - Attributed String With
-(nullable NSAttributedString*)ru_attributedStringWithAttributesAppliedToBlankGaps:(nonnull NSDictionary*)attributes
{
	kRUConditionalReturn_ReturnValueNil(attributes == nil, YES);
	kRUConditionalReturn_ReturnValueNil(attributes.count == 0, NO);

	NSMutableAttributedString* mutableAttributedText = [NSMutableAttributedString new];
	
	[self enumerateAttributesInRange:NSMakeRange(0, self.length)
							 options:(0)
						  usingBlock:
	 ^(NSDictionary<NSString *,id> * _Nonnull attributes, NSRange range, BOOL * _Nonnull stop) {
		 
		 NSMutableDictionary* attributes_new = [NSMutableDictionary dictionary];
		 BOOL attributes_useOld = (attributes != nil);
		 if (attributes_useOld)
		 {
			 [attributes_new addEntriesFromDictionary:attributes];
		 }
		 
		 [attributes_new addEntriesFromDictionary:attributes];
		 
		 [mutableAttributedText appendAttributedString:[[NSAttributedString alloc]initWithString:[[self string]substringWithRange:range]
																					  attributes:[attributes_new copy]]];
		 
	 }];

	return [[NSAttributedString alloc]initWithAttributedString:mutableAttributedText];
}

#if DEBUG
#pragma mark - Unit Testing
-(BOOL)DEBUG__NSAttributedString_RUTextSize_unitTest_withBoundingSize:(CGSize)boundingSize
													 textBoundingRect:(CGRect)textBoundingRect
															  options:(NSStringDrawingOptions)options
{
	NSString* DEBUG__unitTest_errorMessage = [self DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage_withBoundingSize:boundingSize
																											  textBoundingRect:textBoundingRect
																													   options:options];
	if (DEBUG__unitTest_errorMessage)
	{
		NSAssert(false, DEBUG__unitTest_errorMessage);
		return NO;
	}
	
	return YES;
}

-(nullable NSString*)DEBUG__NSAttributedString_RUTextSize_unitTest_errorMessage_withBoundingSize:(CGSize)boundingSize
																				textBoundingRect:(CGRect)textBoundingRect
																						 options:(NSStringDrawingOptions)options
{
	if (CGRectGetWidth(textBoundingRect) <= boundingSize.width)
	{
		CGRect textRect_withoutBounding = [self boundingRectWithSize:CGSizeZero options:options context:nil];
		if (CGRectGetWidth(textRect_withoutBounding) > CGRectGetWidth(textBoundingRect))
		{
			if (CGRectGetHeight(textBoundingRect) <= CGRectGetHeight(textRect_withoutBounding))
			{
				return RUStringWithFormat(@"attributed string %@ had bounding width %f, which produced a textBoundingRect %@ which was bounded, yet textRect_withoutBounding %@ had the same height. It should be taller.",self,boundingSize.width,NSStringFromCGRect(textBoundingRect),NSStringFromCGRect(textRect_withoutBounding));
			}
		}
	}
	
	return nil;
}
#endif

@end
