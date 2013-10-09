//
//  mDetalleViewController.h
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "ECSlidingViewController.h"
#import "mSpeakerDetViewController.h"
#import "mMapaConferenciaViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface mDetalleViewController : UIViewController<EKEventEditViewDelegate, EKEventViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *Lugar;
@property (strong, nonatomic) IBOutlet UILabel *Rol;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *BotonNotificaciones;
@property (strong, nonatomic) IBOutlet UITextView *Titulo;
@property (strong, nonatomic) IBOutlet UILabel *Hora;
@property (strong, nonatomic) IBOutlet UITextView *Expositor;
@property (strong, nonatomic) IBOutlet UILabel *Actividad;
@property (strong, nonatomic) IBOutlet UIButton *BotonPublicacionTwet;
@property (strong, nonatomic) IBOutlet UIButton *botonDeTalleSpeaker;
@property (strong, nonatomic) IBOutlet UIButton *botonImagenExpositor;
@property (strong, nonatomic) IBOutlet UITextView *ContenidoExposicion;
@property (strong, nonatomic) IBOutlet UIButton *BotonPublicarFacebook;
@property (strong, nonatomic) IBOutlet UIImageView*imagen;

@property(nonatomic,strong)UIImage  *imagenEX;
@property(nonatomic,strong)NSString *tituloCelda;
@property(nonatomic,strong)NSString *horacelda;
@property(nonatomic,strong)NSString *ExpositorCelda;
@property(nonatomic,strong)NSString *ContenidoCelda;
@property(nonatomic,strong)NSString *RolCelda;
@property(nonatomic,strong)NSString *LugarCelda;
@property(nonatomic,strong)NSString *Referencia;
@property(nonatomic,strong)NSString *PaisSpeaker;
@property(nonatomic,strong)NSString *InstitucionSpeaker;
@property(nonatomic,strong)NSString *BiografiaSpeaker;
@property(nonatomic,strong)NSString *ActividadSpeaker;
@property(nonatomic,strong)NSString *MensajeInicial;
@property(nonatomic,strong)NSDate   *DateInicio;
@property(nonatomic,strong)NSDate   *DateFin;
@property(nonatomic,strong)UIImage  *NombreImagen;

- (IBAction)PublicaEnFaceBook:(id)sender;
- (IBAction)PublicaEnTwiter:(id)sender;
- (IBAction)RevelarMenuLateral:(id)sender;
- (IBAction)GuardarCalendario:(id)sender;



@end
