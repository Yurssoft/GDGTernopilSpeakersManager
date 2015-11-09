//
//  SMDataController.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  SMSpeaker;
@import CoreData;

@interface SMDataController : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedController;

- (SMSpeaker *)insertNewSpeaker;
- (NSString *)speakerEntityName;

@end
