//
//  mSimposioViewController.h
//  DualmobileCongress
//
//  Created by Alfonso Parra on 11-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mSimposioViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *BotonNotificaciones;
@property (strong, nonatomic) IBOutlet UITextView *TituloSimposio;
@property (strong, nonatomic) IBOutlet UITextView *descripcionSimposio;
@property (strong, nonatomic) IBOutlet UILabel *lugar;
@property (strong, nonatomic) IBOutlet UILabel *horario;





@end
