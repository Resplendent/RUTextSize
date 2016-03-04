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
#import "NSNumber+RUConstants.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>





typedef NS_ENUM(NSInteger, RUViewController_UILabel_TextSize__tableView_section) {
	RUViewController_UILabel_TextSize__tableView_section_oneLine,
	RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines,
	RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines,
	RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText,
	
	RUViewController_UILabel_TextSize__tableView_section__first		= RUViewController_UILabel_TextSize__tableView_section_oneLine,
	RUViewController_UILabel_TextSize__tableView_section__last		= RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText,
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
-(nullable NSString*)cellCustomViewLabel_textForSection:(RUViewController_UILabel_TextSize__tableView_section)section;

@end





@implementation RUViewController_UILabel_TextSize

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
	RUViewController_UILabel_TextSize__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	return [self cellForTableSection:tableSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat padding_vertical = [NSNumber ru_padding_general];
	RUViewController_UILabel_TextSize__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	UILabel* labelForSection = [self cellCustomViewLabelForSection:tableSection];
	kRUConditionalReturn_ReturnValue(labelForSection == nil, YES, 0);

	return [labelForSection ruTextSizeConstrainedToWidth:CGRectGetWidth(tableView.frame)].height + (padding_vertical * 2.0f);
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

	[tableViewCell_LabelSizedToText setLabelSizedToText_padding_left:[NSNumber ru_padding_general]];
	[tableViewCell_LabelSizedToText setLabelSizedToText_padding_right:[NSNumber ru_padding_general]];
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
	NSMutableDictionary<NSNumber*,UILabel*>* section_to_cellCustomViewLabel_mapping_cache = self.section_to_cellCustomViewLabel_mapping_cache;
	NSNumber* section_key = @(section);

	UILabel* label = [section_to_cellCustomViewLabel_mapping_cache objectForKey:section_key];
	kRUConditionalReturn_ReturnValue(label != nil, NO, label);

	label = [UILabel new];
	[label setBackgroundColor:[UIColor greenColor]];
	[label setNumberOfLines:[self cellCustomViewLabel_numberOfLines_forSection:section]];
	[label setFont:[UIFont systemFontOfSize:16.0f]];
	[label setTextColor:[UIColor darkTextColor]];
	[label setText:[self cellCustomViewLabel_textForSection:section]];

	[section_to_cellCustomViewLabel_mapping_cache setObject:label forKey:section_key];
	
	return label;
}

-(NSInteger)cellCustomViewLabel_numberOfLines_forSection:(RUViewController_UILabel_TextSize__tableView_section)section
{
	switch (section)
	{
		case RUViewController_UILabel_TextSize__tableView_section_oneLine:
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
			
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_0MaxNumberOfLines:
			return @"Three lines of text\nwith newlines\n0 max number of lines";
			break;
			
		case RUViewController_UILabel_TextSize__tableView_section_threeLinesOfText_withNewlines_3MaxNumberOfLines:
			return @"Three lines of text\nwith newlines\n3 max number of lines";
			break;
			
		case RUViewController_UILabel_TextSize__tableView_section_manyLines_withLongText:
			return @"This text has to be sooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo long, it takes up many lines. Hopefully this is long enough, but honestly, you never know.";
			break;
	}
	
	NSAssert(false, @"unhandled");
	return 0;
}

@end
