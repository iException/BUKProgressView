//
//  BUKSlideView.h
//  Baixing
//
//  Created by phoebus on 5/28/15.
//  Copyright (c) 2015 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BUKSlideView : UIView

/// The percentage of slide view
@property (nonatomic, assign) CGFloat percentage;

/// The foreground color of slide view
@property (nonatomic, strong) UIColor *foreColor;

/// The background color of slide view
@property (nonatomic, strong) UIColor *backColor;

/// The indicator color of slide view
@property (nonatomic, strong) UIColor *indicatorColor;

/// The indicator image of slide view
@property (nonatomic, strong) UIImage *indicatorImage;

@end
