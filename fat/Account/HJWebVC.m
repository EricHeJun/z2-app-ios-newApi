//
//  HJWebVC.m
//  fat
//
//  Created by ydd on 2021/4/29.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJWebVC.h"
#import <WebKit/WebKit.h>


@interface HJWebVC ()<WKUIDelegate,WKNavigationDelegate>
@property (strong,nonatomic)WKWebView * webView;

@end

@implementation HJWebVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initData];
    
    [self initUI];
    
}
- (void)initUI{
    
    [self.view addSubview:self.webView];
    

    
    if (_webType == KKWebType_Agreement) {
        
        if (@available(iOS 9.0, *)) {
            [_webView loadFileURL:[NSURL fileURLWithPath:_urlString] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_webView loadRequest:request];
        });
    }

}

- (void)initData{
    
    if (_webType == KKWebType_Agreement) {
        
        NSString * local =[[HJCommon shareInstance] getCurrectLocalCountry];
        
        if ([local isEqualToString:@"zh_TW"]) {
            
            _urlString= [[NSBundle mainBundle] pathForResource:@"user_agreement_zh_TW" ofType:@"html"];
            
        }else if ([local isEqualToString:@"zh_HK"]){
            
            _urlString= [[NSBundle mainBundle] pathForResource:@"user_agreement_zh_HK" ofType:@"html"];
            
        }else if ([local isEqualToString:@"zh_CN"]){
            
            _urlString= [[NSBundle mainBundle] pathForResource:@"user_agreement_zh_CN" ofType:@"html"];
            
        }else{
            
            _urlString= [[NSBundle mainBundle] pathForResource:@"user_agreement_en_US" ofType:@"html"];
        }
        
        
        
    }else if (_webType == KKWebType_official){
        
        NSString * language =[[HJCommon shareInstance] getCurrectLocalLanguage];
        
        if ([language hasPrefix:@"cn"]) {
            
            _urlString = @"http://www.marvoto.com/cn";
            
        }else{
            
            _urlString = @"http://www.marvoto.com";
        }
        
        
        
    }else if(_webType == KKWebType_Faq) {
        
    
        NSString * language =[[HJCommon shareInstance] getCurrectLocalLanguage];
        
        if ([language hasPrefix:@"cn"]) {
            
            _urlString = @"http://www.marvoto.com/cn/index.php/m1-2/";
            
        }else{
            
            _urlString = @"http://www.marvoto.com/marvotowebsite/index.php/qa_z1_en/";
        }
        
    }
}

- (WKWebView *)webView{
    
    if (!_webView) {
        WKWebView * webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight - KKNavBarHeight)];
        _webView.allowsBackForwardNavigationGestures = YES;
        // UI代理
        _webView.UIDelegate = self;
        // 导航代理
        _webView.navigationDelegate = self;
        _webView = webView;

    }
    return _webView;
}

- (void)leftBack{
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
