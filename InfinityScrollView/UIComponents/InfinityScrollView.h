//
//  InfinityScrollView.h
//  InfinityScrollView
//
//  A custom UIScrollView that can be scrolled infinity.
//
//  Created by Meng Xiangping on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfinityScrollView : UIScrollView <UIScrollViewDelegate>{
  
  @private
  NSMutableArray *viewItems_;   
  BOOL viewHasAdded_;
  
  
  //auto scroll
  BOOL autoScroll_;
  float autoScrollInterval_;
  NSTimer *autoScrollTimer_;
  
  //page indicator
  UIPageControl *pageControl_;
  BOOL showPageControl_;
  
}


@property (nonatomic) BOOL autoScroll;
@property (nonatomic) float autoScrollInterval;
@property (nonatomic, retain) NSTimer *autoScrollTimer;

//private init method
- (void) setAttrs;

//view item
- (void) setViewItems: (NSMutableArray *) arrayItems;
- (void) addViewItem:(UIView *) view;
- (void) removeViewItem:(NSInteger) index;

//auto scroll
- (void) autoScrollFired;

//page control
- (void) showPageControl;
- (void) removePageControl;


@end
