import sys

#region_map = ['EFakeRateZET', 'MUFakeRateZMT', 'TauFakeRatesZLT', 'TauFakeRatesZTT']
region_map = ['TauFakeRatesZLT']

for region in region_map:
  ifile = open("%s.txt" % region, 'r')
  print region
 
  evtIDs0 = [] # list of all unique event id's in the file
  evtIDs1 = [] # list of all unique event id's in the file
  evtIDs2 = [] # list of all unique event id's in the file
  evtIDs10 = [] # list of all unique event id's in the file
  evtIDs11 = [] # list of all unique event id's in the file
  evtIDs12 = [] # list of all unique event id's in the file
  evtIDs20 = [] # list of all unique event id's in the file
  evtIDs21 = [] # list of all unique event id's in the file
  evtIDs22 = [] # list of all unique event id's in the file
  #dups = {0:0, 1:0, 2:0 ,10:0, 11:0, 12:0, 20:0, 21:0, 22:0}
  dups0=0
  dups1=0
  dups2=0
  dups10=0
  dups11=0
  dups12=0
  dups20=0
  dups21=0
  dups22=0


  #(0, 0, 0, 0, 0, 0, 0, 0, 0) # 1 for each denom / num region
  
  for line in ifile:
      line = line.strip()
      info = line.split(' ')
      numDenom = info[0]
      tauCode = info[1]
      run = info[2]
      lumi = info[3]
      evtID = info[4]
      zMass = info[5]
      t1Pt = info[6]
      t1Eta = info[7]
      t1MtToMET = info[8]
      t2Pt = info[9]
      t2Eta = info[10]
      #tuple = (channel, run, lumi, evtID)
      tuple = (numDenom, run, lumi, evtID, tauCode)
      #print (channel, run, lumi, evtID)
      #pTuple =(numDenom, run, lumi, evtID, t1Pt, t1Eta, t2Pt, t2Eta, zMass)
  
      if not tuple in eval("evtIDs%s" % numDenom):
          eval("evtIDs%s.append(tuple)" % numDenom)
      elif int(numDenom) == 0:
          dups0 += 1
          print "run: %s, lumi: %s, evtId: %s" % (run, lumi, evtID)
      elif int(numDenom) == 1:
          dups1 += 1
      elif int(numDenom) == 2:
          dups2 += 1
      elif int(numDenom) == 10:
          dups10 += 1
      elif int(numDenom) == 11:
          dups11 += 1
      elif int(numDenom) == 12:
          dups12 += 1
      elif int(numDenom) == 20:
          dups20 += 1
      elif int(numDenom) == 21:
          dups21 += 1
      elif int(numDenom) == 22:
          dups22 += 1
          #eval("dups%s = dups%s + int(1)" % (numDenom, numDenom) )
          #count = dups[int(numDenom)]
          #dups[numDenom] = count + 1
          #print "%s,%s,%s,%s,%s,%s,%s,%s,%s" % (pTuple[0],pTuple[1],pTuple[2],pTuple[3],pTuple[4],pTuple[5],pTuple[6],pTuple[7],pTuple[8]) # comma delimited, for excel pasting 
  #print "Dups listed by NumDenomCode --- 0=%i : 1=%i : 2=%i : 10=%i, 11=%i : 12=%i, 20=%i : 21=%i, 22=%i" % (dups[0], dups[1], dups[2], dups[10], dups[11], dups[12], dups[20], dups[21], dups[22])
  print "Dups listed by NumDenomCode --- 0=%i : 1=%i : 2=%i : 10=%i, 11=%i : 12=%i, 20=%i : 21=%i, 22=%i" % (dups0, dups1, dups2, dups10, dups11, dups12, dups20, dups21, dups22)




#  print "%i duplicates out of %i unique events" % (dups, len(evtIDs))
