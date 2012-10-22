//
//  AlertView.m
//  SPBoilerplate
//
//  Created by Local Dev User on 17/10/12.
//  Copyright (c) 2012 Speedwell. All rights reserved.
//

#import "TSAlertView.h"

static const CGFloat kSpaceFromTitleToContent = 15.0f;
static const CGFloat kSpaceFromContentToBottom = 15.0f;

@interface TSAlertView()

- (CGSize)desiredTitleSize;
- (CGSize)desiredContentSize;

@end

@implementation TSAlertView

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat runningY = 0.0f;
    // The title label
    CGSize desiredTitleSize = [self desiredTitleSize];
    CGSize desiredContentSize = [self desiredContentSize];
    
    if (desiredTitleSize.height > 46) {
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, desiredTitleSize.height);
        self.titleBackgroundImageView.frame = CGRectMake(self.titleBackgroundImageView.frame.origin.x, self.titleBackgroundImageView.frame.origin.y, self.titleBackgroundImageView.frame.size.width, desiredTitleSize.height + kSpaceFromTitleToContent);
    }
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, desiredContentSize.height);
    
    runningY = self.titleBackgroundImageView.frame.origin.y + self.titleBackgroundImageView.frame.size.height + 5;
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.titleBackgroundImageView.frame.origin.y + self.titleBackgroundImageView.frame.size.height + 5, self.contentLabel.frame.size.width,  self.contentLabel.frame.size.height);
    runningY += desiredContentSize.height + kSpaceFromContentToBottom;
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y, self.containerView.frame.size.width, runningY);
    // Note: If containerView is smaller than self frame, then [self frame] it will still be there, sticking out under teh content label, however it's clear so you can't see it.
}

- (CGSize)desiredTitleSize
{
    return [self.titleLabel.text sizeWithFont:self.titleLabel.font
                            constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)
                                lineBreakMode:UILineBreakModeWordWrap];
}

- (CGSize)desiredContentSize
{
    return [self.contentLabel.text sizeWithFont:self.contentLabel.font
                              constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, CGFLOAT_MAX)
                                  lineBreakMode:UILineBreakModeWordWrap];
}

@end
