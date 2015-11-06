//
//  SMDataController.m
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import "SMDataController.h"

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
    });
}

#pragma mark - Public

- (SMSpeaker *)insertNewSpeaker
{
    return (SMSpeaker *) [NSEntityDescription insertNewObjectForEntityForName:[self speakerEntityName]
                                                       inManagedObjectContext:self.managedObjectContext];
}

#pragma mark - Private

- (NSString *)speakerEntityName
{
    return @"SMSpeaker";
}

@end
