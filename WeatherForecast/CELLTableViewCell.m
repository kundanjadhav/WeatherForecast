//
//  CELLTableViewCell.m
//  google api test
//
//  Created by Kundan Jadhav on 08/02/14.
//  Copyright (c) 2014 Kundan Jadhav. All rights reserved.
//

#import "CELLTableViewCell.h"

@implementation CELLTableViewCell
@synthesize date,day,temp,weatherImage,weatherDesc,min,max;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
