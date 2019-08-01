#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define START 0
#define END 77360
#define ITR 77361
int main(void)
{
	FILE *fp[3];
	fp[0] = fopen("./integralImage.txt", "w");
	fp[2] = fopen("./tv.h", "w");
	int i, j, k;

	unsigned short number;
	unsigned short tmp_num[2] = {0};

	for (i = 0; i<3; i++)
		if (fp[i] == NULL)
		{
			printf("error occurs when opening fp[%d]!\n", i);
			exit(1);
		}


	srand((long)time(NULL));


	j=0;
	fprintf(fp[2], "unsigned short integralImage[%d] = {\n", ITR);
	for(i=0;i<ITR;i++) //2^15 = 256 x 128 endi endj 232*312
	{
		number=rand()%(END-START+1)+START;
		fprintf(fp[2], "0x%04x,\n", number);
		tmp_num[j] = number;
		
		
		j=j+1;
		if(j==1)
		{
			for(k=0;k>=0;k--)
				fprintf(fp[0], "%04x", tmp_num[k]);
			fprintf(fp[0], "\n");
			j=0;
		}
	}
	fprintf(fp[2], "};\n");
	

	fclose(fp[0]);
	fclose(fp[2]);
	return 0;
}
