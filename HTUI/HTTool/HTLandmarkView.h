//
//  HTLandmarkView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/9/21.
//

#import <UIKit/UIKit.h>

@interface HTLandmarkView : UIView

#define LANDMARKS_KEY @"LANDMARKS_KEY"
#define RECT_KEY   @"RECT_KEY"

@property (nonatomic , strong) NSArray *faceDataArray;

@property (nonatomic, strong) NSMutableArray *pointXArray;
@property (nonatomic, strong) NSMutableArray *pointYArray;
@property (nonatomic, assign) CGRect faceRect;
@property (nonatomic, assign) NSNumber *drawEnable;

@end
