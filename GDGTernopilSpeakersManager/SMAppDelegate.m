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
//    [self populateDatabase];
    return YES;
}

- (void)populateDatabase
{
    [[SMDataController sharedController].managedObjectContext performBlock:^{
        //populating database
        for (NSInteger i = 0; i < 1500; i++)
        {
            SMConference *conference = [[SMDataController sharedController] insertNewConference];
            conference.title         = [NSString stringWithFormat:@"title %@", [NSDate date]];
            conference.place         = [NSString stringWithFormat:@"place %ld", (long)i];
            conference.date          = [NSDate date];
            
            for (NSInteger j = 0; j < 10; j++)
            {
                SMSpeaker *speaker = [[SMDataController sharedController] insertNewSpeaker];
                speaker.name       = [NSString stringWithFormat:@"name %ld", (long)j];
                speaker.surname    = [NSString stringWithFormat:@"surname %ld", (long)j];
                speaker.experience = @(j);
                speaker.birthDate  = @(j);
                NSMutableSet *conferenceSpeakers = [conference mutableSetValueForKey:@"speakers"];
                [conferenceSpeakers addObject:speaker];
                for (NSInteger k = 0; k < 5; k++)
                {
                    SMPresentation *presentation = [[SMDataController sharedController] insertNewPresentation];
                    presentation.title = [NSString stringWithFormat:@"title %ld", (long)k];
                    presentation.comments = [NSString stringWithFormat:@"comments %ld", (long)k];
                    presentation.minutes = @(k);
                    presentation.speaker = speaker;
                }
            }
        }
        [[SMDataController sharedController].managedObjectContext save:nil];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
