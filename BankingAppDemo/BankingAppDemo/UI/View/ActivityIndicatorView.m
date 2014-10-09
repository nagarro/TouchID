//
//  NGProgressView.m
//  BankingAppDemo
//

#import "ActivityIndicatorView.h"
#import "MacroUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "Strings.h"

@implementation ActivityIndicatorView

static ActivityIndicatorView * activityIndicatorView;

-(id)initWithFrame:(CGRect)frame
{
    UIScreen * mainScreen= [UIScreen mainScreen];
    float x = (mainScreen.bounds.size.width/2) - 100;
    float y = (mainScreen.bounds.size.height/2) - 50;
    
    frame = CGRectMake(x, y, 200, 100);
    
    self = [super initWithFrame:frame];
    
    if(self!=nil)
    {
        UIButton * titleView= [[UIButton alloc]initWithFrame:CGRectMake(1, 1, frame.size.width-2, 40)];
        titleView.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        titleView.titleLabel.textAlignment = NSTextAlignmentLeft;
        [titleView setTitle:LocalizedString(kWait_LabelTitle) forState:UIControlStateNormal];
        [self addSubview:titleView];
        
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.Frame =CGRectMake(90, 45, 15, 15);
        [self addSubview:activityIndicator];
        [activityIndicator startAnimating];

        self.backgroundColor = [UIColor colorWithRed:45.0/255.0f green:57.0/255.0f blue:77.0/255.0f alpha:1.0f];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 10.0;
        self.layer.shadowOffset = CGSizeMake(0, 4);
    }
    return self;
}

- (void) show
{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void) hide
{
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        self.window.userInteractionEnabled = YES;
    }
    [self removeFromSuperview];
}

+ (void) showActivityIndicatorView
{
    if(activityIndicatorView==nil)
    {
        activityIndicatorView = [[ActivityIndicatorView alloc]init];
    }
    [activityIndicatorView show];
}

+ (void) hideActivityIndicatorView
{
    if(activityIndicatorView!=nil)
    {
        [activityIndicatorView hide];
        activityIndicatorView  = nil;
    }
}
@end
