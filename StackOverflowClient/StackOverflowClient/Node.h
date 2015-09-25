//
//  Node.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/25/15.
//  Copyright © 2015 koz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic) NSInteger value;
@property (strong,nonatomic) Node *left;
@property (strong,nonatomic) Node *right;
-(BOOL)addValue:(NSInteger)value;

@end
