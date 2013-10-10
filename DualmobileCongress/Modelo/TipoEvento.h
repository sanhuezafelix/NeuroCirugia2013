//
//  TipoEvento.h
//  DualmobileCongress
//
//  Created by Arturo Sanhueza on 09-10-13.
//  Copyright (c) 2013 Luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Evento;

@interface TipoEvento : NSManagedObject

@property (nonatomic, retain) NSString * idTipoEvento;
@property (nonatomic, retain) NSSet *eventoQueDeterminare;
@end

@interface TipoEvento (CoreDataGeneratedAccessors)

- (void)addEventoQueDeterminareObject:(Evento *)value;
- (void)removeEventoQueDeterminareObject:(Evento *)value;
- (void)addEventoQueDeterminare:(NSSet *)values;
- (void)removeEventoQueDeterminare:(NSSet *)values;

@end
