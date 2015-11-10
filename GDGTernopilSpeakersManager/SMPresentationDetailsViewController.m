//
//  SMPresentationDetailsViewController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/10/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMPresentationDetailsViewController.h"
#import "SMPresentation.h"

@interface SMPresentationDetailsViewController ()

@property (strong, nonatomic) SMPresentation *presentation;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation SMPresentationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.presentation.title;
    self.minutesLabel.text = [NSString stringWithFormat:@"%@",self.presentation.minutes];
    self.commentLabel.text = self.presentation.comments;
}

- (void)setThePresentationForDetails:(SMPresentation *)presentationForDetails
{
    self.presentation = presentationForDetails;
    NSAssert(self.presentation, @"Presentation must be set");
}

@end
