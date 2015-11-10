//
//  SMAddNewPresentationViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/10/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMAddNewPresentationViewController.h"
#import "SMDataController.h"
#import "SMPresentation.h"
@class SMSpeaker;

@interface SMAddNewPresentationViewController ()
@property (strong, nonatomic) SMSpeaker *speakerForPresentation;
@end

@implementation SMAddNewPresentationViewController

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
    NSAssert(self.speakerForPresentation, @"Speaker must be created!");
    SMPresentation *presentation = [[SMDataController sharedController] insertNewPresentation];
    presentation.title = [self textFromCellAtIndex:0];
    presentation.minutes = @([self textFromCellAtIndex:1].doubleValue);
    presentation.comments = [self textFromCellAtIndex:2];
    presentation.speaker = self.speakerForPresentation;
    [[SMDataController sharedController].managedObjectContext save:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)textFromCellAtIndex:(NSInteger)index
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UITextField *textField = cell.contentView.subviews.firstObject;
    return textField.text;
}

#pragma mark - Public

- (void)setTheSpeakerForPresentation:(SMSpeaker *)speaker
{
    self.speakerForPresentation = speaker;
    NSAssert(self.speakerForPresentation, @"Speaker must be created!");
}

@end
