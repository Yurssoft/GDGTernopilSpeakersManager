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

@interface SMSpeakersViewController ()

@end

@implementation SMSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeaker];
    speaker.name = @"ONE";
    [[SMDataController sharedController].managedObjectContext save:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"speaker_cell"];
    cell.detailTextLabel.text = @"LOL";
    return cell;
}

@end
