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

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SMSpeaker *speaker;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;

@end

@implementation SMSpeakerDeailsViewController

- (void)setTheSpeakerForDetails:(SMSpeaker *)speakerForDetails
{
    self.speaker = speakerForDetails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = self.speaker.name;
    self.surnameLabel.text = self.speaker.surname;
    self.experienceLabel.text = [NSString stringWithFormat:@"%@",self.speaker.experience];
    self.birthDateLabel.text = [NSString stringWithFormat:@"%@",self.speaker.birthDate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        UIAlertController *fetchError = [UIAlertController alertControllerWithTitle:@"Failed to initialize FetchedResultsController"
                                                                            message:[NSString stringWithFormat:@"%@\n%@", [error localizedDescription], [error userInfo]]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [fetchError addAction:okAction];
        [self.navigationController presentViewController:fetchError animated:YES completion:nil];
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
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
#pragma mark - Accessors

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[SMDataController sharedController] presentationEntityName]];
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[titleSort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.speaker.speakerId == %@", _speaker.speakerId];
    request.predicate = predicate;
    NSManagedObjectContext *moc = [SMDataController sharedController].managedObjectContext;
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                    managedObjectContext:moc
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMPresentationDetailsViewController *presentationDetails = (SMPresentationDetailsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SMPresentationDetailsViewController"];
    SMPresentation *selectedPresentation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [presentationDetails setThePresentationForDetails:selectedPresentation];
    [self.navigationController pushViewController:presentationDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SMPresentation *presentation = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[SMDataController sharedController].managedObjectContext deleteObject:presentation];
        [[SMDataController sharedController].managedObjectContext save:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"presentation_cell"];
    SMPresentation *presentation = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = presentation.title;
    cell.detailTextLabel.text = presentation.comments;
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
