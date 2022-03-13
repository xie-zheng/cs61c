/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

Color *get(Image *image, int row, int col)
{
	// border check
	if (row < 0 || row > image->rows || col < 0 || col > image->cols)
	{
		return 0;
	}
	return &image->image[row][col];
}

// Determines the bits of the neighbors
// return a 8 digit number
// each digit represent the live cell in certain bit
int *checkNeighbors(Image *image, int row, int col)
{
	int resR = 0;
	int resG = 0;
	int resB = 0;
	int dx[3] = {-1, 0, 1};
	int dy[3] = {-1, 0, 1};
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			if (i == 1 && j == 1)
			{
				continue;
			}
			int posy = row + dy[i];
			int posx = col + dx[j];
			Color *c = get(image, posx, posy);
			if (c == NULL)
			{
				continue;
			}
			u_int8_t r, g, b;
			r = c->R;
			g = c->G;
			b = c->B;
			int coe = 1;
			for (int i = 0; i < 8; i++)
			{
				resR = resR + (r % 2) * coe;
				resG = resG + (g % 2) * coe;
				resB = resB + (b % 2) * coe;
				r = r >> 1;
				g = g >> 1;
				b = b >> 1;
				coe = coe * 10;
			}
		}
	}

	int *res = (int *)malloc(sizeof(int) * 3);
	res[0] = resR;
	res[1] = resG;
	res[2] = resB;
	return res;
}

uint8_t applyrule(uint8_t old, int neighbor, uint32_t rule)
{
	uint8_t res = 0;
	for (int i = 0; i < 8; i++)
	{
		int least = old % 2;
		int near = neighbor % 10;
		uint8_t bit;
		if (least)
		{
			// live
			bit = (rule >> (9 + near)) % 2;
		}
		else
		{
			bit = (rule >> near) % 2;
		}
		old = old >> 1;
		neighbor = neighbor / 10;
		res = res + (bit << i);
	}

	return res;
}

Color *genNewcell(Color *c, int *neighbor, uint32_t rule)
{
	Color *result = (Color *)malloc(sizeof(Color));
	result->R = applyrule(c->R, neighbor[0], rule);
	result->G = applyrule(c->G, neighbor[1], rule);
	result->B = applyrule(c->B, neighbor[2], rule);
	return result;
}

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	int *neighbor = checkNeighbors(image, row, col);
	Color *next = genNewcell(get(image, row, col), neighbor, rule);
	free(neighbor);
	return next;
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	Image *result = (Image *)malloc(sizeof(Image));
	result->image = (Color **)malloc(sizeof(Color *) * image->rows);
	result->cols = image->cols;
	result->rows = image->rows;

	for (int i = 0; i < image->rows; i++)
	{
		result->image[i] = (Color *)malloc(sizeof(Color) * image->cols);
		for (int j = 0; j < image->cols; j++)
		{
			result->image[i][j] = *evaluateOneCell(image, i, j, rule);
		}
	}

	return result;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	if (argc < 2)
	{
		return -1;
	}
	Image *src = readData(argv[1]);
	// uint32_t rule = strtol(argv[2], NULL, 16);
	uint32_t rule = 0x1808;
	if (src == NULL)
	{
		return -1;
	}
	Image *next = life(src, rule);
	writeData(next);
	free(src);
	free(next);
	return 0;
}
