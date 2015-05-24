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
@property (weak, nonatomic) IBOutlet UIImageView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *innerView;
@property (weak, nonatomic) IBOutlet UIImageView *ssView;

@property (weak, nonatomic) IBOutlet UIImageView *tick6View;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isTilted;


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
    self.isTilted = NO;
    
    [self animating:1];
    [self beginTilt];
//    [self performSelector:@selector(beginTilt) withObject:nil afterDelay:2.9];
}

- (void)onEnterBackground
{
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
    
    self.tick6View.transform = CGAffineTransformIdentity;
    self.outView.transform = CGAffineTransformIdentity;
    self.innerView.transform = CGAffineTransformIdentity;
    self.ssView.transform = CGAffineTransformIdentity;
}

- (void)beginTilt
{
    [UIView animateWithDuration:2 animations:^{
        
//        self.isTilted = YES;
        CGRect frame = _frame1;
        frame.origin.y -= 120;
        self.tick6View.frame = frame;
        
        frame = _frame3;
        frame.origin.y -= 80;
        self.innerView.frame = frame;
        
        frame = _frame4;
        frame.origin.y -= 40;
        self.ssView.frame = frame;
        
        frame = _frame5;
        frame.origin.y -= 150;
        self.hourLabel.frame = frame;
        
        frame = _frame6;
        frame.origin.y -= 150;
        self.minuteLabel.frame = frame;
        
        CATransform3D transform = CATransform3DMakeRotation(1.2, 1, 0, 0);
        self.tick6View.layer.transform = transform;
        self.outView.layer.transform = transform;
        self.innerView.layer.transform = transform;
        self.ssView.layer.transform = transform;
    }completion:^(BOOL finished) {
        if (!finished)
            return;
        self.isTilted = YES;
        
        [self view:self.ssView turnAround:M_PI_2 * 0.25 step:1];
        [self view:self.tick6View turnAround:M_PI_2 step:1];
        [self view:self.outView turnAround:-M_PI_2 step:1];
        [self view:self.innerView turnAround:-M_PI_2 * 0.25 step:1];
    }];
}


- (void)animating:(int)step
{
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        if (_isTilted)
            return;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2 * step);
        self.tick6View.transform = transform;
        self.outView.transform = transform;
        self.innerView.transform = transform;
        self.ssView.transform = transform;
    } completion:^(BOOL finished) {
        if (_isTilted || !finished)
            return;
        [self animating:step % 4 + 1];
    }];
}

- (void)view:(UIView *)view turnAround:(CGFloat)angle step:(int)step
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CATransform3D transform = CATransform3DMakeRotation(1.2, 1, 0, 0);
        transform = CATransform3DRotate(transform, angle * step, 0, 0, 1);
        view.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        
        if (!finished)
            return;
        [self view:view turnAround:angle step:(step % (int)(M_PI * 2 / ABS(angle)) + 1)];
    }];
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
}


@end
