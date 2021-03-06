//
//  MKStepView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStepView.h"
#import "MKPostView.h"
#import "MKBuyBid.h"

@implementation MKStepView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor whiteColor];
    }
    
    return self;
}

- (void)syncFromNode
{
    self.backgroundColor = [self.nodeTitleAttributes objectForKey:NSBackgroundColorAttributeName];
    [self setNeedsDisplay:YES];
}

- (NSDictionary *)nodeTitleAttributes
{
    return [[NavTheme sharedNavTheme] attributesDictForPath:@"steps/step"];
}

- (void)drawRect:(NSRect)dirtyRect
{
    /*
    if ([self inLiveResize])
    {
        return;
    }
    */
    
    CGFloat yOffset = 5;
    
    [super drawRect:dirtyRect];
    [self drawBackground];
    
    NSDictionary *att = [self nodeTitleAttributes];
    CGFloat fontSize = [(NSFont *)[att objectForKey:NSFontAttributeName] pointSize];

    // draw title
    {
        NSString *title = self.node.nodeTitle;
        //CGFloat titleWidth = [[[NSAttributedString alloc] initWithString:title attributes:att] size].width;
        
        //[title drawAtPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width/2.0 - titleWidth/2.0,
//        [title drawAtPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width/4.0,
        CGFloat margin = MKPostView.leftMargin;
        
        CGFloat smallWidth = 170.0;
        if (self.width < smallWidth)
        {
            CGFloat r = self.width / smallWidth;
            margin *= r*r*r*r*r*r*r;
        }
        
        [title drawAtPoint:NSMakePoint(self.bounds.origin.x + margin + 5,
                                       self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - yOffset)
            withAttributes:att];
    }
    
    // draw status
    NSString *nodeNote = self.node.nodeNote;
    if (nodeNote)
    {
        [nodeNote drawAtPoint:NSMakePoint(self.bounds.size.width - self.width*.2,
                                       self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - yOffset)
            withAttributes:att];
    }
    
    //NSLog(@"%@ stage width: %i", self.node.nodeTitle, (int) self.width);
}

- (MKStage *)stage
{
    return (MKStage *)self.node;
}

- (void)drawBackground
{
    [self drawLeftFill];
    [self drawRightFill];
    
    if (self.hasArrow)
    {
        [self drawArrowLine];
    }
}

/*
- (BOOL)hasArrow
{
    return (self.superview.subviews.lastObject != self);
}
 */

- (void)drawArrowLine
{
    [[NSColor colorWithCalibratedWhite:.8 alpha:1.0] set];
    
    CGFloat right = 10.0;
    CGFloat w = self.width - 1;
    CGFloat h = self.height;
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    [aPath moveToPoint:NSMakePoint(w - right, 0)];
    [aPath lineToPoint:NSMakePoint(w, h/2)];
    [aPath lineToPoint:NSMakePoint(w- right, h)];
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath setLineJoinStyle:NSRoundLineJoinStyle];
    [aPath stroke];
}

- (NSColor *)activeFillColor
{
    return [NSColor colorWithCalibratedWhite:.97 alpha:1.0];
}

- (NSColor *)completeFillColor
{
    return [NSColor colorWithCalibratedWhite:.9 alpha:1.0];
}

- (CGFloat)rightArrowOffset
{
    return 10.0;
}

- (NSColor *)leftColor
{
    MKStage *stage = self.stage;
    
    if (stage.isActive)
    {
        return self.activeFillColor;
    }
    
    if (stage.isComplete)
    {
        return self.completeFillColor;
    }

    //return [NSColor clearColor];
    return [NSColor whiteColor];
}

- (void)drawLeftFill
{
    [self.leftColor set];
    
    CGFloat r = self.rightArrowOffset;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath moveToPoint:NSMakePoint(0, 0)];
    [aPath lineToPoint:NSMakePoint(w - r, 0)];
    [aPath lineToPoint:NSMakePoint(w, h/2)];
    [aPath lineToPoint:NSMakePoint(w - r, h)];
    [aPath lineToPoint:NSMakePoint(0, h)];
    [aPath lineToPoint:NSMakePoint(0, 0)];
    [aPath closePath];
    [aPath fill];
}

- (NSColor *)rightColor
{
    MKStage *stage = self.stage.nextStage;
    
    if (!stage)
    {
        return self.leftColor;
    }
    
    if (stage.isActive)
    {
        return self.activeFillColor;
    }
    
    if (stage.isComplete)
    {
        return self.completeFillColor;
    }
    
    //return [NSColor clearColor];
    return [NSColor whiteColor];
}

- (void)drawRightFill
{
    [self.rightColor set];
    
    CGFloat r = self.rightArrowOffset + 1;
    CGFloat w = self.width;
    CGFloat h = self.height;
    
    NSBezierPath *aPath = [NSBezierPath bezierPath];
    [aPath setLineCapStyle:NSSquareLineCapStyle];
    [aPath moveToPoint:NSMakePoint(w, 0)];
    [aPath lineToPoint:NSMakePoint(w - r, 0)];
    [aPath lineToPoint:NSMakePoint(w, h/2)];
    [aPath lineToPoint:NSMakePoint(w - r, h)];
    [aPath lineToPoint:NSMakePoint(w, h)];
    [aPath lineToPoint:NSMakePoint(w, 0)];
    [aPath closePath];
    [aPath fill];
}

@end
