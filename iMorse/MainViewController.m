//
//  ViewController.m
//  iMorse
//
//  Created by The Guest Family on 3/24/17.
//  Copyright © 2017 AlphaApplications. All rights reserved.
//

#import "MainViewController.h"
#import "MorseCodeConverter.h"
#import "MCReferenceTableVC.h"
#import "MCTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "CoreDataManager.h"
#import "UsefulCodes+CoreDataProperties.h"

@interface MainViewController ()

@property(strong,nonatomic)UIButton *quickCodeBtn;
@property(strong,nonatomic)UIButton *beepBtn;
@property(strong,nonatomic)UIButton *flashBtn;
@property(strong,nonatomic)UIBarButtonItem *tableViewButton;

@property (nonatomic) BOOL enableSound;
@property (nonatomic) BOOL enableFlash;

@property (nonatomic) SystemSoundID dotSoundID;
@property (nonatomic) SystemSoundID dashSoundID;

@end

@implementation MainViewController {
    BOOL playing;
    BOOL flashing;
}

@synthesize num;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    playing = NO;
    flashing = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    num = (int)[defaults integerForKey:@"num"]; //(int) explicitly cast integerforkey as int not long
    
    MCTableViewController *tableVC = [[MCTableViewController alloc] init];
    self.preset = [tableVC presetList];

    self.enableSound = YES;
    self.enableFlash = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:214/255.0 green:206/255.0  blue:195/255.0  alpha:1.0];
    
    //ADDING NAVBAR ITEMS HERE
    UIImage *imageRight = [UIImage imageNamed:@"menu"];
    CGRect frameimg = CGRectMake(0, 0, imageRight.size.width, imageRight.size.height);
    
    UIButton *tableViewButton = [[UIButton alloc] initWithFrame:frameimg];
    [tableViewButton setBackgroundImage:imageRight forState:UIControlStateNormal];
    [tableViewButton addTarget:self action:@selector(tableViewBtnPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [tableViewButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:tableViewButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    //LEFT BAR BUTTON ITEM HERE
    UIImage *imageLeft = [UIImage imageNamed:@"info"];
    CGRect frameimg2 = CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height);
    
    UIButton *refButton = [[UIButton alloc] initWithFrame:frameimg2];
    [refButton setBackgroundImage:imageLeft forState:UIControlStateNormal];
    [refButton addTarget:self action:@selector(refBtnPressed:)
              forControlEvents:UIControlEventTouchUpInside];
    [refButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *infoButton =[[UIBarButtonItem alloc] initWithCustomView:refButton];
    
    self.navigationItem.leftBarButtonItem = infoButton;
    
    //CENTER NAVBAR IMAGE HERE - CREDIT TO AUTHOR:
    // <div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
    
    UIView *navView = [[UIView alloc] init];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = @"iMorse";
    [titleLbl sizeToFit];
    titleLbl.center = navView.center;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    
    UIImage *img = [UIImage imageNamed:@"morse-code"];
    double imageAspect = (img.size.width) / (img.size.height); //44px / 44px = 1
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLbl.frame.origin.x - (titleLbl.frame.size.height * imageAspect) - 20, titleLbl.frame.origin.y - 10, titleLbl.frame.size.width * imageAspect, titleLbl.frame.size.height)];
    [imgView setImage:img];
    [imgView sizeToFit];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    
    [navView addSubview:imgView];
    [navView addSubview:titleLbl];
    
    self.navigationItem.titleView = navView;
    [navView sizeToFit];
    
    //ADDING THE SOUNDS
    NSString *dotSoundPath = [[NSBundle mainBundle]pathForResource:@"dot" ofType:@"wav"];
    NSURL *dotURL = [NSURL fileURLWithPath:dotSoundPath isDirectory:NO];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)dotURL, &_dotSoundID); //CASTING TO CFURL OBJECT MUST USE __BRIDGE
    
    NSString *dashSoundPath = [[NSBundle mainBundle]pathForResource:@"dash" ofType:@"wav"];
    NSURL *dashURL = [NSURL fileURLWithPath:dashSoundPath isDirectory:NO];
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)dashURL, &_dashSoundID); //http://stackoverflow.com/questions/14207960/arc-bridge-modifiers-demystified

    
    //CONFORMING TO DELEGATES
    self.morseTextfield.delegate = self;
    
    //CREATING AND ADDING TEXTFIELD TO VIEW
    self.morseTextfield = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                       (self.view.frame.size.height)/7, 300, 30.0)];
    self.morseTextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.morseTextfield.font = [UIFont fontWithName:@"Avenir Next" size:20];
    self.morseTextfield.textAlignment = NSTextAlignmentCenter;
    self.morseTextfield.placeholder = @"Translate text into morse code";
    [self.morseTextfield addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.morseTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.morseTextfield.spellCheckingType = UITextSpellCheckingTypeNo;
    self.morseTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.morseTextfield setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.morseTextfield];
    
    //CREATING AND ADDING OUTPUT LABEL TO VIEW
    self.outputLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                (self.view.frame.size.height)/4.5, 300, 135.0)];
    self.outputLabel.font = [UIFont fontWithName:@"Avenir Next" size:20];
    self.outputLabel.backgroundColor = [UIColor whiteColor];
    self.outputLabel.numberOfLines = 10;
    self.outputLabel.textAlignment = NSTextAlignmentCenter;
    self.outputLabel.textColor = [UIColor blackColor];
    self.outputLabel.adjustsFontSizeToFitWidth = YES;
    self.outputLabel.layer.masksToBounds = YES;
    self.outputLabel.layer.cornerRadius = 8.0;
    [self.view addSubview:self.outputLabel];
    
    //CREATING THE QUICKCODE BUTTON AND ADDING TO VIEW - HANDLES CYCLING THROUGH TABLEVIEW PRE-SET MORSE CODES
    self.quickCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                  (self.view.frame.size.height)/2, 300, 55.0)];
    self.quickCodeBtn.layer.masksToBounds = YES;
    self.quickCodeBtn.layer.cornerRadius = 8.0;
    self.quickCodeBtn.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [self.quickCodeBtn setTitle:@"Quick Morse Code" forState:normal];
    [self.quickCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.quickCodeBtn addTarget:self action:@selector(getQuickMorseCode) forControlEvents:UIControlEventTouchUpInside];
    self.quickCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.quickCodeBtn];
    
    //CREATING THE BEEP BUTTON AND ADDING TO VIEW
    self.beepBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                                 (self.view.frame.size.height)/1.65, 300.0, 55.0)];
    self.beepBtn.layer.masksToBounds = YES;
    self.beepBtn.layer.cornerRadius = 8.0;
    self.beepBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
    [self.beepBtn setTitle:@"Beep Morse" forState:UIControlStateNormal];
    [self.beepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.beepBtn addTarget:self action:@selector(beepStarted) forControlEvents:UIControlEventTouchUpInside];
    self.beepBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.beepBtn];
    
    //CREATING THE FLASH BUTTON AND ADDING TO VIEW
    self.flashBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,
                                                              (self.view.frame.size.height)/1.4, 300.0, 55.0)];
    self.flashBtn.layer.masksToBounds = YES;
    self.flashBtn.layer.cornerRadius = 8.0;
    self.flashBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:153/255.0 alpha:1.0];
    [self.flashBtn setTitle:@"Flash Morse" forState:UIControlStateNormal];
    [self.flashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.flashBtn addTarget:self action:@selector(flashStarted) forControlEvents:UIControlEventTouchUpInside];
    self.flashBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.flashBtn];
    
    self.quickCodeBtn.hidden = NO;
    self.beepBtn.hidden = YES;
    self.flashBtn.hidden = YES;
    
}

#pragma mark - Textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.morseTextfield resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.morseTextfield resignFirstResponder];
    return YES;
}

- (void)dismissKeyboard {
    [self.morseTextfield resignFirstResponder];
    [self buttonAppear];
    [self convertInput:self.morseTextfield];
    [self.morseTextfield endEditing:YES];
}

- (void)buttonAppear {
    //https://www.raywenderlich.com/5478/uiview-animation-tutorial-practical-recipes
    //http://stackoverflow.com/questions/42309714/when-a-uibutton-is-tapped-how-do-you-made-it-get-bigger-then-go-back-to-the-pr
    self.beepBtn.hidden = YES;
    self.flashBtn.hidden = YES;
    
    self.beepBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.flashBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.beepBtn.hidden = NO;
        self.flashBtn.hidden = NO;

        self.beepBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.flashBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        self.beepBtn.transform = CGAffineTransformMakeScale(1, 1);
        self.flashBtn.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void) tableViewBtnPressed:(UIBarButtonItem *)sender {
    /*
        BE CAREFUL, PROGRAMMATICALLY CREATED SEGUE AND NEED TO SET DELEGATE HERE IF NEEDING TO PASS SOMETHING LIKE I JUST DID
        http://stackoverflow.com/questions/43221243/why-is-my-delegate-not-passing-data-back-after-selecting-row-and-dismissing-view/43222062?noredirect=1#comment73515704_43222062
        https://teamtreehouse.com/community/segueing-to-other-view-controller-programmatically-reassigning-values-from-other-classes
     */
    MCTableViewController *tableVC = [[MCTableViewController alloc] init];
    tableVC.selectedDataDelegate = self;
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:tableVC];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}

- (void) refBtnPressed:(UIBarButtonItem *)sender {
    MCReferenceTableVC *refTable = [[MCReferenceTableVC alloc] init];
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:refTable];
    [self.navigationController presentViewController:navBar animated:YES completion:nil];
}
//DELEGATE METHOD OF SENDPROTOCOLDATA
- (void)sendDataToMain:(NSString*)text {
    NSString *str = text;
    self.morseTextfield.text = str;
    [self buttonAppear];
    [self convertInput:self.morseTextfield.text];
}

#pragma mark - button selector methods
- (void)getQuickMorseCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [[CoreDataManager sharedInstance] fetchAllRecords];

    if(num >= array.count) {
        num = 0;
    }
    //SET THE CONDITIONAL BEFORE SO CODEOBJ GETS THE UPDATED NUMBER, OTHERWISE CAUSES CRASH
    UsefulCodes *codeObj = (UsefulCodes *)array[num];
    NSString *presetListValue = codeObj.codeName;
    
    [defaults setInteger:num forKey:@"num"];
    self.morseTextfield.text = presetListValue;
    [self convertInput:self.morseTextfield.text];
    [self buttonAppear];
    num++;
}

- (void)beepStarted {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MorseCodeConverter *converter = [[MorseCodeConverter alloc]init];
        NSArray *morseCodeArray = [converter convertStringToMorse:self.morseTextfield.text];
        [self playMorseCodeSound:morseCodeArray];
    });
}

- (void)flashStarted {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MorseCodeConverter *converter = [[MorseCodeConverter alloc]init];
        NSArray *morseCodeArray = [converter convertStringToMorse:self.morseTextfield.text];
        [self playMorseCodeFlash:morseCodeArray];
    });
}

#pragma mark - translation button method
//CONVERT THE TEXT INTO MORSE HERE
- (void)convertInput:(id)sender { //use id and sender to take textfield
    
    NSMutableArray *MorseCodeStringsArray = [@[] mutableCopy];
    
    __block float duration = 0.0f;
    
    MorseCodeConverter *converter = [[MorseCodeConverter alloc]init];
    NSArray *morseCodeArray = [converter convertStringToMorse:self.morseTextfield.text];
    [morseCodeArray enumerateObjectsUsingBlock:^(NSNumber *morseCodeNumber, NSUInteger idx, BOOL *stop) {
        
        switch ([morseCodeNumber integerValue]) {
            case MorseCodeDot:
                [MorseCodeStringsArray addObject:kMorseCodeDot];
                duration += 150.0f;
                break;
            case MorseCodeDash:
                [MorseCodeStringsArray addObject:kMorseCodeDash];
                duration += 150.0f * 3;
                break;
            case MorseCodeSingleSpace:
                [MorseCodeStringsArray addObject:kMorseCodeSingleSpace];
                duration += 150.0f;
                break;
            case MorseCodeThreeSpaces:
                [MorseCodeStringsArray addObject:kMorseCodeThreeSpaces];
                duration += 150.0f * 3;
                break;
            default:
                break;
        }
        
    }];
    
    NSString *morseCodeString = [MorseCodeStringsArray componentsJoinedByString:@""];
    self.outputLabel.text = morseCodeString;
    
    //ADD ANIMATION TO MAKE IT MORE INTERESTING
    self.outputLabel.layer.anchorPoint = CGPointMake(0.5, .5);
    
    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(0.0f);
    opacityAnimation.toValue = @(1.0f);
    opacityAnimation.fillMode = kCAFillModeBackwards;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.delegate = self; //Fixed by conforing to CAAnimationDelegate http://stackoverflow.com/questions/9861538/assigning-to-iddelegate-from-incompatible-type-viewcontroller-const-strong
    
    scaleAnimation.values = @[@(1.6f), @(1.0f)];
    [scaleAnimation setTimingFunctions:@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]];
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = NO;
    
    CAAnimationGroup * animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[opacityAnimation, scaleAnimation];
    animGroup.duration = 0.5f;
    [self.outputLabel.layer addAnimation:animGroup forKey:@"scaleIn"];
}

#pragma mark - Flash, Beep and Vibration Button Funtionality Methods
- (void)playMorseCodeSound:(NSArray*)morseArray {

    [morseArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
        
        [NSThread sleepForTimeInterval:0.1];
        
        switch ([morseCodeNumber integerValue]) {
            case MorseCodeDot:
                [self playDotSound];
                [NSThread sleepForTimeInterval:0.5f];
                break;
            case MorseCodeDash:
                [self playDashSound];
                [NSThread sleepForTimeInterval:1.5f];
                break;
            case MorseCodeSingleSpace:
                //pause for 500ms
                [NSThread sleepForTimeInterval:0.5f];
                break;
            case MorseCodeThreeSpaces:
                //pause for 1500ms
                [NSThread sleepForTimeInterval:1.5f];
                break;
            default:
                break;
        }
        
    }];
    
}

- (void)playMorseCodeFlash:(NSArray*)morseArray {
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    [session beginConfiguration];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash]) {
        
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (input) {
            [session addInput:input];
        }
        [session commitConfiguration];
        
        [morseArray enumerateObjectsUsingBlock:^(NSNumber * morseCodeNumber, NSUInteger idx, BOOL *stop) {
            
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff]; //FIRST ON AND THEN OFF?
            [device unlockForConfiguration];
            [session stopRunning];
            [NSThread sleepForTimeInterval:0.1];
            
            switch ([morseCodeNumber integerValue]) {
                case MorseCodeDot:
                    //vibrate for 500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device unlockForConfiguration];
                    [session startRunning];
                    [NSThread sleepForTimeInterval:0.5];
                    break;
                case MorseCodeDash:
                    //vibrate for 1500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device unlockForConfiguration];
                    [session startRunning];
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                case MorseCodeSingleSpace:
                    //pause for 500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device unlockForConfiguration];
                    [session stopRunning];
                    [NSThread sleepForTimeInterval:0.5f];
                    break;
                case MorseCodeThreeSpaces:
                    //pause for 1500ms
                    [device lockForConfiguration:nil];
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device unlockForConfiguration];
                    [NSThread sleepForTimeInterval:1.5f];
                    break;
                default:
                    break;
            }
            
        }];
        
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        [session stopRunning];
    }
    
}

#pragma mark - Sounds
- (void)playDotSound {
    AudioServicesPlaySystemSound(self.dotSoundID);
}

- (void)playDashSound {
    AudioServicesPlaySystemSound(self.dashSoundID);
}

@end
