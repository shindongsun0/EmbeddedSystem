#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tv.h"

#define COL 320
#define ROW 240
#define DetMSize 75516

const int size = 9;
const int Dx[15] = {
	642, 2247, 645, 2250, 1,
	645, 2250, 648, 2253, -1,
	648, 2253, 651, 2256, 1 };
const int Dy[15] = {
	2, 965, 7, 970, 1,
	965, 1928, 970, 1933, -1,
	1928, 2891, 1933, 2896, 1 };
const int Dxy[20] = {
	322, 1285, 325, 1288, 1,
	326, 1289, 329, 1292, -1,
	1606, 2569, 1609, 2572, -1,
	1610, 2573, 1613, 2576, 1 };
unsigned short determinantM[DetMSize];

int main(void)
{
	FILE *fp;
	FILE *fp2;
	FILE *fp3;
	FILE *fp4;
	FILE *fp5;
	fp = fopen("./sw_result.txt", "w");
	fp2 = fopen("./dx.txt", "w");
	fp3 = fopen("./dy.txt", "w");
	fp4 = fopen("./dxy.txt", "w");
	fp5 = fopen("./dxy_f.txt", "w");
	int endi = 1 + (ROW - size);
	int endj = 1 + (COL - size);
	int margin = size / 2;
	int i = 0, j = 0, k = 0;
	int layerStep = COL;
	int dx = 0, dy = 0, dxy = 0;

	if (fp == NULL)
	{
		printf("error occurs when opening sw_result.txt!\n");
		exit(1);
	}
	for (i = 0; i < 1; i++) {
		for (j = 0; j < endj; j++) {
			dx = 0; dy = 0; dxy = 0;
			for (k = 0; k < 15; k += 5) {
				dx += integralImage[i*(COL + 1) + j + Dx[k]];
				fprintf(fp2, "%8x\n", dx);
				dx += integralImage[i*(COL + 1) + j + Dx[k + 3]];
				fprintf(fp2, "%8x\n", dx);
				dx -= integralImage[i*(COL + 1) + j + Dx[k + 1]];
				fprintf(fp2, "%8x\n", dx);
				dx -= integralImage[i*(COL + 1) + j + Dx[k + 2]];
				fprintf(fp2, "%8x\n", dx); 
				dx = dx * Dx[k + 4];
				fprintf(fp2, "%8x\n", dx);

				dy += integralImage[i*(COL + 1) + j + Dy[k]];
				fprintf(fp3, "%8x\n", dy);
				dy += integralImage[i*(COL + 1) + j + Dy[k + 3]];
				fprintf(fp3, "%8x\n", dy);
				dy -= integralImage[i*(COL + 1) + j + Dy[k + 1]];
				fprintf(fp3, "%8x\n", dy);
				dy -= integralImage[i*(COL + 1) + j + Dy[k + 2]];
				dy = dy *Dy[k + 4];
				fprintf(fp3, "%8x\n", dy);

				dxy += integralImage[i*(COL + 1) + j + Dxy[k]];
				fprintf(fp4, "%8x\n", dxy);
				dxy += integralImage[i*(COL + 1) + j + Dxy[k + 3]];
				fprintf(fp4, "%8x\n", dxy);
				dxy -= integralImage[i*(COL + 1) + j + Dxy[k + 1]];
				fprintf(fp4, "%8x\n", dxy);
				dxy -= integralImage[i*(COL + 1) + j + Dxy[k + 2]];
				fprintf(fp4, "%8x\n", dxy); 
				dxy = dxy *Dxy[k + 4];
				fprintf(fp4, "%8x\n", dxy);
			}
			dxy += integralImage[i*(COL + 1) + j + Dxy[k]];
			fprintf(fp5, "%8x\n", dxy);
			dxy += integralImage[i*(COL + 1) + j + Dxy[k + 3]];
			fprintf(fp5, "%8x\n", dxy);
			dxy -= integralImage[i*(COL + 1) + j + Dxy[k + 1]];
			fprintf(fp5, "%8x\n", dxy);
			dxy -= integralImage[i*(COL + 1) + j + Dxy[k + 2]];
			fprintf(fp5, "%8x\n", dxy); 
			dxy = dxy *Dxy[k + 4];
			fprintf(fp5, "%8x\n", dxy);
			printf("%d, %d, %d = %d\n", dx*dy, dxy*dxy, dxy*dxy/2, dx*dy - (dxy*dxy));
			determinantM[((i + margin)*layerStep + margin) + j] = dx*dy - (dxy*dxy / 2);
			

		}
	}
	for (int f = 0; f <	DetMSize; f++) {
		if (determinantM[f] != 0)
			fprintf(fp, "%4x\n", determinantM[f]);
			
	}
	fclose(fp);
	fclose(fp2);
	fclose(fp3);
	fclose(fp4);
	fclose(fp5);
	return 0;
}
