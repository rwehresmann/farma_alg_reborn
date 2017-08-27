#include<stdio.h>
int main()
{
  // Variable declaration
  int a, b, sum;
  // Take two numbers as input from the user
  scanf("%d %d", &a, &b);
  // Add the numbers and assign the value to some variable so that the
  // calculated value can be used else where
  sum = a + b;
  // Use the calculated value
  printf("%d", sum);
  return 0;
  // End of program
}
