//
//  ViewController.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/5/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMConference;

@interface SMSpeakersViewController : UITableViewController

- (void)setTheConferenceForSpeakers:(SMConference *)conferenceForSpeakers;

@end

