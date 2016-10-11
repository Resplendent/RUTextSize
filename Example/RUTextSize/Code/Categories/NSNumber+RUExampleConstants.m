//
//  NSNumber+RUExampleConstants.m
//  RUTextSize
//
//  Created by Benjamin Maer on 3/4/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "NSNumber+RUExampleConstants.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation NSNumber (RUExampleConstants)

#pragma mark - Paddings
+(CGFloat)ru_padding_general
{
	static CGFloat ru_padding_general = 0.0f;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSUInteger const minimum = 4.0f;
		NSUInteger const maximum = 12.0f;
		ru_padding_general = [self ru_randomNumber_withMinimum:minimum
													   maximum:maximum];
	});
	
	return ru_padding_general;
}

+(NSUInteger)ru_randomNumber_withMinimum:(NSUInteger)minimum
								 maximum:(NSUInteger)maximum
{
	kRUConditionalReturn_ReturnValue(maximum <= minimum, YES, NSNotFound);

	NSUInteger difference = maximum - minimum;
	
	NSUInteger randomOffset = arc4random_uniform((u_int32_t )difference);
	return minimum + randomOffset;
}

@end
