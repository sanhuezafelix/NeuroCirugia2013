//
//  mBusquedaViewController.h
//  DualmobileCongress
//
//  Created by luis Gonzalez on 11-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mDetalleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "mAppDelegate.h"
#import "ECSlidingViewController.h"
#import "mCustomCell.h"
#import "Evento.h"
#import "Persona.h"
#import "Lugar.h"
#import "Imagen.h"
#import "Institucion.h"
#import "AnimatedImagesView.h"

@class mBusquedaCloseViewController;

@interface mBusquedaViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource , UISearchBarDelegate>{
    mBusquedaCloseViewController  *ovController;
    BOOL searching;
}

#pragma -mark Propedades

@property (nonatomic, strong) IBOutlet UITableView *SearchTableview;
@property (nonatomic, strong) IBOutlet UISearchBar *BarraBusqeuda;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *BotonMenu;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *BotonNotificaciones;
@property (nonatomic, strong) NSArray *ResultadosCoreData;
@property (nonatomic, strong) NSMutableArray * DysplayItems;
@property (nonatomic, strong) IBOutlet AnimatedImagesView *animationImageView;

#pragma -mark Eventos

- (IBAction)RevelarMenuLateral:(id)sender;
- (IBAction)RevelarNotificaciones:(id)sender;
- (void)CerrarTeclado;

@end
