//
//  SMAddNewPresentationViewController.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/10/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMSpeaker;


@interface SMAddNewPresentationViewController : UITableViewController

- (void)setTheSpeakerForPresentation:(SMSpeaker *)speaker;

@end
