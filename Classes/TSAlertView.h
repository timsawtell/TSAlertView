//  AlertView.h

#import <UIKit/UIKit.h>

@interface TSAlertView : UIView

@property (nonatomic, weak) IBOutlet UIView *containerView; /** the reason there is a container view is so that we dont try and modify [self view] in the layoutSubviews method */
@property (nonatomic, weak) IBOutlet UIImageView *titleBackgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

@end
