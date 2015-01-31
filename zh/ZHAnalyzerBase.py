'''

Generic base class for ZH leptonic analysis.

ZH has three objects:
    obj1
    obj2
    obj3

Objects 1 & 2 must be SS in the signal region.   The OS region is kept as a
control.  The subclasses must define the following functions:

    self.preselection - includes loose preselection on objects and Z identification (MM or EE)
    slef.sign_cut - returns true for OS (signal), false for SS amo
    self.probe1_id
    self.probe2_id

    self.event_weight(row) - general corrections

    self.book_histos(folder) # books histograms in a given folder (region)
    self.fill_histos(histos, row, weight) # fill histograms in a given region

'''

from FinalStateAnalysis.PlotTools.MegaBase import MegaBase
import ROOT
import array
import os
import pprint
import baseSelections as selections

class ZHAnalyzerBase(MegaBase):
    def __init__(self, tree, outfile, wrapper, channel, **kwargs):
        super(ZHAnalyzerBase, self).__init__(tree, outfile, **kwargs)
        # Cython wrapper class must be passed
        self.tree = wrapper(tree)
        self.out = outfile
        jobid = os.environ['jobid']
        zdec  = self.Z_decay_products()
        ch    = (zdec[0][0]+zdec[1][0]).upper()+channel
        #fname = '/'.join(['results',jobid,'ZHAnalyze'+ch,'abdollah_events.txt'])
        ## if os.path.isfile(fname):
        ##     self.fileLog = open(fname,'a')
        ## else:
        ##     self.fileLog = open(fname,'w')
        self.histograms = {}
        self.channel = channel
        #Special histograms, data member so child classes can add to this keeping
        #light the filling part and still be flaxible using any weird variable you can build from the NTuple
        self.hfunc   = { #maps the name of non-trivial histograms to a function to get the proper value, the function must have two args (evt and weight). Used in fill_histos later
            'nTruePU' : lambda row, weight: row.nTruePU,
            'weight'  : lambda row, weight: weight,
            'Event_ID': lambda row, weight: array.array("f", [row.run, #THR - significant additions to tree
							      row.lumi,
							      int((row.evt)/10**5),
							      int((row.evt)%10**5),
							      getattr(row,'%s_%s_Pt' % self.Z_decay_products()),
							      getattr(row,'%s_%s_Eta' % self.Z_decay_products()),
							      getattr(row,'%s_%s_Phi' % self.Z_decay_products()),
							      getattr(row,'%s_%s_Mass' % self.Z_decay_products()),
							      getattr(row,'%s_%s_Pt' % self.H_decay_products()),
							      getattr(row,'%s_%s_Eta' % self.H_decay_products()),
							      getattr(row,'%s_%s_Phi' % self.H_decay_products()),
							      getattr(row,'%s_%s_Mass' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitPt' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitEta' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitPhi' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitMass' % self.H_decay_products()),
                                                              row.Mass,
                                                              self.getZHSVMass(row),
                                                              self.getZHSVMass_tesUp(row),
                                                              self.getZHSVMass_tesDown(row),
							      getattr(row,'%s_%s_SVfitMass' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitMass_tesUp' % self.H_decay_products()),
							      getattr(row,'%s_%s_SVfitMass_tesDown' % self.H_decay_products()),
							      row.eVetoZH,
							      row.muVetoZH,
							      row.tauVetoZH,
							      getattr(row,'%sPt' % self.H_decay_products()[0]),
							      getattr(row,'%sPt_tesUp' % self.H_decay_products()[0]),
							      getattr(row,'%sPt_tesDown' % self.H_decay_products()[0]),
							      getattr(row,'%sEta' % self.H_decay_products()[0]),
							      getattr(row,'%sMass' % self.H_decay_products()[0]),
							      getattr(row,'%sJetPt' % self.H_decay_products()[0]),
							      getattr(row,'%sPt' % self.H_decay_products()[1]),
							      getattr(row,'%sPt_tesUp' % self.H_decay_products()[1]),
							      getattr(row,'%sPt_tesDown' % self.H_decay_products()[1]),
							      getattr(row,'%sEta' % self.H_decay_products()[1]),
							      getattr(row,'%sMass' % self.H_decay_products()[1]),
							      getattr(row,'%sJetPt' % self.H_decay_products()[1]),
							      row.mva_metEt,
							      row.mva_metPhi,
							      row.pfMetEt,
							      row.pfMetPhi,
							      row.type1_pfMetEt,
							      row.jetCountZH,
							      row.muVetoZH4,
							      row.muTightCountZH,
							      row.muTightCountZH_0,
							      row.eTightCountZH,
							      row.eTightCountZH_0,
							      getattr(row,'%sMtToMET' % self.H_decay_products()[0]),
							      #getattr(row,'%sMissingHits' % self.H_decay_products()[0]),
							      ] ),}
        #print '__init__->self.channel %s' % self.channel
        self.eventSet = set() # to keep track of duplicate events
        
    ## def get_channel(self):
    ##     return 'LL'

    ## the 'isReal' methods were used for an alternative fake rate
    ## estimation method which was used for validation purposes (AN-13-187
    ## appendix)
    #@classmethod #staticmethod
    def leg4IsReal(self,row):
        plabel = self.H_decay_products()[1] # label of fourth leg 
        if 't' in plabel: # fourth leg is a tau
            return bool(getattr(row, '%sGenDecayMode' % plabel) >= 0)
        if 'e' in plabel: # electron
            return bool(abs(getattr(row, '%sGenPdgId' % plabel)) == 11)
        if 'm' in plabel: # muon 
            return bool(abs(getattr(row, '%sGenPdgId' % plabel)) == 13)
        return False         

    def leg3IsReal(self,row):
        plabel = self.H_decay_products()[0] # label of third leg 
        if 't' in plabel: # third leg is a tau
            return bool(getattr(row, '%sGenDecayMode' % plabel) >= 0)
        if 'e' in plabel: # electron
            return bool(abs(getattr(row, '%sGenPdgId' % plabel)) == 11)
        if 'm' in plabel: # muon 
            return bool(abs(getattr(row, '%sGenPdgId' % plabel)) == 13)
        return False

    ## Calculate the mass of the 4-vector sum of the SV-fitted di-tau system
    ## and the reconstructed Z boson (new for A -> Zh)
    def getZHSVMass(self, row):
        # Get pt, eta, phi, mass of sv-fitted di-tau system and build 4-vec
        sv_pt = getattr(row, "%s_%s_SVfitPt" % self.H_decay_products() )
        sv_eta = getattr(row, "%s_%s_SVfitEta" % self.H_decay_products() )
        sv_phi = getattr(row, "%s_%s_SVfitPhi" % self.H_decay_products() )
        sv_mass = getattr(row, "%s_%s_SVfitMass" % self.H_decay_products() )
        h_sv = ROOT.TLorentzVector() # Higgs candidate sv-reconstructed 4-vec
        h_sv.SetPtEtaPhiM(sv_pt, sv_eta, sv_phi, sv_mass)

        # Get pt, eta, phi, mass of Z candidate and build 4-vec
        Z_pt = getattr(row, "%s_%s_Pt" % self.Z_decay_products() )
        Z_eta = getattr(row, "%s_%s_Eta" % self.Z_decay_products() )
        Z_phi = getattr(row, "%s_%s_Phi" % self.Z_decay_products() )
        Z_mass = getattr(row, "%s_%s_Mass" % self.Z_decay_products() )
        Z = ROOT.TLorentzVector() # Z candidate 4-vec
        Z.SetPtEtaPhiM(Z_pt, Z_eta, Z_phi, Z_mass)
        
        A = Z + h_sv # pseudoscalar candidate 
        return A.M()

    # Calculate the Tau Energy Systematics adjusted A mass
    def getZHSVMass_tesDown(self, row):
        # Get pt, eta, phi, mass of sv-fitted di-tau system and build 4-vec
        sv_pt = getattr(row, "%s_%s_SVfitPt_tesDown" % self.H_decay_products() )
        sv_eta = getattr(row, "%s_%s_SVfitEta_tesDown" % self.H_decay_products() )
        sv_phi = getattr(row, "%s_%s_SVfitPhi_tesDown" % self.H_decay_products() )
        sv_mass = getattr(row, "%s_%s_SVfitMass_tesDown" % self.H_decay_products() )
        h_sv = ROOT.TLorentzVector() # Higgs candidate sv-reconstructed 4-vec
        h_sv.SetPtEtaPhiM(sv_pt, sv_eta, sv_phi, sv_mass)

        # Get pt, eta, phi, mass of Z candidate and build 4-vec
        Z_pt = getattr(row, "%s_%s_Pt" % self.Z_decay_products() )
        Z_eta = getattr(row, "%s_%s_Eta" % self.Z_decay_products() )
        Z_phi = getattr(row, "%s_%s_Phi" % self.Z_decay_products() )
        Z_mass = getattr(row, "%s_%s_Mass" % self.Z_decay_products() )
        Z = ROOT.TLorentzVector() # Z candidate 4-vec
        Z.SetPtEtaPhiM(Z_pt, Z_eta, Z_phi, Z_mass)
        
        A = Z + h_sv # pseudoscalar candidate 
        return A.M()

    # Calculate the Tau Energy Systematics adjusted A mass
    def getZHSVMass_tesUp(self, row):
        # Get pt, eta, phi, mass of sv-fitted di-tau system and build 4-vec
        sv_pt = getattr(row, "%s_%s_SVfitPt_tesUp" % self.H_decay_products() )
        sv_eta = getattr(row, "%s_%s_SVfitEta_tesUp" % self.H_decay_products() )
        sv_phi = getattr(row, "%s_%s_SVfitPhi_tesUp" % self.H_decay_products() )
        sv_mass = getattr(row, "%s_%s_SVfitMass_tesUp" % self.H_decay_products() )
        h_sv = ROOT.TLorentzVector() # Higgs candidate sv-reconstructed 4-vec
        h_sv.SetPtEtaPhiM(sv_pt, sv_eta, sv_phi, sv_mass)

        # Get pt, eta, phi, mass of Z candidate and build 4-vec
        Z_pt = getattr(row, "%s_%s_Pt" % self.Z_decay_products() )
        Z_eta = getattr(row, "%s_%s_Eta" % self.Z_decay_products() )
        Z_phi = getattr(row, "%s_%s_Phi" % self.Z_decay_products() )
        Z_mass = getattr(row, "%s_%s_Mass" % self.Z_decay_products() )
        Z = ROOT.TLorentzVector() # Z candidate 4-vec
        Z.SetPtEtaPhiM(Z_pt, Z_eta, Z_phi, Z_mass)
        
        A = Z + h_sv # pseudoscalar candidate 
        return A.M()

    def build_zh_folder_structure(self):
        # Build list of folders, and a mapping of
        # (sign, ob1, obj2, ...) => ('the/path', (weights))
        #folders = []
        channel  = self.channel
        flag_map = {}
        weightsAvail = [None, None, None, self.leg3_weight, self.leg4_weight]
        for sign in ['ss', 'os']:
             for failing_objs in [(), (3,), (4,), (3,4)]:
                region_label = '_'.join(['Leg%iFailed' % obj for obj in failing_objs]) if len(failing_objs) else 'All_Passed'
                if 0 in failing_objs:
                    region_label = 'All_Passed_Leg4Real'
                if 10 in failing_objs:
                    region_label = 'All_Passed_Leg3Real'
                flag_map[(sign,region_label)] = {
                    'selection' : {
                        self.sign_cut  : (sign == 'os'), 
                        self.tau1Selection : (not (3 in failing_objs) ),
                        self.tau2Selection : (not (4 in failing_objs) ),
                        },
                    'weights'   : [weightsAvail[i] for i in failing_objs if not (0 in failing_objs or 10 in failing_objs)] 
                    }

        # make special directory for reducible background shape
        # looser selections for the sake of
        # better statistics. These shapes will be normalized to the 1+2-0 yield.      
        region_label = 'All_Passed_red_shape'
        flag_map[('ss', region_label)] = {
            'selection' : {
                self.sign_cut : False, # same sign
                self.red_shape_cuts : True, 
             },
             'weights' : [ weightsAvail[i] for i in ()]
        }

      
        return flag_map

    def begin(self): 

        # Loop over regions, book histograms
        for folders, regionInfo in self.build_zh_folder_structure().iteritems():
            folder = "/".join(folders)
            self.book_histos(folder) # in subclass
            #if 'All_Passed' in folder: #if we are in the all passed region ONLY
            self.book(folder, "Event_ID","Event ID",'run:lumi:evt1:evt2:Z_Pt:Z_Eta:Z_Phi:Z_Mass:h_Pt:h_Eta:h_Phi:h_Mass:h_SVFitPt:h_SVFitEta:h_SVFitPhi:h_SVFitMass:A_VisMass:A_SVFitMass:A_SVFitMassTESUp:A_SVFitMassTESDown:SVFit_h_Mass:SVFit_h_Mass_tesUp:SVFit_h_Mass_tesDown:eVetoZH:muVetoZH:tauVetoZH:t1Pt:t1Pt_tesUp:t1Pt_tesDown:t1Eta:t1Mass:t1JetPt:t2Pt:t2Pt_tesUp:t2Pt_tesDown:t2Eta:t2Mass:t2JetPt:mva_metEt:mva_metPhi:pfMetEt:pfMetPhi:type1_pfMetEt:jetCountZH:muVetoZH4:muTightCountZH:muTightCountZH_0:eTightCountZH:eTightCountZH_0:tau1MtToMET', type=ROOT.TNtuple)
            # Each of the weight subfolders
            wToApply = regionInfo['weights']
            for w in wToApply:
                subf = "/".join([folder, w.__name__])
                self.book_histos(subf)
            if len(wToApply) > 1:
                subf = "/".join([folder, 'all_weights_applied'] )
                self.book_histos(subf)
            
    def process(self):
        # output text file with run:lumi:evt info for syncing purposes
        #sync_file = open("sync_file_%s.txt" % self.name, 'a')
  
        # For speed, map the result of the region cuts to a folder path
        # string using a dictionary
        cut_region_map = self.build_zh_folder_structure()
        id_functions = cut_region_map[ cut_region_map.keys()[0] ]['selection'].keys()
        id_functions.append(self.red_shape_cuts)
        # Reduce number of self lookups and get the derived functions here
        histos       = self.histograms
        preselection = self.preselection
        #id_functions = cut_region_map[ cut_region_map.keys()[0] ]['selection'].keys() 
        fill_histos  = self.fill_histos
        weight_func  = self.event_weight

        counter = 0
        for row in self.tree:
            ######################################################
            ##  SYNC W/ ABDOLLAH DEBUG PART
            ######################################################
            ## dbgRow = debugRow(row)
            ## zdec = self.Z_decay_products()
            ## hdec = self.H_decay_products()
            ## if (int(dbgRow.run),int(dbgRow.lumi),int(dbgRow.evt)) in abdollah.results[zdec[0][0]+zdec[1][0]+hdec[0][0]+hdec[1][0]]:
            ##     toprint = {
            ##         'channel'      : zdec[0][0]+zdec[1][0]+hdec[0][0]+hdec[1][0],
            ##         'ID'           : (int(dbgRow.run),int(dbgRow.lumi),int(dbgRow.evt)),
            ##         }
            
            ##     preval = preselection(dbgRow)
            ##     last   = dbgRow._lastCalledAttr
            ##     toprint['preselection'] = {
            ##         'status'    : preval,
            ##         'last_call' : last,
            ##         }
            ##     ## self.fileLog.write( "# Channel: %s \nRun: %i Lumi: %i Evt: %i\n" % (zdec[0][0]+zdec[1][0]+hdec[0][0]+hdec[1][0],int(dbgRow.run),int(dbgRow.lumi),int(dbgRow.evt)) )
            ##     ## self.fileLog.write( "# preselection: %s " %  ('PASSED' if preval else 'FAILED') )
            ##     ## self.fileLog.write( "due to last call %s : %s\n" % dbgRow._lastCalledAttr )
            ##     for func in cut_region_map[('os','All_Passed')]['selection']:
            ##         fname = func.__name__
            ##         fres  = func(dbgRow)
            ##         ## self.fileLog.write( "# %s: %s " % (fname, 'PASSED' if fres else 'FAILED' ) )                
            ##         ## self.fileLog.write( "due to last call %s : %s\n\n" % dbgRow._lastCalledAttr )
            ##         toprint[fname] = {
            ##             'status'    : fres,
            ##             'last_call' : dbgRow._lastCalledAttr,
            ##             }
            ##     ## self.fileLog.write( 'used_attrs = ' )
            ##     pprint.pprint( toprint, self.fileLog )
            ##     self.fileLog.write( ',\n\n' )
            ## else:
            ##     continue
            ## Check why some of his events don't pass 
            ## zdec = self.Z_decay_products()
            ## hdec = self.H_decay_products()
            ## channel = zdec[0][0]+zdec[1][0]+hdec[0][0]+hdec[1][0]
            ## debug.output_file = self.fileLog
            ## if (int(row.run),int(row.lumi),int(row.evt)) in debug.to_inspect[channel]:
            ##     debug.debug_channel(row, channel, hdec)
            ## else:
            ##     continue
            ######################################################
            ##  END SYNC W/ ABDOLLAH DEBUG PART
            ######################################################

            ######################################################
            ##  TRIG MATCH DEBUG
            ######################################################
            ## counter = 0
            ## if hasattr(row, 'doubleEPass') and hasattr(row, 'e1MatchesDoubleEPath'):
            ##     if row.doubleEPass and (not bool(row.e1MatchesDoubleEPath)) and counter < 10:
            ##         print 'Event passes doubleE trigger selection, but no matching found! Match output %i' % row.e1MatchesDoubleEPath
            ##         counter += 1
                
            ######################################################
            ##  END TRIG MATCH DEBUG
            ######################################################
            
            # Apply basic preselection
            #if not (preselection(row) :
                #print "Event " + str(row.evt) + " failed preselection for row " + str(row)
            #    continue
            #if not selections.is2l2tauANPassed(row):
            #    continue
            #counter += 1
            #print "passed preselection!"
            #if counter < 200: print "passed preselection!"
            #map id results
            
            row_id_map = dict( [ (f, f( row) )  for f in id_functions] )

            # Get the generic event weight
            event_weight = weight_func(row)
            #event_weight = 1.0 # quick hack FIXMEE!!!

            # Figure out which folder/region we are in, multiple regions allowed
            for folder, region_info in cut_region_map.iteritems():
                if not (preselection(row)):
                    continue
                #if row.evt == 306250:
                #  if folder[1]=='All_Passed':
                #    print "analyzing event 306250"
                ##    print row.t1Pt, row.t2Pt
                #    print int((row.evt)/10**5),int((row.evt)%10**5)
                #if not preselection(row):
                #  if folder[1]=='All_Passed': 
                #    print "event %f failed preselection" % row.evt
                #    print row.t1Pt, row.t2Pt
                #  continue
           
                selection = region_info['selection']
                #if counter < 200:
                #print [ (row_id_map[f] == res) for f, res in selection.iteritems() if res is not None], all( [ (row_id_map[f] == res) for f, res in selection.iteritems() if res is not None] )

                if all( [ (row_id_map[f] == res) for f, res in selection.iteritems() if res is not None] ): #all cuts match the one of the region, None means the cut is not needed
                                                                                                            #if counter < 200: print "region found!: ",folder                   
                    if folder[1] == 'All_Passed_Leg4Real' and not self.leg4IsReal(row): continue
                    if folder[1] == 'All_Passed_Leg3Real' and not self.leg3IsReal(row): continue

                    #if folder[0]=='os' and folder[1] == 'All_Passed' and row.evt == 306250:
                    #  print "event 306250 passed full selections"
                    #  print
                    #else: continue 
                    ## add fully passed events to sync file
                    #if folder[1] == 'All_Passed':
                    #    hmass = round(getattr(row, "%s_%s_SVfitMass" % self.H_decay_products()), 1) # should switch to SVfitMas when ready
                    #    hmass_visible = round(getattr(row, "%s_%s_Mass" % self.H_decay_products()), 1)
                    #    #zmass = round(getattr(row, "%s_%s_Mass" % self.Z_decay_products()), 1)
                    #    sync_info = str(self.name) + ' ' + str(row.run) + ' ' + str(row.lumi) + ' ' + str(row.evt) + ' '+ str(hmass_visible) + ' ' + str(hmass) + '\n'
                    #    sync_file.write(sync_info)
                    #    #print "sync_info: " + sync_info


 
                    # make sure we don't have any duplicates
                    # Doesn't work, this currently eliminates duplicates before all selection has happened and thus throws away good events.
                    eventTuple = (row.run, row.lumi, row.evt, folder[0], folder[1] )
                    #if ( (folder[0] == 'os') and (folder[1] == 'All_Passed')): 
                    #    if ((eventTuple in self.eventSet) and not ('red_shape' in folder[1] )):
                    if (eventTuple in self.eventSet and not ('red_shape' in folder[1]) ):
                           #print "found a duplicate event: %i run: %i lumi: %i ZMass: %f Sign: %s Folder Cut: %s" % (row.evt, row.run, row.lumi, getattr(row,'%s_%s_Mass' % self.Z_decay_products()), folder[0], folder[1])
                           continue # we've already put this event in this category!
                    # not a duplicate in signal region
                    self.eventSet.add(eventTuple)
                     
                    fill_histos(histos, folder, row, event_weight)
                    wToApply = [ (w, w(row) )  for w in region_info['weights'] ]
                    #print "folder: %s, event_weight: %f, event: %i_____________________" % (folder, event_weight, row.evt)
                    #print "folder[0]: %s, folder[1]: %s, event_weight: %f, event: %i_____________________" % (folder[0], folder[1], event_weight, row.evt)
                    for w_fcn, w_val in wToApply:
                        #if w_val > 1. :
                            #print 'obj1_weight: %s' % w_val
                        fill_histos(histos, folder+(w_fcn.__name__,), row, event_weight*w_val)
                    if len(wToApply) > 1:
                        w_prod = reduce(lambda x, y: x*y, [x for y,x in wToApply])
                        fill_histos(histos, folder+('all_weights_applied',), row, event_weight*w_prod)
        #sync_file.close()

    def book_general_histos(self, folder):
        '''Book general histogram, valid for each analyzer'''
        self.book(folder, "nTruePU", "NPU", 62, -1.5, 60.5)
        self.book(folder, "weight", "Event weight", 100, 0, 5)
        #self.book(folder, "weight_nopu", "Event weight without PU", 100, 0, 5)
        self.book(folder, "rho", "Fastjet #rho", 100, 0, 25)
        self.book(folder, "nvtx", "Number of vertices", 31, -0.5, 30.5)
        self.book(folder, "Mass", "A Candidate Mass", 800, 0, 800)
        self.book(folder, "LT_Higgs", "scalar PT sum of Higgs candidate legs", 200, 0, 200)
        self.book(folder, "A_SVfitMass", "A candidate reconstructed sv Mass", 800, 0, 800)
        self.book(folder, "A_SVfitMass_tesDown", "A candidate reconstructed sv Mass TES Down", 800, 0, 800)
        self.book(folder, "A_SVfitMass_tesUp", "A candidate reconstructed sv Mass TES Up", 800, 0, 800)
        self.book(folder, "mva_metEt", "MVA MET", 300, 0, 300)
        self.book(folder, "mva_metPhi", "MVA MET PHI", 70, -3.5, 3.5) 
        return None

    def book_kin_histos(self, folder, Id):
        '''books pt/jetPt/absEta for any object'''
        IdToName = {'m' : 'Muon', 'e' : 'Electron', 't' : 'Tau'}
        number   = Id[1] if len(Id) == 2 else ''
        self.book(folder, "%sPt" % Id,     "%s %s Pt" % (IdToName[Id[0]], number),     300, 0, 300)
        self.book(folder, "%sJetPt" % Id,  "%s %s Jet Pt" % (IdToName[Id[0]], number), 200, 0, 200)
        self.book(folder, "%sAbsEta" % Id, "%s %s AbsEta" % (IdToName[Id[0]], number), 100, 0, 2.4)
        self.book(folder, "%sEta" % Id, "%s %s Eta" % (IdToName[Id[0]], number), 200, -2.4, 2.4)
        return None      
    def book_mass_histos(self, folder, *args):
        
        IdToName = {'m' : 'Muon', 'e' : 'Electron', 't' : 'Tau'}
        def get_name(Id):
            number  = Id[1] if len(Id) == 2 else ''
            name = IdToName[Id[0]]
            return (name, number)
        for pos, obj1 in enumerate(args):
            for obj2 in args[pos+1:]:
                self.book(folder, "%s_%s_Mass" % (obj1, obj2), "%s %s - %s %s Mass" % (get_name(obj1) + get_name(obj2) ), 150, 0, 150)

        #self.book(folder, "Mass", "ZH Mass", 200, 0, 200)
        self.book(folder, "%s_%s_SVfitMass" % self.H_decay_products(), "H candidate SVMass", 300, 0, 300)

    def book_resonance_histos(self, folder, products, name):
        self.book(folder, "%s_%s_Pt"     % products, "%s candidate Pt"              % name, 300, 0, 300)
        self.book(folder, "%s_%s_Eta" % products, "%s candidate Eta"          % name, 100, -2.4, 2.4)
        #self.book(folder, "%s_%s_SVfitMass"   % products, "%s candidate SVfit Mass"            % name, 10, 0, 150)
        self.book(folder, "%s_%s_Mass"   % products, "%s candidate Mass"            % name, 300, 0, 300)
        self.book(folder, "%s_%s_DR"     % products, "%s decay products #DeltaR"    % name, 100, 0, 10)
        self.book(folder, "%s_%s_DPhi"   % products, "%s decay products #Delta#phi" % name, 180, 0, 7)

    def book_Z_histos(self, folder):
        self.book_resonance_histos(folder, self.Z_decay_products(), 'Z')

    def book_H_histos(self, folder):
        self.book_resonance_histos(folder, self.H_decay_products(), 'H')
        self.book(folder, "%s_%s_SVfitMass"   % self.H_decay_products(), "H candidate SVfit Mass", 300, 0, 300)
        self.book(folder, "%s_%s_SVfitMass_tesUp"   % self.H_decay_products(), "H candidate SVfit Mass TES up", 300, 0, 300)
        self.book(folder, "%s_%s_SVfitMass_tesDown"   % self.H_decay_products(), "H candidate SVfit Mass TES down", 300, 0, 300)
            
    def fill_histos(self, histos, folder, row, weight):
        '''fills histograms'''
        #find all keys mathing
        folder_str = '/'.join(folder + ('',))
        for key, value in histos.iteritems():
            #print "Key: %s Value: %s" % (key, value)
            location = key[ : key.rfind('/')]+'/'
            if folder_str != location:
                continue
            attr = key[ key.rfind('/') + 1 :]

            # Always fill SV Mass tesUp (because our cuts are now based on loose/tightTauSelectionTESUp)
            if attr == 'A_SVfitMass_tesUp':
                value.Fill( self.getZHSVMass_tesDown(row), weight )

            # Check if NORMAL Hadronic Tau Pt > 21
            toFillNorm = True
            if self.H_decay_products()[0] == 't' or self.H_decay_products()[0] == 't1':
              if getattr(row,'%sPt' % self.H_decay_products()[0]) < 21: toFillNorm = False
            if self.H_decay_products()[1] == 't' or self.H_decay_products()[1] == 't2':
              if getattr(row,'%sPt' % self.H_decay_products()[1]) < 21: toFillNorm = False
            if toFillNorm == True:

                if attr in self.hfunc:
                    value.Fill(
                        self.hfunc[attr](row, weight)
                        )
                elif attr == 'kinematicDiscriminant1':
                    # special case - move me to hfunc, eventually
                    pt_ZH = row.Pt
                    pt_Z = getattr(row, "%s_%s_Pt" % self.Z_decay_products())
                    pt_H = getattr(row, "%s_%s_Pt" % self.H_decay_products())
                    value.Fill(pt_ZH / (pt_Z + pt_H), weight)
                elif attr == 'kinematicDiscriminant2':
                    pt_H = getattr(row, "%s_%s_Pt" % self.H_decay_products())
                    pt_Tau1 = getattr(row, "%sPt" % self.H_decay_products()[0]) 
                    pt_Tau2 = getattr(row, "%sPt" % self.H_decay_products()[1])
                    value.Fill(pt_H / (pt_Tau1 + pt_Tau2), weight)
                elif attr == 'LT_Higgs':
                    pt_Tau1 = getattr(row, "%sPt" % self.H_decay_products()[0])
                    pt_Tau2 = getattr(row, "%sPt" % self.H_decay_products()[1])
                    value.Fill(pt_Tau1 + pt_Tau2, weight)
                elif attr == 'A_SVfitMass':
                    value.Fill( self.getZHSVMass(row), weight )

                # Make sure that for low Pt taus, who drop below the 20 GeV cut off, we don't fill the Histo
                elif attr == 'A_SVfitMass_tesDown':
                  toFillTESDown = True
                  if self.H_decay_products()[0] == 't' or self.H_decay_products()[0] == 't1':
                    if getattr(row,'%sPt_tesDown' % self.H_decay_products()[0]) < 21: toFillTESDown = False
                  if self.H_decay_products()[1] == 't' or self.H_decay_products()[1] == 't2':
                    if getattr(row,'%sPt_tesDown' % self.H_decay_products()[1]) < 21: toFillTESDown = False
                  if toFillTESDown == True:
                    value.Fill( self.getZHSVMass_tesUp(row), weight )

                # This is because the new "If" string wants to iterate over A_SVFitMass_tesUp
                elif attr == 'A_SVfitMass_tesUp': pass
                else:
                    # general case, we can just do getattr(row, "variable") i.e. row.variable
                    value.Fill( getattr(row,attr), weight )
        return None

    def finish(self):
        self.write_histos()

if __name__ == "__main__":
    import pprint
    pprint.pprint(ZHAnalyzerBase.build_zh_folder_structure())
