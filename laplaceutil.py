import slicer

# add to path: import sys
# sys.path.append('C:\Users\jrodgers\Documents\LaplaceModule')
# import laplaceutil

def rainbowize(labelname):
  mapNode = slicer.util.getNode(labelname)
  mapDisplayNode = mapNode.GetDisplayNode()
  mapDisplayNode.SetAndObserveColorNodeID('vtkMRMLColorTableNodeFullRainbow')
  mapDisplayNode.AutoThresholdOff()
  mapDisplayNode.SetThreshold(0.000001,1)
  mapDisplayNode.ApplyThresholdOn()