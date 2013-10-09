//
//  TipoEvento.h
//  DualmobileCongress
//
//  Created by felix sanhueza on 6/6/13.
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
