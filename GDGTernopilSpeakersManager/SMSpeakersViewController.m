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

@interface SMSpeakersViewController () < NSFetchedResultsControllerDelegate >

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SMSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#warning ;dsfksdjfks
    SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeaker];
    speaker.name = @"ONE";
    [[SMDataController sharedController].managedObjectContext save:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speaker_cell"];
    SMSpeaker *speaker = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",speaker.surname, speaker.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",speaker.presentation.count];
    return cell;
}

@end
