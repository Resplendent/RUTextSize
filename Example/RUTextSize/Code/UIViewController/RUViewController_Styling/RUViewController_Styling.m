//
//  RUViewController_Styling.m
//  RUTextSize
//
//  Created by Benjamin Maer on 6/28/17.
//  Copyright © 2017 Benjamin Maer. All rights reserved.
//

#import "RUViewController_Styling.h"
#import "RUTableViewCell_LabelSizedToText.h"
#import "NSNumber+RUExampleConstants.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/NSString+RUMacros.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>

#import <RUTextSize/UILabel+RUTextSize.h>
#import <RUTextSize/RUAttributesDictionaryBuilder.h>





typedef NS_ENUM(NSInteger, RUViewController_Styling__tableSection) {
	RUViewController_Styling__tableSection_underline,
	RUViewController_Styling__tableSection_strikethrough,
	
	RUViewController_Styling__tableSection__first	= RUViewController_Styling__tableSection_underline,
	RUViewController_Styling__tableSection__last	= RUViewController_Styling__tableSection_strikethrough,
};





@interface RUViewController_Styling () <UITableViewDataSource, UITableViewDelegate, RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableView
@property (nonatomic, readonly, nullable) UITableView* tableView;
-(CGRect)tableView_frame;

#pragma mark - tableSectionManager
@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - Table View Cells
-(nonnull RUTableViewCell_LabelSizedToText*)cell_for_tableSection:(RUViewController_Styling__tableSection)tableSection;

#pragma mark - section_to_cellCustomViewLabel_mapping_cache
@property (nonatomic, readonly, nonnull) NSMutableDictionary<NSNumber*,UILabel*>* section_to_cellCustomViewLabel_mapping_cache;

#pragma mark - cell custom view label
-(nonnull UILabel*)cellCustomViewLabel_for_tableSection:(RUViewController_Styling__tableSection)section;
-(nullable NSAttributedString*)cellCustomViewLabel_attributedText_for_tableSection:(RUViewController_Styling__tableSection)section;

#pragma mark - Paddings
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_top;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_bottom;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_left;
+(CGFloat)RUTableViewCell_LabelSizedToText_padding_right;

@end





@implementation RUViewController_Styling

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
	
	_tableSectionManager = [[RTSMTableSectionManager alloc]initWithFirstSection:RUViewController_Styling__tableSection__first
																	lastSection:RUViewController_Styling__tableSection__last];
	[self.tableSectionManager setSectionDelegate:self];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	[self.tableView setFrame:self.tableView_frame];
}

#pragma mark - tableView
-(CGRect)tableView_frame
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
	return [self cell_for_tableSection:[self.tableSectionManager sectionForIndexPathSection:indexPath.section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat const padding_vertical_top = [[self class]RUTableViewCell_LabelSizedToText_padding_top];
	CGFloat const padding_vertical_bottom = [[self class]RUTableViewCell_LabelSizedToText_padding_bottom];
	
	RUViewController_Styling__tableSection const tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	UILabel* const labelForSection = [self cellCustomViewLabel_for_tableSection:tableSection];
	kRUConditionalReturn_ReturnValue(labelForSection == nil, YES, 0);
	
	CGRect const tableView_frame = self.tableView_frame;
	
	CGFloat const constrainedWidth = CGRectGetWidth(tableView_frame) - [[self class]RUTableViewCell_LabelSizedToText_padding_left] - [[self class]RUTableViewCell_LabelSizedToText_padding_right];
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
-(nonnull RUTableViewCell_LabelSizedToText*)cell_for_tableSection:(RUViewController_Styling__tableSection)tableSection
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
	[tableViewCell_LabelSizedToText setLabelSizedToText:[self cellCustomViewLabel_for_tableSection:tableSection]];
	
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
-(nonnull UILabel*)cellCustomViewLabel_for_tableSection:(RUViewController_Styling__tableSection)section
{
	
	NSMutableDictionary<NSNumber*,UILabel*>* const section_to_cellCustomViewLabel_mapping_cache = self.section_to_cellCustomViewLabel_mapping_cache;
	NSNumber* const section_key = @(section);
	
	UILabel* label = [section_to_cellCustomViewLabel_mapping_cache objectForKey:section_key];
	kRUConditionalReturn_ReturnValue(label != nil, NO, label);
	
	label = [UILabel new];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont systemFontOfSize:16.0f]];
	[label setTextColor:[UIColor darkTextColor]];
	[label setAttributedText:[self cellCustomViewLabel_attributedText_for_tableSection:section]];
	[label setNumberOfLines:2];
	[label setTextAlignment:NSTextAlignmentCenter];
	
	[section_to_cellCustomViewLabel_mapping_cache setObject:label forKey:section_key];
	
	return label;
}

-(nullable NSAttributedString*)cellCustomViewLabel_attributedText_for_tableSection:(RUViewController_Styling__tableSection)section
{
	switch (section)
	{
		case RUViewController_Styling__tableSection_underline:
		{
			NSMutableAttributedString* const mutableAttributedString = [NSMutableAttributedString new];
			
			RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
			[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"the last word will have " attributes:[attributesDictionaryBuilder attributesDictionary_generate]]];

			[attributesDictionaryBuilder setUnderlineStyle:NSUnderlineStyleSingle | NSUnderlinePatternSolid];
			[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"underline" attributes:[attributesDictionaryBuilder attributesDictionary_generate]]];

			return [[NSAttributedString alloc] initWithAttributedString:mutableAttributedString];
		}
			break;

		case RUViewController_Styling__tableSection_strikethrough:
		{
			NSMutableAttributedString* const mutableAttributedString = [NSMutableAttributedString new];

			RUAttributesDictionaryBuilder* const attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
			[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"the last word will have " attributes:[attributesDictionaryBuilder attributesDictionary_generate]]];
			
			[attributesDictionaryBuilder setStrikethroughStyle:NSUnderlineStyleSingle | NSUnderlinePatternSolid];
			[mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"strikethrough" attributes:[attributesDictionaryBuilder attributesDictionary_generate]]];

			return [[NSAttributedString alloc] initWithAttributedString:mutableAttributedString];
		}
			break;
	}
	
	NSAssert(false, @"unhandled");
	return 0;
}

@end
