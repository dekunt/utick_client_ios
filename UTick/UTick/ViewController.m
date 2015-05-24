//
//  ViewController.m
//  UTick
//
//  Created by dekunt on 15/5/22.
//  Copyright (c) 2015年 MeU. All rights reserved.
//

#import "ViewController.h"

#define FONT_WITH_SIZE(sizeValue)       [UIFont fontWithName:@"OCRAStd" size:(sizeValue)]


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *innerView;
@property (weak, nonatomic) IBOutlet UIImageView *ssView;

@property (weak, nonatomic) IBOutlet UIImageView *tick6View;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL notFirstLoad;
@property (nonatomic) BOOL isTilted;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTime];
    self.isTilted = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_notFirstLoad)
        return;
    _notFirstLoad = YES;
    
    [self animating:1];
    [self beginTilt];
//    [self performSelector:@selector(beginTilt) withObject:nil afterDelay:4];
}


- (void)beginTilt
{
    [UIView animateWithDuration:1 animations:^{
        
//        self.isTilted = YES;
        CGRect frame = self.tick6View.frame;
        frame.origin.y -= 90;
        self.tick6View.frame = frame;
        
        frame = self.innerView.frame;
        frame.origin.y -= 60;
        self.innerView.frame = frame;
        
        frame = self.ssView.frame;
        frame.origin.y -= 30;
        self.ssView.frame = frame;
        
        CATransform3D transform = CATransform3DMakeRotation(1.2, 1, 0, 0);
        self.tick6View.layer.transform = transform;
        self.outView.layer.transform = transform;
        self.innerView.layer.transform = transform;
        self.ssView.layer.transform = transform;
    }completion:^(BOOL finished) {
        self.isTilted = YES;
        [self turnAround:1];
    }];
}


- (void)animating:(int)step
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        if (_isTilted)
            return;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2 * step);
        self.tick6View.transform = transform;
        self.outView.transform = transform;
        self.innerView.transform = transform;
        self.ssView.transform = transform;
    } completion:^(BOOL finished) {
        if (_isTilted)
            return;
        [self animating:step % 4 + 1];
    }];
}

- (void)turnAround:(int)step
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        CATransform3D transform = CATransform3DMakeRotation(1.2, 1, 0, 0);
        transform = CATransform3DRotate(transform, M_PI_2 * step, 0, 0, 1);
        self.tick6View.layer.transform = transform;
        self.outView.layer.transform = transform;
        self.innerView.layer.transform = transform;
        self.ssView.layer.transform = transform;
    } completion:^(BOOL finished) {
        [self turnAround:step % 4 + 1];
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
