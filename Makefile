#compilers
NVCC = /usr/local/cuda-12.0/bin/nvcc
# /usr/local/cuda-12.0/bin/nvcc
GCC = /usr/bin/gcc
# /usr/bin/gcc
GENCODE_FLAGS = -gencode arch=compute_80,code=sm_80

NVCCVERSION = $(shell $(NVCC) --version | grep release | sed -n -E 's/.* ([0-9]+\.[0-9]+).*/\1/p')
GCC_BIN_DIR = $(shell dirname ${GCC})
GCCVERSION = $(shell ${GCC} --version | grep ^gcc | sed 's/^.* //g')

NVCC_FLAGS = -O3 -ccbin $(GCC_BIN_DIR) -m64 $(GENCODE_FLAGS)

CUDA_LIBS = -lcusparse -lcublas
LIBS =  -lineinfo $(CUDA_LIBS)

#options
OPTIONS = -Xcompiler -fopenmp-simd

REQUIRED_VERSION = 12.0

all: double half

double:
	$(NVCC) $(NVCC_FLAGS) src/main_f64.cu -o spmv_double  -D f64 $(OPTIONS) $(LIBS) 

half:
	$(NVCC) $(NVCC_FLAGS) src/main_f16.cu -o spmv_half $(OPTIONS) $(LIBS) 

clean:
	rm -rf spmv_double
	rm -rf spmv_half
