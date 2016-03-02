//
//  RUViewController.m
//  RUTextSize
//
//  Created by Benjamin Maer on 11/20/2015.
//  Copyright (c) 2015 Benjamin Maer. All rights reserved.
//

#import "RUViewController.h"
#import "RUGenericTableViewCell_CustomView.h"
#import "RUTextViewWithPlaceholderContainerView.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>





typedef NS_ENUM(NSInteger, RUViewController__tableView_section) {
	RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView,
	RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally,
	RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredVertically,
	RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically,

	RUViewController__tableView_section__first		= RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView,
	RUViewController__tableView_section__last		= RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically,
};





@interface RUViewController () <UITableViewDataSource,UITableViewDelegate,RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableView
@property (nonatomic, readonly, nullable) UITableView* tableView;
-(CGRect)tableViewFrame;

#pragma mark - tableSectionManager
@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - Header Label Text
-(nullable NSString*)headerLabelTextForIndexPathSection:(NSInteger)indexPathSection;

#pragma mark - Table View Cells
-(nonnull RUGenericTableViewCell_CustomView*)cellForTableSection:(RUViewController__tableView_section)tableSection;
-(nonnull RUGenericTableViewCell_CustomView*)genericTableViewCell_CustomView_withCustomView:(nonnull UIView*)customView;

#pragma mark - genericTableViewCell_CustomView Custom Views
-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView;
-(void)apply_textCenteredHorizontally_toRUTextViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView;
-(void)apply_textCenteredVertically_toRUTextViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView;

-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally;
-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredVertically;
-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically;

@end





@implementation RUViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.view addSubview:self.tableView];

	_tableSectionManager = [[RTSMTableSectionManager alloc]initWithFirstSection:RUViewController__tableView_section__first
																	lastSection:RUViewController__tableView_section__last];
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
	return UIEdgeInsetsInsetRect(self.view.bounds, (UIEdgeInsets){
		.top	= CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame),
	});
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
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	return [self cellForTableSection:tableSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (tableSection)
	{
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredVertically:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically:
			return 60.0f;
			break;
	}
	
	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:section];
	switch (tableSection)
	{
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
			return 20.0f;
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredVertically:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically:
			return 30.0f;
			break;
	}
	
	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel* headerLabel = [UILabel new];
	[headerLabel setBackgroundColor:[UIColor lightGrayColor]];
	[headerLabel setTextAlignment:NSTextAlignmentCenter];
	[headerLabel setFont:[UIFont systemFontOfSize:12.0f weight:UIFontWeightMedium]];
	[headerLabel setTextColor:[UIColor darkTextColor]];
	[headerLabel setNumberOfLines:0];
	[headerLabel setText:[self headerLabelTextForIndexPathSection:section]];

	return headerLabel;
}

#pragma mark - Header Label Text
-(nullable NSString*)headerLabelTextForIndexPathSection:(NSInteger)indexPathSection
{
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPathSection];
	switch (tableSection)
	{
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
			return @"RUGenericTableViewCell_CustomView";
			break;
			
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally:
			return @"RUGenericTableViewCell_CustomView\ntext centered horizontally";
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredVertically:
			return @"RUGenericTableViewCell_CustomView\ntext centered vertically";
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically:
			return @"RUGenericTableViewCell_CustomView\ntext centered horizontally and vertically";
			break;
	}
	
	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return nil;
}

#pragma mark - Table View Cells
-(nonnull RUGenericTableViewCell_CustomView*)cellForTableSection:(RUViewController__tableView_section)tableSection
{
	switch (tableSection)
	{
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
			return [self genericTableViewCell_CustomView_withCustomView:[self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView]];
			break;
			
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally:
			return [self genericTableViewCell_CustomView_withCustomView:[self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally]];
			break;
			
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredVertically:
			return [self genericTableViewCell_CustomView_withCustomView:[self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredVertically]];
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically:
			return [self genericTableViewCell_CustomView_withCustomView:[self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically]];
			break;
	}

	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return nil;
}

-(nonnull RUGenericTableViewCell_CustomView*)genericTableViewCell_CustomView_withCustomView:(nonnull UIView*)customView
{
	kRUDefineNSStringConstant(RUViewController__tableDequeIdentifier_RUGenericTableViewCell_CustomView);
	RUGenericTableViewCell_CustomView* genericTableViewCell_CustomView = [self.tableView dequeueReusableCellWithIdentifier:RUViewController__tableDequeIdentifier_RUGenericTableViewCell_CustomView];
	if (genericTableViewCell_CustomView == nil)
	{
		genericTableViewCell_CustomView = [[RUGenericTableViewCell_CustomView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RUViewController__tableDequeIdentifier_RUGenericTableViewCell_CustomView];
		[genericTableViewCell_CustomView setSelectionStyle:UITableViewCellSelectionStyleNone];
		[genericTableViewCell_CustomView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
		[genericTableViewCell_CustomView.layer setBorderWidth:1.0f];
	}

	[genericTableViewCell_CustomView setCustomView:customView];
	
	return genericTableViewCell_CustomView;
}

#pragma mark - genericTableViewCell_CustomView Custom Views
-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView
{
	RUTextViewWithPlaceholderContainerView* textViewWithPlaceholderContainerView = [RUTextViewWithPlaceholderContainerView new];
	[textViewWithPlaceholderContainerView.textViewPlaceholderLabel setText:@"Placeholder text"];
	return textViewWithPlaceholderContainerView;
}

-(void)apply_textCenteredHorizontally_toRUTextViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView
{
	kRUConditionalReturn(textViewWithPlaceholderContainerView == nil, YES);

	[textViewWithPlaceholderContainerView.textView setTextAlignment:NSTextAlignmentCenter];
	[textViewWithPlaceholderContainerView.textViewPlaceholderLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)apply_textCenteredVertically_toRUTextViewWithPlaceholderContainerView:(nonnull RUTextViewWithPlaceholderContainerView*)textViewWithPlaceholderContainerView
{
	kRUConditionalReturn(textViewWithPlaceholderContainerView == nil, YES);
	
	[textViewWithPlaceholderContainerView setCenterTextVertically:YES];
}

-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontally
{
	RUTextViewWithPlaceholderContainerView* textViewWithPlaceholderContainerView = [self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView];
	[self apply_textCenteredHorizontally_toRUTextViewWithPlaceholderContainerView:textViewWithPlaceholderContainerView];

	return textViewWithPlaceholderContainerView;
}

-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredVertically
{
	RUTextViewWithPlaceholderContainerView* textViewWithPlaceholderContainerView = [self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView];
	[self apply_textCenteredVertically_toRUTextViewWithPlaceholderContainerView:textViewWithPlaceholderContainerView];
	
	return textViewWithPlaceholderContainerView;
}

-(nonnull RUTextViewWithPlaceholderContainerView*)genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView_textCenteredHorizontallyAndVertically
{
	RUTextViewWithPlaceholderContainerView* textViewWithPlaceholderContainerView = [self genericTableViewCell_CustomView_RUTextViewWithPlaceholderContainerView];
	[self apply_textCenteredHorizontally_toRUTextViewWithPlaceholderContainerView:textViewWithPlaceholderContainerView];
	[self apply_textCenteredVertically_toRUTextViewWithPlaceholderContainerView:textViewWithPlaceholderContainerView];
	
	return textViewWithPlaceholderContainerView;
}

#pragma mark - RTSMTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RTSMTableSectionManager*)tableSectionManager sectionIsAvailable:(NSInteger)section
{
	return YES;
}

@end
