//
//  StackOverflowService.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/15/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowService : NSObject
+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError*))completionHandler;
@property (strong, nonatomic) NSString *term;
@end
