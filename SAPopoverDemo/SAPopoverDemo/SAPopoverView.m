//
//  SAPopoverView.m
//  popTest
//
//  Created by sagles on 14/12/11.
//  Copyright (c) 2014年 SA. All rights reserved.
//

#import "SAPopoverView.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat angleLength = 10.f;
static CGPoint anglePoints[3];

@interface SAPopoverView ()

/**
 *  <#Description#>
 */
@property (nonatomic, strong) UIView *contentView;

/**
 *  <#Description#>
 */
@property (nonatomic, strong) UIWindow *window;

/**
 *  <#Description#>
 */
@property (nonatomic, weak) UIView *saInnerView;

@end

@implementation SAPopoverView

+ (instancetype)popoverViewWithView:(UIView *)view
{
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)innerView
{
    if (self = [self init]) {
        
        self.backgroundColor = [UIColor clearColor];
        _angle = 45.f;
        _popoverColor = [UIColor blackColor];
        _popoverAlpha = .5f;
        
        _contentView = ({
            UIView *view = [[UIView alloc] initWithFrame:innerView.bounds];
            view.clipsToBounds = YES;
            
            [view addSubview:innerView];
            _saInnerView = innerView;
            
            [self addSubview:view];
            
            view;
        });
    }
    return self;
}

- (void)showWithView:(UIView *)view
{
//    self.contentView.backgroundColor = self.popoverColor;
//    self.contentView.alpha = self.popoverAlpha;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelAlert;
    
    self.contentView.frame = CGRectInset(self.saInnerView.frame, -_innerPadding, -_innerPadding);
    if (self.cornerRadio > 0.f) {
        self.contentView.layer.cornerRadius = self.cornerRadio;
    }
    
    [self popoverViewFrameWithView:view];
    
    self.saInnerView.center = CGPointMake(ceilf(self.contentView.frame.size.width/2), ceilf(self.contentView.frame.size.height/2));
    
    self.frame = self.window.bounds;
    
    __weak typeof(self) wSelf = self;
    [self.window addSubview:wSelf];
    [self.window makeKeyAndVisible];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, self.popoverColor.CGColor);
    CGContextSetAlpha(ctx, self.popoverAlpha);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.frame cornerRadius:self.cornerRadio].CGPath;
    
    CGContextAddPath(ctx, path);
    
    CGContextMoveToPoint(ctx, anglePoints[0].x, anglePoints[0].y);
    CGContextAddLineToPoint(ctx, anglePoints[1].x, anglePoints[1].y);
    CGContextAddLineToPoint(ctx, anglePoints[2].x, anglePoints[2].y);
    
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissPopoverView:YES];
}

- (void)dismissPopoverView:(BOOL)animate
{
    if (animate) {
        self.userInteractionEnabled = NO;
        [UIView transitionWithView:self
                          duration:.35f
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.alpha = 0.f;
                        } completion:^(BOOL finished) {
                            [self removeFromSuperview];
                        }];
    }
    else {
        [self removeFromSuperview];
    }
}

#pragma mark - Touch events

- (void)tapOnPopover:(UITapGestureRecognizer *)gestureRecognizer
{
    [self dismissPopoverView:YES];
}

#pragma mark - Private methods

- (CGRect)popoverViewFrameWithView:(UIView *)view
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect viewFrame = [view.superview convertRect:view.frame toView:view.window];
    CGRect popFrame = self.contentView.frame;
    
    CGFloat radian = M_PI/180 * self.angle;
    
    UIEdgeInsets edge = UIEdgeInsetsMake(CGRectGetMinY(viewFrame), CGRectGetMinX(viewFrame), frame.size.height - CGRectGetMaxY(viewFrame), frame.size.width - CGRectGetMaxX(viewFrame));
    
    if (edge.top >= popFrame.size.height+angleLength+self.controlPadding) {
        CGPoint vertexPoint = CGPointMake(CGRectGetMinX(viewFrame)+viewFrame.size.width/2, CGRectGetMinY(viewFrame)-self.controlPadding);
        CGFloat offset_x = ceilf(vertexPoint.x) - ceil(popFrame.size.width/2);
        popFrame.origin.x = offset_x < 0.f ? 8.f : offset_x;
        popFrame.origin.y = ceil(vertexPoint.y) - (popFrame.size.height+angleLength);
        
        anglePoints[0] = vertexPoint;
        anglePoints[1] = CGPointMake(vertexPoint.x - (angleLength/tanf(radian)), vertexPoint.y-angleLength);
        anglePoints[2] = CGPointMake(vertexPoint.x + (angleLength/tanf(radian)), vertexPoint.y-angleLength);
        
    }
    else if (edge.bottom >= popFrame.size.height+angleLength+self.controlPadding) {
        CGPoint vertexPoint = CGPointMake(CGRectGetMinX(viewFrame)+viewFrame.size.width/2, CGRectGetMaxY(viewFrame)+self.controlPadding);
        CGFloat offset_x = ceilf(vertexPoint.x) - ceil(popFrame.size.width/2);
        popFrame.origin.x = offset_x < 0.f ? 8.f : offset_x;
        popFrame.origin.y = ceil(vertexPoint.y) + angleLength;
        
        anglePoints[0] = vertexPoint;
        anglePoints[1] = CGPointMake(vertexPoint.x - (angleLength/tanf(radian)), vertexPoint.y+angleLength);
        anglePoints[2] = CGPointMake(vertexPoint.x + (angleLength/tanf(radian)), vertexPoint.y+angleLength);
        
    }
    else if (edge.left >= popFrame.size.width+angleLength+self.controlPadding) {
        CGPoint vertexPoint = CGPointMake(CGRectGetMinX(viewFrame)-self.controlPadding, CGRectGetMinY(viewFrame)+viewFrame.size.height/2);
        CGFloat offset_y = ceil(vertexPoint.y) - ceil(popFrame.size.height/2);
        popFrame.origin.x = ceil(vertexPoint.x) - (popFrame.size.width+angleLength);
        popFrame.origin.y = offset_y < 0.f ? 8.f : offset_y;
        
        anglePoints[0] = vertexPoint;
        anglePoints[1] = CGPointMake(vertexPoint.x - angleLength, vertexPoint.y - (angleLength/tanf(radian)));
        anglePoints[2] = CGPointMake(vertexPoint.x - angleLength, vertexPoint.y + (angleLength/tanf(radian)));
        
    }
    else if (edge.right >= popFrame.size.width+angleLength+self.controlPadding) {
        CGPoint vertexPoint = CGPointMake(CGRectGetMaxX(viewFrame)+self.controlPadding, CGRectGetMinY(viewFrame)+viewFrame.size.height/2);
        CGFloat offset_y = ceil(vertexPoint.y) - ceil(popFrame.size.height/2);
        popFrame.origin.x = ceil(vertexPoint.x) + angleLength;
        popFrame.origin.y = offset_y < 0.f ? 8.f : offset_y;
        
        anglePoints[0] = vertexPoint;
        anglePoints[1] = CGPointMake(vertexPoint.x + angleLength, vertexPoint.y - (angleLength/tanf(radian)));
        anglePoints[2] = CGPointMake(vertexPoint.x + angleLength, vertexPoint.y + (angleLength/tanf(radian)));
    }
    else {
        popFrame = CGRectZero;
    }
    
    self.contentView.frame = popFrame;
    
    return self.contentView.frame;
}

@end

@implementation UIView (SAPopoverView)

- (SAPopoverView *)popoverView
{
    for (UIView *view = self; view; view = view.superview)
        if ([view.nextResponder isKindOfClass:[SAPopoverView class]])
            return (SAPopoverView *)view.nextResponder;
    
    return nil;
}

@end
