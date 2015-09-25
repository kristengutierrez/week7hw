//
//  Node.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/25/15.
//  Copyright © 2015 koz. All rights reserved.
//

#import "Node.h"

@implementation Node
-(BOOL)addValue:(NSInteger)value {
  if (value == self.value) {
    return false;
  } else if (value > self.value) {
    //go to right
    if (!self.right) {
      Node *node = [[Node alloc] init];
      node.value = value;
      self.right = node;
      return true;
    } else {
      return [self.right addValue:value];
    }
  } else {
    if (!self.left) {
      Node *node = [[Node alloc]init];
      node.value = value;
      self.left = node;
      return true;
    } else {
      return [self.left addValue:value];
    }
  }
}

@end
