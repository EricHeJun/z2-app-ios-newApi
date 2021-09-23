//
//  HJGuideVC.m
//  fat
//
//  Created by 何军 on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJGuideVC.h"

@interface HJGuideVC ()
@property (strong,nonatomic)UITextView * textView;

@end

@implementation HJGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self refreshUI];
}

- (void)initData{
    
}

- (void)initUI{
    
    [self.view addSubview:self.textView];
    
}

- (void)refreshUI{
    
    NSString * textstr = @"如何连接脂肪厚度仪Z2？\n1、开启手机蓝牙功能；\n2、将Z2设备开机；\n3、等待APP自动搜索Z2设备...\n或点击右上角图标主动搜索Z2设备连接。";

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textstr];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    
    textAttachment.image = [UIImage imageNamed:@"img_btn_searchBLE"];
    
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
    
    [string insertAttributedString:textAttachmentString atIndex:self.textView.text.length];//index为用户指定要插入图片在文本框中的位置，从0开始
    
    
    
    NSMutableParagraphStyle*paragraphStyle = [[NSMutableParagraphStyle alloc]init];

    paragraphStyle.lineSpacing=10;//字体的行间距


    NSDictionary*attributes =@{NSFontAttributeName:kk_sizefont(KKFont_Normal),NSParagraphStyleAttributeName:paragraphStyle};


    self.textView.attributedText = [[NSAttributedString alloc] initWithString:textstr attributes:attributes];
    
    
   
    
    //self.textView.attributedText = string;
    
}

- (UITextView *)textView{
    
    if (!_textView) {
        
        UITextView * textView = [[UITextView alloc] init];
        textView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500));
        textView.font= kk_sizefont(KKFont_Normal);
        textView.editable = NO;
        _textView = textView;
        
    }
    
    return _textView;
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
