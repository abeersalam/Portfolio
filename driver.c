//Author: Abeer Salam
//Email: abeerguy@gmail.com
//Course: CPSC240-MonWed
//Assignment number: 6
//Due date: December 16, 2013
//File name: assn6d.c
//Program name: subprograms
//Language: C
//Page width maximum: 140 columns
//Purpose: Calls the main assembly program

#include <stdio.h>
#include <stdint.h>

extern double * assn6m();

int main()
{
  double * return_code = (double * )99;
  printf("%s","Welcome to Assignment 6 by Abeer Salam\n");
  return_code = (double *)assn6m();  

  printf("%s","The driver received these values: \n");
  //Outputs the entire array (max size)
  for (int i = 0; i < 12; i++) {
      printf("%3.18lf\n", return_code[i]);
  }
  
  printf("%s","Enjoy your assembly program. Bye.\n");
  return 0;
}//End of main
