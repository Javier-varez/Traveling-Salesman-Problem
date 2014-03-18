Traveling-Salesman-Problem
==========================

Traveling Salesman Problem Brute Force Algorithm

This is a brute force algorithm to solve the Traveling Salesman Problem. It takes a recursive approach to this problem by delegating each iteration to the next call of the function.

Written in Objective-C and C, using the Foundation Framework from Apple. 

The input is a matrix with the minimum distance between two nodes.
      
This is an example of a directed network with four nodes (0, 1, 2 ,3) and that is connected form 0 to 1, from 1 to 2, from 2 to 3 and from 3 to 0. All connections have a cost (distance) of 1.
      
                    To
              | 0 | 1 | 2 | 3 |
          | 0 | - | 1 | - | - |
     from | 1 | - | - | 1 | - |
          | 2 | - | - | - | 1 |
          | 3 | 1 | - | - | - |
