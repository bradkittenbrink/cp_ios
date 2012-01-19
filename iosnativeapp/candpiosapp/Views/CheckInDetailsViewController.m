#import "CheckInDetailsViewController.h"
#import "SVProgressHUD.h"

@implementation CheckInDetailsViewController

@synthesize slider, place;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGFloat margin = 40;
    CGFloat width = 320 - margin * 2;
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(margin, margin, width, 40)];
    [slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    slider.continuous = NO;
    slider.minimumValue = 0.5;
    slider.maximumValue = 8;
    slider.value = 2;
    [self.view addSubview:slider];
    
    UIButton *checkInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [checkInButton addTarget:self action:@selector(checkInPressed:) forControlEvents:UIControlEventTouchDown];
    [checkInButton setTitle:@"Check In" forState:UIControlStateNormal];
    checkInButton.frame = CGRectMake(margin, margin * 3, width, 40);
    [self.view addSubview:checkInButton];
}

- (void)checkInPressed:(id)sender {
    // send the server your lat/lon, checkin_time (now), checkout_time (now + duration from slider), and the venue data from the place. 

    // checkOutTime is equal to the slider value (represented in hours) * 60 minutes * 60 seconds to normalize the units into seconds
    NSInteger checkInTime = [[NSDate date] timeIntervalSince1970];
    NSInteger checkOutTime = checkInTime + slider.value * 3600;
    NSString *foursquareID = place.foursquareID;
    
	[SVProgressHUD showWithStatus:@"Checking In..."];

    // Fire a notification 5 minutes before checkout time
    NSInteger minutesBefore = 5;
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.alertBody = @"You will be automatically checked out of C&P in 5 min and your listings will not be visible until you checkin again.";
        localNotif.alertAction = @"Check In";

        localNotif.fireDate = [NSDate dateWithTimeIntervalSince1970:(checkOutTime - minutesBefore * 60)];
//        localNotif.fireDate = [NSDate dateWithTimeIntervalSince1970:(checkInTime + 10)];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
    
    [SVProgressHUD dismiss];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sliderMoved:(id)sender {
    UISlider *thisSlider = (UISlider *)sender;

    // Only allow choices for 30 minutes, 1, 2, 4 and 8 hours
    
    float val = thisSlider.value;
    
    if (val > 0.5 && val < 0.75) {
        thisSlider.value = 0.5;
    }
    else if (val >= 0.75 && val < 1.5) {
        thisSlider.value = 1;
    }
    else if (val >= 1.5 && val < 3) {
        thisSlider.value = 2;
    }
    else if (val >= 3 && val < 6) {
        thisSlider.value = 4;
    }
    else if (val >= 6) {
        thisSlider.value = 8;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
