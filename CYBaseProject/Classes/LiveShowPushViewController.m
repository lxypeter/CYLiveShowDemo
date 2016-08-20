//
//  LiveShowPushViewController.m
//  CYLiveShowDemo
//
//  Created by Peter Lee on 16/8/19.
//  Copyright © 2016年 CY.Lee. All rights reserved.
//

#import "LiveShowPushViewController.h"
#import <LFLiveKit/LFLiveKit.h>

@interface LiveShowPushViewController () <LFLiveSessionDelegate>

@property (nonatomic, strong) LFLiveSession *session;

@end

@implementation LiveShowPushViewController

#pragma mark - lazyLoad
- (LFLiveSession*)session {
    if (!_session) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.preView = self.view;
        _session.delegate = self;
    }
    return _session;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self authorizeVideo];
    [self configureSubViews];
}

- (void)configureSubViews{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UIButton *liveButton = [[UIButton alloc]init];
    [liveButton setTitle:@"开始直播" forState:UIControlStateNormal];
    [liveButton setTitle:@"停止直播" forState:UIControlStateSelected];
    [liveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [liveButton addTarget:self action:@selector(clickLiveButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:liveButton];
    [liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.mas_equalTo(200);
    }];
}

#pragma mark - authorized
- (void)authorizeVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            [_self.session setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

#pragma mark - event method
- (void)clickLiveButton:(UIButton *)liveButton{
    liveButton.selected = !liveButton.selected;
    if (liveButton.selected) {
        [self startLive];
    }else{
        [self stopLive];
    }
}

- (void)startLive {
    LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
    //测试用地址
    streamInfo.url = @"rtmp://live.hkstv.hk.lxdns.com:1935/live/lxy";
    [self.session startLive:streamInfo];
}

- (void)stopLive {
    [self.session stopLive];
}

#pragma mark - LFLiveKit delegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
}

@end
