// MRViewController.m
//UIStoryboard *czsb = [UIStoryboard storyboardWithName:@"MRViewController" bundle:nil];
// MRViewController *sbVc = [czsb instantiateViewControllerWithIdentifier:@"MRViewController"];
//_window.rootViewController = sbVc ;
#import "MRViewController.h"


@interface MRViewController ()
@property (nonatomic, weak) IBOutlet UIButton *remoteButton;
@property (nonatomic, weak) IBOutlet UISwitch *euSwitch;
@end


@implementation MRViewController

- (IBAction)loadRemoteGEOJSON:(id)sender
{
    self.remoteButton.hidden = YES;
    // map source: https://github.com/johan/world.geo.json
    NSString *url = @"https://github.com/johan/world.geo.json/blob/master/countries.geo.json";
    NSURL *URL = [NSURL URLWithString:url];
    long identifier = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(identifier, 0);
    dispatch_async(backgroundQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:URL];
        NSError *jsonError;
        id json = [NSJSONSerialization JSONObjectWithData:data
                                                  options:0
                                                    error:&jsonError];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (json == nil) {
                NSLog(@"%@", jsonError);
                self.remoteButton.hidden = NO;
                return;
            }
            NSError *error;
            if ([self.worldMapView loadGeoJSONMap:json withError:&error]) {
                [self switchAction:nil];
            } else {
                NSLog(@"%@", error);
                self.remoteButton.hidden = NO;
            }

        });
    });
}

- (IBAction)switchAction:(id)sender
{
    if (self.euSwitch.on) {
        NSSet *allCountries = self.worldMapView.allCountries;
        NSMutableSet *hiddenCountries = allCountries.mutableCopy;
        NSSet *euCountries = [NSSet setWithObjects:@"BE", @"BEL", @"BG", @"BGR",
                                    @"CZ", @"CZE", @"DK", @"DNK", @"DE", @"DEU",
                                    @"EE", @"EST", @"IE", @"IRL", @"EL", @"GRC",
                                    @"ES", @"ESP", @"FR", @"FRA", @"HR", @"HRV",
                                    @"IT", @"ITA", @"CY", @"CYP", @"LV", @"LVA",
                                    @"LT", @"LTU", @"LU", @"LUX", @"HU", @"HUN",
                                    @"MT", @"MLT", @"NL", @"NLD", @"AT", @"AUT",
                                    @"PL", @"POL", @"PT", @"PRT", @"RO", @"ROU",
                                    @"SI", @"SVN", @"SK", @"SVK", @"FI", @"FIN",
                                    @"SE", @"SWE", @"UK", @"GBR", nil];
        NSSet *candidates = [NSSet setWithObjects:@"ME", @"MNE", @"IS", @"ISL",
                                                  @"AL", @"ALB", @"RS", @"SRB",
                                                  @"TR", @"TUR", nil];
        for (NSString *country in euCountries) {
                [hiddenCountries removeObject:country];
        }
        for (NSString *country in candidates) {
            [hiddenCountries removeObject:country];
        }
        self.worldMapView.hiddenCountries = hiddenCountries;
        self.worldMapView.disabledCountries = candidates;
        self.worldMapView.mapInset = UIEdgeInsetsMake(50.0f, 50.0f, -20.0f, 50.0f);
    } else {
        self.worldMapView.hiddenCountries = nil;
        self.worldMapView.disabledCountries = nil;
        self.worldMapView.mapInset = UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f);
    }
}

#pragma mark - MRWorldMapViewDelegate
- (void)worldMap:(MRWorldMapView *)map didHighlightCountry:(NSString *)code
{
    if (code) {
//        NSLog(@"highlighted country: %@", code);
    }
}

- (void)worldMap:(MRWorldMapView *)map didSelectCountry:(NSString *)code
{
    NSLocale *locale = NSLocale.currentLocale;
    NSString *countryName = [locale displayNameForKey:NSLocaleCountryCode
                                                value:code];
    self.label.text = countryName;
}
- (UIColor *)worldMap:(MRWorldMapView *)map selectedColorForCountry:(NSString *)code{
    return [UIColor redColor];
}
- (UIColor *)worldMap:(MRWorldMapView *)map colorForCountry:(NSString *)code{
    if ([code isEqualToString:@"CN"]) {
        return [UIColor redColor];
    }
    return UIColor.grayColor;
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.worldMapView.highlightedCountry = nil;
        [self.worldMapView setNeedsDisplay];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.worldMapView.highlightedCountry = nil;
    [self.worldMapView setNeedsDisplay];
}

#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 4.0f;
    [self switchAction:nil];
}

@end
