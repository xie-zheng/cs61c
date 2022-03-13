/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

// ----------------
// Helper Functions
// Read a color
void colorScanf(FILE *fp, Color *c)
{
	fscanf(fp, "%hhu %hhu %hhu", &c->R, &c->G, &c->B);
}

// Print a single color
void colorPrint(Color *c)
{
	printf("%3u %3u %3u", c->R, c->G, c->B);
}
// -----------------------------------------

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.
Image *readData(char *filename)
{
	FILE *fp = fopen(filename, "r");
	if (fp == NULL)
	{
		return NULL;
	}
	// read header
	Image *im = (Image *)malloc(sizeof(Image));

	// unused var
	char type[20];
	uint8_t range;

	fscanf(fp, "%s", type);
	fscanf(fp, "%u %u", &im->cols, &im->rows);
	fscanf(fp, "%hhu", &range);

	// read pixels
	im->image = (Color **)malloc(sizeof(Color *) * im->rows);
	for (int i = 0; i < im->rows; i++)
	{
		im->image[i] = (Color *)malloc(sizeof(Color) * im->cols);
		for (int j = 0; j < im->cols; j++)
		{
			Color c;
			colorScanf(fp, &c);
			im->image[i][j] = c;
		}
	}

	fclose(fp);
	return im;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	// print header
	printf("P3\n%u %u\n255\n", image->cols, image->rows);
	// print image
	Color **ptr = image->image;
	for (int i = 0; i < image->rows; i++)
	{
		for (int j = 0; j < image->cols; j++)
		{
			colorPrint(&ptr[i][j]);
			if (j != image->rows - 1)
			{
				printf("   "); // 3 whitespace between each color
			}
		}
		printf("\n");
	}
}

// Frees an image
void freeImage(Image *image)
{
	free(image->image);
	free(image);
}