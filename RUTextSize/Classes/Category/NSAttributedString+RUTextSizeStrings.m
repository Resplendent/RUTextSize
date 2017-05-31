//
//  NSAttributedString+RUTextSizeStrings.m
//  Pods
//
//  Created by Benjamin Maer on 4/11/16.
//
//

#import "NSAttributedString+RUTextSizeStrings.h"

#import "RUAttributesDictionaryBuilder.h"





@implementation NSAttributedString (RUTextSizeStrings)

#if (DEBUG || NSString_RUTextSizeStrings__Enable_DEBUG_Code)
#pragma mark - Unit Testing
+(nonnull instancetype)ru_exampleAttributedString_emojiWithNewlineAndLabelAbsorb
{
	UILabel* label = [UILabel new];
	[label setTextAlignment:NSTextAlignmentCenter];

	NSMutableAttributedString* attributedText = [NSMutableAttributedString new];

	RUAttributesDictionaryBuilder* attributesDictionaryBuilder_emoji = [RUAttributesDictionaryBuilder new];
	[attributesDictionaryBuilder_emoji absorbPropertiesFromLabel:label];
	[attributesDictionaryBuilder_emoji setFont:[UIFont systemFontOfSize:54.0f weight:UIFontWeightMedium]];

	[attributedText appendAttributedString:[[NSAttributedString alloc]initWithString:@"🎉"
																		  attributes:[attributesDictionaryBuilder_emoji attributesDictionary_generate]]];

	RUAttributesDictionaryBuilder* attributesDictionaryBuilder_text = [RUAttributesDictionaryBuilder new];
	[attributesDictionaryBuilder_text absorbPropertiesFromLabel:label];
	[attributesDictionaryBuilder_text setFont:[UIFont systemFontOfSize:13.0f]];
	[attributesDictionaryBuilder_text setTextColor:[UIColor blackColor]];

	[attributedText appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n\nPost Created"
																		  attributes:[attributesDictionaryBuilder_text attributesDictionary_generate]]];

	return [attributedText copy];
}
#endif

@end
