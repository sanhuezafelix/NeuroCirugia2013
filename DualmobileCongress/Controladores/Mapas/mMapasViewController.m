//
//  mMapasViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 11-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mMapasViewController.h"
#import "REPagedScrollView.h"
#import "mZoomMapas.h"
#import "GAI.h"


@interface mMapasViewController ()

@end

@implementation mMapasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     //trackenado GA
        
    id trackerMapa = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerMapa sendView:@"Mapa"];
    

    
    UIImage *barButtonImage = [[UIImage imageNamed:@"btnmenu.png"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonMenu setBackgroundImage:barButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.title= @" ";
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                              forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
       self.title = @" ";
    
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];


    [self IniciarPageView];
   
}

-(void)IniciarPageView{
    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    mZoomMapas *zoom = [[mZoomMapas alloc]initWithImageMapName:@"lobby.png" atLocation:CGPointMake(5, 5)];
    [scrollView addPage:zoom];
    zoom = [[mZoomMapas alloc]initWithImageMapName:@"piso_2.png" atLocation:CGPointMake(5, 5)];
    [scrollView addPage:zoom];
    zoom = [[mZoomMapas alloc]initWithImageMapName:@"zocalo.png" atLocation:CGPointMake(5, 5)];
    [scrollView addPage:zoom];

}

- (void)viewDidUnload {
    [self setBotonMenu:nil];
    [super viewDidUnload];
}
- (IBAction)RevelarMenuLateral:(id)sender {
     [self.slidingViewController anchorTopViewTo:ECRight];
    id eventoMenuLateralAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoMenuLateralAhora sendEventWithCategory:@"uiAction"
                                       withAction:@"Revelar Menu Lateral"
                                        withLabel:@"Revelo desde Mapas"
                                        withValue:nil];
    
    
}

- (IBAction)RevelarNotificaciones:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
    id eventoNotificacionesDesdeAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoNotificacionesDesdeAhora sendEventWithCategory:@"uiAction"
                                               withAction:@"Revelar Notificaciones"
                                                withLabel:@"Revelo desde Mapas"
                                                withValue:nil];
}
@end
