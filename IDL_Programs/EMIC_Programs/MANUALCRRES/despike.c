#include "window_typedef.h"

void moment(float data[], int n, float *ave, float *adev, float *sdev, float *var, float *skew, float *curt);
void sort1d(unsigned long n, float arr[]);
void mdian1(float x[], int n, float *med, int zeroflag);

void assign_value(float data1d[], int num, float value);
void pack_pad_float(float **data2d,int width,int height,float *data1d,int xpow2,int ypow2,int i,int j,int xwin,int ywin,int xwinedgeL,int xwinedgeR,int ywinedgeU,int ywinedgeD);
void unpack_pad_float(float **data2d,int width,int height,float *data1d,int xpow2,int ypow2,int i,int j,int xwin,int ywin, int xwinedgeL,int xwinedgeR,int ywinedgeU,int ywinedgeD);
void increment_buffer(float **data2d,int ywin,int ypow2,int width);

float **matrix(int nrl, int nrh, int ncl, int nch);
float *vector(int nl, int nh);
unsigned long *lvector(int nl, int nh);

int main(int argc, char **argv)
{

  float *tmp;			/* 1d vector of floats for reading and writing */
  float *floatvec1;		/* 1d vector of floats used in fourn, wavelet codes by numerical recipes */
  float **buffer1;		/* 2d matrix of floats, stores the entire width by ywin input dataset */
  float **outdata1;		/* 2d matrix of floats, used to write the output filtered data */
  unsigned long *nfft;		/* array that holds the number of X and Y powers of 2 */

  float ave,adev,sdev,var,skew,curt;	/* statistical values from numerical recipes */
  float xmed,multiple,current_value;	/* median despiking variables */

  int xwin,ywin;		/* size of window */
  int xwinedgeR,xwinedgeL;	/* left and right xwindedges, typically used to center window in power of 2 */
  int ywinedgeU,ywinedgeD;	/* up and down ywindedges, typically used to center window in power of 2 */
  int xpow2,ypow2;		/* power of 2 sizes, this is only necessary if using fourier or wavelets */
				/*   otherwise, xpow2 and ypow2 can be any size */
  int endny;			/* tests and marks end of file writing */

  int value;			/* defines which statistical measure to write to pixel(s) */

  int width;			/* width of input file */
  int num_lines;		/* number of lines in file */
  int linecnt=0;		/* number of lines written */
  int i,j,ii,jj;		/* index counters */
  int zerocnt=0;
  int zeroflag=1;		/* 1=remove zeros from array before counting them toward the median, 0=count them */

  FILE *infile1,*outfile1;
   

  fprintf(stderr,"*** Sort and find median within moving window, zero value if it falls outside of multiple of median ***\n") ;
  if(argc < 8){
    fprintf(stderr,"\nusage: %s <input1> <output1> <width> <xwinedgeL> <xwinedgeR> <ywinedgeU> <ywinedgeD> [multiple]\n\n", argv[0]) ;
    fprintf(stderr,"input parameters: \n");
    fprintf(stderr,"  input1               input file1 of floats\n");
    fprintf(stderr,"  output1              output filtered file1 of floats\n");
    fprintf(stderr,"  width                width of input files\n");
    fprintf(stderr,"  xwinedgeL,xwinedgeR  size of the rind around the window\n");
    fprintf(stderr,"  ywinedgeU,ywinedgeD  size of the rind around the window\n");
    fprintf(stderr,"  multiple             if pixel value is greater than multiple*median, then zero it (default=3.0)\n\n");
    exit(-1);
  }

  infile1 = fopen(argv[1],"r");
  if (infile1 == NULL){fprintf(stderr,"ERROR: cannot open infile1: %s\n",argv[1]); exit(-1);}

  outfile1 = fopen(argv[2],"w");
  if (outfile1 == NULL){fprintf(stderr,"ERROR: cannot open outfile1: %s\n",argv[2]); exit(-1);}

  sscanf(argv[3],"%d",&width);
  fseek(infile1, 0L, REL_EOF);
  num_lines=(int)(ftell(infile1)/(sizeof(float)*width));
  rewind(infile1);
  fprintf(stdout,"width and number lines in files: %d %d\n",width,num_lines);

  xwin=1;				/* set the xwin,ywin variables to work one pixel at a time */
  ywin=1;
  sscanf(argv[4],"%d",&xwinedgeL);
  sscanf(argv[5],"%d",&xwinedgeR);
  sscanf(argv[6],"%d",&ywinedgeU);
  sscanf(argv[7],"%d",&ywinedgeD);

  xpow2 = xwinedgeL + xwin + xwinedgeR;
  ypow2 = ywinedgeU + ywin + ywinedgeD;

  fprintf(stderr,"moving window size (X by Y): %5d %5d\n",xwin,ywin);
  fprintf(stderr,"rind around the window X(l,r) by Y(u,d): %5d %5d %5d %5d\n",xwinedgeL,xwinedgeR,ywinedgeU,ywinedgeD);
  fprintf(stderr,"power of 2 size of window (Xpow2, Ypow2): %5d %5d\n",xpow2,ypow2);

  multiple=3.0;
  if(argc > 8)sscanf(argv[8],"%f",&multiple);
  fprintf(stderr,"pixel values greater than %f times the local median will be zeroed\n",multiple);

/**** allocate the memory  all arrays, except tmp, start at 1 not zero ****/

  nfft = lvector(1,2);
  nfft[1]=ypow2; nfft[2]=xpow2; 

  floatvec1 = vector(1,xpow2*ypow2);	/* vector of windowed data passed between numerical recipes routines */
  buffer1 = matrix(1,ypow2,1,width);	/* matrix of input data, stores entire rows */
  outdata1 = matrix(1,ywin,1,width);	/* matrix of output data, stores entire rows */

  tmp = (float *)malloc(sizeof(float)*width);
  if (tmp == NULL){fprintf(stderr,"ERROR: memory allocation failure of single line tmp buffer...\n"); exit(-1);}


/***** the main section of the code *****/

/* first set up the buffer with the first ypow2 rows of data */
/* upper left corner of very first window is the image coordinate 1,1 */

  for (i=ywinedgeU+1; i<=ypow2; i++){
     fread((char *)tmp, sizeof(float), width, infile1);
     for (j=1; j<=width; j++) buffer1[i][j]=tmp[j-1];
     if (feof(infile1)!=0){fprintf(stderr,"ERROR: window size is bigger than file: %s\n",argv[1]); exit(-1);}
  }


/* this is the big loop that goes through the entire buffer of floats line by line */ 

  for (i=1; i<=num_lines; i+=ywin){		/* i and j are the current IMAGE point, not BUFFER point */
     						/* they are the top left corner of the window (excluding edges)*/
     if ((i-1)%100==0)fprintf(stderr,"\rline, despike cnt: %6d %d",i,zerocnt);

     for (j=1; j<=width; j+=xwin){		/* THIS IS THE FILTERING SECTION */
	 pack_pad_float(buffer1,width,num_lines,floatvec1,xpow2,ypow2,i,j,
			xwin,ywin,xwinedgeL,xwinedgeR,ywinedgeU,ywinedgeD);

         current_value = floatvec1[ywinedgeU*xpow2+xwinedgeL+1];	/* floatvec is rearranged in mdian1, get current value now */

/*	 moment(floatvec1,xpow2*ypow2,&ave,&adev,&sdev,&var,&skew,&curt); */ /* use other statistics if necessary */
         mdian1(floatvec1,xpow2*ypow2,&xmed,zeroflag);			/* find the median */

         if (current_value > multiple*xmed) {
            assign_value(floatvec1,xpow2*ypow2,0.0);			/* zero the point if necessary */
            zerocnt++;
         }
         else assign_value(floatvec1,xpow2*ypow2,current_value);	/* floatvec was rearranged, assign correct point */

	 unpack_pad_float(outdata1,width,num_lines,floatvec1,xpow2,ypow2,i,j,
			xwin,ywin,xwinedgeL,xwinedgeR,ywinedgeU,ywinedgeD);

     } /* end of x */


     if(i+ywin-1 > num_lines) endny=ywin-((i-1+ywin)-num_lines);
     else endny=ywin;
     for (ii=1; ii<=endny; ii++){			/* WRITE OUT THE FILTERED DATA */
         for (j=1; j<=width; j++) tmp[j-1]=outdata1[ii][j];
         fwrite((char *)tmp, sizeof(float), width, outfile1);
	 linecnt++;
     }


     increment_buffer(buffer1,ywin,ypow2,width);	/* MOVE ROWS AT END OF BUFFER TO BEGINNING */


     for (ii=ypow2-ywin+1; ii<=ypow2; ii++){		/* READ IN NEW LINES OF DATA */
        fread((char *)tmp, sizeof(float), width, infile1);
        for (j=1; j<=width; j++) buffer1[ii][j]=tmp[j-1];
	if( feof(infile1)!=0 ) break;			/* break out of this loop */
     }


  } /* end of y */


  fprintf(stderr,"\nTotal Lines Written: %d\n",linecnt);
  fprintf(stderr,"Total Points Zeroed: %d\n",zerocnt);

  return (0);
}




