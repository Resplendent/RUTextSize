//
//  UITextField+RUAttributesDictionaryBuilder.m
//  Pods
//
//  Created by Benjamin Maer on 5/31/17.
//
//

#import "UITextField+RUAttributesDictionaryBuilder.h"
#import "RUAttributesDictionaryBuilder.h"





@implementation UITextField (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder
{
	[self setFont:attributesDictionaryBuilder.font];
	[self setTextColor:attributesDictionaryBuilder.textColor];
	[self setTextAlignment:attributesDictionaryBuilder.textAlignment];
}

#pragma mark - attributesDictionaryBuilder
-(nonnull RUAttributesDictionaryBuilder*)ru_attributesDictionaryBuilder
{
	RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
	[attributesDictionaryBuilder setFont:self.font];
	[attributesDictionaryBuilder setTextColor:self.textColor];
	[attributesDictionaryBuilder setTextAlignment:self.textAlignment];

	return attributesDictionaryBuilder;
}

@end
