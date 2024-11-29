//The c file of the djisktra's algorithm.The memory address are manually defined for all variables so that they wont overlap on the data memory

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#ifdef linux // for host pc

#include <stdio.h>

void _put_byte(char c) { putchar(c); }

void _put_str(char *str)
{
    while (*str)
    {
        _put_byte(*str++);
    }
}

void print_output(uint8_t num)
{
    if (num == 0)
    {
        putchar('0'); // if the number is 0, directly print '0'
        _put_byte('\n');
        return;
    }

    if (num < 0)
    {
        putchar('-'); // print the negative sign for negative numbers
        num = -num;   // make the number positive for easier processing
    }

    // convert the integer to a string
    char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
    uint8_t index = 0;

    while (num > 0)
    {
        buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
        num /= 10;                        // move to the next digit
    }

    // print the characters in reverse order (from right to left)
    while (index > 0)
    {
        putchar(buffer[--index]);
    }
    _put_byte('\n');
}

void _put_value(uint8_t val) { print_output(val); }

#else // for the test device

void _put_value(uint8_t val) {}
void _put_str(char *str) {}

#endif

/*
Functions Usage

instead of using printf() function for debugging,
use the below function calls to print a number, string or a newline

for newline: _put_byte('\n');
for string:  _put_str("your string here");
for number:  _put_value(your_number_here);

Examples:
        _put_value(START_POINT);
        _put_value(END_POINT);
        _put_str("Hello World!");
        _put_byte('\n');

*/

// main function
int main(int argc, char const *argv[])
{

#ifdef linux

    const uint8_t START_POINT = atoi(argv[1]);
    const uint8_t END_POINT = atoi(argv[2]);
    uint8_t NODE_POINT = 0;
    uint8_t CPU_DONE = 0;
    uint8_t cost_function[64]; //{1,0,2,29,1,3,8,2,4,28,3,5,6,4,4,7,6,8,2,7,9,12,8,10,11,9,9,8,13,19,12,14,13,15,16,14,14,17,18,16,16,19,12,18,20,19,21,24,29,20,22,23,21,21,20,25,24,26,25,27,28,26,3,26,29,1,20,28};
                               // uint8_t* cost_ptr=cost_function;
    uint8_t stind[31];
    uint8_t distance[30];
    uint8_t previous_node[30];
    uint8_t path_planned[32];
    uint8_t minIndex = 0; // Initialize the index of the minimum element to the first element
    uint8_t minValue = 0;
    uint8_t current_node = 0;

#else
    // Address value of variables are updated for RISC-V Implementation
#define START_POINT (*(volatile uint8_t *)0x02000000)
#define END_POINT (*(volatile uint8_t *)0x02000004)
#define NODE_POINT (*(volatile uint8_t *)0x02000008)
#define CPU_DONE (*(volatile uint8_t *)0x0200000c)
#define cost_function ((uint8_t *)0x02000010)
#define stind ((uint8_t *)0x02000056)
#define distance ((uint8_t *)0x02000077)
#define previous_node ((uint8_t *)0x02000096)
#define path_planned ((uint8_t *)0x020000b6)
#define current_node (*(volatile uint8_t *)0x020000d8)

#endif

    // array to store the planned path
    // index to keep track of the path_planned array
    uint8_t idx = 0;
    // ############# Add your code here #############

    cost_function[0] = 1;
    cost_function[1] = 0;
    cost_function[2] = 2;
    cost_function[3] = 29;
    cost_function[4] = 1;
    cost_function[5] = 3;
    cost_function[6] = 8;
    cost_function[7] = 2;
    cost_function[8] = 4;
    
    cost_function[9] = 3;
    cost_function[10] = 5;
    cost_function[11] = 6;
    cost_function[12] = 4;
    cost_function[13] = 4;
    cost_function[14] = 7;
    cost_function[15] = 6;
    cost_function[16] = 8;
    cost_function[17] = 2;
    cost_function[18] = 7;
    cost_function[19] = 9;
    cost_function[20] = 12;
    cost_function[21] = 8;
    cost_function[22] = 10;
    cost_function[23] = 11;
    cost_function[24] = 9;
    cost_function[25] = 9;
    cost_function[26] = 8;
    cost_function[27] = 13;
   
    cost_function[28] = 12;
    cost_function[29] = 14;
    cost_function[30] = 13;
    cost_function[31] = 15;
    cost_function[32] = 16;
    cost_function[33] = 14;
    cost_function[34] = 14;
    cost_function[35] = 17;
    cost_function[36] = 18;
    cost_function[37] = 16;
    cost_function[38] = 16;
    cost_function[39] = 19;
   
    cost_function[40] = 18;
    cost_function[41] = 20;
    cost_function[42] = 19;
    cost_function[43] = 21;
    cost_function[44] = 24;
    cost_function[45] = 29;
    cost_function[46] = 20;
    cost_function[47] = 22;
    cost_function[48] = 23;
    cost_function[49] = 21;
    cost_function[50] = 21;
    cost_function[51] = 20;
    cost_function[52] = 25;
    cost_function[53] = 24;
    cost_function[54] = 26;
    cost_function[55] = 25;
    cost_function[56] = 27;
    cost_function[57] = 28;
    cost_function[58] = 26;
    
    cost_function[59] = 26;
    cost_function[60] = 29;
    cost_function[61] = 1;
    cost_function[62] = 20;
    cost_function[63] = 28;

    stind[0] = 0;
    stind[1] = 1;
    stind[2] = 4;
    stind[3] = 7;
    stind[4] = 9;
    stind[5] = 12;
    stind[6] = 13;
    stind[7] = 15;
    stind[8] = 17;
    stind[9] = 21;
    stind[10] = 24;
    stind[11] = 25;
    stind[12] = 26;
    stind[13] = 28;
    stind[14] = 30;
    stind[15] = 33;
    stind[16] = 34;
    stind[17] = 37;
    stind[18] = 38;
    stind[19] = 40;
    stind[20] = 42;
    stind[21] = 46;
    stind[22] = 49;
    stind[23] = 50;
    stind[24] = 51;
    stind[25] = 53;
    stind[26] = 55;
    stind[27] = 58;
    stind[28] = 59;
    stind[29] = 61;
    stind[30] = 64;

    for (uint8_t i = 0; i < 30; i++)
    {
        distance[i] = 99;
    }
    distance[START_POINT] = 0;
    for (uint8_t j = 0; j < 30; j++)
    {
        uint8_t minIndex = 0;           // Initialize the index of the minimum element to the first element
        uint8_t minValue = distance[0]; // Initialize the minimum value to the value of the first element

        for (uint8_t i = 1; i < 30; i++)
        {
            if (distance[i] < minValue)
            {
                // If a smaller element is found, update the minimum value and its index
                minValue = distance[i];
                minIndex = i;
            }
        }
        current_node = minIndex;

        for (uint8_t j = stind[current_node]; j < stind[current_node + 1]; j++)
        {

            if (distance[current_node] + 1 < distance[cost_function[j]] && distance[cost_function[j]] != 98)
            {

                distance[cost_function[j]] = distance[current_node] + 1;
                previous_node[cost_function[j]] = current_node;
                // printf("currentnode : %d neighbour: %d distance: %d previous_node: %d",current_node,i,distance[i],previous_node[i]);
                // printf("\n");
            }
        }

        distance[current_node] = 98;
    }

    uint8_t before_value = END_POINT;
    path_planned[0] = END_POINT;
    for (int i = 0; i < 30; i++)
    {
        path_planned[i + 1] = previous_node[before_value];
        // printf("%d\n",path_planned[i]);
        before_value = path_planned[i + 1];
        idx++;

        if (path_planned[i] == START_POINT)
        {
            break;
        }
    }
    uint8_t start = 0;
    uint8_t end = idx - 1;

    while (start < end)
    {
        // Swap the elements at the start and end positions
        uint8_t temp = path_planned[start];
        path_planned[start] = path_planned[end];
        path_planned[end] = temp;

        // Move the start and end pointers toward each other
        start++;
        end--;
    }

    // ##############################################

    // the node values are written into data memory sequentially.
    for (int i = 0; i < idx; ++i)
    {
        NODE_POINT = path_planned[i];
    }
    // Path Planning Computation Done Flag
    CPU_DONE = 1;

#ifdef linux // for host pc

    _put_str("######### Planned Path #########\n");
    for (int i = 0; i < idx; ++i)
    {
        _put_value(path_planned[i]);
    }
    _put_str("################################\n");

#endif

    return 0;
}