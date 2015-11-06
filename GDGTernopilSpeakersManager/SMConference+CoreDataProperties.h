//
//  SMConference+CoreDataProperties.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SMConference.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMConference (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *place;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<SMPresentation *> *presentations;
@property (nullable, nonatomic, retain) NSSet<SMSpeaker *> *speakers;

@end

@interface SMConference (CoreDataGeneratedAccessors)

- (void)addPresentationsObject:(SMPresentation *)value;
- (void)removePresentationsObject:(SMPresentation *)value;
- (void)addPresentations:(NSSet<SMPresentation *> *)values;
- (void)removePresentations:(NSSet<SMPresentation *> *)values;

- (void)addSpeakersObject:(SMSpeaker *)value;
- (void)removeSpeakersObject:(SMSpeaker *)value;
- (void)addSpeakers:(NSSet<SMSpeaker *> *)values;
- (void)removeSpeakers:(NSSet<SMSpeaker *> *)values;

@end

NS_ASSUME_NONNULL_END
