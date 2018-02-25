//      | |       | |      | |— —-— —、
//      | |       | |      | |——- ——  \
//      | |_ _ _ _| |      | |       \ \
//      | |_ _ _ _| |      | |       | |
//      | |       | |      | |       / /
//      | |       | |      | |——- ——  /
//      | |       | |      | |— —-— —‘




#import "HD_ViewController.h"
#import "MessageTipView.h"
@interface HD_ViewController ()

@end

@implementation HD_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [MessageTipView showAlertMessageWithMessage:@"小曲满山飘" withDuration:2 withEnableBackDismiss:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
