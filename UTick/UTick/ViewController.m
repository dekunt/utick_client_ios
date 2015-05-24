//
//  ViewController.m
//  UTick
//
//  Created by dekunt on 15/5/22.
//  Copyright (c) 2015年 MeU. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define FONT_WITH_SIZE(sizeValue)       [UIFont fontWithName:@"OCRAStd" size:(sizeValue)]


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *clockView;
@property (weak, nonatomic) IBOutlet UIImageView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *innerView;
@property (weak, nonatomic) IBOutlet UIImageView *ssView;

@property (weak, nonatomic) IBOutlet UIImageView *tick6View;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (strong, nonatomic) NSTimer *timer;


@property (nonatomic) CGRect frame1;
@property (nonatomic) CGRect frame2;
@property (nonatomic) CGRect frame3;
@property (nonatomic) CGRect frame4;
@property (nonatomic) CGRect frame5;
@property (nonatomic) CGRect frame6;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate addHandlerForEnterBackground:^{
        [self onEnterBackground];
    }];
    [appDelegate addHandlerForEnterForeground:^{
        [self onEnterForefround];
    }];
    
    _frame1 = self.tick6View.frame;
    _frame2 = self.outView.frame;
    _frame3 = self.innerView.frame;
    _frame4 = self.ssView.frame;
    _frame5 = self.hourLabel.frame;
    _frame6 = self.minuteLabel.frame;
    [self updateTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self onEnterForefround];
}

- (void)onEnterForefround
{
    [self view:self.ssView turnAround:20];
    [self view:self.tick6View turnAround:90];
    [self view:self.outView turnAround:-90];
    [self view:self.innerView turnAround:-20];
    [self performSelector:@selector(beginTilt) withObject:nil afterDelay:0.3];
}

- (void)onEnterBackground
{
    [self.clockView.layer removeAllAnimations];
    [self.tick6View.layer removeAllAnimations];
    [self.outView.layer removeAllAnimations];
    [self.innerView.layer removeAllAnimations];
    [self.ssView.layer removeAllAnimations];
    [self.hourLabel.layer removeAllAnimations];
    [self.minuteLabel.layer removeAllAnimations];

    self.tick6View.frame = _frame1;
    self.innerView.frame = _frame3;
    self.ssView.frame = _frame4;
    self.hourLabel.frame = _frame5;
    self.minuteLabel.frame = _frame6;
    
    self.clockView.transform = CGAffineTransformIdentity;
    self.tick6View.transform = CGAffineTransformIdentity;
    self.outView.transform = CGAffineTransformIdentity;
    self.innerView.transform = CGAffineTransformIdentity;
    self.ssView.transform = CGAffineTransformIdentity;
}

- (void)beginTilt
{
    [UIView animateWithDuration:2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.clockView.transform = transform;
    }];
    [UIView animateWithDuration:2 animations:^{
        
        CGRect frame = _frame1;
        frame.origin.y -= 360;
        self.tick6View.frame = frame;
        
        frame = _frame3;
        frame.origin.y -= 240;
        self.innerView.frame = frame;
        
        frame = _frame4;
        frame.origin.y -= 120;
        self.ssView.frame = frame;
        
        CATransform3D transform = CATransform3DMakeRotation(1.2, 1, 0, 0);
        self.clockView.layer.transform = transform;
    }];
    
    [UIView animateWithDuration:1.3 animations:^{
        
        CGRect frame = _frame5;
        frame.origin.x += 50;
        frame.origin.y -= 200;
        self.hourLabel.frame = frame;
        
        frame = _frame6;
        frame.origin.x += 50;
        frame.origin.y -= 210;
        self.minuteLabel.frame = frame;
    }  completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect frame = _frame5;
            frame.origin.y -= 160;
            self.hourLabel.frame = frame;
            
            frame = _frame6;
            frame.origin.y -= 160;
            self.minuteLabel.frame = frame;
        } completion:nil];
    }];
}


- (void)view:(UIView *)view turnAround:(CGFloat)angle
{
    if (angle == 0) {
        Log_Err(@"angle == 0");
        return;
    }
    CGFloat duration = 360.0f / ABS(angle);
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: angle > 0 ? M_2_PI : -M_2_PI];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)updateTime
{
    [self.timer invalidate];
    self.timer = nil;
    
    NSDate *time = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH"];
    [self.hourLabel setText:[formatter stringFromDate:time]];
    [formatter setDateFormat:@"mm"];
    [self.minuteLabel setText:[formatter stringFromDate:time]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
}


@end
