/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// ---------------
// Helper Function
void setBorW(Color *c, int b_or_w)
{
	uint8_t color = (b_or_w) ? 0 : 255;
	c->R = color;
	c->G = color;
	c->B = color;
}
// --------------

// Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	Color *c = (Color *)malloc(sizeof(Color));
	setBorW(c, image->image[row][col].B % 2);

	return c;
}

// Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
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
			result->image[i][j] = *evaluateOnePixel(image, i, j);
		}
	}

	return result;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image,
where each pixel is black if the LSB of the B channel is 0,
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	if (argc < 1)
	{
		return -1;
	}
	Image *src = readData(argv[1]);
	Image *decoded = steganography(src);
	writeData(decoded);
	free(src);
	free(decoded);
	// FILE *dst = fopen(argv[2], "w");
	return 0;
}
