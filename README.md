Release #2, December 2016

This code implements various methods described in:

1. C. G. Bampis, P. Maragos and A. C. Bovik, "Graph-Driven Diffusion 
and Random Walk Schemes for Image Segmentation," in IEEE Transactions
on Image Processing, vol. 26, no. 1, pp. 35-50, Jan. 2017

2. C. Bampis and P. Maragos, "Unifying the random walker algorithm and
the SIR model for graph clustering and image segmentation", in Proc.
IEEE Int'l Conf. Image Processing (ICIP), Sept. 2015.

If you use this code, please consider citing these two works.

For any questions or comments, please contact Christos Bampis: cbampis@gmail.com

Currently, this code demonstrates the following functionalities:

a. apply a graph-based Random Walker (RW) and Normalized Random Walker (NRW)
on a given image

b. convert graph-based results to a pixel image

c. apply diffusion schemes

The following files are part of this release:

1. demo_nrw.m: demo script for nrw

2. Diffusion.m: script implementing RW, NRW and NLRW diffusion schemes

3. funcs: folder with functions

4. graph_analysis_toolbox_funcs: modified functions from Grady's Graph Analysis Toolbox:

http://cns.bu.edu/~lgrady/software.html

5. other_funcs: publicly available functions with supporting role

6. images: test images folder

7. seeds: test seeds folder

The demos folder contains video demos of diffusion.