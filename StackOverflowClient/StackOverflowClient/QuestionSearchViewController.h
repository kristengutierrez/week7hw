//
//  QuestionSearchViewController.h
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/15/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
//@property (strong, nonatomic) UISearchBar *searchBar;
@end
