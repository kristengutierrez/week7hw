//
//  Question.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/16/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPic;
@property (strong, nonatomic) NSString *ownerName;
@end
