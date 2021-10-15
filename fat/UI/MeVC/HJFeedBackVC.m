//
//  HJFeedBackVC.m
//  fat
//
//  Created by 何军 on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJFeedBackVC.h"

#define MAX_WORD_NUMBER 400
#define MIN_WORD_NUMBER 10

@interface HJFeedBackVC ()<TZImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    UIImage * _selImage;
    
}

@property (strong,nonatomic)UIScrollView * scrollView;

@property (strong,nonatomic)UIView * suggestBgView;
@property (strong,nonatomic)UITextView * suggestTfView;

@property (nonatomic,strong)UILabel *numberWordLab; //字数统计

@property (nonatomic,strong)UIView * pictureView; //图片视图
@property (nonatomic,strong)UIButton * addPictureBtn;
@property (strong,nonatomic)UIButton * deleteBtn;


@property (nonatomic,strong)UIView *contactView;
@property (nonatomic,strong)UITextField *contactTf; //联系方式

@end

@implementation HJFeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self initUI];
    
    
}

- (void)initUI{
    
    [self addRightBtnOneWithString:KKLanguage(@"lab_feedback_submit")];
    
    [self.view addSubview:self.scrollView];

    [self.scrollView addSubview:self.suggestBgView];
    
    [self.scrollView addSubview:self.pictureView];
    
    [self.scrollView addSubview:self.contactView];
    
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
            //背景可移动scroview //防止遮挡top line
        UIScrollView * scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight-KKNavBarHeight);
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.scrollEnabled = YES;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        scrollView.contentSize = CGSizeMake(KKSceneWidth, KKSceneHeight);
        
           _scrollView = scrollView;
        }
    return _scrollView;
}



#pragma mark - 意见反馈
- (UIView *)suggestBgView{
    
    if (!_suggestBgView) {
        _suggestBgView = [[UIView alloc] init];
        _suggestBgView.frame = CGRectMake(0,0 , KKSceneWidth, kk_y(350));
    }
    
    [_suggestBgView addSubview:self.suggestTfView];
    

    if (_numberWordLab == nil) {
        _numberWordLab = [[UILabel alloc] init];
    }
    
    _numberWordLab.frame=CGRectMake(_suggestBgView.frame.size.width - kk_x(100)-kk_x(40), _suggestBgView.frame.size.height - kk_y(40), kk_x(110), kk_y(40));
    _numberWordLab.text = [NSString stringWithFormat:@"%ld/%d",(long)self.suggestTfView.text.length,MAX_WORD_NUMBER];
    _numberWordLab.font = kk_sizefont(12);
    _numberWordLab.textAlignment = NSTextAlignmentRight;
    _numberWordLab.textColor = kkTextBlackColor;
    [_suggestBgView addSubview:_numberWordLab];
   
    
    UIView * lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, _suggestBgView.frame.size.height-1, KKSceneWidth, 1);
    lineView.backgroundColor = kkBgGrayColor;
    [_suggestBgView addSubview:lineView];
    
    return _suggestBgView;
}
#pragma mark - 建议内容
- (UITextView*)suggestTfView{
    
    if (!_suggestTfView) {
        
        _suggestTfView = [[UITextView alloc] init];
        _suggestTfView.frame=CGRectMake(kk_x(40), kk_y(20), KKSceneWidth - 2* kk_x(40), kk_y(220));
        _suggestTfView.font = kk_sizefont(15);
        _suggestTfView.textColor = kkTextBlackColor;
        _suggestTfView.delegate = self;
        
        //_placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = NSLocalizedString(@"lab_feedback_enter_suggestions", @"");
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = kkTextGrayColor;
        placeHolderLabel.font = kk_sizefont(15);
        [placeHolderLabel sizeToFit];
        [_suggestTfView addSubview:placeHolderLabel];
        
        //runtime 方式 去设置属性
        [_suggestTfView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
    }
    return _suggestTfView;
}

#pragma mark - 添加照片
- (UIView*)pictureView{
 
    if (!_pictureView) {
        
        _pictureView = [[UIView alloc] init];
        _pictureView.frame = CGRectMake(0, _suggestBgView.frame.size.height+_suggestBgView.frame.origin.y, KKSceneWidth, kk_y(270));
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(40), 0, kk_x(200),KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_feedback_add_picture");
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [_pictureView addSubview:titleLab];
        
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, KKButtonHeight-1, KKSceneWidth, 1);
        lineView.backgroundColor = kkBgGrayColor;
        [_pictureView addSubview:lineView];
        
        
        float imgaeWidth = kk_y(140);
        
        if (_addPictureBtn == nil) {
            _addPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        
        _addPictureBtn.frame = CGRectMake(kk_x(40), KKButtonHeight+kk_y(20), imgaeWidth, imgaeWidth);
       
        
        _addPictureBtn.contentMode = UIViewContentModeScaleAspectFill;
        _addPictureBtn.layer.masksToBounds = YES;
        [_addPictureBtn setImage:[UIImage imageNamed:@"img_me_add_picture"] forState:UIControlStateNormal];
        [_addPictureBtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
        [_addPictureBtn addTarget:self action:@selector(addPictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pictureView addSubview:_addPictureBtn];
        
        
        if (_deleteBtn == nil) {
            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        
        UIImage * deleteImage = [UIImage imageNamed:@"img_device_delete"];
        
        _deleteBtn.frame = CGRectMake(_addPictureBtn.frame.size.width - deleteImage.size.width, 0, deleteImage.size.width, deleteImage.size.height);
    
        [_deleteBtn setImage:deleteImage forState:UIControlStateNormal];
      
        [_deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addPictureBtn addSubview:_deleteBtn];
        _deleteBtn.hidden = YES;
        
        
        lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _pictureView.frame.size.height-1, KKSceneWidth, 1);
        lineView.backgroundColor = kkBgGrayColor;
        [_pictureView addSubview:lineView];
        
    }
    
    return _pictureView;
}


#pragma mark - 联系方式
- (UIView *)contactView{
    
    if (!_contactView) {
        
        _contactView = [[UIView alloc] init];
        _contactView.frame = CGRectMake(0, _pictureView.frame.size.height+_pictureView.frame.origin.y, KKSceneWidth, 2*KKButtonHeight);
        
        UILabel * contactLab = [[UILabel alloc] init];
        contactLab.frame = CGRectMake(kk_x(40), 0, KKSceneWidth-kk_x(40), KKButtonHeight);
        contactLab.text = NSLocalizedString(@"lab_feedback_contact", @"");
        contactLab.font = kk_sizefont(KKFont_Normal);
        [_contactView addSubview:contactLab];
        
        
        UIView * lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, KKButtonHeight-1, KKSceneWidth, 1);
        lineView.backgroundColor = kkBgGrayColor;
        [_contactView addSubview:lineView];
        
        
        UITextField * contactTf = [[UITextField alloc] init];
        contactTf.frame = CGRectMake(kk_x(40), KKButtonHeight,KKSceneWidth-2*kk_x(40), KKButtonHeight);
        contactTf.font = kk_sizefont(KKFont_Normal);
        contactTf.textColor = kkTextBlackColor;
        contactTf.placeholder =KKLanguage(@"enter_account_placeholder");
        contactTf.delegate = self;
        [_contactView addSubview:contactTf];
        self.contactTf = contactTf;
        
        if (@available(iOS 12.0, *)) {
            //Xcode 10 适配
            contactTf.textContentType = UITextContentTypeOneTimeCode;
        }
        
        
        lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, _contactView.frame.size.height-1, KKSceneWidth, 1);
        lineView.backgroundColor = kkBgGrayColor;
        [_contactView addSubview:lineView];
        
    }
    
    return _contactView;
}
#pragma mark - 删除图片
- (void)deleteImage:(UIButton*)sender{
    
    _selImage = [UIImage imageNamed:@"img_me_add_picture"];
    [self refreshPictureView:YES];
   
}
#pragma mark - 添加图片
- (void)addPictureBtnClick{
    
    SW(sw);
    [self showAlertSheetTitle:@"" message:@"" dataArr:@[KKLanguage(@"lab_me_setUser_Profile_select_2"),KKLanguage(@"lab_me_setUser_Profile_select_1")] callback:^(NSInteger index, NSString * _Nonnull titleString) {
        
        if (index == 0) {
            
            [sw requestCameraAuthorization];
            
        }else if (index == 1){
            
            [sw getPicture];
            
        }
        
    }];

}

- (void)getPicture{
    
    SW(sw);
    TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];//设置多选最多支持的最大数量，设置代理
    imagePC.allowTakePicture = NO;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePC animated:YES completion:nil];//跳转
    
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage * image = [photos firstObject];
        
        self->_selImage = image;
        
        [sw refreshPictureView:NO];
        
    }];
}

- (void)refreshPictureView:(BOOL)isShowDelete{
    
    [self.addPictureBtn setImage:_selImage forState:UIControlStateNormal];
    
    _deleteBtn.hidden = isShowDelete;
    
}

- (void)requestCameraAuthorization{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:( AVMediaTypeVideo)];
    SW(sw);
    if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted) {
                    [sw takePhoto];
                }
            });
        }];
    }else if (status == AVAuthorizationStatusRestricted ||
              status == AVAuthorizationStatusDenied){
        
            NSString *app_Name = [[HJCommon shareInstance]getAppName];
            NSString *title = NSLocalizedString(@"lab_requires_access_camera", @"");
            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"lab_open_camera_authorization_method", @""),app_Name];
        
        [sw showAlertViewTitle:title message:msg dataArr:@[KKLanguage(@"lab_common_ok")] callback:^(NSInteger index, NSString * _Nonnull titleString) {
            
        }];
    
    }else if (status == AVAuthorizationStatusAuthorized){
        [self takePhoto];
    }
}

- (void)takePhoto{
    SW(sw);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        //确保主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.view.backgroundColor = [UIColor redColor];
                controller.modalPresentationStyle = UIModalPresentationFullScreen;
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = sw;
                [sw presentViewController:controller
                                 animated:YES
                               completion:^(void){
                    DLog(@"Picker View Controller is presented");
                }];
            }
            
        });
        
    }];
}
#pragma mark ============== 提交 ===============
- (void)rightBtnOneClick:(UIButton *)sender{
    
    NSString * suggest = [[HJCommon shareInstance] whitespaceCharacterSet:self.suggestTfView.text];
    NSString * contact = [[HJCommon shareInstance] whitespaceCharacterSet:self.contactTf.text];
    if (suggest.length == 0) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_feedback_enter_suggestions")];
        return;
    }
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    if (_selImage) {
        
        [self uploadImage:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
            
            if (result == NO) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self showLoadingInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
                 
                    
                });
     
                  return;
            }
            
            [self uploadSuggest:suggest contact:contact imgUrl:[nameArray firstObject]];
            
        }];
        
    }else{
        
        [self uploadSuggest:suggest contact:contact imgUrl:@""];
        
    }

}
- (void)uploadSuggest:(NSString*)suggest contact:(NSString*)contact imgUrl:(NSString*)imgUrl{
    
    HJFeedBackModel * model = [[HJFeedBackModel alloc] init];

    model.imgUrl = imgUrl;
    model.content = suggest;
    model.contactWay = contact;
    model.phoneInfo = [[HJCommon shareInstance] getAppVersion];
    model.systemType = @"iOS";
    
    NSDictionary * dic = [model toDictionary];

    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_suggest_submit withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success ) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [self showToastInWindows:KKToastTime title:model.msg];
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
}

- (void)uploadImage:(ImageCallback)success {
    
    [[HJOSSUpload aliyunInit] uploadImage:@[_selImage] success:^(BOOL result,NSArray<NSString *> * _Nonnull nameArray) {
        success(result,nameArray);
    }];
}
#pragma mark ============== imagePickerController 方法 ===============
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    SW(sw);
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self->_selImage = portraitImg;
        [sw refreshPictureView:NO];
        
    }];
}

#pragma mark =============== delegate 方法 ===============
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //去掉 表情 符号
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *suggestString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString * newString ;
    if (suggestString.length>=MAX_WORD_NUMBER) {
        newString = [suggestString substringToIndex:MAX_WORD_NUMBER];
        textView.text = newString;
    }else{
        newString = suggestString;
    }
    
    _numberWordLab.text = [NSString stringWithFormat:@"%ld/%d",(long)newString.length,MAX_WORD_NUMBER];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
