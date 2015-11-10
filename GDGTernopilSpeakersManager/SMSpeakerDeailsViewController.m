//
//  SpeakerDeailsViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/9/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMSpeakerDeailsViewController.h"
#import "SMSpeaker.h"
#import "SMAddNewPresentationViewController.h"
#import "SMDataController.h"
#import "SMPresentation.h"
#import "SMPresentationDetailsViewController.h"

@interface SMSpeakerDeailsViewController () < UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SMSpeaker *speaker;
@property (strong, nonatomic) NSArray *speakerPresentations;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;

@end

@implementation SMSpeakerDeailsViewController

- (void)setTheSpeakerForDetails:(SMSpeaker *)speakerForDetails
{
    self.speaker = speakerForDetails;
    NSAssert(self.speaker, @"Speaker must exist!");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.speaker.name;
    self.surnameLabel.text = self.speaker.surname;
    self.experienceLabel.text = [NSString stringWithFormat:@"%@",self.speaker.experience];
    self.birthDateLabel.text = [NSString stringWithFormat:@"%@",self.speaker.birthDate];
    [self setAndSortArrayOfPresentations];
}

- (void)viewWillAppear:(BOOL)animated
{
#warning make it nsfetched res con!
    [[SMDataController sharedController].managedObjectContext refreshObject:self.speaker mergeChanges:YES];
//    self.speaker = [[SMDataController sharedController].managedObjectContext objectWithID:speakerObjectId];
    [self setAndSortArrayOfPresentations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add_new_presentation"])
    {
        UINavigationController *navcCon = (UINavigationController *) segue.destinationViewController;
        SMAddNewPresentationViewController *addPresentationVC = navcCon.viewControllers.firstObject;
        [addPresentationVC setTheSpeakerForPresentation:self.speaker];
    }
}

- (void)setAndSortArrayOfPresentations
{
    self.speakerPresentations = self.speaker.presentation.allObjects;
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    [self.speakerPresentations sortedArrayUsingDescriptors:@[titleSort]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMPresentationDetailsViewController *presentationDetails = (SMPresentationDetailsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SMPresentationDetailsViewController"];
    SMPresentation *selectedPresentation = [self.speakerPresentations objectAtIndex:indexPath.row];
    [presentationDetails setThePresentationForDetails:selectedPresentation];
    [self.navigationController pushViewController:presentationDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SMPresentation *presentation = [self.speakerPresentations objectAtIndex:indexPath.row];
        [[SMDataController sharedController].managedObjectContext deleteObject:presentation];
        [[SMDataController sharedController].managedObjectContext save:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.speakerPresentations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"presentation_cell"];
    SMPresentation *presentation = [self.speakerPresentations objectAtIndex:indexPath.row];
    cell.textLabel.text = presentation.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", presentation.minutes];
    return cell;
}

@end
