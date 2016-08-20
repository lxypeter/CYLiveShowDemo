//
//  LiveShowPlayViewController.h
//  CYLiveShowDemo
//
//  Created by Peter Lee on 16/8/19.
//  Copyright © 2016年 CY.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveShowPlayViewController : UIViewController

@property (nonatomic, copy) NSString *liveShowUrl;

- (instancetype)initWithLiveShowUrl:(NSString *)liveShowUrl;

@end
