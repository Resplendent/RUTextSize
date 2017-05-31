//
//  UITextField+RUAttributesDictionaryBuilder.h
//  Pods
//
//  Created by Benjamin Maer on 5/31/17.
//
//

#import <UIKit/UIKit.h>





@class RUAttributesDictionaryBuilder;





@interface UITextField (RUAttributesDictionaryBuilder)

#pragma mark - absorb
-(void)ru_absorb_attributesDictionaryBuilder:(nonnull RUAttributesDictionaryBuilder*)attributesDictionaryBuilder;

#pragma mark - attributesDictionaryBuilder
-(nonnull RUAttributesDictionaryBuilder*)ru_attributesDictionaryBuilder;

@end
