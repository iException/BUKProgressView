//
//  BUKSlideView.m
//  Baixing
//
//  Created by phoebus on 5/28/15.
//  Copyright (c) 2015 baixing. All rights reserved.
//

#import "BUKSlideView.h"

@interface BUKSlideView ()

/// The indicator of slide view
@property (nonatomic, strong) UIImage *indicator;

@end

@implementation BUKSlideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self registerKVO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self registerKVO];
    }
    return self;
}

- (void)registerKVO
{
    // register kvo forKeyPath: percentage
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(percentage))
              options:NSKeyValueObservingOptionNew
              context:nil];
}

#pragma mark - getter & setter -
- (void)setPercentage:(CGFloat)percentage
{
    NSAssert((isnan(percentage) == NO), @"percentage value is nan");
    NSAssert((percentage >= 0.0f && percentage <= 1.0f), @"percentage value must between 0.0f and 1.0f");
    
    if ( percentage < 0.0f || percentage > 1.0f || isnan(percentage) ) {
        _percentage = 0.0f;     // reset to zero
        [self setNeedsDisplay];
        return;
    }
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(percentage))];
    _percentage = percentage;
    [self didChangeValueForKey:NSStringFromSelector(@selector(percentage))];
}

- (UIColor *)foreColor
{
    // return custom fore color
    if ( _foreColor ) { return _foreColor; }
    
    // return default fore color
    return [UIColor colorWithRed:0xff/255.0f green:0x77/255.0f blue:0x00/255.0f alpha:1.0f];
}

- (UIColor *)backColor
{
    // return custom back color
    if ( _backColor ) { return _backColor; }
    
    // return default back color
    return [UIColor colorWithRed:0x66/255.0f green:0x66/255.0f blue:0x66/255.0f alpha:1.0f];
}

- (UIImage *)indicator
{
    // return image indicator
    if ( self.indicatorImage ) { return self.indicatorImage; }
    
    // return color indicator
    return [self defaultIndicator:self.indicatorColor];
}

- (UIImage *)defaultIndicator:(UIColor *)color
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGRect rect = CGRectMake(0, 0, 20, 20);
        if ( color ) {
            CGContextSetFillColorWithColor(ctx, color.CGColor);
        } else {
            CGContextSetFillColorWithColor(ctx, [UIColor cyanColor].CGColor);
        }
        CGContextFillEllipseInRect(ctx, rect);
        
        // get image from context
        _indicator = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGContextRestoreGState(ctx);
    });
    return _indicator;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    UIImage *thumb    = self.indicator;
    CGFloat offsetX   = thumb.size.width / 2;
    CGFloat offsetY   = self.bounds.size.height / 2;
    CGFloat lineWidth = self.bounds.size.width - thumb.size.width;
     
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    
    CGContextSetStrokeColorWithColor(context, self.backColor.CGColor);
    CGContextMoveToPoint(context, offsetX, offsetY);
    CGContextAddLineToPoint(context, offsetX + lineWidth, offsetY);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, self.foreColor.CGColor);
    CGContextMoveToPoint(context, offsetX, offsetY);
    CGContextAddLineToPoint(context, offsetX + lineWidth * self.percentage, offsetY);
    CGContextStrokePath(context);
    
    [thumb drawAtPoint:CGPointMake(lineWidth * self.percentage, offsetY - thumb.size.height / 2)];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ( [keyPath isEqualToString:@"percentage"] ) {
        // re call drawRect: to update ui
        [self setNeedsDisplay];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    // un register kvo forKeyPath: percentage
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(percentage))];
}

@end
