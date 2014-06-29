//
//  CELLTableViewCell.h
//  google api test
//
//  Created by Kundan Jadhav on 08/02/14.
//  Copyright (c) 2014 Kundan Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CELLTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *temp;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImage;

@property (strong, nonatomic) IBOutlet UILabel *weatherDesc;
@property (strong, nonatomic) IBOutlet UILabel *min;
@property (strong, nonatomic) IBOutlet UILabel *max;

@end
