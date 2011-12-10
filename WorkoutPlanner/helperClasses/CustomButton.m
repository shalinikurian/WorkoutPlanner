//
//  CustomButton.m
//  WorkoutPlanner
//
//  Created by Shalini Kurian on 11/24/11.
//  Copyright (c) 2011 Stanford . All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize indexPath = _indexPath;
@synthesize exercise = _exercise;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed: @"add.png"]
              forState:UIControlStateNormal];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
