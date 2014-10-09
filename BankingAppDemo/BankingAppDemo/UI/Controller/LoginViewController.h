//
//  LoginViewController.h
//  BankingAppDemo
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField* userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;

- (IBAction) loginButtonAction:(id)sender;

@end
