//
//  AppDelegate.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/5/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMDataController.h"
#import "SMSpeaker.h"
#import "SMPresentation.h"
#import "SMConference.h"

@interface SMAppDelegate ()

@end

@implementation SMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    //uncomment this for database populating
    [self populateDatabase];
    return YES;
}

- (void)populateDatabase
{
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_BACKGROUND, 0);
    dispatch_queue_t backgroundQueue = dispatch_queue_create("sm.private.coredata.creating.queue", attr);
    __block NSManagedObjectContext *backgroundContextForCreatingObjects;
    NSPersistentStoreCoordinator *coordinator = [SMDataController sharedController].managedObjectContext.persistentStoreCoordinator;
    dispatch_async(backgroundQueue, ^{
        backgroundContextForCreatingObjects = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgroundContextForCreatingObjects.persistentStoreCoordinator = coordinator;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:backgroundContextForCreatingObjects];
        for (NSInteger i = 0; i < 15; i++)
        {
            SMConference *conference = [[SMDataController sharedController] insertNewConferenceInContext:backgroundContextForCreatingObjects];
            conference.title         = [NSString stringWithFormat:@"title %@", [NSDate date]];
            conference.place         = [NSString stringWithFormat:@"place %ld", (long)i];
            conference.date          = [NSDate date];
            
            for (NSInteger j = 0; j < 7; j++)
            {
                SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeakerInContext:backgroundContextForCreatingObjects];
                speaker.name       = [NSString stringWithFormat:@"name %ld", (long)j];
                speaker.surname    = [NSString stringWithFormat:@"surname %ld", (long)j];
                speaker.experience = @(j);
                speaker.birthDate  = @(j);
                NSMutableSet *conferenceSpeakers = [conference mutableSetValueForKey:@"speakers"];
                [conferenceSpeakers addObject:speaker];
                for (NSInteger k = 0; k < 3; k++)
                {
                    SMPresentation *presentation = [[SMDataController sharedController] insertNewPresentationInContext:backgroundContextForCreatingObjects];
                    presentation.title = [NSString stringWithFormat:@"title %ld", (long)k];
                    presentation.comments = [NSString stringWithFormat:@"comments %ld", (long)k];
                    presentation.minutes = @(k);
                    presentation.speaker = speaker;
                }
            }
        }
        if ([backgroundContextForCreatingObjects hasChanges]) {
            // Save Changes
            NSError *error = nil;
            [backgroundContextForCreatingObjects save:&error];
        }
    });
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SMDataController sharedController].managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

@end
