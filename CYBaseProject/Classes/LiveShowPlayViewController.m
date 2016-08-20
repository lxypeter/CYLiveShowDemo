//
//  LiveShowPlayViewController.m
//  CYLiveShowDemo
//
//  Created by Peter Lee on 16/8/19.
//  Copyright © 2016年 CY.Lee. All rights reserved.
//

#import "LiveShowPlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LiveShowPlayViewController ()

@property (atomic, retain) id<IJKMediaPlayback> player;

@end

@implementation LiveShowPlayViewController

- (instancetype)initWithLiveShowUrl:(NSString *)liveShowUrl{
    self = [super init];
    if (self) {
        _liveShowUrl = [liveShowUrl copy];
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurePlayer];
    [self configureSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    if (![self.player isPlaying]) {
        [self.player prepareToPlay];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.player shutdown];
}

- (void)configurePlayer{
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.liveShowUrl] withOptions:nil];
    
    UIView *playerView = [self.player view];
    [self.view addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
    
    UIButton *playButton = [[UIButton alloc]init];
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    [playButton setTitle:@"暂停" forState:UIControlStateSelected];
    [playButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    playButton.selected = YES;
    [bottomView addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.mas_equalTo(200);
    }];
}

- (void)clickPlayButton:(UIButton *)playButton{
    playButton.selected = !playButton.selected;
    if (playButton.selected) {
        [self.player play];
    }else{
        [self.player pause];
    }
}

@end
