//
//  InfinityScrollView.m
//  InfinityScrollView
//
//  Created by Meng Xiangping on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InfinityScrollView.h"

@implementation InfinityScrollView
@synthesize autoScroll = autoScroll_;
@synthesize autoScrollInterval = autoScrollInterval_;
@synthesize autoScrollTimer = autoScrollTimer_;


- (void)dealloc{
  
  [viewItems_ release];
  [pageControl_ release];
  self.delegate = nil;
  self.autoScrollTimer = nil;
  [super dealloc];
  
}

- (id)init {
  
  self = [super init];
  if (self) {
    
    [self setAttrs];
    
  }
  return self;
  
}

- (id)initWithCoder:(NSCoder *)aDecoder{
  
  self = [super initWithCoder:aDecoder];
  if(self){
    
    [self setAttrs];
    
  }
  
  return self;
}

- (void)setAttrs{
  
  autoScroll_ = NO;
  autoScrollInterval_ = 2.0f;
  
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;
  self.pagingEnabled = YES;
  
  self.delegate = self;
  
  self.contentSize = CGSizeMake(self.frame.size.width * 3, 
                                self.frame.size.height);
  self.contentOffset = CGPointMake(self.frame.size.width, 0);

}


#pragma view items
- (void)setViewItems:(NSMutableArray *)arrayItems{

  [viewItems_ release];
  viewItems_ = arrayItems;
  [viewItems_ retain];
  
}

- (void)addViewItem:(UIView *)view{
  
  [viewItems_ addObject:view];
  
}

- (void)removeViewItem:(NSInteger)index{
  
  [viewItems_ removeObjectAtIndex:index];
  
}


- (void)layoutSubviews{
  
  if(viewHasAdded_ == NO && viewItems_ != nil){
    
    for(int i = 0;i < [viewItems_ count];i++){
      
      UIView *view = (UIView *)[viewItems_ objectAtIndex:i];
      view.frame = CGRectMake(i * self.frame.size.width, 0, 
                              self.frame.size.width, 
                              self.frame.size.height);
      
      [self addSubview:view];
      
    }
    
    viewHasAdded_ = YES;
    
  }
  
}

#pragma auto scroll

- (void)setAutoScroll:(BOOL)autoScroll{
  
  autoScroll_ = autoScroll;
  
  if(autoScroll_ == YES){
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval 
                                                            target:self 
                                                          selector:@selector(autoScrollFired) 
                                                          userInfo:nil 
                                                           repeats:YES];

  }else{
    
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
    
  }
  
}


- (void)autoScrollFired{
  
  [self scrollRectToVisible:CGRectMake(self.frame.size.width * 2, 
                                       self.frame.origin.y, 
                                       self.frame.size.width, 
                                       self.frame.size.height) animated:YES];
  
}


#pragma page control
- (void)showPageControl{

  pageControl_ = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, 
                                                                self.frame.size.width, 20)];
  [self addSubview:pageControl_];
  
}

- (void)removePageControl{
  
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  if(scrollView.contentOffset.x >= scrollView.frame.size.width * 2 || 
     scrollView.contentOffset.x <= 0){

    float offset;    

    if(scrollView.contentOffset.x >= scrollView.frame.size.width * 2){

      offset = -scrollView.frame.size.width;

    }
    else if(scrollView.contentOffset.x <= 0){
      
      offset = scrollView.frame.size.width;    
      
    }
    
    scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    
    for(int i = 0;i < [scrollView.subviews count];i++){
      
      UIView *view = [scrollView.subviews objectAtIndex:i];
      view.frame = CGRectMake(view.frame.origin.x + offset, 
                              view.frame.origin.y, 
                              view.frame.size.width, 
                              view.frame.size.height);

      if(view.frame.origin.x < 0){
        
        view.frame = CGRectMake(([viewItems_ count] - 1) * scrollView.frame.size.width, 
                                view.frame.origin.y, 
                                view.frame.size.width, 
                                view.frame.size.height);

      }else if(view.frame.origin.x > ([viewItems_ count] - 1) * scrollView.frame.size.width){
        
        view.frame = CGRectMake(0,
                                view.frame.origin.y,
                                view.frame.size.width,
                                view.frame.size.height);
        
      }
      
    }

  }
  
}

@end
