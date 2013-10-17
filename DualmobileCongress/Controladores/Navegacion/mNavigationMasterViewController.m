//
//  mNavigationMasterViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mNavigationMasterViewController.h"
#import "mAppDelegate.h"
#import "Evento.h"
#import "Persona.h"
#import "Notificacion.h"


@interface mNavigationMasterViewController ()

@property(nonatomic,strong)mAppDelegate *dele;

@end

@implementation mNavigationMasterViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 4.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    [self notifica];

    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[mMenuLateralViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuLateral"];
        [self evento];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[mNotificacionesViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Notificaciones"];
        [self notifica];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 7.0) {
        UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar128"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    if (sysVer >= 7.0){
        
        _dele.window.tintColor = [UIColor lightGrayColor];
        
    }
    
    else {
        
        UIImage *backButtonImage = [[UIImage imageNamed:@"boton_volver"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 2)];
        
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:backButtonImage];
        
    }
}

-(void)evento {
    
    _dele = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Evento" inManagedObjectContext:_dele.managedObjectContext];
    NSFetchRequest *fet = [[NSFetchRequest alloc]init];
    [fet setEntity:ent];
    NSArray *ar = [_dele.managedObjectContext executeFetchRequest:fet error:&error];
    NSLog(@"%@",ar);
}

-(void)notifica {
    
    _dele = [[UIApplication sharedApplication] delegate];
    
    NSError*error;
    NSEntityDescription *entidad = [NSEntityDescription entityForName:@"Notificacion" inManagedObjectContext:_dele.managedObjectContext];
    NSArray*ar=[[NSArray alloc] init];
    NSFetchRequest *fetiche = [[NSFetchRequest alloc] init];
    [fetiche setEntity:entidad];
    NSPredicate *canuto = [NSPredicate predicateWithFormat:@"(contenidoNoti.length > 0)"];
   ar = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO];
    [fetiche setPredicate:canuto];
    ar = [_dele.managedObjectContext executeFetchRequest:fetiche error:&error];
    NSLog(@"%@",ar);


}


@end
