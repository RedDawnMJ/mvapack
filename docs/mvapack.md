## What is MVAPACK?
[MVAPACK](https://bionmr.unl.edu/mvapack.php) is a chemometric toolbox for NMR and GC/LC-MS metabolomics data processing. First introduced by [Bradley Worley and Robert Powers](https://doi.org/10.1021/cb4008937) and has grown to encompass full processing of Nuclear Magnetic Resonance (NMR) and Mass Spectrometry (MS) (As well as chromatography) type data. The software is written as a package for [GNU Octave](https://octave.org/) and encompasses over 336 functions made to automate data analysis with emphasis on simplifying manual inspection.

## Why MVAPACK?
MVAPACK stands for MultiVariate Analysis Package. This is key to the use of Octave which is a simple language to learn and has much support for linear algebra based algorithms. The use of multivariate regression techniques has been pivotal to metabolomics as a whole. Especially principle component analysis (PCA) which has become a nearly emblematic analysis approach of metabolomics. MVAPACK also provides partial least squares (PLS), orthogonal partial least squares (OPLS), linear discriminate analysis (LDA), random forest (RF), and support vector machine (SVM) algorithms. MVAPACK also provides multiple data loading functions to simplify the data analysis pipeline of multiple types of instrumental data.

## How can I get MVAPACK?
The software package can be installed through the Dockerfile found in this [git page](https://github.com/RedDawnMJ/mvapack) or octave installable tar files can be obtained by requesting through the [Powers Group website](https://bionmr.unl.edu/mvapack-form.php). MVAPACK is also being developed as a webserver with full GUI support and interactive processing workflow.

## There's More!
We have developed a synthetic dataset in mzML format for benchmarking metabolomics data processing software. We have a publication *(doi here when submitted)* demonstrating the use and capabilities of multiple software applications. That data is available throught the following link: *(link here after submission)*

We also have a standard mixture dataset *(link here after submission)* and biological dataset (M. Smegmatis) *(link here after submission)* that were used to test the LC-MS pipelines as well as benchmark the software applications as discussed above.

