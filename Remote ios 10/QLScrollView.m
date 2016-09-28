//
//  QLScrollView.m
//  Remote ios 10
//
//  Created by SU on 16/9/22.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "QLScrollView.h"

@implementation QLScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        QLScrollView *scrollView = [[QLScrollView alloc] init];
        
        [scrollView.refreshControl beginRefreshing];
        
        
    }
    return self;
}

@end
