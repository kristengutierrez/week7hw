//
//  BurgerMenuViewController.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/14/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "WebViewController.h"
#import "Errors.h"

CGFloat const kBurgerOpenScreenMultiplier = 0.2;
CGFloat const kBurgerOpenScreenDivider = 3.0;
NSTimeInterval const kTimeToSlideMenuOpen = 0.3;
CGFloat const kBurgerButtonWidth = 50.0;
CGFloat const kBurgerButtonHeight = 50.0;


@interface BurgerMenuViewController () <UITableViewDelegate>
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  NSError *error;
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  
  id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (error) {
    NSLog(@"domain: %@ code: %ld", error.domain, (long)error.code);
    NSError *myError = [NSError errorWithDomain:kStackOverflowErrorDomain code:StackOverflowBadJSON userInfo:nil];
  }
  
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  [self addChildViewController:mainMenuVC];
  mainMenuVC.tableView.delegate = self;
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  [self addChildViewController:questionSearchVC];
  questionSearchVC.view.frame = self.view.frame;
  [self.view addSubview:questionSearchVC.view];
  [questionSearchVC didMoveToParentViewController:self];
    // Do any additional setup after loading the view.
  self.topViewController = questionSearchVC;
  
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  self.viewControllers = @[questionSearchVC, myQuestionsVC];
  UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBurgerButtonWidth, kBurgerButtonHeight)];
  [burgerButton setImage:[UIImage imageNamed:@"menu-alt-512"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];
  self.pan = pan;
  
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  WebViewController *webVC = [[WebViewController alloc] init];
  [self presentViewController:webVC animated:true completion:nil];
}


- (void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
  if (sender.state == UIGestureRecognizerStateEnded) {
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kBurgerOpenScreenDivider) {
      NSLog(@"User is opening menu");
      [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
      }];
    } else {
      [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
      }];
    }
  }
}
- (void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * kBurgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
  }];

}
- (void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

- (void)switchToViewController:(UIViewController *)newVC {
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
  } completion:^(BOOL finished) {
    CGRect oldFrame = self.topViewController.view.frame;
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
      
    }];
  }];
}
#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if (![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
}
@end
