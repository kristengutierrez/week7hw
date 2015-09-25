//
//  QuestionSearchViewController.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/15/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "Question.h"


@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) Question *question;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  _tapRecognizer.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:_tapRecognizer];
  _searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

#pragma mark - UISearchBarDelegate
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
  [self.view endEditing:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [StackOverflowService questionsForSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
    self.questions = results;
    [self.tableView reloadData];
    [self.view endEditing:YES];
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.questions = results;
      dispatch_group_t group = dispatch_group_create();
      dispatch_queue_t imageQueue = dispatch_queue_create("com.koz.stackoverflowclient",DISPATCH_QUEUE_CONCURRENT );
      
      for (Question *question in results) {
        dispatch_group_async(group, imageQueue, ^{
          NSString *avatarURL = question.avatarURL;
          NSURL *imageURL = [NSURL URLWithString:avatarURL];
          NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
          UIImage *image = [UIImage imageWithData:imageData];
          question.avatarPic = image;
        });
        [self.tableView reloadData];
      }
      
      dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Yeah" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:true completion:nil];
        
      });
    }
  }];
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  Question *questionText = self.questions[indexPath.row];
  cell.textLabel.text = questionText.title;
  NSString *avatarURL = _question.avatarURL;
  NSLog(@"avatar url:%@", avatarURL);
  NSURL *imageURL = [NSURL URLWithString:avatarURL];
  NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
  UIImage *image = [UIImage imageWithData:imageData];
//  _question.avatarPic = image;
  cell.imageView.image = image;
  
  return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"%lu", (unsigned long)self.questions.count);
  return self.questions.count;
}
@end
