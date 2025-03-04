//
//  MagicCodeViewController.h
//  VisualPairingHack
//
//  Created by Guilherme Rambo on 23/02/19.
//  Copyright © 2019 Guilherme Rambo. All rights reserved.
//

@import UIKit;

@import  AVFoundation;
@interface MagicCodeViewController : UIViewController{
    void *_playerItemContext;
}
@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) AVPlayer *cloudAVPlayer;
@property (nonatomic,strong) UIImageView *markView ;
@end

