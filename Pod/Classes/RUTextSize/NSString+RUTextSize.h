//
//  NSString+RUTextSize.h
//  Shimmur
//
//  Created by Benjamin Maer on 8/7/14.
//  Copyright (c) 2014 ShimmurInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





@interface NSString (RUTextSize)

#pragma mark - Text Size
- (CGSize)ruTextSizeWithBoundingWidth:(CGFloat)boundingWidth attributes:(nullable NSDictionary *)attributes NS_AVAILABLE_IOS(6_0);

@end
