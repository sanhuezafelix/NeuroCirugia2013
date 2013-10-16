//
//  mJornadaViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 07-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mJornadaViewController.h"
#import "mAppDelegate.h"
#import "mSimposioDetViewController.h"
#import "NSDataAdditions.h"
#import "GAI.h"

@interface mJornadaViewController ()

@property(nonatomic,strong)mAppDelegate *delegate;

@end

@implementation mJornadaViewController


-(void)AnularActualizaEstadoAutorizadorSincronizacion{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"kAutorizadorSincronizacion"];
    [defaults synchronize];
    
    NSLog(@"valor de autorizador Jornada  %c", [defaults boolForKey:@"kAutorizadorSincronizacion"]);
}

//-(void)AnularActualizaEstadoAutorizadorSincronizacionImagen{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    [defaults setBool:NO forKey:@"kAutorizadorSincronizacionImagen"];
//    [defaults synchronize];
//    
//    NSLog(@"valor de autorizador IMAGEN %c", [defaults boolForKey:@"kAutorizadorSincronizacionImagen"]);
//}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //trackenado GA
    
    id trackerJornada = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerJornada sendView:@"Jornada"];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.TituloJornada.text = self.Titulo;
    
    self.title = @" ";
    
    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.title = @" ";
    self.EventosPadre = [[NSMutableArray alloc]initWithArray:[self CargarSimposios]];
    self.EventosHijos = [[NSMutableArray alloc]initWithArray:[self CargarEventos]];
    NSArray *arr = [NSArray arrayWithObjects:
                    @"publi_bot_1.png",@"publi_bot_2.png",@"publi_bot_3.png", nil];
    [self.animationImageView setImagesArr:arr];
    self.animationImageView.showNavigator = NO;
    [self.animationImageView startAnimating];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self              action:@selector(imageTapped:)];
    self.animationImageView.userInteractionEnabled = YES;
    [self.animationImageView addGestureRecognizer:tap];
    
}
- (void )imageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    NSLog(@"tap imagen");
    id TokeImagenTracking = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [TokeImagenTracking sendEventWithCategory:@"uiAction"
                                   withAction:@"Tap Publicidad"
                                    withLabel:@"Tap Branding Principal"
                                    withValue:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma -mark Tableview datasource y delegate

#pragma -mark Tableview datasource y delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows;
    if (section == 0) {
        rows = [self.EventosPadre count];
    }
    else{
        rows = [self.EventosHijos count];
        
    }
    return rows;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    if (section == 0) {
        if ([self.EventosPadre count]>0)
        {
            sectionName = NSLocalizedString(@"Simposios", @"Simposios");
        }
        else;
        
    }
    if (section == 1) {
        if ([self.EventosHijos count]>0)
        {
            sectionName = NSLocalizedString(@"Eventos", @"Eventos");
        }
        else;
        
    }
    
    
    return sectionName;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"JornadaCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.opaque = YES;
        cell.Imagen.opaque = YES;
      
        
    }
    cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"celdaSpeaker.png"]];
    
    if (indexPath.section == 0)
    {
        Eventopadre *info = [self.EventosPadre objectAtIndex:indexPath.row];
        cell.Titulo.text = info.tituloEP;
        cell.Subtitulo.text = info.participantes.nombre;

        cell.Actividad.text = info.tipoEP;
        cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicioEP]];
        cell.Hora.text = [self DateToString:[self StringToDate:info.horaFinEP]];
    }
    
    else
    {
        Evento *info = [self.EventosHijos objectAtIndex:indexPath.row];
        cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];
        cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];
        cell.Titulo.text = info.titulo;
        cell.Subtitulo.text = info.speaker.nombre;
        cell.texto.text = info.lugarEnQueMeDesarrollo.nombreLugar;
        cell.Actividad.text = info.tipoEvento;
        
    }
    
    return cell;
}


#pragma mark - Fetchs Coredata

-(NSArray*)CargarSimposios
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Eventopadre" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@"(horaInicioEP >= %@) AND (horaFinEP < %@)",self.InicioJornada,self.FinJornada];
    [fetchRequest setPredicate:Predicado];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"horaInicioEP" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    return [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

-(NSArray*)CargarEventos
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@"(horaInicio >= %@) AND (horaFin < %@) AND (eventoPadre.tituloEP == %@)",self.InicioJornada,self.FinJornada, NULL];
    [fetchRequest setPredicate:Predicado];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"horaInicio" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    return [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}


#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 73.0f;
}


-(NSDate*)StringToDate:(NSString*)hora{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zz"];
    NSRange RangoReemplazo = {20, 5};
    
    NSString *remplaso = [hora stringByReplacingCharactersInRange:RangoReemplazo withString:@"-0400"];
    return  [dateFormatter dateFromString:remplaso];
}

-(NSString*)DateToString:(NSDate*)Date{
    
    
    NSDateFormatter *formateadorFecha = [[NSDateFormatter alloc] init];
    [formateadorFecha setDateFormat:@"H:mm"];
    return  [formateadorFecha stringFromDate:Date];
    
}


#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"DetalleMixto"])
    {
        
        NSIndexPath *indexPath = [self.JornadasTableView indexPathForSelectedRow];
        NSLog(@"seccion seleccionada es ==> %d",indexPath.section);
        if (indexPath.section == 0)
        {
            Eventopadre *info = [self.EventosPadre objectAtIndex:indexPath.row];
            mSimposioDetViewController *destino = (mSimposioDetViewController *)segue.destinationViewController;
            destino.ExpositorCelda = info.participantes.nombre;

            destino.LugarCelda = info.eventoHijo;

            destino.tituloCelda = info.tituloEP;
            destino.ContenidoeventoHijoCelda =info.tipoEP;
            
            
            NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicioEP]]];
            destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFinEP]]];
            destino.EsSimposio = true;
            
            
            
            
        }
        else{
            Evento *info = [self.EventosHijos objectAtIndex:indexPath.row];
           mSimposioDetViewController *destino = (mSimposioDetViewController *)segue.destinationViewController;
            NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
            UIImage *beforeImage = [UIImage imageWithData:dataObj];
            destino.ExpositorCelda = info.speaker.nombre;
            destino.tituloCelda = info.titulo;
            destino.ContenidoeventoHijoCelda =info.tipoEvento;
            destino.LugarCelda = info.lugarEnQueMeDesarrollo.nombreLugar;
            destino.NombreImagen = beforeImage;
            NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
            destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
            destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
            destino.PaisSpeaker = info.speaker.lugarDondeProvengo.ciudad;
            destino.BiografiaSpeaker = info.speaker.bio;
            destino.Referencia  = info.speaker.tratamiento;
            destino.DateFin = [self StringToDate:info.horaFin];
            destino.DateInicio = [self StringToDate:info.horaInicio];
            destino.ActividadSpeaker = info.descripcionEvento;
            destino.EsSimposio = FALSE;
            
        }
         
        
    }
}


- (IBAction)RevelarNotificaciones:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
    id eventoNotificacionesDesdeAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoNotificacionesDesdeAhora sendEventWithCategory:@"uiAction"
                                               withAction:@"Revelar Notificaciones"
                                                withLabel:@"Revelo desde Jornada"
                                                withValue:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL estadoAutorizador = [defaults boolForKey:@"kAutorizadorSincronizacion"];
//    BOOL estadoAutorizadorImagen = [defaults boolForKey:@"kAutorizadorSincronizacionImagen"];
    
    
    if (estadoAutorizador == YES) {
        // Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
        
        [self AnularActualizaEstadoAutorizadorSincronizacion];
        
    }
//    if (estadoAutorizadorImagen == YES) {
//        // Cargamos el valor de la hora. Usaremos un timer para actualizar la hora cada x tiempo
//        
//        [self AnularActualizaEstadoAutorizadorSincronizacionImagen];
//    }
    
    [super viewWillAppear:animated];
    
}


- (void)viewDidUnload
{
    
    [self setTituloJornada:nil];
    [self setJornadasTableView:nil];
    [super viewDidUnload];
}
@end
