//
//  SAPopoverView.h
//  popTest
//
//  Created by sagles on 14/12/11.
//  Copyright (c) 2014年 SA. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义popover，传入自定义view后会生成一个popover（UI根据参数定）。popover基于window（alertLevel），若自定义view有事件需要响应，
 *  则应该在响应方法的末尾加上popover的dismiss函数，若点击无自定义响应的区域，popover会自动消失。
 */
@interface SAPopoverView : UIView

/**
 *  背景色
 */
@property (nonatomic, strong) UIColor *popoverColor;

/**
 *  背景透明度
 */
@property (nonatomic, assign) CGFloat popoverAlpha;

/**
 *  圆角半径
 */
@property (nonatomic, assign) CGFloat cornerRadio;

/**
 *  popoverView跟指向控件的距离
 */
@property (nonatomic, assign) CGFloat controlPadding;

/**
 *  传入view跟popoverView内部的边距
 */
@property (nonatomic, assign) CGFloat innerPadding;

/**
 *  箭头等腰三角形等腰角角度，默认45°
 */
@property (nonatomic, assign) CGFloat angle;


+ (instancetype)popoverViewWithView:(UIView *)view;

- (instancetype)initWithView:(UIView *)view;

- (void)showWithView:(UIView *)view;

- (void)dismissPopoverView:(BOOL)animate;

@end

@interface UIView (SAPopoverView)

- (SAPopoverView *)popoverView;

@end
