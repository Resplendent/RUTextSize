//
//  RUAttributesDictionaryBuilder.m
//  Qude
//
//  Created by Benjamin Maer on 8/5/14.
//  Copyright (c) 2014 QudeLLC. All rights reserved.
//

#import "RUAttributesDictionaryBuilder.h"
#import "NSMutableDictionary+RUUtil.h"

#if DEBUG
#import "NSString+RUTextSizeStrings.h"
#import "UILabel+RUTextSize.h"
#endif

#import <CoreText/CoreText.h>

#import <ResplendentUtilities/RUClassOrNilUtil.h>
#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation RUAttributesDictionaryBuilder

#pragma mark - Properties
-(void)setProperty:(nullable id)propertyValue
	 attributeType:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_font:
			[self setFont:kRUClassOrNil(propertyValue, UIFont)];
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_paragraphStyle:
		{
			NSParagraphStyle* paragraphStyle = kRUClassOrNil(propertyValue, NSParagraphStyle);
			kRUConditionalReturn((propertyValue == nil) != (paragraphStyle != nil), YES);
			[self setLineBreakMode:paragraphStyle.lineBreakMode];
			[self setLineSpacing:@(paragraphStyle.lineSpacing)];
			[self setTextAlignment:paragraphStyle.alignment];
		}
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_textColor:
			[self setTextColor:kRUClassOrNil(propertyValue, UIColor)];
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey:
		{
			NSNumber* textColorShouldUseCoreTextKey = kRUNumberOrNil(propertyValue);
			kRUConditionalReturn((propertyValue == nil) != (textColorShouldUseCoreTextKey != nil), YES);

			[self setTextColorShouldUseCoreTextKey:textColorShouldUseCoreTextKey.boolValue];
		}
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_kerning:
			[self setKerning:kRUNumberOrNil(propertyValue)];
			break;
	}
}

#pragma mark - Absorb
-(void)absorbPropertiesFromLabel:(UILabel*)label
{
	[self setFont:label.font];
	[self setTextColor:label.textColor];
	[self setLineBreakMode:label.lineBreakMode];
	[self setTextAlignment:label.textAlignment];
}

-(void)absorbPropertiesFromButton:(UIButton*)button
{
	[self absorbPropertiesFromLabel:button.titleLabel];
}

-(void)absorbPropertiesFromTextField:(UITextField*)textField
{
	[self setFont:textField.font];
	[self setTextColor:textField.textColor];
}

-(void)absorbPropertiesFromTextView:(UITextView*)textView
{
	[self setFont:textView.font];
	[self setTextColor:textView.textColor];
	[self setTextAlignment:textView.textAlignment];
}

-(void)absorbPropertiesAttributesDictionary:(nonnull NSDictionary*)attributesDictionary
						   ignoreNilEntries:(BOOL)ignoreNilEntries
{
	for (RUAttributesDictionaryBuilder_attributeType attributeType = RUAttributesDictionaryBuilder_attributeType__first;
		 attributeType <= RUAttributesDictionaryBuilder_attributeType__last;
		 attributeType++)
	{
		NSString* attributeKey = [[self class]attributeTypeKeyForEnum:attributeType];
		BOOL attributeKey_use = (attributeKey != nil);
		if (attributeKey_use == false)
		{
			NSAssert(attributeKey_use, @"unhandled");
			continue;
		}

		id attributeValue = [attributesDictionary objectForKey:attributeKey];

		if ((ignoreNilEntries == NO) ||
			(attributeValue != nil))
		{
			[self setProperty:attributeValue
				attributeType:attributeType];
		}
	}
}

#pragma mark - Create Attributes Dictionary
-(NSDictionary*)createAttributesDictionary
{
	NSMutableDictionary* attributesDictionary = [NSMutableDictionary dictionary];

	[attributesDictionary setObjectOrRemoveIfNil:self.font forKey:[[self class] attributeTypeKeyForEnum:RUAttributesDictionaryBuilder_attributeType_font]];

	[attributesDictionary setObjectOrRemoveIfNil:self.textColor forKey:[[self class] attributeTypeKeyForEnum:(self.textColorShouldUseCoreTextKey ?
																											  RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey :
																											  RUAttributesDictionaryBuilder_attributeType_textColor)]];

	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setLineBreakMode:self.lineBreakMode];
	[style setAlignment:self.textAlignment];

	if (self.lineSpacing)
	{
		[style setLineSpacing:self.lineSpacing.floatValue];
	}

	if (self.kerning)
	{
		[attributesDictionary setObject:self.kerning forKey:[[self class]attributeTypeKeyForEnum:RUAttributesDictionaryBuilder_attributeType_kerning]];
	}

	[attributesDictionary setObjectOrRemoveIfNil:style forKey:[[self class]attributeTypeKeyForEnum:RUAttributesDictionaryBuilder_attributeType_paragraphStyle]];
	
	return [attributesDictionary copy];
}

#pragma mark - Attribute Type
+(nonnull NSString*)attributeTypeKeyForEnum:(RUAttributesDictionaryBuilder_attributeType)attributeType
{
	switch (attributeType)
	{
		case RUAttributesDictionaryBuilder_attributeType_font:
			return NSFontAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_paragraphStyle:
			return NSParagraphStyleAttributeName;
			break;
			
		case RUAttributesDictionaryBuilder_attributeType_textColor:
			return NSForegroundColorAttributeName;
			break;

		case RUAttributesDictionaryBuilder_attributeType_textColor_textColorShouldUseCoreTextKey:
			return (
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpointer-bool-conversion"
					((&kCTForegroundColorAttributeName) != nil) ?
#pragma clang diagnostic pop
					(NSString *)kCTForegroundColorAttributeName :
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
					[self attributeTypeKeyForEnum:RUAttributesDictionaryBuilder_attributeType_textColor]);
#pragma clang diagnostic pop
			break;

		case RUAttributesDictionaryBuilder_attributeType_kerning:
			return NSKernAttributeName;
			break;
	}
	
	NSAssert(false, @"unhandled attributeType %li",attributeType);
	return nil;
}

#if DEBUG
#pragma mark - Unit Testing
+(void)DEBUG__RUAttributesDictionaryBuilder_RUTextSize_kerning_unitTest
{
	NSString* const superLongText = [NSString ru_exampleString_longestTest];

	UILabel* const debugLabel = [UILabel new];
	[debugLabel setFont:[UIFont systemFontOfSize:24.0f]];
	[debugLabel setText:superLongText];
	[debugLabel setLineBreakMode:NSLineBreakByWordWrapping];

	CGFloat const boundedWidth = 100.0f;

	CGSize const non_kerned_size = [debugLabel ruTextSizeConstrainedToWidth:boundedWidth];

	RUAttributesDictionaryBuilder* const attributes = [RUAttributesDictionaryBuilder new];
	[attributes absorbPropertiesFromLabel:debugLabel];
	[attributes setKerning:@(10)];

	[debugLabel setAttributedText:[[NSAttributedString alloc] initWithString:superLongText attributes:[attributes createAttributesDictionary]]];

	CGSize kerned_size = [debugLabel ruTextSizeConstrainedToWidth:boundedWidth];

	NSAssert((CGSizeEqualToSize(non_kerned_size, kerned_size) == false), @"These should be different sizes");
}
#endif

@end
