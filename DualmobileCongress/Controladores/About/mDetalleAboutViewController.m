//
//  mDetalleAboutViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 13-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mDetalleAboutViewController.h"
#import "GAI.h"

@interface mDetalleAboutViewController ()

@end

@implementation mDetalleAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //trackenado GA
    
    id trackerJornada = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerJornada sendView:@"DetalleAbout"];
    NSLog(@"%@",self.weburl);
    NSURL        *url       = [NSURL URLWithString:self.weburl];
    NSURLRequest *loadURL   = [[NSURLRequest alloc] initWithURL:url];
    _caga.text = @"Sin acceso";
    [self.WebView loadRequest:loadURL];

}

- (void)webViewDidStartLoad:(UIWebView *)webView
{ [_indicador startAnimating];
    _caga.text = @"Cargando...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ [_indicador stopAnimating]; _indicador.hidden = TRUE;
  [_caga setHidden:YES];
}


- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)RevelarNotificaciones:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
@end
