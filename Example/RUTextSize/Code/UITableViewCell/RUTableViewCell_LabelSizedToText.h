//
//  RUTableViewCell_LabelSizedToText.h
//  RUTextSize
//
//  Created by Benjamin Maer on 3/4/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RUTableViewCell_LabelSizedToText : UITableViewCell

#pragma mark - labelSizedToText
@property (nonatomic, strong, nullable) UILabel* labelSizedToText;
@property (nonatomic, assign) CGFloat labelSizedToText_padding_left;
@property (nonatomic, assign) CGFloat labelSizedToText_padding_right;

@end
