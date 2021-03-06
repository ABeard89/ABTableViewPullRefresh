//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ABRefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BACKGROUND_COLOR [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]
#define BORDER_COLOR BACKGROUND_COLOR

#define ARROW_WIDTH 30.0f
#define LEFT_PADDING 25.0f

@implementation ABRefreshTableHeaderView

@synthesize isFlipped, lastUpdatedDate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = BACKGROUND_COLOR;
        
        lastUpdatedLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(0.0f, frame.size.height - 30.0f,
                                       frame.size.width - ARROW_WIDTH, 20.0f)];
        lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        lastUpdatedLabel.textColor = TEXT_COLOR;
        lastUpdatedLabel.shadowColor =
        [UIColor colorWithWhite:0.9f alpha:1.0f];
        lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        lastUpdatedLabel.backgroundColor = self.backgroundColor;
        lastUpdatedLabel.opaque = YES;
        lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lastUpdatedLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                frame.size.height - 48.0f, frame.size.width - ARROW_WIDTH, 20.0f)];
        statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        statusLabel.textColor = TEXT_COLOR;
        statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        statusLabel.backgroundColor = self.backgroundColor;
        statusLabel.opaque = YES;
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self setStatus:kPullToReloadStatus];
        [self addSubview:statusLabel];
        
        arrowImage = [[UIImageView alloc] initWithFrame:
                      CGRectMake(25.0f, frame.size.height
                                 - 65.0f, ARROW_WIDTH, 55.0f)];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        arrowImage.image = [UIImage imageNamed:@"blueArrow.png"];
        [arrowImage layer].transform =
        CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        [self addSubview:arrowImage];
        
        activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:
                        UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(25.0f, frame.size.height
                                        - 38.0f, 20.0f, 20.0f);
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        isFlipped = NO;
    }
    return self;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    arrowImage.frame = CGRectMake(LEFT_PADDING,
                                  frame.size.height - 65.0f,
                                  ARROW_WIDTH,
                                  55.0f);
    activityView.frame = CGRectMake(LEFT_PADDING,
                                    frame.size.height - 38.0f,
                                    20.0f,
                                    20.0f);
    lastUpdatedLabel.frame = CGRectMake(LEFT_PADDING + ARROW_WIDTH,
                                        frame.size.height - 30.0f,
                                        frame.size.width - 2*(ARROW_WIDTH + LEFT_PADDING),
                                        20.0f);
    statusLabel.frame = CGRectMake(LEFT_PADDING + ARROW_WIDTH,
                                   frame.size.height - 48.0f,
                                   lastUpdatedLabel.frame.size.width,
                                   20.0f);
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context,  kCGPathFillStroke);
    [BORDER_COLOR setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
    CGContextAddLineToPoint(context, self.bounds.size.width,
                            self.bounds.size.height - 1);
    CGContextStrokePath(context);
}

- (void)flipImageAnimated:(BOOL)animated
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animated ? .18 : 0.0];
    [arrowImage layer].transform = isFlipped ?
    CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) :
    CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
    [UIView commitAnimations];
    
    isFlipped = !isFlipped;
}

- (void)setLastUpdatedDate:(NSDate *)newDate
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if (newDate)
    {
        lastUpdatedDate = newDate;
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        if ([language hasPrefix:@"ja"]) {
            [formatter setDateFormat:@"MM月dd日 HH:mm"];
            lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:lastUpdatedDate]];
        }
        else
        {
             lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:lastUpdatedDate]];
        }    }
    else
    {
        lastUpdatedDate = nil;
        
        if ([language hasPrefix:@"ja"]) {
            lastUpdatedLabel.text = @"";
        }
        else
        {
            lastUpdatedLabel.text = @"Last Updated: Never";
        }
    }
}

- (void)setStatus:(int)status
{
    switch (status) {
        case kReleaseToReloadStatus:
            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
                statusLabel.text = NSLocalizedString(@"指を離して更新...", @"Release to refresh status");
            }
            else
            {
                statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            }
            break;
        case kPullToReloadStatus:
            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
                statusLabel.text = NSLocalizedString(@"画面を引っ張って更新...", @"Pull down to refresh status");
            }
            else
            {
                statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
            }
            break;
        case kLoadingStatus:
            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
                statusLabel.text = NSLocalizedString(@"読み込み中...", @"Loading Status");
            }
            else
            {
                statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            }
            break;
        default:
            break;
    }
}

- (void)toggleActivityView:(BOOL)isON
{
    if (!isON)
    {
        [activityView stopAnimating];
        arrowImage.hidden = NO;
    }
    else
    {
        [activityView startAnimating];
        arrowImage.hidden = YES;
        [self setStatus:kLoadingStatus];
    }
}

- (void)dealloc {
    activityView = nil;
    statusLabel = nil;
    arrowImage = nil;
    lastUpdatedLabel = nil;
}

@end

//#import "EGORefreshTableHeaderView.h"
//
//
//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
//#define FLIP_ANIMATION_DURATION 0.18f
//
//
//@interface EGORefreshTableHeaderView (Private)
//- (void)setState:(EGOPullRefreshState)aState;
//@end
//
//@implementation EGORefreshTableHeaderView
//
//@synthesize delegate=_delegate;
//
//
//- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
//    if((self = [super initWithFrame:frame])) {
//		
//		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
//
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont systemFontOfSize:12.0f];
//		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		// MODIFY BUG 2015-06-17 iOS6 deprecated UITextAlignmentCenter
////		label.textAlignment = UITextAlignmentCenter;
//		label.textAlignment = NSTextAlignmentCenter;
//		[self addSubview:label];
//		_lastUpdatedLabel=label;
//		[label release];
//		
//		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont boldSystemFontOfSize:13.0f];
//		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		// MODIFY BUG 2015-06-17 iOS6 deprecated UITextAlignmentCenter
////		label.textAlignment = UITextAlignmentCenter;
//		label.textAlignment = NSTextAlignmentCenter;
//		[self addSubview:label];
//		_statusLabel=label;
//		[label release];
//		
//		CALayer *layer = [CALayer layer];
//		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
//		layer.contentsGravity = kCAGravityResizeAspect;
//		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
//		
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//		
//		[[self layer] addSublayer:layer];
//		_arrowImage=layer;
//		
//		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
//		[self addSubview:view];
//		_activityView = view;
//		[view release];
//		
//		[self setState:EGOOPullRefreshNormal];
//    }
//	
//    return self;
//	
//}
//
//- (id)initWithFrame:(CGRect)frame  {
//  return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
//}
//
//#pragma mark -
//#pragma mark Setters
//
//- (void)refreshLastUpdatedDate {
//	
//	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
//		
//		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
//		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//
//        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//        if ([language hasPrefix:@"ja"]) {
//            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//            _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
//        }
//        else
//        {
//             _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
//        }
//        
//		
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}
//
//}
//
//- (void)setState:(EGOPullRefreshState)aState{
//	
//	switch (aState) {
//		case EGOOPullRefreshPulling:
//            
//            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
//                _statusLabel.text = NSLocalizedString(@"指を離して更新...", @"Release to refresh status");
//            }
//            else
//            {
//                _statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
//            }
//           
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
//
//			break;
//		case EGOOPullRefreshNormal:
//			
//			if (_state == EGOOPullRefreshPulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//				_arrowImage.transform = CATransform3DIdentity;
//				[CATransaction commit];
//			}
//            
//            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
//                _statusLabel.text = NSLocalizedString(@"画面を引っ張って更新...", @"Pull down to refresh status");
//            }
//            else
//            {
//                _statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
//            }
//			
//			[_activityView stopAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = NO;
//			_arrowImage.transform = CATransform3DIdentity;
//			[CATransaction commit];
//			
//			[self refreshLastUpdatedDate];
//			
//			break;
//		case EGOOPullRefreshLoading:
//            
//            if ([[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ja"]) {
//                _statusLabel.text = NSLocalizedString(@"読み込み中...", @"Loading Status");
//            }
//            else
//            {
//                _statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
//            }
//			//NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
//
//            
//			[_activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = YES;
//			[CATransaction commit];
//			
//			break;
//		default:
//			break;
//	}
//	
//	_state = aState;
//}
//
//
//#pragma mark -
//#pragma mark ScrollView Methods
//
//- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
//	
//	if (_state == EGOOPullRefreshLoading) {
//		
//		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//		offset = MIN(offset, 60);
//		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
//		
//	} else if (scrollView.isDragging) {
//		
//		BOOL _loading = NO;
//		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
//			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
//		}
//		
//		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
//			[self setState:EGOOPullRefreshNormal];
//		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
//			[self setState:EGOOPullRefreshPulling];
//		}
//		
//		if (scrollView.contentInset.top != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
//		
//	}
//	
//}
//
//- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
//	
//	BOOL _loading = NO;
//	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
//		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
//	}
//	
//	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
//		
//		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
//			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
//		}
//		
//		[self setState:EGOOPullRefreshLoading];
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.2];
//		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
//		[UIView commitAnimations];
//		
//	}
//	
//}
//
//- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
//	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:.3];
//	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
//	[UIView commitAnimations];
//	
//	[self setState:EGOOPullRefreshNormal];
//
//}
//
//
//#pragma mark -
//#pragma mark Dealloc
//
//- (void)dealloc {
//	
//	_delegate=nil;
//	_activityView = nil;
//	_statusLabel = nil;
//	_arrowImage = nil;
//	_lastUpdatedLabel = nil;
//    [super dealloc];
//}
//
//
//@end
