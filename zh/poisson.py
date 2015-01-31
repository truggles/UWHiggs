import ROOT

y = ROOT.TMath.Poisson(1,.2465)
x = ROOT.TMath.Poisson(2,.1914)
z = ROOT.TMath.Poisson(3,.4355)
h = ROOT.TMath.Poisson(2,.3784)

i = ROOT.TMath.Poisson(8,1.2528)
j = ROOT.TMath.Poisson(8,2)
print "y = %f x = %f z = %f h = %f i = %f j = %f" % (y, x, z, h, i, j)
