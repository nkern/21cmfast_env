!#/bin/sh

## Env variables for 21cmFAST
export cppflags="-L/fftw_float/lib -I/fftw_float/include"
export ldflags="-L/gnu/gsl/lib -I/gnu/gsl/lib -I/gnu/gsl/include -L/fftw_float/lib -lgsl -lgslcblas -lfftw3f_omp -lfftw3f -lm"
export LD_LIBRARY_PATH="/gnu/gsl/lib"



