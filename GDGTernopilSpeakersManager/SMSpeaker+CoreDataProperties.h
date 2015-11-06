//
//  SMSpeaker+CoreDataProperties.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SMSpeaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMSpeaker (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *birthDate;
@property (nullable, nonatomic, retain) NSNumber *experience;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *surname;
@property (nullable, nonatomic, retain) NSSet<SMConference *> *conferences;
@property (nullable, nonatomic, retain) NSSet<SMPresentation *> *presentation;

@end

@interface SMSpeaker (CoreDataGeneratedAccessors)

- (void)addConferencesObject:(SMConference *)value;
- (void)removeConferencesObject:(SMConference *)value;
- (void)addConferences:(NSSet<SMConference *> *)values;
- (void)removeConferences:(NSSet<SMConference *> *)values;

- (void)addPresentationObject:(SMPresentation *)value;
- (void)removePresentationObject:(SMPresentation *)value;
- (void)addPresentation:(NSSet<SMPresentation *> *)values;
- (void)removePresentation:(NSSet<SMPresentation *> *)values;

@end

NS_ASSUME_NONNULL_END
