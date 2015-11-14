//
//  SMAddNewConference.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/14/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMAddNewConference.h"
#import "SMConference.h"
#import "SMDataController.h"

@implementation SMAddNewConference

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender
{
    SMConference *conference = [[SMDataController sharedController] insertNewConference];
    conference.title = [self textFromCellAtIndex:0];
    conference.place = [self textFromCellAtIndex:1];
    conference.date = [NSDate date];
    [[SMDataController sharedController].managedObjectContext save:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)textFromCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UITextField *textField = cell.contentView.subviews.firstObject;
    return textField.text;
}
@end
