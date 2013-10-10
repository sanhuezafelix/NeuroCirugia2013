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
         
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[mMenuLateralViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuLateral"];
        [self evento];
    }
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[mNotificacionesViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Notificaciones"];
        [self personas];
    }
    
//    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar"];
    
//    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];

//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = nil;
//    
//    UIImage *backButtonImage = [[UIImage imageNamed:@"boton_volver"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 2)];
//    
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
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
        
//        self.navigationItem.hidesBackButton = YES;
//        
//        CGRect frameimgback1 = CGRectMake(0, 0, 60, 35);
//        UIButton *back = [[UIButton alloc]initWithFrame:frameimgback1];
//        [back setImage:[UIImage imageNamed:@"boton_volver"] forState:UIControlStateNormal];
//        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *btnL = [[UIBarButtonItem alloc]initWithCustomView:back];
//        
//        self.navigationItem.leftBarButtonItem = btnL;
//        
//        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont, [UIColor darkGrayColor], UITextAttributeTextShadowColor, [NSValue valueWithCGSize:CGSizeMake(0.0,-1.0)], UITextAttributeTextShadowOffset, nil] forState:UIControlStateNormal];
       
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

-(void)personas {
    
    _dele = [[UIApplication sharedApplication] delegate];
    NSError *error;
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Persona" inManagedObjectContext:_dele.managedObjectContext];
    NSFetchRequest *fet = [[NSFetchRequest alloc]init];
    [fet setEntity:ent];
    NSArray *ar = [_dele.managedObjectContext executeFetchRequest:fet error:&error];
    NSLog(@"%@",ar);
}


@end
