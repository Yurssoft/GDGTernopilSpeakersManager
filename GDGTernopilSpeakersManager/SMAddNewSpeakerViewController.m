//
//  SMAddNewSpeakerViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/10/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMAddNewSpeakerViewController.h"
#import "SMDataController.h"
#import "SMSpeaker.h"

@interface SMAddNewSpeakerViewController ()

@end

@implementation SMAddNewSpeakerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeaker];
    speaker.name = [self textFromCellAtIndex:0];
    speaker.surname = [self textFromCellAtIndex:1];
    speaker.experience = @([self textFromCellAtIndex:2].doubleValue);
    speaker.birthDate = @([self textFromCellAtIndex:3].doubleValue);
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
