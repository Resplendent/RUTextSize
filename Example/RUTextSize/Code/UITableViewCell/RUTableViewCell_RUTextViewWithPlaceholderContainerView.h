//
//  RUTableViewCell_RUTextViewWithPlaceholderContainerView.h
//  RUTextSize
//
//  Created by Benjamin Maer on 6/11/15.
//  Copyright (c) 2015 Lee Pollard. All rights reserved.
//

#import <UIKit/UIKit.h>





@class RUTextViewWithPlaceholderContainerView;





@interface RUTableViewCell_RUTextViewWithPlaceholderContainerView : UITableViewCell

@property (nonatomic, readonly) RUTextViewWithPlaceholderContainerView* textViewWithPlaceholderContainerView;

+(CGFloat)cellHeight;

@end
