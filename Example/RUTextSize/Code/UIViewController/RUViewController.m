//
//  RUViewController.m
//  RUTextSize
//
//  Created by Lee Pollard on 04/28/2015.
//  Copyright (c) 2014 Lee Pollard. All rights reserved.
//

#import "RUViewController.h"
#import "RUTableViewCell_RUTextViewWithPlaceholderContainerView.h"
#import "RUTextViewWithPlaceholderContainerView.h"
#import "RUAttributesDictionaryBuilder.h"
#import "NSString+RUTextSize.h"

#import <UIColor+RUUtility.h>
#import <RUTableSectionManager.h>
#import <RUConstants.h>





typedef NS_ENUM(NSInteger, RUViewController_table_sectionType) {
	RUViewController_table_sectionType_textViewWithPlaceholderContainerView,
	RUViewController_table_sectionType_textViewWithPlaceholderContainerView_verticallyCentered,
	
	RUViewController_table_sectionType__first		= RUViewController_table_sectionType_textViewWithPlaceholderContainerView,
	RUViewController_table_sectionType__last		= RUViewController_table_sectionType_textViewWithPlaceholderContainerView_verticallyCentered,
};





@interface RUViewController () <UITableViewDataSource,UITableViewDelegate,RUTableSectionManager_SectionDelegate>

@property (nonatomic, readonly) RUTableSectionManager* tableSectionManager;

@property (nonatomic, readonly) UITableView* tableView;
@property (nonatomic, readonly) CGRect tableViewFrame;
@property (nonatomic, readonly) UIEdgeInsets tableViewContentInset;

@property (nonatomic, readonly) UITapGestureRecognizer* tapGesture;
-(void)didTap_tapGesture;

-(NSString *)titleForHeaderInSection:(NSInteger)section;
-(UIFont*)fontForHeader;

-(RUTableViewCell_RUTextViewWithPlaceholderContainerView*)tableViewCell_RUTextViewWithPlaceholderContainerView_verticallyCentered:(BOOL)verticallyCentered;

@end





@implementation RUViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	_tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap_tapGesture)];
	[self.view addGestureRecognizer:self.tapGesture];

	_tableSectionManager = [[RUTableSectionManager alloc]initWithFirstSection:RUViewController_table_sectionType__first lastSection:RUViewController_table_sectionType__last];
	[self.tableSectionManager setSectionDelegate:self];
	
	_tableView = [UITableView new];
	[self.tableView setBackgroundColor:self.view.backgroundColor];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	[self.tableView setFrame:self.tableViewFrame];
	[self.tableView setContentInset:self.tableViewContentInset];
}

#pragma mark - Frames
-(CGRect)tableViewFrame
{
	return self.view.bounds;
}

-(UIEdgeInsets)tableViewContentInset
{
	return (UIEdgeInsets){
		.top	= CGRectGetHeight([UIApplication sharedApplication].statusBarFrame),
	};
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.tableSectionManager.numberOfSectionsAvailable;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController_table_sectionType sectionType = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (sectionType)
	{
		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView:
			return [self tableViewCell_RUTextViewWithPlaceholderContainerView_verticallyCentered:NO];
			break;

		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView_verticallyCentered:
			return [self tableViewCell_RUTextViewWithPlaceholderContainerView_verticallyCentered:YES];
			break;
	}

	NSAssert(false, @"unhandled");
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RUViewController_table_sectionType sectionType = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];
	switch (sectionType)
	{
		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView:
		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView_verticallyCentered:
			return [RUTableViewCell_RUTextViewWithPlaceholderContainerView cellHeight];
			break;
	}
	
	NSAssert(false, @"unhandled");
	return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel* label = [UILabel new];
	[label setText:[self titleForHeaderInSection:section]];
	[label setFont:[self fontForHeader]];
	[label setBackgroundColor:[UIColor colorWithWhite:0.5f alpha:0.5f]];
	[label setTextColor:[UIColor blackColor]];
	[label setNumberOfLines:0.0f];
	return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	static CGFloat const padding_vertical = 2.0f;

	RUAttributesDictionaryBuilder* attributesDictionaryBuilder = [RUAttributesDictionaryBuilder new];
	[attributesDictionaryBuilder setFont:[self fontForHeader]];

	NSString* title = [self titleForHeaderInSection:section];
	CGFloat textHeight = [title ruTextSizeWithBoundingWidth:CGRectGetWidth(tableView.bounds) attributes:[attributesDictionaryBuilder createAttributesDictionary]].height;
	return textHeight + (padding_vertical * 2.0f);
}

#pragma mark - Header Titles
-(NSString *)titleForHeaderInSection:(NSInteger)section
{
	RUViewController_table_sectionType sectionType = [self.tableSectionManager sectionForIndexPathSection:section];
	switch (sectionType)
	{
		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView:
			return @"RUTextViewWithPlaceholderContainerView";
			break;

		case RUViewController_table_sectionType_textViewWithPlaceholderContainerView_verticallyCentered:
			return @"RUTextViewWithPlaceholderContainerView - vertically centered";
			break;
	}
	
	NSAssert(false, @"unhandled");
	return nil;
}

-(UIFont*)fontForHeader
{
	return [UIFont systemFontOfSize:12.0f];
}

#pragma mark - RUTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RUTableSectionManager *)tableSectionManager sectionIsAvailable:(NSInteger)section
{
	return YES;
}

#pragma mark - Gesture Actions
-(void)didTap_tapGesture
{
	[self.view endEditing:YES];
}

#pragma mark - Cells
-(RUTableViewCell_RUTextViewWithPlaceholderContainerView*)tableViewCell_RUTextViewWithPlaceholderContainerView_verticallyCentered:(BOOL)verticallyCentered
{
	NSString* cellIdenifier = RUStringWithFormat(@"cellIdenifier-%@",NSStringFromClass([RUTableViewCell_RUTextViewWithPlaceholderContainerView class]));
	RUTableViewCell_RUTextViewWithPlaceholderContainerView* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdenifier];
	
	if (cell == nil)
	{
		cell = [[RUTableViewCell_RUTextViewWithPlaceholderContainerView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenifier];
		[cell.textViewWithPlaceholderContainerView.textViewPlaceholderLabel setText:@"Placeholder text"];
	}

	[cell.textViewWithPlaceholderContainerView setCenterTextVertically:verticallyCentered];
	
	return cell;
}

@end
