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
    NSString *key = @"8XW945CZg8n1i6FYoBbeeQ((";
  NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?key=%@&access_token=%@&order=desc&sort=activity&intitle=%@&site=stackoverflow", key, accessToken, searchTerm];
  NSLog(@"%@", url);
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSArray *questions = [QuestionJSONParser questionsResultsFromJSON:responseObject];
    NSLog(@"Questions array count: %lu", (unsigned long)questions.count);
    
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
    case 402:
      localizedDescription = @"Invalid access token";
      errorCode = StackOverflowInvalidAccessToken;
      break;
    case 403:
      localizedDescription = @"Access denied";
      errorCode = StackOverflowAccessDenied;
      break;
    case 404:
      localizedDescription = @"Method does not exist";
      errorCode = StackOverflowInvalidMethod;
      break;
    case 405:
      localizedDescription = @"Key required";
      errorCode = StackOverflowKeyRequired;
      break;
    case 406:
      localizedDescription = @"Access token compromised";
      errorCode = StackOverflowAccessTokenCompromised;
      break;
    case 407:
      localizedDescription = @"Write operation rejected";
      errorCode = StackOverflowWriteOperationDenied;
      break;
    case 409:
      localizedDescription = @"Request has already been run";
      errorCode = StackOverflowDuplicateRequest;
      break;
    case 500:
      localizedDescription = @"Unexpected internal error, try again later";
      errorCode = StackOverflowInternalError;
      break;
    case 503:
      localizedDescription = @"Temporarily unavailable, try again later";
      errorCode = StackOverflowTemporarilyUnavailable;
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
