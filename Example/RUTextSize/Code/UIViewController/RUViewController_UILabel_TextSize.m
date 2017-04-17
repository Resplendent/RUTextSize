//
//  RUViewController_UILabel_TextSize.m
//  RUTextSize
//
//  Created by Benjamin Maer on 3/4/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RUViewController_UILabel_TextSize.h"
#import "RUTableViewCell_LabelSizedToText.h"
#import "UILabel+RUTextSize.h"
#import "NSNumber+RUExampleConstants.h"
#import "NSString+RUTextSize.h"
#import "NSString+RUTextSizeStrings.h"
#import "RUAttributesDictionaryBuilder.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>





typedef NS_ENUM(NSInteger, RUViewController_UILabel_TextSize__tableView_section) {
	RUViewController_UILabel_TextSize__tableView_section_oneLine,
	RUViewController_UILabel_TextSize__tableView_section_oneLine_withReallyLongText,
	RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines,
	RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines,
	RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText,
	RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_cappedAt2Lines,

	RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_truncatedTail,
	RUViewController_UILabel_TextSize__tableView_section_manyLines_withScatteredText_truncatedTail,
    
    RUViewController_UILabel_TextSize__tableView_section_sameString_withoutKerning,
    RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning,

	RUViewController_UILabel_TextSize__tableView_section__first		= RUViewController_UILabel_TextSize__tableView_section_oneLine,
	RUViewController_UILabel_TextSize__tableView_section__last		= RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning,
};





@interface RUViewController_UILabel_TextSize () <UITableViewDataSource,UITableViewDelegate,RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableView
@property (nonatomic, readonly, nullable) UITableView* tableView;
-(CGRect)tableViewFrame;

#pragma mark - tableSectionManager
@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - Table View Cells
-(nonnull RUTableViewCell_LabelSizedToText*)cellForTableSection:(RUViewController_UILabel_TextSize__tableView_section)tableSection;

#pragma mark - section_to_cellCustomViewLabel_mapping_cache
@property (nonatomic, readonly, nonnull) NSMutableDictionary<NSNumber*,UILabel*>* section_to_cellCustomViewLabel_mapping_cache;

#pragma mark - cell custom view label
-(nonnull UILabel*)cellCustomViewLabelForSection:(RUViewController_UILabel_TextSize__tableView_section)section;
-(NSInteger)cellCustomViewLabel_numberOfLines_forSection:(RUViewController_UILabel_TextSize__tableView_section)section;
-(nullable UIColor*)cellCustomViewLabel_backgroundColorForSection:(RUViewController_UILabel_TextSize__tableView_section)section;
-(nullable NSString*)cellCustomViewLabel_textForSection:(RUViewController_UILabel_TextSize__tableView_section)section;
-(NSLineBreakMode)cellCustomViewLabel_lineBreakMode_forSection:(RUViewController_UILabel_TextSize__tableView_section)section;

#pragma mark - Paddings
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_top;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_bottom;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_left;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_right;

@end





@implementation RUViewController_UILabel_TextSize

#pragma mark - NSObject
-(void)dealloc
{
	[self.tableView setDelegate:nil];
	[self.tableView setDataSource:nil];
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.view addSubview:self.tableView];

	_tableSectionManager = [[RTSMTableSectionManager alloc]initWithFirstSection:RUViewController_UILabel_TextSize__tableView_section__first
																	lastSection:RUViewController_UILabel_TextSize__tableView_section__last];
	[self.tableSectionManager setSectionDelegate:self];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	[self.tableView setFrame:self.tableViewFrame];
}

#pragma mark - tableView
-(CGRect)tableViewFrame
{
	return self.view.bounds;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.view endEditing:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.tableSectionManager numberOfSectionsAvailable];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController_UILabel_TextSize__tableView_section const tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	return [self cellForTableSection:tableSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat const padding_vertical_top = [[self class]RUTableViewCell_LabelSizedToText_padding_top];
	CGFloat const padding_vertical_bottom = [[self class]RUTableViewCell_LabelSizedToText_padding_bottom];

	RUViewController_UILabel_TextSize__tableView_section const tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	UILabel* const labelForSection = [self cellCustomViewLabelForSection:tableSection];
	kRUConditionalReturn_ReturnValue(labelForSection == nil, YES, 0);

	CGRect const tableViewFrame = self.tableViewFrame;

	CGFloat const constrainedWidth = CGRectGetWidth(tableViewFrame) - [[self class]RUTableViewCell_LabelSizedToText_padding_left] - [[self class]RUTableViewCell_LabelSizedToText_padding_right];
	CGSize const textSize = [labelForSection ruTextSizeConstrainedToWidth:constrainedWidth];

	return textSize.height + padding_vertical_top + padding_vertical_bottom;
}

#pragma mark - Paddings
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_top
{
	return [NSNumber ru_padding_general];
}

+(CGFloat)RUTableViewCell_LabelSizedToText_padding_bottom
{
	return [NSNumber ru_padding_general];
}

+(CGFloat)RUTableViewCell_LabelSizedToText_padding_left
{
	return [NSNumber ru_padding_general];
}

+(CGFloat)RUTableViewCell_LabelSizedToText_padding_right
{
	return [NSNumber ru_padding_general];
}

#pragma mark - Table View Cells
-(nonnull RUTableViewCell_LabelSizedToText*)cellForTableSection:(RUViewController_UILabel_TextSize__tableView_section)tableSection
{
	kRUDefineNSStringConstant(RUViewController__tableDequeIdentifier_RUTableViewCell_LabelSizedToText);
	RUTableViewCell_LabelSizedToText* tableViewCell_LabelSizedToText = [self.tableView dequeueReusableCellWithIdentifier:RUViewController__tableDequeIdentifier_RUTableViewCell_LabelSizedToText];
	if (tableViewCell_LabelSizedToText == nil)
	{
		tableViewCell_LabelSizedToText = [[RUTableViewCell_LabelSizedToText alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RUViewController__tableDequeIdentifier_RUTableViewCell_LabelSizedToText];
		[tableViewCell_LabelSizedToText setSelectionStyle:UITableViewCellSelectionStyleNone];
		[tableViewCell_LabelSizedToText.layer setBorderColor:[UIColor darkGrayColor].CGColor];
		[tableViewCell_LabelSizedToText.layer setBorderWidth:1.0f];
	}

	[tableViewCell_LabelSizedToText setExpectedDebugValue_topPadding:[[self class]RUTableViewCell_LabelSizedToText_padding_top]];
	[tableViewCell_LabelSizedToText setExpectedDebugValue_bottomPadding:[[self class]RUTableViewCell_LabelSizedToText_padding_top]];

	[tableViewCell_LabelSizedToText setLabelSizedToText_padding_left:[[self class]RUTableViewCell_LabelSizedToText_padding_left]];
	[tableViewCell_LabelSizedToText setLabelSizedToText_padding_right:[[self class]RUTableViewCell_LabelSizedToText_padding_right]];
	[tableViewCell_LabelSizedToText setLabelSizedToText:[self cellCustomViewLabelForSection:tableSection]];

	return tableViewCell_LabelSizedToText;
}

#pragma mark - RTSMTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RTSMTableSectionManager*)tableSectionManager sectionIsAvailable:(NSInteger)section
{
	return YES;
}

#pragma mark - section_to_cellCustomViewLabel_mapping_cache
@synthesize section_to_cellCustomViewLabel_mapping_cache = _section_to_cellCustomViewLabel_mapping_cache;
-(NSMutableDictionary<NSNumber*,UILabel*>*)section_to_cellCustomViewLabel_mapping_cache
{
	if (_section_to_cellCustomViewLabel_mapping_cache == nil)
	{
		_section_to_cellCustomViewLabel_mapping_cache = [NSMutableDictionary dictionary];
	}

	return _section_to_cellCustomViewLabel_mapping_cache;
}

#pragma mark - cell custom view label
-(nonnull UILabel*)cellCustomViewLabelForSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
    
	NSMutableDictionary<NSNumber*,UILabel*>* const section_to_cellCustomViewLabel_mapping_cache = self.section_to_cellCustomViewLabel_mapping_cache;
	NSNumber* const section_key = @(section);

	UILabel* label = [section_to_cellCustomViewLabel_mapping_cache objectForKey:section_key];
	kRUConditionalReturn_ReturnValue(label != nil, NO, label);

	label = [UILabel new];
	[label setBackgroundColor:[self cellCustomViewLabel_backgroundColorForSection:section]];
	[label setNumberOfLines:[self cellCustomViewLabel_numberOfLines_forSection:section]];
	[label setFont:[UIFont systemFontOfSize:16.0f]];
	[label setTextColor:[UIColor darkTextColor]];
    [label setLineBreakMode:[self cellCustomViewLabel_lineBreakMode_forSection:section]];

    if (section == RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning)
    {
        RUAttributesDictionaryBuilder* const attributesDictionary = [RUAttributesDictionaryBuilder new];
        [attributesDictionary absorbPropertiesFromLabel:label];
        [attributesDictionary setKerning:@(5)];
        [label setAttributedText:[[NSAttributedString alloc] initWithString:[self cellCustomViewLabel_textForSection:section] attributes:[attributesDictionary createAttributesDictionary]]];
    }
    else
    {
        [label setText:[self cellCustomViewLabel_textForSection:section]];
    }
	[section_to_cellCustomViewLabel_mapping_cache setObject:label forKey:section_key];

	return label;
}

-(NSInteger)cellCustomViewLabel_numberOfLines_forSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
	switch (section)
	{
		case RUViewController_UILabel_TextSize__tableView_section_oneLine:
		case RUViewController_UILabel_TextSize__tableView_section_oneLine_withReallyLongText:
			return 1;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines:
			return 0;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines:
			return 3;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText:
			return 0;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_cappedAt2Lines:
			return 2;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_truncatedTail:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withScatteredText_truncatedTail:
			return 0;
			break;
            
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning:
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withoutKerning:
            return 0;
            break;
	}

	NSAssert(false, @"unhandled");
	return 0;
}

-(nullable UIColor*)cellCustomViewLabel_backgroundColorForSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
	switch (section)
	{
		case RUViewController_UILabel_TextSize__tableView_section_oneLine:
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines:
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_truncatedTail:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withScatteredText_truncatedTail:
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning:
			return [UIColor greenColor];
			break;

        case RUViewController_UILabel_TextSize__tableView_section_sameString_withoutKerning:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_cappedAt2Lines:
		case RUViewController_UILabel_TextSize__tableView_section_oneLine_withReallyLongText:
			return [UIColor redColor];
			break;
	}

	NSAssert(false, @"unhandled");
	return 0;
}

-(nullable NSString*)cellCustomViewLabel_textForSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
	switch (section)
	{
		case RUViewController_UILabel_TextSize__tableView_section_oneLine:
			return @"One line";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_oneLine_withReallyLongText:
			return @"One line, capped at 1 line, with text that is sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo long, you can't possible see the end of this.";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines:
			return @"Three lines of text\nwith newlines\n0 max number of lines";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines:
			return @"Three lines of text\nwith newlines\n3 max number of lines";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText:
			return [NSString ru_exampleString_longestTest];
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_cappedAt2Lines:
			return @"This text is capped at 2 lines, but has to be sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo long, it takes up many lines if it weren't capped. Hopefully this is long enough, but honestly, you never know.";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_truncatedTail:
			return @"This text should have a truncated tail, but has to be sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo long, it takes up many lines if it weren't capped. Hopefully this is long enough, but honestly, you never know.";
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withScatteredText_truncatedTail:
			return @"Hey\n\n\n\n\n\n\n\nHardship\n\n\nJutfd";
			break;
            
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning:
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withoutKerning:
            return @"This string is going to look mighty different once kerning is applied... They might even be different sizes! How exciting!";
	}

	NSAssert(false, @"unhandled");
	return 0;
}

-(NSLineBreakMode)cellCustomViewLabel_lineBreakMode_forSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
	switch (section)
	{
		case RUViewController_UILabel_TextSize__tableView_section_oneLine:
		case RUViewController_UILabel_TextSize__tableView_section_oneLine_withReallyLongText:
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines:
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_cappedAt2Lines:
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withKerning:
        case RUViewController_UILabel_TextSize__tableView_section_sameString_withoutKerning:
			return NSLineBreakByWordWrapping;
			break;

		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText_truncatedTail:
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withScatteredText_truncatedTail:
			return NSLineBreakByTruncatingTail;
			break;
	}

	NSAssert(false, @"unhandled");
	return 0;
}

@end
