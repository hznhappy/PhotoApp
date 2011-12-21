//
//  GridView.m
//  PhotoApp
//
//  Created by Andy on 12/21/11.
//  Copyright 2011 chinarewards. All rights reserved.
//

#import "GridView.h"

@implementation GridView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGFloat colX1 = maxX/3.0;
    CGFloat colX2 = 2*colX1;
    CGFloat rowY1 = maxY/3.0;
    CGFloat rowY2 = 2*rowY1;
    
    CGContextBeginPath(context);
    //draw the border
    CGContextSetLineWidth(context, 4.0f);
    CGContextMoveToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, minX, minY);
    CGContextStrokePath(context);

    //draw the grid line
    CGContextSetLineWidth(context, 1.2f);
    CGContextMoveToPoint(context, colX1, CGRectGetMinY(rect));  
    CGContextAddLineToPoint(context, colX1, CGRectGetMaxY(rect));
    
    CGContextMoveToPoint(context, colX2, CGRectGetMinY(rect));
    CGContextAddLineToPoint(context, colX2, CGRectGetMaxY(rect));
    
    CGContextMoveToPoint(context, CGRectGetMinX(rect),rowY1);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect),rowY1);
    
    CGContextMoveToPoint(context, CGRectGetMinX(rect),rowY2);
    CGContextAddLineToPoint(context,CGRectGetMaxX(rect),rowY2);
    
    CGContextStrokePath(context);
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
