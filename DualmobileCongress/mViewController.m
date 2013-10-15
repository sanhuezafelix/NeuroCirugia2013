//
//  mViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 06-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mViewController.h"
#import "mAppDelegate.h"
#import "Institucion.h"
#import "Lugar.h"
#import "GAI.h"
#import "Evento.h"

@interface mViewController ()

@property (nonatomic,strong) mAppDelegate *delegate;

@end

@implementation mViewController
@synthesize comenzarBoton;

-(void)awakeFromNib{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self activaInicioTimer];
	self.delegate = [[UIApplication sharedApplication] delegate];

    if ([[NSFileManager defaultManager]fileExistsAtPath:[self Ruta]] == TRUE) {
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
        
        [self CargadorBaseDatosNoImagenes:_nombresEntidad];
    }
    else{
        [self CargadorBaseDatosNoImagenes:_nombresEntidad];

      self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
        
    }
}

- (IBAction)comenzarAccion:(id)sender {
    
    [self CargadorBaseDatosNoImagenes:_nombresEntidad];


    id eventoComenzar = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoComenzar sendEventWithCategory:@"uiAction"
                        withAction:@"buttonPress"
                         withLabel:@"Presionó botón Comenzar"
                         withValue:nil];
}


- (IBAction)IniciarSesion:(id)sender
{
    [self CargadorBaseDatosImagenes:@"Imagen"];
    [self Guardar];
    
    if ([self.UserMail.text length]>0 && [self.UserName.text length] >0  && [self.UserSpecialty.text length]>0 )
    {
        NSLog(@"textfield con datos");
        }
}


- (IBAction)CerrarTeclado:(id)sender {
    NSLog(@"apretaste fondo");
    [sender resignFirstResponder];
    [self.UserMail resignFirstResponder];
    [self.UserName resignFirstResponder];
    [self.UserSpecialty resignFirstResponder];
    
}

-(BOOL)VerificarMail:(NSString*)UserMail
{
    
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:UserMail];
    
}

#pragma mark - Carga base datos

-(void)CargadorBaseDatosImagenes:(NSString*)entidadImagen;
{
    
        
        [self.ActividadServidor startAnimating];
        NSFetchRequest *fetchRequestImagen = [[NSFetchRequest alloc] init];
        // asignamos el nombre de la entidad a utilizar
        NSEntityDescription *entidad = [NSEntityDescription entityForName:entidadImagen
                                                   inManagedObjectContext:self.delegate.managedObjectContext];
        [fetchRequestImagen setEntity:entidad];
        NSError *error;
        NSArray *fetchedObjectsImagen = [self.delegate.managedObjectContext executeFetchRequest:fetchRequestImagen
                                                                           error:&error];
        [self.ActividadServidor stopAnimating];

    // <---NSLog
    
    NSLog(@"IMAGENES %@", [fetchRequestImagen description]);
    
    // NSLog--->
}
    
-(void)CargadorBaseDatosNoImagenes:(NSArray*)nombresEntidad
{
    
    nombresEntidad = [NSArray arrayWithObjects:@"Evento", @"Persona", @"Lugar",@"Eventopadre",@"Notificacion",@"Institucion", nil];
    
for (NSString *unaEntidad in nombresEntidad)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // asignamos el nombre de la entidad a utilizar
        NSEntityDescription *entidad = [NSEntityDescription entityForName:unaEntidad
                                                   inManagedObjectContext:self.delegate.managedObjectContext];
        [fetchRequest setEntity:entidad];
        NSError *error;
        NSArray *fetchedObjects = [self.delegate.managedObjectContext executeFetchRequest:fetchRequest
  error:&error];
    }
}

-(void)activaInicioTimer{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"kCanceladorInicioTimer"];
    
    [defaults synchronize];
}


#pragma mark - Plist Metodos

-(void)Guardar{
    
    NSLog(@"guardando...");
    
       NSDictionary *diccionario = [[NSDictionary alloc]initWithObjectsAndKeys:self.UserName.text,@"Nombre",self.UserMail.text ,@"Mail",self.UserSpecialty.text,@"Especialidad", nil];
    
    [diccionario writeToFile:[self Ruta] atomically:YES];
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Ahora"];
    
}
-(NSString *)Ruta{
    NSString * PathFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"ruta ==> %@",[PathFolder stringByAppendingPathExtension:@"Usuarios.plist"] );
    return [PathFolder stringByAppendingPathExtension:@"Usuarios.plist"];
}

#pragma mark - Eventos Generales de la Vista

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self activaInicioTimer];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    
    [self setUserName:nil];
    [self setUserSpecialty:nil];
    [self setUserMail:nil];
    [self setComenzarBoton:nil];
    [super viewDidUnload];
}



@end
