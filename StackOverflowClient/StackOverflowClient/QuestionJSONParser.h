//
//  QuestionJSONParser.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/16/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionJSONParser : NSObject
+(NSArray *)questionsResultsFromJSON:(NSDictionary *)jsonInfo;
@end
