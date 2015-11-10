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

@interface SMSpeakerDeailsViewController ()

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add_new_presentation"])
    {
        UINavigationController *navcCon = (UINavigationController *) segue.destinationViewController;
        SMAddNewPresentationViewController *addPresentationVC = navcCon.viewControllers.firstObject;
        [addPresentationVC setTheSpeakerForPresentation:self.speaker];
    }
}

@end
