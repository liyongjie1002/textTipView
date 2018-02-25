//      | |       | |      | |— —-— —、
//      | |       | |      | |——- ——  \
//      | |_ _ _ _| |      | |       \ \
//      | |_ _ _ _| |      | |       | |
//      | |       | |      | |       / /
//      | |       | |      | |——- ——  /
//      | |       | |      | |— —-— —‘




#import "MessageTipView.h"

//屏幕宽度
#define kTipViewScreenWidth  ([UIScreen mainScreen].bounds.size.width)
//提示框的宽度
#define kAlertWidth  kTipViewScreenWidth -100

//间隙
const CGFloat KAlertGap   = 10.0;
//文字大小
const CGFloat messageFont   = 16.0;

@interface MessageTipView ()
//提示信息
@property (nonatomic,copy)NSString *message;
//点击背景是否dismiss
@property (nonatomic,assign)BOOL backDismiss;
//黑色背景
@property(nonatomic,strong)UIView *backgroundView;
//提示框
@property(nonatomic,strong)UIView *contentView;

@end


@implementation MessageTipView


+(void)showAlertMessageWithMessage:(NSString *)message withDuration:(CGFloat)duration withEnableBackDismiss:(BOOL)backDismiss{
    MessageTipView *tipView = [[MessageTipView alloc]initAlertMessageViewWithMessage:message backDismiss:backDismiss];
    
    [tipView showAlert];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tipView dismissAlert];
    });
}

-(instancetype)initAlertMessageViewWithMessage:(NSString *)message
                                   backDismiss:(BOOL )backDismiss{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        _message = [message copy];
        _backDismiss = backDismiss;
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)showAlert{
    CGFloat backViewAlpha = 0.2f;
 
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = backViewAlpha;
    }];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.25f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[_contentView layer] addAnimation:popAnimation forKey:nil];
    
}
-(void)dismissAlert{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.center =CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        self.backgroundView.alpha =0.0;
        self.contentView.alpha =0.0;
        
    } completion:^(BOOL finished){
    
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}
-(void)tapAction{
    [self dismissAlert];
}
#pragma mark ------ 懒加载
-(UIView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView =[[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor =[UIColor blackColor];
        _backgroundView.alpha =0.0f;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_backgroundView addGestureRecognizer:tap];
        tap.enabled = _backDismiss ==YES ?YES :NO;
    }
    return _backgroundView;
}

-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView                     = [[UIView alloc]init];
        _contentView.layer.cornerRadius  = 5;
        _contentView.layer.masksToBounds = YES;

        _contentView.backgroundColor =[UIColor colorWithWhite:0.0 alpha:0.4];
        
        //文字高度
        CGFloat messageHeight = [self createMessageHeight];
        _contentView.bounds =CGRectMake(0, 0, kAlertWidth, messageHeight+KAlertGap);
        _contentView.center =self.center;
    }
    return _contentView;
}
-(CGFloat)createMessageHeight
{
    if (!self.message.length) return 0;
    
    CGFloat height = [self heightWithString:self.message fontSize:messageFont width:kAlertWidth -2 *KAlertGap];
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KAlertGap, kAlertWidth, height)];
    messageLabel.numberOfLines = 0;
    messageLabel.text = self.message;
    UIColor *textColor = [UIColor whiteColor];
    messageLabel.textColor = textColor;
    messageLabel.font = [UIFont systemFontOfSize:messageFont];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:messageLabel];
    return CGRectGetMaxY(messageLabel.frame);
}

/** 计算文本高度 **/
-(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}
-(void)dealloc{
    
}
@end
