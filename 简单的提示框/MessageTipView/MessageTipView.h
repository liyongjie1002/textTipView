//      | |       | |      | |— —-— —、
//      | |       | |      | |——- ——  \
//      | |_ _ _ _| |      | |       \ \
//      | |_ _ _ _| |      | |       | |
//      | |       | |      | |       / /
//      | |       | |      | |——- ——  /
//      | |       | |      | |— —-— —‘




#import <UIKit/UIKit.h>

@interface MessageTipView : UIView

/*
 message        提示的文字
 duration       时长
 backDismiss    点击背景可否消失
 */

+(void)showAlertMessageWithMessage:(NSString *)message withDuration:(CGFloat )duration withEnableBackDismiss:(BOOL )backDismiss;

@end
