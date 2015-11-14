//
//  SMConferenceDetailsViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/14/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMConferenceDetailsViewController.h"
#import "SMConference.h"
#import "SMSpeakersViewController.h"

@interface SMConferenceDetailsViewController ()

@property (strong, nonatomic) SMConference *conference;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SMConferenceDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.conference.title;
    self.placeLabel.text = self.conference.place;
    self.dateLabel.text = self.conference.date.description;
}

- (void)setTheConferenceForDetails:(SMConference *)conferenceForDetails
{
    self.conference = conferenceForDetails;
}

- (IBAction)speakersButtonPressed:(UIButton *)sender
{
    NSString *speakers = @"SMSpeakersViewController";
    SMSpeakersViewController *speakerVC = (SMSpeakersViewController *) [self.storyboard instantiateViewControllerWithIdentifier:speakers];
    [speakerVC setTheConferenceForSpeakers:self.conference];
    [self.navigationController pushViewController:speakerVC animated:YES];
}

@end
