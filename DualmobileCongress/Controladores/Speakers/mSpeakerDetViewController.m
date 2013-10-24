//
//  mSpeakerDetViewController.m
//  DualmobileCongress
//
//  Created by luis Gonzalez on 31-05-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import "mSpeakerDetViewController.h"
#import "mAppDelegate.h"
#import "GAI.h"
#import "Notificacion.h"

@interface mSpeakerDetViewController ()
@property(nonatomic,strong)mAppDelegate *delegate;
@end

@implementation mSpeakerDetViewController

-(void)awakeFromNib{
    [self.DetailSpeakerTableview reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     //trackenado GA
        
    id trackerDetalleSpeaker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [trackerDetalleSpeaker sendView:@"DetalleSpeaker"];
    

    UIImage *NotButtonImage = [[UIImage imageNamed:@"boton_nota"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    [self.BotonNotificaciones setBackgroundImage:NotButtonImage
                                        forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    NSLog(@"el nombre es ==> %@",self.Nombrecelda);
    self.title = @" ";
    self.delegate = [[UIApplication sharedApplication]delegate];
   // self.NombreSpeaker.text = [self.ReferenciaSpeaker stringByAppendingFormat:@" %@",self.Nombrecelda];
    
    self.NombreSpeaker.text = self.Nombrecelda;
    
    self.PaisSpeaker.text = self.Paiscelda;
    self.ImageViewSpeaker.image = self.ImagenDelSpeaker;
    if (self.Institucioncelda== nil) {
        NSLog(@"es nulo");
       

    }
    else{
        NSLog(@"no es nulo");
         self.InstitucionSpeaker.text = self.Institucioncelda;
    }
    self.Biografia.text = self.BiografiaCelda;
    
    NSLog(@"nombre: %@ Pais %@ Institucion %@", self.Nombrecelda , self.Paiscelda , self.Institucioncelda);
    self.EventoQueParticipo = [[NSMutableArray alloc]initWithArray:[self CargarEventosQueParticipo]];
 
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
-(void)notifica {
    
    NSError *error;
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Notificacion" inManagedObjectContext:_delegate.managedObjectContext];
    NSFetchRequest *fet = [[NSFetchRequest alloc]init];
    [fet setEntity:ent];
    NSArray *ar = [_delegate.managedObjectContext executeFetchRequest:fet error:&error];
    NSLog(@"%@",ar);
}



- (IBAction)RevelarNotificaciones:(id)sender
{
    [self notifica];
    [self.slidingViewController anchorTopViewTo:ECLeft];
    id eventoNotificacionesDesdeAhora = [[GAI sharedInstance] trackerWithTrackingId:@"UA-41445507-1"];
    [eventoNotificacionesDesdeAhora sendEventWithCategory:@"uiAction"
                                               withAction:@"Revelar Notificaciones"
                                                withLabel:@"Revelo desde Detalle Speaker"
                                                withValue:nil];
}


- (void)viewDidUnload {
    
    [self setBotonNotificaciones:nil];
    [self setDetailSpeakerTableview:nil];
    [self setNombreSpeaker:nil];
    [self setPaisSpeaker:nil];
    [self setInstitucionSpeaker:nil];
    [self setTitulosSpeaker:nil];
    [self setImageViewSpeaker:nil];
    [self setBiografia:nil];
    [super viewDidUnload];
}

#pragma -mark Tableview datasource y delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Cantidad de eventos que participo ==> %d",[self.EventoQueParticipo count]);
    return [self.EventoQueParticipo count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Evento *info = [self.EventoQueParticipo objectAtIndex:indexPath.row];
    NSString *cellIdentifier = @"CharlasCell";
    mCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[mCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.contentView.backgroundColor   =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"celdaSpeaker.png"]];
    
    cell.Titulo.text = info.titulo;
    cell.horaInicio.text = [self DateToString:[self StringToDate:info.horaInicio]];;
    cell.Hora.text = [self DateToString:[self StringToDate:info.horaFin]];;
    cell.lugar.text = info.lugarEnQueMeDesarrollo.nombreLugar;
    NSLog(@"nombre del speaker ==> %@" ,self.Nombrecelda);
    cell.Subtitulo.text = info.speaker.nombre;
    


    
    return cell;
}


#pragma mark - Fetchs Coredata

-(NSArray*)CargarEventosQueParticipo
{
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Evento" inManagedObjectContext:self.delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *Predicado = [NSPredicate predicateWithFormat:@"speaker.nombre = %@ ",self.Nombrecelda];
    [fetchRequest setPredicate:Predicado];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"horaInicio" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error = nil;
    
    return [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}
-(NSDate*)StringToDate:(NSString*)hora{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzzz"];
    NSRange RangoReemplazo = {20,5};
    
    NSString *remplaso = [hora stringByReplacingCharactersInRange:RangoReemplazo withString:@"-0300"];
    return  [dateFormatter dateFromString:remplaso];
}

-(NSString*)DateToString:(NSDate*)Date{
    
    
    NSDateFormatter *formateadorFecha = [[NSDateFormatter alloc] init];
    [formateadorFecha setDateFormat:@"H:mm"];
    return  [formateadorFecha stringFromDate:Date];
    
}


#pragma -mark Alto de la cada celda

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  
    return 73.0f;
}

#pragma -mark enviamos datos de la celda selecionadas a la vista de detalle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Comprobamos si el identificador es el adecuado
    
    if ([segue.identifier isEqualToString:@"DetalleEvento"])
    {
        Evento *info = [self.EventoQueParticipo objectAtIndex:[self.DetailSpeakerTableview indexPathForSelectedRow].row];
        mDetalleViewController *destino = (mDetalleViewController *)segue.destinationViewController;
        NSData *dataObj = [NSData dataWithBase64EncodedString:info.speaker.fotoPersona.binarioImagen];
        UIImage *beforeImage = [UIImage imageWithData:dataObj];
        destino.ExpositorCelda = info.speaker.nombre;
        destino.tituloCelda = info.titulo;
        destino.ContenidoCelda =info.tematica;
        destino.LugarCelda = info.lugarEnQueMeDesarrollo.ciudad;
        destino.NombreImagen = beforeImage;
        NSString *HoraExposicion = [[NSString alloc]initWithFormat:@"De %@ ",[self DateToString:[self StringToDate:info.horaInicio]]];
        destino.horacelda = [HoraExposicion stringByAppendingFormat:@"a %@ Hrs.",[self DateToString:[self StringToDate:info.horaFin]]];
        destino.InstitucionSpeaker = info.speaker.institucionQueMePatrocina.nombreInstitucion;
        destino.PaisSpeaker = info.speaker.lugarDondeProvengo.pais;
        destino.BiografiaSpeaker = info.speaker.bio;
        destino.Referencia  = info.speaker.tratamiento;
        destino.DateFin = [self StringToDate:info.horaFin];
        destino.DateInicio = [self StringToDate:info.horaInicio];
        destino.ActividadSpeaker = info.descripcionEvento;
        if (![info.eventoPadre.tipoEP isEqualToString:@"Simposio"] )
        {
            destino.EsSimposio = false;
        }
        else
        {
            destino.EsSimposio = true;
            destino.NombreSimposioPadre = info.eventoPadre.tituloEP;
            
        }

    }
}






@end
