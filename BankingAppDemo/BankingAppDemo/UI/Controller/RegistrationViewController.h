//
//  RegistrationViewController.h
//  BankingAppDemo
//

#import <UIKit/UIKit.h>

@protocol RegistrationViewControllerDelegate <NSObject>

- (void) registrationSuccessful;

@end

@interface RegistrationViewController : UIViewController
{
    
}

@property (nonatomic, assign) id <RegistrationViewControllerDelegate> registrationDelegate;

@property (weak, nonatomic) IBOutlet UITextField* userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField* passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;

- (IBAction) registerButtonAction:(id)sender;

@end
