//
//  MagicCodeViewController.m
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

#import "MagicCodeViewController.h"

#import "VisualPairing.h"

@interface MagicCodeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *codeContainer;
@property (nonatomic, strong) VPPresenterView *codeView;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation MagicCodeViewController

- (instancetype)init
{
    self = [super init];

    self.title = @"Generate";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Generate" image:[UIImage imageNamed:@"generate"] tag:0];

    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

  
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self _configureAsPresenter];
}
- (void)_configureAsPresenter
{
    CGFloat codeSize = 300;

    self.codeContainer = [UIView new];

    self.codeContainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.codeContainer.clipsToBounds = YES;

    self.codeContainer.backgroundColor = [UIColor whiteColor];
    //self.codeContainer.layer.cornerRadius = codeSize/2;
   // self.codeContainer.layer.borderColor = [UIColor colorWithRed:0.00 green:0.49 blue:1.00 alpha:1.00].CGColor;
    //self.codeContainer.layer.borderWidth = 1;

    [self.view addSubview:self.codeContainer];

    [self.codeContainer.widthAnchor constraintEqualToConstant:codeSize].active = YES;
    [self.codeContainer.heightAnchor constraintEqualToConstant:codeSize].active = YES;
    [self.codeContainer.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.codeContainer.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    //[self _installParticles];
    [self createplayer];
    self.codeView = [[NSClassFromString(@"VPPresenterView") alloc] initWithFrame:CGRectZero];
    self.codeView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.codeContainer addSubview:self.codeView];

    [self.codeView.widthAnchor constraintEqualToAnchor:self.codeContainer.widthAnchor].active = YES;
    [self.codeView.heightAnchor constraintEqualToAnchor:self.codeContainer.heightAnchor].active = YES;
    [self.codeView.centerXAnchor constraintEqualToAnchor:self.codeContainer.centerXAnchor].active = YES;
    [self.codeView.centerYAnchor constraintEqualToAnchor:self.codeContainer.centerYAnchor].active = YES;
    self.codeView.alpha = 0.0 ;
    [self.codeView setVerificationCode:@"Proximity Pairing"];

    [self _installCodeField];
}
-(void)createplayer
{
    AVPlayerItem *playerItem = [self prepare];
    // 假设 cloudAVPlayer 和 cloudPlayerLayer 已经声明
    AVPlayer *cloudAVPlayer = [AVPlayer playerWithPlayerItem:playerItem];

    AVPlayerLayer *cloudPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:cloudAVPlayer];
    cloudAVPlayer.externalPlaybackVideoGravity = AVLayerVideoGravityResizeAspectFill;
    cloudPlayerLayer.frame = CGRectMake(0, 0, 300, 300); //self.codeContainer.bounds;
    [self.codeContainer.layer addSublayer:cloudPlayerLayer];

    // 添加状态观察者
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&_playerItemContext];

    // 添加播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];

    // 开始播放视频
    self.playerItem = playerItem;
    self.cloudAVPlayer = cloudAVPlayer;
    [cloudAVPlayer play];
    
    // 加载图片
    UIImage *image = [UIImage imageNamed:@"ProximityPairingMask"];
    if (!image) {
        NSLog(@"Image not found");
        return;
    }

    // 创建UIImageView并设置图片
    UIImageView *markView = [[UIImageView alloc] initWithImage:image];

    // 设置markView的中心点为self.view的中心点
    self.markView = markView;
    
//    [self.markView.widthAnchor constraintEqualToAnchor:self.codeContainer.widthAnchor].active = YES;
//    [self.markView.heightAnchor constraintEqualToAnchor:self.codeContainer.heightAnchor].active = YES;
//    [self.markView.centerXAnchor constraintEqualToAnchor:self.codeContainer.centerXAnchor].active = YES;
//    [self.markView.centerYAnchor constraintEqualToAnchor:self.codeContainer.centerYAnchor].active = YES;
    // 设置markView的尺寸（可选）
    // markView.frame = CGRectMake(markView.center.x - 200, markView.center.y - 200, 400, 400);

    // 将markView设置为self.view的遮罩
    self.codeContainer.maskView = markView;
    //self.markView.frame = CGRectMake(0, 0, 300, 300);
    //markView.center = self.codeContainer.center;
}
// 记得实现下面的方法来处理播放结束的通知
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (notification.object == self.playerItem) {
        // Handle the end of playback
        NSLog(@"Done....");
        __weak typeof(self) weakSelf = self;
        [self.playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf && strongSelf.cloudAVPlayer) {
                [strongSelf.cloudAVPlayer play];
            }
        }];
    }
}
-(AVPlayerItem*)prepare
{
    NSString *resourceName = @"ProximityPairingLoop";
    NSString *resourceExtension = @"mov";

    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:resourceExtension];
    if (fileURL) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
        return playerItem;
    } else {
        NSLog(@"File not found");
        return nil;
    }
}
- (void)_installParticles
{
//    NSData *assetData = [[NSDataAsset alloc] initWithName:@"particles"].data;
//    if (!assetData) return;
//
//    NSDictionary *caar = [NSKeyedUnarchiver unarchiveObjectWithData:assetData];
//    CALayer *rootLayer = caar[@"rootLayer"];
//    if (!rootLayer) return;
//
//    [self.codeContainer.layer addSublayer:rootLayer];
}

- (void)_installCodeField
{
    self.textField = [UITextField new];
    self.textField.delegate = self;
    self.textField.text = @"Proximity Pairing";
    self.textField.placeholder = @"Enter code to transmit";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;

    self.textField.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.textField];

    [self.textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16].active = YES;
    [self.textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16].active = YES;
    [self.textField.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16].active = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.codeView start];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.codeView stop];

    self.codeView.verificationCode = textField.text;

    [self.codeView start];

    [self.textField resignFirstResponder];

    return YES;
}
// 实现KVO回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &_playerItemContext) {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItem *theItem = (AVPlayerItem *)object;
            if (theItem.status == AVPlayerItemStatusFailed) {
                // Handle failure
            } else if (theItem.status == AVPlayerItemStatusReadyToPlay) {
                // Ready to play
            } else if (theItem.status == AVPlayerItemStatusUnknown) {
                // Unknown status
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
// 当视图布局发生变化时调用此方法来更新maskView的frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.codeContainer.maskView) {
        UIImageView *maskView = (UIImageView *)self.codeContainer.maskView;
        
        // 更新maskView的中心点
        maskView.center = CGPointMake(self.codeContainer.bounds.size.width / 2, self.codeContainer.bounds.size.height / 2);
        
        // 如果需要保持maskView的宽高比或固定尺寸，可以根据需要调整frame
        CGFloat maskSize = 300.0;
        maskView.frame = CGRectMake(maskView.center.x - maskSize / 2, maskView.center.y - maskSize / 2, maskSize, maskSize);
    }
}

@end

