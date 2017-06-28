//
//  RUViewController.m
//  RUTextSize
//
//  Created by Benjamin Maer on 11/20/2015.
//  Copyright (c) 2015 Benjamin Maer. All rights reserved.
//

#import "RUViewController.h"
#import "RUTextViewWithPlaceholderContainerView.h"
#import "RUViewController_RUTextViewWithPlaceholderContainerView.h"
#import "RUViewController_UILabel_TextSize.h"
#import "RUViewController_Styling.h"

#import <ResplendentUtilities/NSString+RUMacros.h>
#import <ResplendentUtilities/RUConditionalReturn.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>





typedef NS_ENUM(NSInteger, RUViewController__tableView_section) {
	RUViewController__tableView_section_UILabel_textSize,
	RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView,
	RUViewController__tableView_section_styling,

	RUViewController__tableView_section__first		= RUViewController__tableView_section_UILabel_textSize,
	RUViewController__tableView_section__last		= RUViewController__tableView_section_styling,
};





@interface RUViewController () <UITableViewDataSource,UITableViewDelegate,RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableView
@property (nonatomic, readonly, nullable) UITableView* tableView;
-(CGRect)tableViewFrame;

#pragma mark - tableSectionManager
@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - cell Text
-(nullable NSString*)cellTextForSection:(RUViewController__tableView_section)section;

#pragma mark - Table View Cells
-(nonnull UITableViewCell*)cellForTableSection:(RUViewController__tableView_section)tableSection;

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

	[self.view setBackgroundColor:[UIColor whiteColor]];

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
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	return [self cellForTableSection:tableSection];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (tableSection)
	{
		case RUViewController__tableView_section_UILabel_textSize:
		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
		case RUViewController__tableView_section_styling:
			return 30.0f;
			break;
	}
	
	NSAssert(false, @"unhandled tableSection %li",(long)tableSection);
	return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController__tableView_section tableSection = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (tableSection)
	{
		case RUViewController__tableView_section_UILabel_textSize:
			[self.navigationController pushViewController:[RUViewController_UILabel_TextSize new] animated:YES];
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
			[self.navigationController pushViewController:[RUViewController_RUTextViewWithPlaceholderContainerView new] animated:YES];
			break;

		case RUViewController__tableView_section_styling:
			[self.navigationController pushViewController:[RUViewController_Styling new] animated:YES];
			break;
	}
}

#pragma mark - Header Label Text
-(nullable NSString*)cellTextForSection:(RUViewController__tableView_section)section
{
	switch (section)
	{
		case RUViewController__tableView_section_UILabel_textSize:
			return @"UILabel - Text Size";
			break;

		case RUViewController__tableView_section_RUTextViewWithPlaceholderContainerView:
			return @"RUGenericTableViewCell_CustomView";
			break;

		case RUViewController__tableView_section_styling:
			return NSStringFromClass([RUViewController_Styling class]);
			break;
	}
	
	NSAssert(false, @"unhandled tableSection %li",(long)section);
	return nil;
}

#pragma mark - Table View Cells
-(nonnull UITableViewCell*)cellForTableSection:(RUViewController__tableView_section)tableSection
{
	kRUDefineNSStringConstant(RUViewController__tableDequeIdentifier_UITableViewCell);
	UITableViewCell* genericTableViewCell_CustomView = [self.tableView dequeueReusableCellWithIdentifier:RUViewController__tableDequeIdentifier_UITableViewCell];
	if (genericTableViewCell_CustomView == nil)
	{
		genericTableViewCell_CustomView = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RUViewController__tableDequeIdentifier_UITableViewCell];
		[genericTableViewCell_CustomView setSelectionStyle:UITableViewCellSelectionStyleNone];
		[genericTableViewCell_CustomView.layer setBorderColor:[UIColor darkGrayColor].CGColor];
		[genericTableViewCell_CustomView.layer setBorderWidth:1.0f];
	}
	
	[genericTableViewCell_CustomView.textLabel setText:[self cellTextForSection:tableSection]];
	
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
