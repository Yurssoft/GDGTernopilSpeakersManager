//
//  SMConfernceViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/14/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//
@import CoreData;
#import "SMConfernceViewController.h"
#import "SMDataController.h"
#import "SMConferenceDetailsViewController.h"
#import "SMSpeaker.h"
#import "SMPresentation.h"
#import "SMConference.h"

static void *ProgressContext = &ProgressContext;

@interface SMConfernceViewController () < NSFetchedResultsControllerDelegate >

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusButton;

@end

@implementation SMConfernceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:
                               [[SMDataController sharedController] conferenceEntityName]];
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                ascending:NO
                                                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[titleSort];
    request.fetchBatchSize = 60;
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc]
                                                            initWithFetchRequest:request
                                                            completionBlock:^(NSAsynchronousFetchResult *result) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    [result.progress removeObserver:weakSelf forKeyPath:@"completedUnitCount" context:ProgressContext];
                                                                    [weakSelf.fetchedResultsController performFetch:nil];
                                                                    [weakSelf.tableView reloadData];
                                                                    NSString *status = [NSString stringWithFormat:@"Fetched %li Records", weakSelf.fetchedResultsController.fetchedObjects.count];
                                                                    self.statusButton.title = status;
                                                                });
                                                            }];
    
    [[SMDataController sharedController].managedObjectContext performBlock:^{
        
        NSProgress *progress = [NSProgress progressWithTotalUnitCount:1];
        
        [progress becomeCurrentWithPendingUnitCount:1];
        
        NSError *asynchronousFetchRequestError = nil;
        NSAsynchronousFetchResult *asynchronousFetchResult = (NSAsynchronousFetchResult *)
                                                [[SMDataController sharedController].managedObjectContext
                                                executeRequest:asynchronousFetchRequest
                                                 error:&asynchronousFetchRequestError];
        //for warning dismiss
        if (asynchronousFetchResult){;}
        
        if (asynchronousFetchRequestError)
            NSLog(@"%@, %@", asynchronousFetchRequestError, asynchronousFetchRequestError.localizedDescription);
        
        [asynchronousFetchResult.progress addObserver:self forKeyPath:@"completedUnitCount" options:NSKeyValueObservingOptionNew context:ProgressContext];
        
        [progress resignCurrent];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == ProgressContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *status = [NSString stringWithFormat:@"Fetched %li Records", (long)[[change objectForKey:@"new"] integerValue]];
            self.statusButton.title = status;
        });
    }
}

#pragma mark - Accessors

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:
                               [[SMDataController sharedController] conferenceEntityName]];
    NSSortDescriptor *titleSort = [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                ascending:NO
                                                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[titleSort];
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
    SMConferenceDetailsViewController *conferenceDetails = (SMConferenceDetailsViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"SMConferenceDetailsViewController"];
    SMConference *selectedConference = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [conferenceDetails setTheConferenceForDetails:selectedConference];
    [self.navigationController pushViewController:conferenceDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SMConference *conference = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[SMDataController sharedController].managedObjectContext deleteObject:conference];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conference_cell"];
    SMConference *conference = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conference.title;
    cell.detailTextLabel.text = conference.place;
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    [self.tableView reloadData];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - Undo manager

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSUndoManager*)undoManager
{
    return [SMDataController sharedController].managedObjectContext.undoManager;
}

@end
