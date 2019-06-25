//
//  RNTPTDocumentView.m
//  RNPdftron
//
//  Copyright © 2018 PDFTron. All rights reserved.
//

#import "RNTPTDocumentView.h"

@interface RNTPTDocumentView () <PTDocumentViewControllerDelegate>
@end

@implementation RNTPTDocumentView
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _documentViewController = [[PTDocumentViewController alloc] init];
        _documentViewController.delegate = self;
    }
    return self;
}

- (void)didMoveToWindow
{
    if (_documentViewController) {
        return;
    }
    
    UIViewController *controller = self.findParentViewController;
    if (controller == nil || self.window == nil) {
        return;
    }
    

    _documentViewController.controlsHidden = NO;
    
    _documentViewController.shareButtonHidden = YES;
    UIColor* white = [UIColor whiteColor];
    [_documentViewController.pdfViewCtrl setBackgroundColor:white];
    
    



    
    


    if (_showNavButton) {
        UIImage *navImage = [UIImage imageNamed:_navButtonPath];
        UIBarButtonItem *navButton = [[UIBarButtonItem alloc] initWithImage:navImage style:UIBarButtonItemStylePlain target:self action:@selector(navButtonClicked)];
        _documentViewController.navigationItem.leftBarButtonItem = navButton;

    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_documentViewController];
    
    
    UIView *controllerView = navigationController.view;
    
    [controller addChildViewController:navigationController];
    [self addSubview:controllerView];
    
    UIColor* black = [UIColor blackColor];
    controllerView.tintColor = black;
    controllerView.backgroundColor = white;

    
 


    
    controllerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:
     @[[controllerView.topAnchor constraintEqualToAnchor:self.topAnchor],
       [controllerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [controllerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
       [controllerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
       ]];
    
    [navigationController didMoveToParentViewController:controller];
    
    // Open a file URL.
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:_document withExtension:@"pdf"];
    if ([_document containsString:@"://"]) {
        fileURL = [NSURL URLWithString:_document];
    } else if ([_document hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:_document];
    }

    [_documentViewController openDocumentWithURL:fileURL];
}

- (void)navButtonClicked
{
    if([self.delegate respondsToSelector:@selector(navButtonClicked:)]) {
        [self.delegate navButtonClicked:self];
    }
}

- (UIViewController *)findParentViewController {
    UIResponder *parentResponder = self;
    while ((parentResponder = parentResponder.nextResponder)) {
        if ([parentResponder isKindOfClass:UIViewController.class]) {
            return (UIViewController *)parentResponder;
        }
    }
    return nil;
}

- (void)dealloc
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
