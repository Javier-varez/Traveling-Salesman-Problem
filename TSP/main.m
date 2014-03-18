//
//  main.m
//  TSP
//
//  Brute force algorithm that finds the optimum solution/s for the Traveling Salesman Problem.
//
//  Created by Francisco Javier Álvarez García on 17/03/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>

#define kCost @"Cost"
#define kPath @"Path"

void calculateSolutions(NSArray*, NSMutableArray*, NSMutableArray*, NSMutableArray*);

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        
        //Obtain Matrix to study
        NSLog(@"Number Of Nodes: ");
        
        NSUInteger numberOfNodes = 0;
        
        scanf("%ld", &numberOfNodes);
        
        NSMutableArray *matrix = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < numberOfNodes; i++) {
            
            NSLog(@"%lu Row ", (unsigned long)i+1);
            
            NSMutableArray *currentRow = [[NSMutableArray alloc] init];
            for (NSUInteger j = 0; j < numberOfNodes; j++) {
                
                double valueToRead = 0.0;
                scanf("%lf", &valueToRead);
                
                NSNumber *numberRead = [NSNumber numberWithDouble:-valueToRead];
                
                [currentRow addObject:numberRead];
            }
            [matrix addObject:currentRow];
            currentRow = nil;
        }
        
        /*NSArray *matrix = @[@[@(-0), @(-1), @(-1.5), @(-1.5), @(-1)],
                            @[@(-1), @(-0), @(-1), @(-1.5), @(-1.5)],
                            @[@(-1.5), @(-1), @(-0), @(-1), @(-1.5)],
                            @[@(-1.5), @(-1.5), @(-1), @(-0), @(-1)],
                            @[@(-1), @(-1.5), @(-1.5), @(-1), @(-0)]];*/
        
        /*NSArray *matrix = @[@[@(-0), @(-2.9), @(-3.2), @(-3.6), @(-2.9), @(-3.2), @(-3.6)],
                            @[@(-3.4), @(-0), @(-0.3), @(-0.7), @(-1.7), @(-2.1), @(-2.4)],
                            @[@(-3.1), @(-1.3), @(-0), @(-0.3), @(-0.7), @(-1.7), @(-2.1)],
                            @[@(-2.7), @(-1), @(-1.4), @(-0), @(-1), @(-1.4), @(-1.7)],
                            @[@(-3.4), @(-1.7), @(-2.1), @(-2.4), @(-0), @(-0.3), @(-0.7)],
                            @[@(-3.1), @(-1.3), @(-1.7), @(-2.1), @(-1), @(-0), @(-0.3)],
                            @[@(-2.7), @(-1), @(-1.4), @(-1.7), @(-1), @(-1.4), @(-0)]];*/
        
        //Initialize solutions mutable dictionary
        NSMutableArray *solutions = [[NSMutableArray alloc] init];
        
        //Initialize nodesVisited
        NSMutableArray *nodesVisited = [[NSMutableArray alloc] init];
        [nodesVisited addObject:@0];
        
        //Call function calculateSolutions, that will return 1 or more optimal solutions
        
        calculateSolutions([matrix copy], solutions, nodesVisited, nil);
        
        NSLog(@"%@", solutions);
    }
    return 0;
}


//Recursive function to solve the TSP Problem... not quite fast, but accurate as possible...
void calculateSolutions(NSArray* costMatrix, NSMutableArray *solutions, NSMutableArray* nodesVisited, NSMutableArray *costArray) {
    
    NSArray *rowForCurrentIteration = [costMatrix objectAtIndex: [[nodesVisited lastObject] integerValue]];
    
    if (!costArray) costArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *initialCostArray = [costArray mutableCopy];
    
    
    //Iterate through the possible solutions in our row...
    NSUInteger index = 0;
    for (index = 0; index < [rowForCurrentIteration count]; index++) {
        
        NSNumber *costIndex = [rowForCurrentIteration objectAtIndex:index];
        NSNumber *indexObject = [[NSNumber alloc] initWithUnsignedInteger:index];
        
        //If the selected column hasn't been traveled to, and its feasible...
        if ([costIndex doubleValue] < 0 && ![nodesVisited containsObject:indexObject]) {
            
            //Create nodes array that will be sent to the next iteration of this function
            NSMutableArray *temporaryNodesVisited = [nodesVisited mutableCopy];
            //Add new node
            [temporaryNodesVisited addObject:indexObject];
            
            //Add Cost for the new node visited
            [costArray addObject:costIndex];
            
            if ([temporaryNodesVisited count] == [rowForCurrentIteration count]) {
                
                //Add cost to travel back to the initial point (if feasible...)
                
                NSUInteger lastNode = [[temporaryNodesVisited lastObject] unsignedIntegerValue];
                NSArray *rowForLastNode = [costMatrix objectAtIndex:lastNode];
                
                if([[rowForLastNode objectAtIndex:0] doubleValue] < 0) {
                    //Add last cost to array
                    [costArray addObject:[rowForLastNode objectAtIndex:0]];
                    
                    [temporaryNodesVisited addObject:@0];
                    
                    //Obtain total cost of the costArray
                    double totalCostOfArray = 0.0;
                    for (NSNumber *i in costArray) {
                        totalCostOfArray = totalCostOfArray + [i doubleValue];
                    }
                    
                    // If cost is less than last solution, remove current solutions
                    if ([solutions lastObject]) {
                        NSDictionary *lastSolutionFound = [solutions lastObject];
                        
                        if (totalCostOfArray > [lastSolutionFound[kCost] doubleValue]) {
                            [solutions removeAllObjects];
                            //Add new solution
                            NSDictionary *newSolution = @{kCost: @(totalCostOfArray),
                                                          kPath: temporaryNodesVisited};
                            [solutions addObject:newSolution];
                        }
                        else if (totalCostOfArray == [lastSolutionFound[kCost] doubleValue]) {
                            //Add new solution
                            NSDictionary *newSolution = @{kCost: @(totalCostOfArray),
                                                          kPath: temporaryNodesVisited};
                            [solutions addObject:newSolution];
                        }
                    }
                    else {
                        //Add new solution
                        NSDictionary *newSolution = @{kCost: @(totalCostOfArray),
                                                      kPath: temporaryNodesVisited};
                        [solutions addObject:newSolution];
                    }
                }
            }
            else {
                //Keep looking for solutions...
                calculateSolutions(costMatrix, solutions, temporaryNodesVisited, [costArray mutableCopy]);
            }
        }
        //Retrieve initial cost array when the program passes to a different solution or possibility...
        costArray = [initialCostArray mutableCopy];
    }
}