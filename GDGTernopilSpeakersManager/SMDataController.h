//
//  SMDataController.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SMSpeaker;
@class SMPresentation;
@class SMConference;
@import CoreData;

@interface SMDataController : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedController;
- (NSString *)uuid;

- (SMSpeaker *)insertNewSpeaker;
- (NSString *)speakerEntityName;

- (SMPresentation *)insertNewPresentation;
- (NSString *)presentationEntityName;

- (SMConference *)insertNewConference;
- (NSString *)conferenceEntityName;

- (SMSpeaker *)insertNewSpeakerInContext:(NSManagedObjectContext *)context;

- (SMPresentation *)insertNewPresentationInContext:(NSManagedObjectContext *)context;

- (SMConference *)insertNewConferenceInContext:(NSManagedObjectContext *)context;
@end
