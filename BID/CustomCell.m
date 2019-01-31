//
//  CustomCell.m
//  PresentationLayer
//
//  Created by yyshen on 2017/8/27.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CustomCell.h"

@implementation CustomCell

- (IBAction)onClickStart:(UITextField *)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PickerNotification"
     object:self.startTimeText];
}

- (IBAction)onClickTo:(UITextField *)sender {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PickerNotification2"
     object:self.toTimeText];
}

@end
