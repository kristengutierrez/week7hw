//
//  WebViewController.m
//  StackOverflowClient
//
//  Created by Kristen Kozmary on 9/14/15.
//  Copyright (c) 2015 koz. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  NSString *baseURL = @"https://stackexchange.com/oauth/dialog";
  NSString *clientID = @"5558";
  NSString *redirectURI = @"https://stackexchange.com/oauth/login_success";
  NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", baseURL,clientID,redirectURI];
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
    // Do any additional setup after loading the view.
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

  if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
    NSString *fragmentString = navigationAction.request.URL.fragment;
    NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
    NSString *fullTokenParameter = components.firstObject;
    NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
    NSLog(@"%@", token);
    [self dismissViewControllerAnimated:true completion:nil];
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}

@end
