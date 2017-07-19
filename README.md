# Slicer_LaplaceSolver
Code for Slicer module (via MATLAB bridge) that solves Laplace equation within a labelmap volume. Bounary conditions (ie. source and sink) are adjacent labels, to be specified by the user. 

Code was developed by Jessica Rodgers and Jordan DeKraker as part of UWO Slicer Project Week 2017 at Robarts Research Institute, http://wiki.imaging.robarts.ca/index.php/Main_Page

INSTALL INSTRUCTIONS
Open slicer and click Edit>Application Settings>Modules. There will be an arrow next to the 'Additional module paths' section, click it and then click 'Add' and specify the path to your download.

For easy visualization of outputs, run the following code in Slicer's Python Interactor:
add to path: import sys
sys.path.append('<specify full path to your Laplace Module download folder')
import laplaceutil
laplaceutil.rainbowize('<output file name>')
