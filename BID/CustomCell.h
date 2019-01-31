//
//  CustomCell.h
//  PresentationLayer
//
//  Created by yyshen on 2017/8/27.
//  Copyright © 2017年 shen. All rights reserved.
//

#ifndef CustomCell_h
#define CustomCell_h


#endif /* CustomCell_h */

#import <UIKit/UIKit.h>
#import "CheckBox.h"

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleText;

@property (weak, nonatomic) IBOutlet UITextField *startTimeText;

@property (weak, nonatomic) IBOutlet UITextField *toTimeText;

@property (nonatomic, weak) IBOutlet CheckBox *checkBox;


@end
