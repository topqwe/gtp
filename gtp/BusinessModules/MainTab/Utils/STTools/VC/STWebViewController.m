//
//  STWebViewController.m
//  SportHome
//
//  Created by stoneobs on 16/12/14.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#import "STWebViewController.h"
#import <WebKit/WebKit.h>
@interface STWebViewController ()<WKNavigationDelegate>
@property(nonatomic, strong) NSString             *urlStr;
@property(nonatomic, strong) NSString             *h5String;
@property(nonatomic, strong) WKWebView            *webView;
@property(nonatomic, strong) UIProgressView       *progressView;
@property(nonatomic, strong) UIView               *loadingView;
@property(nonatomic, strong) NSString                     *path;/**< <##> */
@end

@implementation STWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.urlStr = url;
    }
    return self;
}
- (instancetype)initWithLocalUrl:(NSString *)path{
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}
- (instancetype)initWithH5String:(NSString *)h5String{
    self = [super init];
    if (self) {
        self.h5String = h5String;
    }
    return self;
}
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}
#pragma mark --Geter And Setter
- (UIColor *)progressTintColor
{
    if (_progressTintColor) {
        return _progressTintColor;
    }
    return [UIColor orangeColor];
}
- (UIColor *)progressBackgroundColor
{
    if (_progressTintColor) {
        return _progressTintColor;
    }
    return [UIColor grayColor];
}
#pragma mark --vc生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在加载...";
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *jScript =
    @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    wkWebConfig.userContentController = wkUController;
    
    
    self.webView = [[WKWebView alloc] initWithFrame:SCREEN_FRAME configuration:wkWebConfig];
    [self.view addSubview:self.webView];
    
    if (self.urlStr) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]]];
    }
    if (self.path) {
        [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.path]]];
    }
    if (self.h5String) {
        [self.webView loadHTMLString:self.h5String baseURL:nil];
    }

    self.webView.navigationDelegate = self;
    
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 1)];
    self.progressView.backgroundColor = self.progressBackgroundColor;
    self.progressView.progressTintColor = self.progressTintColor;
    [self.view addSubview:self.progressView];
    
    if (!self.navigationController.navigationController.navigationBar.translucent) {
        self.progressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
        //self.webView.height = self.webView.height - 64;
    }else{
         self.progressView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 1);
        
    }
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    //菊花
    UIActivityIndicatorView * juhuaView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [juhuaView startAnimating];
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    juhuaView.center = CGPointMake(_loadingView.frame.size.width/2, _loadingView.frame.size.width/2);
    self.loadingView.layer.cornerRadius = 15;
    self.loadingView.center = self.view.center;
    self.loadingView.backgroundColor = [UIColor grayColor];
    [self.loadingView addSubview:juhuaView];
    [self.view addSubview:self.loadingView];
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
#pragma mark --kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object==self.webView&&[keyPath isEqualToString:@"estimatedProgress"]) {
        //NSLog(@"%f",self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;

    }
    if (object==self.webView&&[keyPath isEqualToString:@"title"]) {
        
        self.title = self.webView.title;
    }
}
#pragma mark --WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{

    //完成
    self.loadingView.hidden = YES;
    if (self.forceTitle.length) {
        self.title = self.forceTitle;
    }

}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.loadingView.hidden = YES;
    if (self.forceTitle.length) {
        self.title = self.forceTitle;
    }
    NSLog(@"%@",error);


}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
{

    self.loadingView.hidden = YES;
    NSLog(@"%@",error);
    if (self.forceTitle.length) {
        self.title = self.forceTitle;
    }

}
@end
