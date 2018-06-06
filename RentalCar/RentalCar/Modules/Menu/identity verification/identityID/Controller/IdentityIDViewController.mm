//
//  IdentityIDViewController.m
//  RentalCar
//
//  Created by Hulk on 2017/3/13.
//  Copyright © 2017年 xyx. All rights reserved.
//

#import "IdentityIDViewController.h"
#import "CircleView.h"
#import "LBorderView.h"

#import "MyViewController.h"
#import "LiveViewController.h"
#import "ScnDriveViewController.h"
#import "BaseNavController.h"
#import "IDmodel.h"
#import "DriverModel.h"
#import "StartScnBtnAndLoding.h"
#import "ScanView.h"
#import "XDYHomeService.h"
#import "BaseWebController.h"
#import "ProIdentityIDViewController.h"


#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
#import <MGIDCard/MGIDCard.h>
#import <MGBaseKit/MGBaseKit.h>
#endif





@interface IdentityIDViewController ()<ObserverServiceDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScnDrivePhotoDelegate,MyViewControllerLivingDelegate,LodingDelegate,BaseWebControllerDelegate>
{
    IdentityService *service;
    UIImagePickerController *_imagePickerController;
    IDmodel *UserIfomodel;
    DriverModel *driverModel;
    XDYHomeService *_homeService;
    //    NSTimer *timer;
    //    int present;
    int ScanType;
    int FAQType;
    
    UIView *Type2View;
    UILabel *label2title;
    UIImageView *label2RightImg;
    UIImageView *Type2Img;
    UILabel *label2Info;
    UIView *Type3View;
    UIImageView *Type3Img;
    UILabel *label3title;
    UILabel *label3Info;
    UIImageView *label3RightImg;
    
}
typedef enum{
    
    Personal       = 0,//扫身份证
    Drive      = 1,//驾照
    Living     = 2,//人脸识别
    Done     = 3,//人脸识别完成
    
}personalOrDriveAndLiving;
@property(nonatomic,strong)CircleView *titleView;
@property(nonatomic,strong)ScanView *scanView;

@property(nonatomic,strong)StartScnBtnAndLoding *startScnBtn;
@property(nonatomic,strong)UIImage *faceImg;

@property(nonatomic,strong)UIButton *reScn;
@property(nonatomic,strong)UIButton *nextScn;
@property(nonatomic,strong)UIImageView *doneNOImg;
@property(nonatomic,copy)NSString* webViewUrl;



//身份证及驾照信息
@property(nonatomic,strong)UILabel *labelName;
@property(nonatomic,strong)UILabel *labelSex;
@property(nonatomic,strong)UILabel *labelBirth;
@property(nonatomic,strong)UILabel *PersonID;
@property(nonatomic,strong)UILabel *labelName2;
@property(nonatomic,strong)UILabel *labelSex2;
@property(nonatomic,strong)UILabel *labelBirth2;
@property(nonatomic,strong)UILabel *PersonID2;
@property(nonatomic,assign)BOOL canCa;

@end

@implementation IdentityIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#fbfbfb"]];
    _canCa = [APPUtil isCameraPermissionOn];
    FAQType =1;
    _homeService = [[XDYHomeService alloc] init];
    _homeService.serviceDelegate = self;
    [self addItemForLeft:RightBtn Title:@"遇到问题" Titlecolor:[UIColor colorWithHexString:@"#25D880"] action:@selector(VerificationFAQ:) spaceWidth:-10];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upProgress:) name:@"IdentityUploadProgress" object:nil];
    
    service =[[IdentityService alloc]init];
    service.serviceDelegate = self;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [service requestMemberFRFAgreementWithService:param success:^(id data) {
//        debugLog(@"%@",data);
        _webViewUrl = [data[@"result"]objectForKey:@"url"];
    } fail:^(NSString *error) {
//        debugLog(@"%@",error);
    }];
    
    [self setTitle:@"实名认证"];
    
    _titleView = [[CircleView alloc]init];
    
    _titleView.tagS =1;
    
    [_titleView setFrame:CGRectMake(autoScaleW(kScreenWidth/2 -(kScreenWidth-15)/2), NVBarAndStatusBarHeight+15,kScreenWidth-15, autoScaleH(50))];
    [_titleView.layer setCornerRadius:20.0];
    _titleView.layer.masksToBounds = YES;
    
    [self.view addSubview:_titleView];
    
    _scanView = [[ScanView alloc]initWithFrame:CGRectMake(autoScaleW(15), autoScaleW(164), autoScaleW(345), autoScaleW(220))];
    
    [self.view addSubview:_scanView];
    
    [self steupStartScnBtn:Personal];
    CGFloat ScndescribeY = CGRectGetMaxY(_startScnBtn.frame);
    UIButton *Scndescribe = [[UIButton alloc]init];
    [Scndescribe setImage:[UIImage imageNamed:@"icon_safety"] forState:UIControlStateNormal];
    
    [Scndescribe setTitle:@"您的资料仅用于审核用车资格" forState:UIControlStateNormal];
    [Scndescribe setFrame:CGRectMake(kScreenWidth/2-autoScaleW(kScreenWidth)/2, ScndescribeY+21, autoScaleW(kScreenWidth), autoScaleH(22))];
    [Scndescribe setTitleColor:[UIColor colorWithHexString:@"#CFCFCF"] forState:UIControlStateNormal];
    [Scndescribe.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    //    Scndescribe.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:Scndescribe];
    
#pragma mark - 身份证扫描授权
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        NSLog(@"%@", [NSString stringWithFormat:@"身份证扫描授权%@", License ? @"成功" : @"失败"]);
    }];
#endif
    
#pragma mark - 驾照扫描授权
    if (![MGLiveManager getLicense]) {
        [MGLiveManager licenseForNetWokrFinish:^(bool License) {
            NSLog(@"%@", [NSString stringWithFormat:@"驾照扫描授权%@", License ? @"成功" : @"失败"]);
        }];
    }
    
    CGFloat labeY = CGRectGetMaxY(_scanView.frame);
    
    [self steupLabel:labeY+20 info:nil state:0];
    [self initTopNotificationView];
    [self proIdentity];
    //    [self setLabelHDYES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(proIdentity) name:kGetUserInfoNotification object:nil];;
}

- (void)initTopNotificationView{
    Type2View = [[UIView alloc]initWithFrame:CGRectMake(0, NVBarAndStatusBarHeight, kScreenWidth, autoScaleH(30))];
    [Type2View setBackgroundColor:[UIColor colorWithHexString:@"#2EA2FF"]];
    [Type2View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushType)]];
    [self.view addSubview:Type2View];
    
    Type2Img = [[UIImageView alloc]initWithFrame:CGRectMake(autoScaleW(11), Type2View.height/2-(autoScaleH(14)/2), autoScaleW(14), autoScaleH(14))];
    
    [Type2Img setImage:[UIImage imageNamed:@"icon_confirm_white"]];
    
    [Type2View addSubview:Type2Img];
    
    label2title = [[UILabel alloc]initWithFrame:CGRectMake(Type2Img.right+autoScaleW(10), 0, Type2View.width/2, Type2View.height)];
    [label2title setText:@"您的人工认证申请正在受理中"];
    [label2title setTextColor:[UIColor whiteColor]];
    [label2title setFont:[UIFont systemFontOfSize:autoScaleH(12)]];
    [Type2View addSubview:label2title];
    
    label2Info =[[UILabel alloc]initWithFrame:CGRectMake(Type2View.right-(autoScaleW(60))-autoScaleW(10), 0, autoScaleW(50), Type2View.height)];
    [label2Info setText:@"查看详情"];
    [label2Info setTextColor:[UIColor whiteColor]];
    [label2Info setFont:[UIFont systemFontOfSize:autoScaleH(12)]];
    [Type2View addSubview:label2Info];
    
    label2RightImg = [[UIImageView alloc]initWithFrame:CGRectMake(label2Info.right+5, Type2View.height/2 -(autoScaleH(10)/2), autoScaleW(10), autoScaleH(10))];
    [label2RightImg setImage:[UIImage imageNamed:@"icon_BackWhite"]];
    CGAffineTransform PhotoButtonTransform = CGAffineTransformMakeRotation(180 * M_PI/180.0);
    [label2RightImg setTransform:PhotoButtonTransform];
    [label2RightImg setContentMode:UIViewContentModeScaleAspectFit];
    
    [Type2View addSubview:label2RightImg];
    
    Type2View.hidden = YES;
    _titleView.top = NVBarAndStatusBarHeight+15;
}


-(void)steupStartScnBtn:(personalOrDriveAndLiving)personalOrDriveAndLiving{
    
    _startScnBtn = [[StartScnBtnAndLoding alloc]initWithFrame:CGRectMake(kScreenWidth/2-((kScreenWidth-20)/2), autoScaleW(561), kScreenWidth-20, autoScaleH(48))];
    _startScnBtn.delegate = self;
    _startScnBtn.maxValue = 100;
    //判断相机权限
    if (_canCa) {
        
    }else{
        [_startScnBtn setEnabled:NO];
        return;
    }
    
    [_startScnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置背景色
    
    [_startScnBtn.leftimg setBackgroundColor:[UIColor colorWithHexString:@"#09c58a"]];
    [_startScnBtn.bgimg setBackgroundColor:[UIColor colorWithHexString:@"#26d880"]];
    //遮盖色
    [self.view addSubview:_startScnBtn];
//        personalOrDriveAndLiving = Living;
    switch (personalOrDriveAndLiving) {
        case Personal://身份证识别
        {
            
            [_startScnBtn addTarget:self action:@selector(ScnCardIdCard:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Drive://驾照识别
        {
            [self.labelName2 setText:@""];
            [self.labelSex2 setText:@""];
            [self.labelBirth2 setText:@""];
            [self.PersonID2 setText:@""];
            
            [self.labelName setText:[NSString stringWithFormat:@"姓名"]];
            [self.labelSex setText:[NSString stringWithFormat:@"准驾车型"]];
            [self.labelBirth setText:[NSString stringWithFormat:@"证号"]];
            [self.PersonID setText:[NSString stringWithFormat:@""]];
            [_startScnBtn addTarget:self action:@selector(ScnDriveCard:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Living://人脸识别
        {
            [self.labelName2 setText:@""];
            [self.labelSex2 setText:@""];
            [self.labelBirth2 setText:@""];
            [self.PersonID2 setText:@""];
            
            [self.labelName setText:[NSString stringWithFormat:@""]];
            [self.labelSex setText:[NSString stringWithFormat:@""]];
            [self.labelBirth setText:[NSString stringWithFormat:@""]];
            [_startScnBtn addTarget:self action:@selector(ScnLivingPerson:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case Done:
        {
            
            [_startScnBtn addTarget:self action:@selector(DoneOk:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark ----- 身份证扫描 ---------------
-(void)ScnCardIdCard:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"重新扫描"]) {
        [StatisticsClass eventId:SF03];
        [_reScn setHidden:YES];
        [_nextScn setHidden:YES];
        [self steupStartScnBtn:Personal];
    }else{
        [StatisticsClass eventId:SF01];
    }
    
    //    ScanType = 1;
    
    FAQType = 1;
    CGFloat light = [UIScreen mainScreen].brightness;
    
#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
    
    BOOL idcard = [MGIDCardManager getLicense];
    if (!idcard) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"SDK授权失败，请检查" delegate:self cancelButtonTitle:@"完成" otherButtonTitles:nil, nil] show];
        return;
    }
    [[UIScreen mainScreen] setBrightness:0.9];
    MGIDCardManager *cardManager = [[MGIDCardManager alloc] init];
    [cardManager setScreenOrientation: MGIDCardScreenOrientationLandscapeLeft];
    //    IDCARD_SIDE_FRONT : IDCARD_SIDE_BACK
    [cardManager IDCardStartDetection:self IdCardSide:IDCARD_SIDE_FRONT finish:^(MGIDCardModel *model) {
        [[UIScreen mainScreen] setBrightness:light];
        [_scanView.cardIdImgView setImage:[model croppedImageOfIDCard]];
        // [self setupRescnIdCard:Personal];
        NSString *pathFile = [[model croppedImageOfIDCard] saveImage];
        //设置求情的token
        NSString *token =[UserInfo share].token;
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:token forKey:@"token"];
        [param setObject:pathFile forKey:@"imgIdFront"];
        //上传身份证的接口
        [service requestIdentityCardInfoWithService:param success:^(id data) {
//            debugLog(@"%@",data);
            
            
        } fail:^(NSString * error) {
            
        }];
    }errr:^(MGIDCardError errorType) {
        [[UIScreen mainScreen] setBrightness:light];
    }];
#endif
    
    
    
}
//安装最下方的扫描完成后的按钮





-(void)clearInfo{
    _scanView.cardIdImgView.image = nil;
}





#pragma mark ---------------驾照扫描---------------
-(void)ScnDriveCard:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"重新扫描"]){
        [StatisticsClass eventId:JZ02];
        [_reScn setHidden:YES];
        [_nextScn setHidden:YES];
        [self steupStartScnBtn:Drive];
    }
    else{
        [StatisticsClass eventId:JZ01];
    }
//    debugLog(@"扫描驾照");
    FAQType =2;
    ScnDriveViewController *scnDrive = [[ScnDriveViewController alloc]init];
    scnDrive.scnDriveDelegate =self;
    [self presentViewController:scnDrive animated:YES completion:nil];
    
    
}

-(void)drivingId:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"确认无误"]) {
        [StatisticsClass eventId:SF04];
    }
    ScanType = 1;
    FAQType =2;
    _reScn.hidden =YES;
    _nextScn.hidden = YES;
    //_startScnBtn.hidden = NO;
    [_startScnBtn removeFromSuperview];
    ;
    _titleView.tagS = 2;
    _titleView.tagH = 1;
    [self clearInfo];
    [_scanView.scanTitle setText:@"扫描驾照"];
    
    [APPUtil runAnimationWithCount:71 name:@"motion_cardscan00" imageView:_scanView.animationView repeatCount:1 animationDuration:0.03];
    
    [_titleView setNeedsLayout];
    
    [self steupStartScnBtn:Drive];
}

#pragma mark - 驾照识别返回数据
-(void)onImg:(UIImage *)selectImg{
    
    [_scanView.cardIdImgView setImage:selectImg];
    
    NSData * imageData = UIImageJPEGRepresentation(selectImg,1);
   float length = [imageData length]/1000;
    NSLog(@"图片大小为 %f  KB",length);
    
    // [self setupRescnIdCard:Personal];
    NSString *pathFile = [selectImg saveImage];
//    debugLog(@"%@",selectImg);
    NSString *token =[UserInfo share].token;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:token forKey:@"token"];
    [param setObject:pathFile forKey:@"imgDriver"];
    
    //返回的接口
    //上传驾照
    [service requestDrivingCardInfoWithService:param success:^(id data) {
//        debugLog(@"%@",data);
        
    } fail:^(NSString *error) {
        
    }];
    
    
    //[self setupRescnIdCard:Living];
    
}






#pragma mark --------------------人脸扫描----------------
-(void)ScnLivingPerson:(UIButton *)button{
//    debugLog(@"扫描人物");
    FAQType =3;
    [StatisticsClass eventId:JZ04];
    if (![MGLiveManager getLicense]) {
        return;
    }
    
    MyViewController *myVC = [[MyViewController alloc] initWithDefauleSetting];
    myVC.LivingDelegate = self;
    BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:myVC];
    [self presentViewController:nav animated:NO completion:nil];
    
}

#pragma mark 人脸扫描按钮点击
-(void)livingId:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"确认无误"]) {
        [StatisticsClass eventId:JZ03];
    }
    ScanType = 2;
    FAQType =3;
    _reScn.hidden =YES;
    _nextScn.hidden = YES;
    //_startScnBtn.hidden = NO;
    [_startScnBtn removeFromSuperview];
    ;
    _titleView.tagS = 3;
    _titleView.tagH = 2;
    [self clearInfo];
    [_scanView.scanTitle setText:@"人脸扫描"];
    [_scanView.animationView setImage:[UIImage imageNamed:@"motion_facescan0077"]];
    [_scanView.animationView setFrame:CGRectMake(_scanView.width/2-(autoScaleW(115)/2), _scanView.height/2-(autoScaleH(145)/2), autoScaleW(115), autoScaleH(145))];
    [APPUtil runAnimationWithCount:77 name:@"motion_facescan00" imageView:_scanView.animationView repeatCount:1 animationDuration:0.03];
    
    [_titleView setNeedsLayout];
    
    [self steupStartScnBtn:Living];
}


#pragma mark 人脸识别返回的数据
- (void)onData:(FaceIDData *)faceIdData{
    //gh:缺张图片
    _titleView.tagH = 3;
    [_startScnBtn removeFromSuperview];
    [self clearInfo];
    [_scanView.animationView setHidden:YES];
    [_scanView setHidden:NO];
    [_titleView setNeedsLayout];
    
    [self steupStartScnBtn:Done];
    //    debugLo/(@"%@",faceIdData.delta)
    
    _doneNOImg = [[UIImageView alloc]init];
    _faceImg= [UIImage imageWithData:[faceIdData.images objectForKey:@"image_best"]];
    [_doneNOImg setFrame:CGRectMake(_scanView.width/2-autoScaleW(173)/2, _scanView.height/2-autoScaleH(173)/2, autoScaleW(173), autoScaleH(173))];
    [_doneNOImg setImage:_faceImg];
    [_doneNOImg setBackgroundColor:[UIColor redColor]];
    [_scanView addSubview:_doneNOImg];
    [self setLabelHDYES];
    
    //上传人脸识别
    //    NSString *pathFile = [_faceImg saveImage];
    NSString *token =[UserInfo share].token;
    NSDictionary *param = @{@"token":token, @"imgFace":[faceIdData.images objectForKey:@"image_best"]};
    //上传图片
    [service requestFaceCardInfoWithService:param success:^(id data) {
//        debugLog(@"%@",data);
        
    } fail:^(NSString * error) {
//        debugLog(@"%@",error);
    }];
    
    
}

#pragma mark -完成验证
-(void)DoneOk:(StartScnBtnAndLoding *)button{
    StartScnBtnAndLoding *temp = button;
//    debugLog(@"%@", temp.presentlab);
    if ([temp.presentlab.text isEqualToString:@"重新认证"]) {
        FAQType =3;
        [StatisticsClass eventId:JZ04];
        MyViewController *myVC = [[MyViewController alloc] initWithDefauleSetting];
        myVC.LivingDelegate = self;
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:myVC];
        [self presentViewController:nav animated:NO completion:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
//        debugLog(@"完成认证");
    }
    
}

#pragma mark - 封装的lable方法
-(void)steupLabel:(CGFloat)Y info:(NSArray *)info state:(int)state{
    
    float mg =9;
    float lg =30;
    UIColor *l = [UIColor colorWithHexString:@"#CFCFCF"];
    UIColor *r = [UIColor colorWithHexString:@"#7A7A7A"];
    
    if (self.labelName == nil) {
        self.labelName =[[UILabel alloc]init];
        [self.labelName setFont:[UIFont systemFontOfSize:15]];
        [self.labelName setTextAlignment:NSTextAlignmentRight];
        [self.labelName setTextColor:l];
        
        [self.labelName setFrame:CGRectMake(0, Y, autoScaleW(self.view.width/3), autoScaleH(20))];
        
        [self.view addSubview:self.labelName];
        
        CGFloat  labelNameX=  CGRectGetMaxX(self.labelName.frame);
        self.labelName2 =[[UILabel alloc]init];
        [self.labelName2 setFont:[UIFont systemFontOfSize:15]];
        [self.labelName2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelName2 setTextColor:r];
        [self.labelName2 setFrame:CGRectMake(autoScaleW(labelNameX+lg), Y, autoScaleW(self.view.width), autoScaleH(20))];
        
        [self.view addSubview:self.labelName2];
    }
    
    if (self.labelSex ==nil) {
        CGFloat  labelSexY=  CGRectGetMaxY(self.labelName.frame);
        
        self.labelSex =[[UILabel alloc]init];
        [self.labelSex setFont:[UIFont systemFontOfSize:15]];
        [self.labelSex setTextAlignment:NSTextAlignmentRight];
        [self.labelSex setTextColor:l];
        [self.labelSex setFrame:CGRectMake(0, labelSexY+mg, autoScaleW(self.view.width/3), autoScaleH(20))];
        
        [self.view addSubview:self.labelSex];
        //2
        CGFloat  labelSexX=  CGRectGetMaxX(self.labelSex.frame);
        self.labelSex2 =[[UILabel alloc]init];
        [self.labelSex2 setFont:[UIFont systemFontOfSize:15]];
        [self.labelSex2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelSex2 setTextColor:r];
        [self.labelSex2 setFrame:CGRectMake(autoScaleW(labelSexX+lg), labelSexY+mg, autoScaleW(self.view.width), autoScaleH(20))];
        
        [self.view addSubview:self.labelSex2];
    }
    
    if (self.labelBirth == nil) {
        CGFloat  labelBirthY=  CGRectGetMaxY(self.labelSex.frame);
        
        self.labelBirth =[[UILabel alloc]init];
        [self.labelBirth setFont:[UIFont systemFontOfSize:15]];
        [self.labelBirth setTextAlignment:NSTextAlignmentRight];
        [self.labelBirth setTextColor:l];
        [self.labelBirth setFrame:CGRectMake(0, labelBirthY+mg, autoScaleW(self.view.width/3), autoScaleH(20))];
        
        [self.view addSubview:self.labelBirth];
        //2
        CGFloat  labelBirthX=  CGRectGetMaxX(self.labelBirth.frame);
        self.labelBirth2 =[[UILabel alloc]init];
        [self.labelBirth2 setFont:[UIFont systemFontOfSize:15]];
        [self.labelBirth2 setTextAlignment:NSTextAlignmentLeft];
        [self.labelBirth2 setTextColor:r];
        [self.labelBirth2 setFrame:CGRectMake(autoScaleW(labelBirthX+lg), labelBirthY+mg, autoScaleW(self.view.width), autoScaleH(20))];
        
        [self.view addSubview:self.labelBirth2];
    }
    
    if (self.PersonID == nil) {
        CGFloat  PersonIDY=  CGRectGetMaxY(self.labelBirth.frame);
        
        self.PersonID =[[UILabel alloc]init];
        [self.PersonID setTextAlignment:NSTextAlignmentRight];
        [self.PersonID setFont:[UIFont systemFontOfSize:15]];
        [self.PersonID setTextColor:l];
        [self.PersonID setFrame:CGRectMake(0, PersonIDY+mg, autoScaleW(self.view.width/3), autoScaleH(20))];
        
        [self.view addSubview:self.PersonID];
        //2
        CGFloat  PersonIDX=  CGRectGetMaxX(self.PersonID.frame);
        self.PersonID2 =[[UILabel alloc]init];
        [self.PersonID2 setFont:[UIFont systemFontOfSize:15]];
        [self.PersonID2 setTextAlignment:NSTextAlignmentLeft];
        [self.PersonID2 setTextColor:r];
        [self.PersonID2 setFrame:CGRectMake(autoScaleW(PersonIDX+lg), PersonIDY+mg, autoScaleW(self.view.width), autoScaleH(20))];
        
        [self.view addSubview:self.PersonID2];
    }
    
    if (info == nil) {
        [self.labelName setText:[NSString stringWithFormat:@"姓名"]];
        [self.labelSex setText:[NSString stringWithFormat:@"性别"]];
        [self.labelBirth setText:[NSString stringWithFormat:@"生日"]];
        [self.PersonID setText:[NSString stringWithFormat:@"身份证号"]];
        
        [self.labelName2 setText:[NSString stringWithFormat:@""]];
        [self.labelSex2 setText:[NSString stringWithFormat:@""]];
        [self.labelBirth2 setText:[NSString stringWithFormat:@""]];
        [self.PersonID2 setText:[NSString stringWithFormat:@""]];
    }
    
}

#pragma mark - 网络请求失败
-(void)onFailure:(NSString *)msg withType:(ActionType)type{
    if (type == _REQUEST_ID_) {
        [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
    }
    
    if (type == _REQUEST_DrivingID_){
        [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
    }
    
    if (type == _REQUEST_FaceID_Fill){
        [self steupStartScnBtn:Living];
        _titleView.tagS = 3;
        _titleView.tagH = 2;
        [_titleView setNeedsLayout];
        
        [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - 网络请求成功
-(void)onSuccess:(id)data withType:(ActionType)type{
    if (type == _REQUEST_ID_) {
        
        NSDictionary *result = [data objectForKey:@"result"];
        if (![[result objectForKey:@"idAuditPassed"] isEqualToString:@"1"]) {
            [self.labelName2 setText:@"未检测到"];
            [self.labelSex2 setText:@"未检测到"];
            [self.labelBirth2 setText:@"未检测到"];
            [self.PersonID2 setText:@"未检测到"];
        }else{
            UserIfomodel = [IDmodel yy_modelWithJSON:result ];
//            debugLog(@"%@",UserIfomodel);
            [self.labelName2 setText:[NSString stringWithFormat:@"%@", UserIfomodel.vName]];
            if ([UserIfomodel.sex isEqualToString:@"0"]) {
                [self.labelSex2 setText:@"男"];
            }else{
                [self.labelSex2 setText:@"女"];
            }
            
            [self.labelBirth2 setText:[NSString stringWithFormat:@"%@",UserIfomodel.birthday]];
            [self.PersonID2 setText:[NSString stringWithFormat:@"%@",UserIfomodel.idNumber]];
        }
        
        
        if ([[data objectForKey:@"status"]intValue] == 1 &&[[result objectForKey:@"idAuditPassed"] isEqualToString:@"1"]) {
            
            [self performSelector:@selector(GoodAlpha) withObject:nil afterDelay:1.0f];
            
        }else{
            [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
            
        }
    }
    
    if (type == _REQUEST_DrivingID_) {
        //        NSDictionary *result = [data objectForKey:@"result"];
        //        UserIfomodel = [IDmodel yy_modelWithJSON:result ];
        //        debugLog(@"%@",UserIfomodel);
        NSDictionary *result = [data objectForKey:@"result"];
        if (![[result objectForKey:@"driverAuditPassed"] isEqualToString:@"1"]) {
            [self.labelName2 setText:@"未检测到"];
            [self.labelSex2 setText:@"未检测到"];
            [self.labelBirth2 setText:@"未检测到"];
            //            [self.PersonID2 setText:@"未检测到"];
        }else{
            driverModel = [DriverModel yy_modelWithJSON:result ];
//            debugLog(@"%@",UserIfomodel);
            [self.labelName setText:[NSString stringWithFormat:@"姓名"]];
            [self.labelSex setText:[NSString stringWithFormat:@"准驾车型"]];
            [self.labelBirth setText:[NSString stringWithFormat:@"证号"]];
            [self.labelName2 setText:[NSString stringWithFormat:@"%@", driverModel.vName]];
            [self.labelSex2 setText:[NSString stringWithFormat:@"%@",driverModel.driverCarType]];
            [self.labelBirth2 setText:[NSString stringWithFormat:@"%@",driverModel.driverNo]];
            [self.PersonID setHidden:YES];
            [self.PersonID2 setHidden:YES];
        }
        
        
//        debugLog(@"%@",[data objectForKey:@"status"]);
//        debugLog(@"%@",[result objectForKey:@"driverAuditPassed"]);
        
        if ([[data objectForKey:@"status"]intValue] == 1 && [[result objectForKey:@"driverAuditPassed"] isEqualToString:@"1"]) {
            
            [self performSelector:@selector(GoodAlpha) withObject:nil afterDelay:1.0f];
            
        }else{
            [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
        }
        
    }
    
    if (type == _REQUEST_FaceID_) {
        
        //判断服务器状态
        if ([[data objectForKey:@"status"]intValue] == 1) {
            //判断身份验证
            if ([[[data objectForKey:@"result"] objectForKey:@"faceAuditPassed"] integerValue] !=2) {
                
                [self steupStartScnBtn:Done];
                //                [_startScnBtn setTitle:@"完成认证" forState:UIControlStateNormal];
                [_startScnBtn.presentlab setText:@"认证成功"];
                CGFloat doneOKImgY =  CGRectGetMaxY(self.titleView.frame);
                
                UIImageView *doneOKImg = [[UIImageView alloc]init];
                [doneOKImg setFrame:CGRectMake(kScreenWidth/2-autoScaleW(173)/2, doneOKImgY+85, autoScaleW(173), autoScaleH(173))];
                [doneOKImg setImage:[UIImage imageNamed:@"img_done"]];
                [self.view addSubview:doneOKImg];
                [_scanView setHidden:YES];
                CGFloat labelNameY = CGRectGetMaxY(doneOKImg.frame);
                UILabel *labelName = [[UILabel alloc]init];
                [labelName setFrame:CGRectMake(0, labelNameY+30, kScreenWidth, 20)];
                [labelName setTextAlignment:NSTextAlignmentCenter];
                [labelName setTextColor:[UIColor colorWithHexString:@"#686868"]];
                [labelName setText:@"恭喜您完成全部认证！"];
                [StatisticsClass eventId:JZ05];
                [self.view addSubview:labelName];
                [_doneNOImg setHidden:YES];
                [self setTitle:@"完成认证"];
            }else{
//                debugLog(@"不是同一个人");
//                debugLog(@"%@",_doneNOImg);
                [_doneNOImg setHidden:NO];
                _titleView.tagS = 3;
                _titleView.tagH = 2;
                [_titleView setNeedsLayout];
                //                [self steupStartScnBtn:Living];
                [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
            }
            
        }else{
//            debugLog(@"服务器失败");
            [self steupStartScnBtn:Done];
            [self performSelector:@selector(BadAlpha) withObject:nil afterDelay:1.0f];
            //            CGFloat doneOKImgY =  CGRectGetMaxY(self.titleView.frame);
            //
            //            UIImageView *doneOKImg = [[UIImageView alloc]init];
            //            [doneOKImg setFrame:CGRectMake(kScreenWidth/2-autoScaleW(173)/2, doneOKImgY+85, autoScaleW(173), autoScaleH(173))];
            //            [doneOKImg setImage:[UIImage imageNamed:@"img_done"]];
            //            [self.view addSubview:doneOKImg];
        }
        
    }
    
}

#pragma mark - 图片上传进度
-(void)upProgress:(NSNotification *)notification{
    NSProgress *Progress = notification.object;
//    debugLog(@"传递的进度%f",Progress.fractionCompleted*100);
//    debugLog(@"传递的进度%f",Progress.fractionCompleted);
    //回到主线程刷新ui
    dispatch_async(dispatch_get_main_queue(), ^{
        [_startScnBtn setPresent:Progress.fractionCompleted*100];
    });
    
    
}

//当动画结束时进行下一步操作
-(void)onDone:(int)reaNimate{
//    debugLog(@"动画结束，可以跳转下一步");
    [_startScnBtn setUserInteractionEnabled:YES];
    if (ScanType ==1) {
        [self setupRescnIdCard:Drive];
    }else if (ScanType ==2){
        [self setupRescnIdCard:Living];
    }else{
        [self setupRescnIdCard:Personal];
    }
}

-(void)setupRescnIdCard:(personalOrDriveAndLiving)personalOrDriveAndLiving{
    [self.startScnBtn setHidden:YES];
    _reScn = [[UIButton alloc]init];
    _reScn = [[UIButton alloc]init];
    [_reScn setFrame:CGRectMake(kScreenWidth/2-((kScreenWidth-30)/2), autoScaleW(561), kScreenWidth/2-20, autoScaleH(48))];
    [_reScn setTitle:@"重新扫描" forState:UIControlStateNormal];
    [_reScn setTitleColor:[UIColor colorWithHexString:@"#9F9F9F"] forState:UIControlStateNormal];
    [_reScn.layer setBorderColor:[UIColor colorWithHexString:@"#E7EDEA"].CGColor];
    [_reScn.layer setBorderWidth:1.0];
    
    [_reScn setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#FCFCFC"]] forState:UIControlStateNormal];
    _reScn.layer.masksToBounds = YES;
    [_reScn.layer setCornerRadius:5.0];
    
    [self.view addSubview:_reScn];
    
    CGFloat nextScnX = CGRectGetMaxX(_reScn.frame);
    
    _nextScn = [[UIButton alloc]init];
    _nextScn = [[UIButton alloc]init];
    [_nextScn setFrame:CGRectMake(nextScnX+10, _reScn.origin.y, kScreenWidth/2-20, autoScaleH(48))];
    [_nextScn setTitle:@"确认无误" forState:UIControlStateNormal];
    [_nextScn setTitleColor:[UIColor colorWithHexString:@"#FCFCFC"] forState:UIControlStateNormal];
    [_nextScn.layer setBorderColor:[UIColor colorWithHexString:@"#E7EDEA"].CGColor];
    [_nextScn.layer setBorderWidth:1.0];
    
    [_nextScn setBackgroundImage:[UIColor imageWithColor:[UIColor colorWithHexString:@"#25D880"]] forState:UIControlStateNormal];
    _nextScn.layer.masksToBounds = YES;
    [_nextScn.layer setCornerRadius:5.0];
    
    [self.view addSubview:_nextScn];
    
    switch (personalOrDriveAndLiving) {
        case Personal:
        {
            [_reScn addTarget:self action:@selector(ScnCardIdCard:) forControlEvents:UIControlEventTouchUpInside];
            _reScn.tag =100;
            //暂时绑人脸
            
            [_nextScn addTarget:self action:@selector(drivingId:) forControlEvents:UIControlEventTouchUpInside];
            _nextScn.tag =101;
            
            [self setTitle:@"驾照认证"];
        }
            break;
        case Drive:
        {
            [_reScn addTarget:self action:@selector(ScnDriveCard:) forControlEvents:UIControlEventTouchUpInside];
            _reScn.tag =200;
            [_nextScn addTarget:self action:@selector(livingId:) forControlEvents:UIControlEventTouchUpInside];
            
            _nextScn.tag =201;
            [self setTitle:@"面部识别"];
        }
            break;
        case Living:
        {
            [_reScn addTarget:self action:@selector(ScnDriveCard:) forControlEvents:UIControlEventTouchUpInside];
            [_nextScn addTarget:self action:@selector(livingId:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
    
    
}
//成功的结束动画
-(void)GoodAlpha{
    [_startScnBtn OKAlpha];
    
}
//不成功的动画
-(void)BadAlpha{
    [_startScnBtn NOAlpha];
    [_startScnBtn setUserInteractionEnabled:YES];
    
}

-(void)VerificationFAQ:(UIButton *)button{
    
    //调试屏蔽
    
    [StatisticsClass eventId:SF02];
    
    if (FAQType ==1) {
        BaseWebController *webVC = [[BaseWebController alloc] init];
        webVC.homeUrl = ProIdUrl;
        webVC.webTitle = @"问题详情";
        webVC.delegate =self;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    if (FAQType ==2) {
        BaseWebController *webVC = [[BaseWebController alloc] init];
        webVC.homeUrl = ProIdUrl;
        webVC.webTitle = @"问题详情";
        webVC.delegate =self;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    if (FAQType ==3) {
        BaseWebController *webVC = [[BaseWebController alloc] init];
        webVC.homeUrl = FcaeRecognitionUrl;
        webVC.webTitle = @"问题详情";
        webVC.delegate =self;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    //    debugLog(@"%@",[UserInfo share].auditStatus);
    //
    //    ProIdentityIDViewController *proIDvc = [[ProIdentityIDViewController alloc]init];
    //    proIDvc.ProType = [[UserInfo share].auditStatus integerValue];
    //    [self.navigationController pushViewController:proIDvc animated:YES];
}

-(void)ProIdentityIDClick{
    ProIdentityIDViewController *proIDvc = [[ProIdentityIDViewController alloc]init];
    proIDvc.ProType = [[UserInfo share].auditStatus integerValue];
    [self.navigationController pushViewController:proIDvc animated:YES];
    
}


- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}


-(void)proIdentity{
    Type2View.hidden = YES;
    _titleView.top = NVBarAndStatusBarHeight+15;
    if ([[UserInfo share].auditStatus isEqualToString:@"2"]) {
        Type2View.hidden = NO;
        _titleView.top = NVBarAndStatusBarHeight+20;
        Type2View.backgroundColor = [UIColor colorWithHexString:@"#2EA2FF"];
        Type2Img.image = [UIImage imageNamed:@"icon_confirm_white"];
        label2title.text = @"您的人工认证申请正在受理中";
        label2Info.text = @"查看详情";
        label2RightImg.image = [UIImage imageNamed:@"icon_BackWhite"];
        _titleView.top = NVBarAndStatusBarHeight+20;
    }
    
    if ([[UserInfo share].auditStatus isEqualToString:@"3"]) {
        Type2View.hidden = NO;
        Type2View.backgroundColor = [UIColor colorWithHexString:@"#FF4C4C"];
        Type2Img.image = [UIImage imageNamed:@"icon_confirm_white"];
        label2title.text = @"您的人工认证申请未通过";
        label2Info.text = @"查看详情";
        label2RightImg.image = [UIImage imageNamed:@"icon_BackWhite"];
        _titleView.top = NVBarAndStatusBarHeight+20;
    }
}

-(void)pushType{
    ProIdentityIDViewController *proIDvc = [[ProIdentityIDViewController alloc]init];
    proIDvc.ProType = [[UserInfo share].auditStatus integerValue];
    [self.navigationController pushViewController:proIDvc animated:YES];
    
}

- (AVCaptureDevicePosition)getCamera:(BOOL)index{
    AVCaptureDevicePosition tempVideo;
    if (index == NO) {
        tempVideo = AVCaptureDevicePositionFront;
    }else{
        tempVideo = AVCaptureDevicePositionBack;
    }
    return tempVideo;
}


-(void)setLabelHDYES{
    [_labelName setHidden:YES];
    [_labelSex setHidden:YES];
    [_labelBirth setHidden:YES];
    [_PersonID setHidden:YES];
    [_labelName2 setHidden:YES];
    [_labelSex2 setHidden:YES];
    [_labelBirth2 setHidden:YES];
    [_PersonID2 setHidden:YES];
}

-(void)setLabelHDNO{
    [_labelName setHidden:NO];
    [_labelSex setHidden:NO];
    [_labelBirth setHidden:NO];
    [_PersonID setHidden:NO];
    [_labelName2 setHidden:NO];
    [_labelSex2 setHidden:NO];
    [_labelBirth2 setHidden:NO];
    [_PersonID2 setHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}

-(void)dealloc{
//    debugLog(@"可能完成");
    [_homeService requestUserAuthState];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//motion_cardscan0000


@end
