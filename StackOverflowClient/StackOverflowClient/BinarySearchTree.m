//
//  BinarySearchTree.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/25/15.
//  Copyright © 2015 koz. All rights reserved.
//

#import "BinarySearchTree.h"
#import "Node.h"
@interface BinarySearchTree()
@property (strong,nonatomic) Node *root;
@end

@implementation BinarySearchTree

-(BOOL)addValue:(NSInteger)value {
  if (!self.root) {
    Node *node = [[Node alloc] init];
    node.value = value;
    self.root = node;
    return true;
  } else {
    return [self.root addValue:value];
  }
}


@end
