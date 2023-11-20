//
//  HTCaptureView.m
//  HTEffectDemo
//
//  Created by MBPC001 on 2023/4/13.
//

#import "HTCaptureView.h"
#import "HTUIConfig.h"

@interface HTCaptureView ()

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) NSInteger width;

@end

@implementation HTCaptureView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName width:(NSInteger)width {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageName = imageName;
        _width = width;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    self.progressView.hidden = YES;
    
    [self addSubview:self.cameraBtn];
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(HTWidth(66)/HTWidth(90)*self.width);
    }];
    
    
}

#pragma mark - 拍照
- (void)cameraClick {
    if (self.captureCameraBlock) {
        self.captureCameraBlock();
    }
}

# pragma mark - 长按手势
- (void)onStartTranscribe:(UIGestureRecognizer *)longGesture {

    if (longGesture.state==UIGestureRecognizerStateBegan) {

        NSLog(@"长按手势开启");
        self.progressView.timeMax = 15;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"THVideoOutputNoti" object:@"begin"];
        if (_videoCaptureBlock) {
            _videoCaptureBlock(YES);
        }

    } else if (longGesture.state==UIGestureRecognizerStateEnded){
        NSLog(@"长按手势结束");
        if (self.progressView.timeMax > 0) {
            [self.progressView clearProgress];
        }
    }
}

#pragma mark - 懒加载
- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        [_cameraBtn setTag:1];
        [_cameraBtn setImage:[UIImage imageNamed:self.imageName] forState:UIControlStateNormal];
        [_cameraBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraClick)]];
        [_cameraBtn addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onStartTranscribe:)]];
    }
    return _cameraBtn;
}

- (HTVideoProgressView *)progressView {

    if (!_progressView) {
        _progressView = [[HTVideoProgressView alloc] init];
        _progressView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        _progressView.layer.cornerRadius = self.width/2;
        _progressView.layer.masksToBounds = YES;
        WeakSelf
        _progressView.videoProgressEndBlock = ^{
            if (weakSelf.videoCaptureBlock) {
                weakSelf.videoCaptureBlock(NO);
            }
        };
    }
    return _progressView;
}
@end
