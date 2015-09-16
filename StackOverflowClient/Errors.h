//
//  Errors.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/14/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverflowErrorDomain;
typedef enum : NSUInteger {
  StackOverflowBadJSON,
  StackOverflowConnectionDown,
  StackOverflowTooManyAttempts,
  StackOverflowInvalidParameter,
  StackOverflowNeedAuthentication,
  StackOverflowGeneralError,
} StackOverflowErrorCodes;