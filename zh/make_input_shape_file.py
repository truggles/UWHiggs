import ROOT
import os
from FinalStateAnalysis.MetaData.data_views import extract_sample, read_lumi

jobid = "2013-11-02-8TeV-v1-ZH"

def get_lumi(filename):
    sample_name = extract_sample(filename)
    lumi = read_lumi(
        os.path.join(
            'inputs',
            jobid,
            sample_name+".lumicalc.sum"
        )
    )
    return lumi


#jobid = "2013-07-17-8TeV-v1-ZH_light"
jobid = "2013-11-02-8TeV-v1-ZH"

#path = "/afs/hep.wisc.edu/cms/stephane/CMSSW_5_3_9/src/UWHiggs/zh/results/%s/ZHAnalyze" % jobid
path = "/afs/hep.wisc.edu/home/stephane/sync_setup/src/UWHiggs/zh/results/%s/ZHAnalyze" % jobid
#path = "/afs/hep.wisc.edu/cms/stephane/sync_setup/src/UWHiggs/zh/results/%s/ZHAnalyze" % jobid

label_map = { 'data' : 'data_obs',
              'WZJetsTo3LNu_pythia' : 'wz_mc',
              'ZZJetsTo4L_pythia' : 'ZZ',
              'Zjets_M50' : 'Zjets',
              'ggZZ2L2L' : 'GGToZZ2L2L',
              'TTplusJets_madgraph' : 'TTZ', 
              #'MSSM_A_ZH_FullSim' : 'signal'
            }

#lumi_map = { 'data_obs' : 33600/2,
#             'wz' : 760148,
#             'ZZ' : 6916175,
#             'Zjets' : 6500,
#             'GGToZZ2L2L' : 1,
#             'TTZ' : 30079,
#             'ZH_htt90' : 3035940,
#             'ZH_htt95' : 3354534,
#             'ZH_htt100' : 4187710, 
#             'ZH_htt105' : 4649040,
#             'ZH_htt110' : 5886157,
#             'ZH_htt115' : 6886610,
#             'ZH_htt120' : 8732105,
#             'ZH_htt125' : 11199643,
#             'ZH_htt130' : 13980929,
#             'ZH_htt135' : 20473241,
#             'ZH_htt140' : 28243507,
#             'ZH_htt145' : 42768759,
#             'ZH_htt150' : 75315442,
#             'ZH_htt155' : 136283748,
#             'ZH_htt160' : 99005845,
#             'ZH_hww110' : 45803935,
#             'ZH_hww120' : 20582363,
#             'ZH_hww130' : 12982150,
#             'ZH_hww140' : 8751285,
#
#        }
             
lumi_map = { 'data_obs' : 39425/2,
             'wz_mc' : get_lumi('WZJetsTo3LNu_pythia'),
             'ZZ' : get_lumi('ZZJetsTo4L_pythia'),
             'Zjets_mc' : get_lumi('Zjets_M50'),
             'GGToZZ2L2L' : get_lumi('ggZZ2L2L'),
             'TTZ' : get_lumi('TTplusJets_madgraph'),
             #'signal' : get_lumi('MSSM_A_ZH_FullSim'),
             'ZH_hww125' : 1.0,
        }

for mass in range(90, 160, 5):
    label_map['VH_H2Tau_M-%s' % mass] = 'ZH_htt%s' % mass
    lumi_map['ZH_htt%s' % mass] = get_lumi('VH_H2Tau_M-%s' % mass)

for mass in range(110, 140, 10):
    label_map['VH_%s_HWW' % mass] = 'ZH_hww%s' % mass
    lumi_map['ZH_hww%s' % mass] = get_lumi('VH_%s_HWW' % mass)
print label_map
default = "NULL"

official_input = ROOT.TFile("official_shapes.root")
output_file = ROOT.TFile("input_shapes.root", "RECREATE")

for channel, label in [("MMTT","t1_t2"), ("MMMT","m3_t"), ("MMET","e_t"), ("MMEM","e_m3"), ("EETT","t1_t2"), ("EEMT","m_t"), ("EEET","e3_t"), ("EEEM","e3_m")]:
#for channel, label in [ ("MMMT","m3_t"), ("MMET","e_t"), ("MMEM","e_m3"), ("EEMT","m_t"), ("EEET","e3_t"), ("EEEM","e3_m")]:

#for channel, label in [("MMMT", "m3_t")]:
    if (channel == "MMEM"):
        channel_label = "mmme_zh" 
    else:    channel_label = channel.lower() + "_zh" 
    output_file.mkdir(channel_label)
 
    label = "A" # this is A -> Zh now :) and I'm lazy...
    for root, dir, filenames in os.walk(path + channel):
        for fname in filenames:
            print fname
            input_file = ROOT.TFile(path + channel + "/" + fname, "r")
            #print path + channel + "/" + fname
            h = input_file.Get("os/All_Passed/%s_SVfitMass" % label)
            h.Rebin(15) 
            #h = input_file.Get("os/All_Passed/%s_Mass" % label)
            #h.Draw()
            o_label = label_map.get(fname[:(len(fname)-5)], default)
            #print channel_label + "/" + o_label 
            #h_official = official_input.Get(channel_label + "/" + o_label)
            #if not bool(h_official): continue
            #h_official.Draw()
            if (o_label == "NULL"): continue
            if (o_label == 'Zjets'): continue
            scale_factor = lumi_map['data_obs'] / lumi_map[o_label]
            print "scaling by scale factor: %s" % str(scale_factor)
            h.Scale(scale_factor)            

            # reducible background estimated via '1+2-0' fake rate method
            if (o_label == 'data_obs'):
                h_1 = input_file.Get("ss/Leg3Failed/leg3_weight/%s_SVfitMass" % label)
                h_1_shape = input_file.Get("ss/3_failed_red_shape/%s_SVfitMass" % label)
                # scale loosened red background shape to actual count
                h_1_shape.Scale( h_1.Integral() / h_1_shape.Integral() )
                h_2 = input_file.Get("ss/Leg4Failed/leg4_weight/%s_SVfitMass" % label)
                h_2_shape = input_file.Get("ss/4_failed_red_shape/%s_SVfitMass" % label)
                h_2_shape.Scale( h_2.Integral() / h_2_shape.Integral() )
                h_0 = input_file.Get("ss/Leg3Failed_Leg4Failed/all_weights_applied/%s_SVfitMass" % label)
                h_0_shape = input_file.Get("ss/3_failed_red_shape_4_failed_red_shape/%s_SVfitMass" % label)
                h_0_shape.Scale( h_0.Integral() / h_0_shape.Integral() )
                h_red_bckg = ROOT.TH1F(h_1_shape)
                h_red_bckg.Add(h_2_shape)
                h_red_bckg.Add(h_0_shape, -1)
                #h_red_bckg = ROOT.TH1F(h_1)
                #h_red_bckg.Add(h_2)
                #h_red_bckg.Add(h_0, -1)
                h_red_bckg.Rebin(20)
                output_file.cd(channel_label)
                h_red_bckg.Write('Zjets')                

            output_file.cd(channel_label)
            h.Write(o_label)

            #h_official.Write(o_label + "_official") 
        ## scale to mH=125 GeV expected yield
        file_120 = ROOT.TFile(path + channel + "/VH_120_HWW.root", "r") 
        h_125 = file_120.Get("os/All_Passed/%s_SVfitMass" % label)
        h_125.Scale(lumi_map['data_obs']/lumi_map['ZH_hww125']) # scale to 125
        output_file.cd(channel_label)
        h_125.Write('ZH_hww125')

output_file.Write()
output_file.Close()
 
