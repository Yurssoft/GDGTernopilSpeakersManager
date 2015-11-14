//
//  SMDataController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMDataController.h"
#import "SMSpeaker.h"
#import "SMPresentation.h"
#import "SMConference.h"

@interface SMDataController ()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation SMDataController

+ (instancetype)sharedController
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [self new];
        [_sharedInstance initializeCoreData];
    });
    
    return _sharedInstance;
}

- (void)initializeCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SpeakersManagerDataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;
    _managedObjectContext = moc;
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"SpeakersManager.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = _managedObjectContext.persistentStoreCoordinator;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        _managedObjectContext.undoManager = [NSUndoManager new];
    });
}

#pragma mark - Public

- (SMSpeaker *)insertNewSpeaker
{
    SMSpeaker *speaker = (SMSpeaker *) [NSEntityDescription insertNewObjectForEntityForName:[self speakerEntityName]
                                                                     inManagedObjectContext:self.managedObjectContext];
    speaker.speakerId = [self uuid];
    return speaker;
}

- (NSString *)speakerEntityName
{
    return @"SMSpeaker";
}

- (SMPresentation *)insertNewPresentation
{
    SMPresentation *presentation = (SMPresentation *) [NSEntityDescription insertNewObjectForEntityForName:[self presentationEntityName]
                                                                                    inManagedObjectContext:self.managedObjectContext];
    presentation.presentationId = [self uuid];
    return presentation;
}

- (NSString *)presentationEntityName
{
    return @"SMPresentation";
}

- (SMConference *)insertNewConference
{
    SMConference *conference = (SMConference *) [NSEntityDescription insertNewObjectForEntityForName:[self conferenceEntityName]
                                                                              inManagedObjectContext:self.managedObjectContext];
    conference.conferenceId = [self uuid];
    return conference;
}

- (NSString *)conferenceEntityName
{
    return @"SMConference";
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

#pragma mark - Private


@end
