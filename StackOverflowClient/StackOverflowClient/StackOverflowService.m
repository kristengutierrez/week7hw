//
//  StackOverflowService.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/15/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import "StackOverflowService.h"
#import <AFNetworking/AFNetworking.h>
#import "Errors.h"
#import "Question.h"
#import "QuestionJSONParser.h"
#import "QuestionSearchViewController.h"


@implementation StackOverflowService

+ (void)questionsForSearchTerm:(NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError*))completionHandler {
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow",searchTerm];
//   *url = @"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow", searchTerm];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *questions = [QuestionJSONParser questionsResultsFromJSON:responseObject];
    
    completionHandler(questions,nil);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (operation.response) {
      NSError *stackOverflowError = [self errorForStatusCode:operation.response.statusCode];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil,stackOverflowError);
      });
    } else {
      NSError *reachabilityError = [self checkReachability];
      if (reachabilityError) {
        completionHandler(nil, reachabilityError);
      }
    }
  }];
}



+(NSError *)errorForStatusCode:(NSInteger)statusCode {
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 502:
      localizedDescription = @"Too many requests, slow down";
      errorCode = StackOverflowTooManyAttempts;
      break;
      case 400:
      localizedDescription = @"Invalide search term, try another search";
      errorCode = StackOverflowInvalidParameter;
      break;
      case 401:
      localizedDescription = @"You must sign in to access this feature";
      errorCode = StackOverflowNeedAuthentication;
      break;
    default:
      localizedDescription = @"Something went wrong";
      errorCode = StackOverflowGeneralError;
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverflowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}

+(NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverflowErrorDomain code:StackOverflowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection!"}];
    return error;
  }
  return nil;
}

@end
