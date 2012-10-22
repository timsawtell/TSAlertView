//  AlertViewController.m

#import "TSAlertViewController.h"

static const NSInteger kDimmerViewTag = 999999990;

CG_INLINE CGPoint CGRectCenter(CGRect rect)
{
	return CGPointMake(rect.origin.x + (rect.size.width / 2), rect.origin.y + (rect.size.height / 2));
}

CG_INLINE CGRect CGRectCenteredInnerRect(CGPoint centrePoint, CGSize size)
{
    CGRect r;
    r.origin = CGPointMake(centrePoint.x - (size.width / 2), centrePoint.y - (size.height / 2));
    r.size = size;
    return r;
}

CG_INLINE CGRect CGRectCenteredInsideRect(CGRect outerRect, CGRect innerRect)
{
	//CGPoint center =
	return CGRectCenteredInnerRect(CGRectCenter(outerRect), innerRect.size);
}


@interface TSAlertViewController()
/** Need a (non retaining) reference back to the owner so that this class can remove the dimmer view if there are no more alertViews to show. */
@property (nonatomic, weak) UIViewController *owner;
@end

@implementation TSAlertViewController

@synthesize owner;

#pragma mark - View Lifecycle

- (void)showForViewController:(__weak UIViewController *)controller
                    withTitle:(NSString *)title
                  withContent:(NSString *)content
{
    TSAlertView *alertView = (TSAlertView *)self.view;
    alertView.titleLabel.text = title;
    alertView.contentLabel.text = content;
    alertView.alpha = 0;
    // round ALL THE CORNERS!!
    alertView.layer.cornerRadius = 10.0f;
    alertView.titleBackgroundImageView.layer.cornerRadius = 5.0f;
    alertView.containerView.layer.cornerRadius = 10.0f;
    self.owner = controller;
    
    BOOL foundExistingDimmerView = NO;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView.tag == kDimmerViewTag) {
            foundExistingDimmerView = YES;
            break;
        }
    }
    
    UIView *dimmerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height)];
    if (!foundExistingDimmerView) {
        // add a light gray see through view to cover the view of the owner.
        dimmerView.backgroundColor = [UIColor blackColor];
        dimmerView.alpha = 0; // will animate this up to 0.7
        dimmerView.tag = kDimmerViewTag;
        [controller.view addSubview:dimmerView];
    }
    
    // add a shadow
    alertView.layer.shadowColor = [UIColor whiteColor].CGColor;
    alertView.layer.shadowRadius = 2.0f;
    alertView.layer.shadowOpacity = 0.15f;
    alertView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    
    // add self as a child view contoller to controller. This is an arc / ios 6 thing and ensures that this instance is not dealloc'd
    [controller addChildViewController:self];
    [controller.view addSubview:alertView];
    [alertView layoutSubviews]; // need to do this so that we know how big the alert view is.
    alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y, alertView.frame.size.width, alertView.containerView.frame.size.height);
    // make sure that the alert view will always be visible so that the user can close the alert
    if (alertView.frame.size.height > controller.view.frame.size.height) {
        alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y, alertView.frame.size.width, controller.view.frame.size.height - 44.0f);
    }
    
    alertView.frame = CGRectCenteredInsideRect(controller.view.frame, alertView.frame);
    
    [UIView animateWithDuration:0.3 animations:^{
        dimmerView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            alertView.alpha = 1;
        }];
    }];
}

- (IBAction)closeTouched:(id)sender
{
    // find any other alertViews. Rules are: only remove the dimmerView if there are no other alertViews showing on self.owner
    BOOL foundOtherAlertViews = NO;
    for (UIView *testView in self.owner.view.subviews) {
        if ([testView isKindOfClass:[self.view class]] && testView != self.view) {
            foundOtherAlertViews = YES;
            break;
        }
    }
    
    // find the dimmer view
    UIView *dimmerView = nil;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView.tag == kDimmerViewTag) {
            dimmerView = testView;
            break;
        }
    }
    
    UIView *selfRef = nil;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView == self.view) {
            selfRef = testView;
            break;
        }
    }
    
    // animate the alert view off the screen
    if (nil != selfRef) {
        CATransform3D transform = CATransform3DIdentity;
        // make the view rotate on the z axis
        transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
        selfRef.layer.zPosition = 500; // so that upon rotation some layers dont go under other layers, idk, comment this line and see for yourself. Seemed to be more of a problem the more subvies the view had
        
        [UIView animateWithDuration:0.1f animations:^{
            selfRef.frame = CGRectMake(selfRef.frame.origin.x -5, selfRef.frame.origin.y - 5, selfRef.frame.size.width, selfRef.frame.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8f animations:^{
                selfRef.layer.transform = transform;
                selfRef.frame = CGRectMake(selfRef.frame.origin.x, self.owner.view.frame.size.height + 300, selfRef.frame.size.width, selfRef.frame.size.height);
                if (nil != dimmerView && !foundOtherAlertViews) {
                    dimmerView.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                [selfRef removeFromSuperview];
                if (nil != dimmerView && !foundOtherAlertViews) {
                    [dimmerView removeFromSuperview];
                }
                // finally remove self from the caller. (the counterpart is [controller addChildViewController:self];)
                [self removeFromParentViewController];
            }];
        }];
    } else {
        [self removeFromParentViewController];
    }
}
@end