//
//  HTLandmarkView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/9/21.
//

#import "HTLandmarkView.h"

@implementation HTLandmarkView

- (void)drawRect:(CGRect)rect{
    if([self.drawEnable intValue] == 1){
        //1.获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        //2.拼接路径
        UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:self.faceRect];
        //3.把路径添加到上下文
        CGContextAddPath(context, path1.CGPath);
        [[UIColor cyanColor] set];
        //4.渲染上下文
        CGContextStrokePath(context);
        for(int i = 0;i < self.pointXArray.count;i++){
            CGFloat pointX = [self.pointXArray[i] floatValue];
            CGFloat pointY = [self.pointYArray[i] floatValue];
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(pointX, pointY, 3, 3)];
            CGContextAddPath(context, path.CGPath);
//            CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
            CGContextFillPath(context);
        }
    }else{
    }
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSetAllowsAntialiasing(context, true);
//    CGContextSetShouldAntialias(context, true);
//
//    [[UIColor greenColor] set];
//    CGContextSetLineWidth(context, 2);
//
//    for (NSDictionary *faceData in self.faceDataArray) {
//        if ([faceData objectForKey:LANDMARKS_KEY]) {
//            for (NSValue *pointValue in [faceData objectForKey:LANDMARKS_KEY]) {
//                CGPoint p = [pointValue CGPointValue] ;
//                CGContextFillRect(context, CGRectMake(p.x - 1.0 , p.y - 1.0 , 2.0 , 2.0));
//            }
//        }
//        if ([faceData objectForKey:RECT_KEY]) {
//            CGContextStrokeRect(context, [[faceData objectForKey:RECT_KEY] CGRectValue]);
//        }
//    }
//}

@end
