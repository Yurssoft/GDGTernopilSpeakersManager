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
#include <stdlib.h>

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
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t sem = dispatch_semaphore_create(2);
        dispatch_group_async(group, backgroundQueue, ^{
            dispatch_apply(20000, backgroundQueue, ^(size_t i)
                           {
                               SMConference *conference = [[SMDataController sharedController] insertNewConferenceInContext:backgroundContextForCreatingObjects];
                               conference.place         = [NSString stringWithFormat:@"place %@", [NSDate date]];
                               conference.title         = [NSString stringWithFormat:@"title %ld", (long)i * arc4random_uniform(777)];
                               conference.date          = [NSDate date];
                               dispatch_apply(2, backgroundQueue, ^(size_t j)
                                              {
                                                  SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeakerInContext:backgroundContextForCreatingObjects];
                                                  speaker.name       = [NSString stringWithFormat:@"name %ld", (long)j * arc4random_uniform(777)];
                                                  speaker.surname    = [NSString stringWithFormat:@"surname %ld", (long)j * arc4random_uniform(777)];
                                                  speaker.experience = @(j);
                                                  speaker.birthDate  = @(j);
                                                  NSMutableSet *conferenceSpeakers = [conference mutableSetValueForKey:@"speakers"];
                                                  [conferenceSpeakers addObject:speaker];
                                              });
                           });
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_group_notify(group, backgroundQueue, ^{
            if ([backgroundContextForCreatingObjects hasChanges])
            {
                NSError *error = nil;
                [backgroundContextForCreatingObjects save:&error];
            }
        });
    });
}

- (void)managedObjectContextDidSave:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SMDataController sharedController].managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

@end
