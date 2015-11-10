//
//  ViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/5/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMSpeakersViewController.h"
#import "SMDataController.h"
#import "SMSpeaker.h"
#import "SMSpeakerDeailsViewController.h"

@interface SMSpeakersViewController () < NSFetchedResultsControllerDelegate >

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SMSpeakersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Accessors

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[SMDataController sharedController] speakerEntityName]];
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"surname" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[lastNameSort];
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
    SMSpeakerDeailsViewController *speakerDetails = (SMSpeakerDeailsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SMSpeakerDeailsViewController"];
    SMSpeaker *selectedSpeaker = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [speakerDetails setTheSpeakerForDetails:selectedSpeaker];
    [self.navigationController pushViewController:speakerDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SMSpeaker *speaker = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[SMDataController sharedController].managedObjectContext deleteObject:speaker];
#warning check
        [[SMDataController sharedController].managedObjectContext save:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speaker_cell"];
    SMSpeaker *speaker = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",speaker.surname, speaker.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",speaker.presentation.count];
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
