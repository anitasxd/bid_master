//
//  CheckBox.h
//  PresentationLayer
//
//  Created by yyshen on 2017/8/27.
//  Copyright © 2017年 shen. All rights reserved.
//

#ifndef CheckBox_h
#define CheckBox_h


#endif /* CheckBox_h */

#import <UIKit/UIKit.h>

@interface CheckBox : UIControl

//! The control state.
@property (nonatomic, readwrite, getter = isChecked) BOOL checked;

//! The color of the box surrounding the tappable area of the Checkbox control.
//!
//! In iOS 7, all views have a tintColor property.  We redeclare that property
//! here to accommodate tint color customization for iOS 6 devices.
@property (nonatomic, strong) UIColor *tintColor;

@end
