//  AlertViewController.h

/**
 * A view controller that will present a view that shows a message, and dismisses in a sexy kinda way.
 * The rules are:
 * add a dimmer view if the caller doesn't have one.
 * create an alertview and layout its subviews so that we know the frame size
 * center the alerview in the callers view
 * add the alertview to the caller as a subview
 *
 * On close: find any other alertviews
 * if there are more alert views on the caller, do not remove the dimmer view
 * animate the alertView off the screen
 * remove alertView from caller
 * if no more alertViews, remove the dimmerView
 */

#import "TSAlertView.h"

@interface TSAlertViewController : UIViewController

- (IBAction)closeTouched:(id)sender;
- (void)showForViewController:(__weak UIViewController *)controller
                    withTitle:(NSString *)title
                  withContent:(NSString *)content;

@end