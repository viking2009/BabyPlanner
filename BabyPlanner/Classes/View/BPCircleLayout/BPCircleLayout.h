//
//  BPCircleLayout.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 08.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) NSInteger cellsPerCircle;
@property (nonatomic, assign) CGSize itemSize;

@end
