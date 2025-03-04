//
//  VisualPairing.h
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@interface VPScannerViewController : UIViewController

+ (instancetype)instantiateViewController;

@property(copy, nonatomic) NSString *titleMessage;
@property(copy, nonatomic) void(^scannedCodeHandler)(NSString *);

@end
//
//@interface VPPresenterView: UIView
//
//- (void)start;
//- (void)stop;
//
//@property (nonatomic, copy) NSString *verificationCode;
//
//@end

/*
* This header is generated by classdump-dyld 1.0
* on Friday, February 12, 2021 at 12:44:11 AM Eastern European Standard Time
* Operating System: Version 14.4 (Build 18D52)
* Image Source: /System/Library/PrivateFrameworks/VisualPairing.framework/VisualPairing
* classdump-dyld is licensed under GPLv3, Copyright © 2013-2016 by Elias Limneos.
*/

//#import <UIKitCore/UIView.h>

@protocol OS_dispatch_source;
@class AVPlayer, CALayer, NSArray, NSObject, NSString;

@interface VPPresenterView : UIView {

    AVPlayer* _moviePlayer;
    BOOL _started;
    CALayer* _watermarkLayer;
    NSArray* _watermarkPixelBuffers;
    unsigned long long _watermarkStepIndex;
    NSObject<OS_dispatch_source> *_watermarkStepTimer;
    unsigned _flags;
    NSString* _verificationCode;
}
@property (assign,nonatomic) unsigned flags;                         //@synthesize flags=_flags - In the implementation block
@property (nonatomic,copy) NSString * verificationCode;              //@synthesize verificationCode=_verificationCode - In the implementation block
-(void)layoutSubviews;
-(void)stop;
-(void)setFlags:(unsigned)arg1 ;
-(NSString *)verificationCode;
-(void)setVerificationCode:(NSString *)arg1 ;
-(void)start;
-(unsigned)flags;
-(void)_watermarkStep;
@end
