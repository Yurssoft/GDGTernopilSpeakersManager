//
//  SMPresentation+CoreDataProperties.h
//  GDGTernopilSpeakersManager
//
//  Created by Yura Boyko on 11/6/15.
//  Copyright © 2015 Yura Boyko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SMPresentation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMPresentation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comments;
@property (nullable, nonatomic, retain) NSNumber *minutes;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) SMConference *conference;
@property (nullable, nonatomic, retain) SMSpeaker *speaker;

@end

NS_ASSUME_NONNULL_END
