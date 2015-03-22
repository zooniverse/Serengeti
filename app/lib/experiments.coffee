$ = require('jqueryify')
User = require 'zooniverse/lib/models/user'
Subject = require 'models/subject'
AnalyticsLogger = require 'lib/analytics'

# CONSTANTS #

###
Define the active experiment here by using a string which exists in http://experiments.zooniverse.org/active_experiments
If no experiments should be running right now, set this to null, false or ""
###
ACTIVE_EXPERIMENT = "SerengetiInterestingAnimalsExperiment1"

###
When an error is encountered from the experiment server, this is the period, in milliseconds, that the code below will
  wait before any further attempts to contact it.
###
RETRY_INTERVAL = 300000 # (5 minutes) #

###
This determines how many random subjects will be served for every inserted image. For example, a value of 3 means that
  for every inserted subject, there will be three random subjects
###
INSERTION_RATIO = 3

###
Until the experiment server supports user profile storage, the profiles will be hardcoded here for demo purposes.
###
SPECIES_INTEREST_PROFILES = {
  "1821039": ['giraffe','lionmale','lionfemale'] # alexbfree (interesting)
  "1928567": ['giraffe','lionmale','lionfemale'] # alexzootest1 (interesting)
  "1928568": ['leopard','baboon'] # alexzootest2 (interesting)
  "1928569": ['zebra','gazellethomsons'] # alexzootest3 (control)
  "1928585": ['hippopotamus'] # alexzootest17 (control)
}

###
set up pools of subjects that are known to contain each species, for those species with at least 20 subjects
###
SPECIES_SUBJECTS = {
  'blank': ['ASG00178ar', 'ASG00044qq', 'ASG0016uga', 'ASG001elxa', 'ASG00017gl', 'ASG00130v2', 'ASG0004oli',
            'ASG000bb5m', 'ASG000yd00', 'ASG0008on6', 'ASG0004ss1', 'ASG0016z63', 'ASG000do14', 'ASG0004hr1',
            'ASG000yve1', 'ASG0005y9y', 'ASG00186uy', 'ASG000fevn', 'ASG0008juj', 'ASG0000f5g'],
  'aardvark': ['ASG0007be4', 'ASG000qtjm', 'ASG0004oot', 'ASG000suxl', 'ASG0001yyo', 'ASG000z8nm', 'ASG0008oeb',
               'ASG0018wyj', 'ASG000rstl', 'ASG000eds0', 'ASG000mzxw', 'ASG000nsk6', 'ASG000oyhk', 'ASG000f0vr',
               'ASG0004om0', 'ASG0018vhk', 'ASG0008pqv', 'ASG000d4ke', 'ASG0012f4t', 'ASG0005q19'],
  'aardwolf': ['ASG0001m7p', 'ASG000ckdq', 'ASG0013pie', 'ASG000sxc7', 'ASG000290o', 'ASG000cryh', 'ASG0013xkk',
               'ASG0009jw4', 'ASG00069cc', 'ASG00061ef', 'ASG0006gdj', 'ASG00052yb', 'ASG0006ho8', 'ASG000syj0',
               'ASG0002uji', 'ASG00055s1', 'ASG0019h36', 'ASG00168hd', 'ASG000eix3', 'ASG000tgdt'],
  'baboon': ['ASG001aoqg', 'ASG000rbfg', 'ASG0007w1r', 'ASG00004jx', 'ASG000qqsx', 'ASG0002fg8', 'ASG000n1sc',
             'ASG000rbfh', 'ASG0017db1', 'ASG000da05', 'ASG0005iie', 'ASG000ol0a', 'ASG00106p2', 'ASG001817b',
             'ASG0003y6w', 'ASG000cccm', 'ASG000rrqm', 'ASG0011q27', 'ASG000zsqy', 'ASG001drv3'],
  'batearedfox': ['ASG0005k62', 'ASG00018f3', 'ASG0001cp3', 'ASG00046kz', 'ASG0001i6w', 'ASG0018yoy', 'ASG00017ck',
                  'ASG0019ly7', 'ASG00031xg', 'ASG0001e67', 'ASG0006wd6', 'ASG0014zvn', 'ASG0003t0t', 'ASG0001und',
                  'ASG000yqi1', 'ASG000e9sd', 'ASG0019kl5', 'ASG000yqgk', 'ASG0002kby', 'ASG0002bvz'],
  'buffalo': ['ASG000ats0', 'ASG000znea', 'ASG0004q0i', 'ASG001cvv4', 'ASG000f1t9', 'ASG000nohz', 'ASG0019gw3',
              'ASG000pncl', 'ASG00193ip', 'ASG000oege', 'ASG000qqng', 'ASG000bnnl', 'ASG000z87t', 'ASG0001ocb',
              'ASG000dzdd', 'ASG000teze', 'ASG000qzh1', 'ASG000f221', 'ASG000cphd', 'ASG000mys5'],
  'bushbuck': ['ASG000995j', 'ASG000pndr', 'ASG000bw5f', 'ASG000bvvg', 'ASG0008122', 'ASG0009izf', 'ASG000bw9n',
               'ASG000zfdy', 'ASG0010d19', 'ASG0008055', 'ASG000yq4o', 'ASG0011ebz', 'ASG0010d0s', 'ASG0004z1b',
               'ASG000q078', 'ASG00193ae', 'ASG000bw1q', 'ASG000zff4', 'ASG0004yjz', 'ASG0009ve5'],
  'caracal': ['ASG00112pl', 'ASG0001v9a', 'ASG000atgt', 'ASG0007tii', 'ASG0006skj', 'ASG0012dpt', 'ASG00112pt',
              'ASG00112pz', 'ASG00112pk', 'ASG0005row', 'ASG0007tj2', 'ASG0008vi2', 'ASG00112q2', 'ASG000256y',
              'ASG00022uv', 'ASG0012wjq', 'ASG0006zz3', 'ASG0008o8n', 'ASG000eixu', 'ASG0000f0k'],
  'cheetah': ['ASG000d7h8', 'ASG0005n1e', 'ASG0005mw4', 'ASG000d7sr', 'ASG0013j75', 'ASG000d4v8', 'ASG0013jdm',
              'ASG00185cb', 'ASG0013yya', 'ASG0005lub', 'ASG00047kl', 'ASG0017bth', 'ASG001858x', 'ASG000qptg',
              'ASG000o110', 'ASG000owfa', 'ASG000zwoz', 'ASG0012fda', 'ASG000101z', 'ASG000fi78'],
  'civet': ['ASG0018ksr', 'ASG00051b1', 'ASG00190p3', 'ASG0019aa1', 'ASG000nfr7', 'ASG000d42v', 'ASG0018kr1',
            'ASG00003eq', 'ASG000y44e', 'ASG000ze11', 'ASG0008u5u', 'ASG000yk10', 'ASG000r0dd', 'ASG0004oib',
            'ASG0009hn1', 'ASG0018jm1', 'ASG0018js2', 'ASG0018mp8', 'ASG0018mn5', 'ASG0005q1l'],
  'dikdik': ['ASG0012539', 'ASG0005u7f', 'ASG001aray', 'ASG0008k1f', 'ASG000yqpn', 'ASG0007bgo', 'ASG000sijt',
             'ASG000bxqj', 'ASG0001wf9', 'ASG000002y', 'ASG000pndz', 'ASG0002fh6', 'ASG0016arc', 'ASG000bvv1',
             'ASG0000udv', 'ASG000bwej', 'ASG000yqir', 'ASG000po04', 'ASG0003us6', 'ASG0003heg'],
  'duiker': ['ASG001e05e', 'ASG0018tv6', 'ASG0018ovm', 'ASG0019cqr', 'ASG0018knb', 'ASG0019cdi', 'ASG0018mao',
             'ASG00196iy', 'ASG00193c2', 'ASG0018wzc', 'ASG0018q9o', 'ASG0018qa2', 'ASG001938w', 'ASG0018mjy',
             'ASG0018kot', 'ASG0019f3o', 'ASG00194wq', 'ASG0018m3j', 'ASG0018q99', 'ASG001blb2'],
  'eland': ['ASG001d44h', 'ASG0008fuj', 'ASG001d45l', 'ASG001cmsh', 'ASG00076mt', 'ASG0012e30', 'ASG0011bvk',
            'ASG0006oeq', 'ASG0011qwf', 'ASG000tjq9', 'ASG0007178', 'ASG0007j4a', 'ASG000shln', 'ASG001e7s7',
            'ASG0006smp', 'ASG0006gn9', 'ASG0012e4o', 'ASG001a44b', 'ASG0006gn8', 'ASG001d3yo'],
  'elephant': ['ASG0013fvc', 'ASG000crr3', 'ASG00184us', 'ASG0012obv', 'ASG000nex2', 'ASG00000cy', 'ASG000ney0',
               'ASG0013zhf', 'ASG00101rd', 'ASG000s9tt', 'ASG0002fny', 'ASG000eqdy', 'ASG001f5vu', 'ASG0012ahu',
               'ASG000mzii', 'ASG001b6m8', 'ASG000yjeb', 'ASG000pwem', 'ASG000a8wu', 'ASG000znni'],
  'gazellegrants': ['ASG0002zz5', 'ASG0006sld', 'ASG0014ul2', 'ASG000thrw', 'ASG000rqok', 'ASG0012isx', 'ASG0012p4u',
                    'ASG0004sny', 'ASG0014ndg', 'ASG001470k', 'ASG000zczf', 'ASG000r0jb', 'ASG0014lbh', 'ASG00147cf',
                    'ASG0014718', 'ASG000rro5', 'ASG001825f', 'ASG0008lep', 'ASG000f1bm', 'ASG0002iu8'],
  'gazellethomsons': ['ASG000ouzl', 'ASG0008hlo', 'ASG0016ros', 'ASG000ow05', 'ASG000mv86', 'ASG001bhig',
                      'ASG0016ms2',
                      'ASG00151kl', 'ASG000ntsp', 'ASG0004fm9', 'ASG00029mm', 'ASG0019b87', 'ASG00056lm',
                      'ASG0004tkz',
                      'ASG0002iy1', 'ASG0002dl6', 'ASG0013j6a', 'ASG000cqme', 'ASG000qsu3', 'ASG0012cn9'],
  'genet': ['ASG0015jt1', 'ASG00190s5', 'ASG0003s1f', 'ASG0002fih', 'ASG0004cs4', 'ASG0004bx9', 'ASG0006dqd',
            'ASG0008jm8', 'ASG00016ly', 'ASG0002fis', 'ASG0019h7p', 'ASG0005oqz', 'ASG00190u9', 'ASG0008auq',
            'ASG00003g4', 'ASG0000aho', 'ASG0007409', 'ASG00173ha', 'ASG0018wht', 'ASG00190vg'],
  'giraffe': ['ASG0008tqq', 'ASG000pa6q', 'ASG000e99e', 'ASG001b0i6', 'ASG0019ee3', 'ASG0001d4l', 'ASG0009nkz',
              'ASG000rdrj', 'ASG0009prx', 'ASG0017407', 'ASG000tadm', 'ASG000eenb', 'ASG001brb0', 'ASG001f9ds',
              'ASG0013sul', 'ASG000y46i', 'ASG00089mc', 'ASG000pngo', 'ASG0017wby', 'ASG000qin4'],
  'guineafowl': ['ASG00066dz', 'ASG0005cjs', 'ASG000qpi0', 'ASG0003wfn', 'ASG00041i0', 'ASG000ztgd', 'ASG0007e37',
                 'ASG000zigd', 'ASG00088xr', 'ASG000r6jl', 'ASG0001wk9', 'ASG00060jm', 'ASG001e7sv', 'ASG0001a74',
                 'ASG001eruj', 'ASG0010mm9', 'ASG0000unr', 'ASG000o65g', 'ASG00060dg', 'ASG000r0s1'],
  'hare': ['ASG0003q3e', 'ASG0005cpg', 'ASG00060wx', 'ASG0018rcb', 'ASG0004co0', 'ASG0018kgw', 'ASG0001ka2',
           'ASG0003szc', 'ASG0001yje', 'ASG00040vu', 'ASG00021aj', 'ASG000n0c9', 'ASG0003v3r', 'ASG0018lg9',
           'ASG0002bvj', 'ASG0000fjc', 'ASG00002dp', 'ASG0003hry', 'ASG0001hdx', 'ASG0001wrz'],
  'hartebeest': ['ASG000tesz', 'ASG000cp27', 'ASG0007whh', 'ASG000cpy2', 'ASG000zo2i', 'ASG0007cjr', 'ASG000cp4n',
                 'ASG0004y77', 'ASG000oayo', 'ASG001812g', 'ASG000cox5', 'ASG000tsn3', 'ASG000cobb', 'ASG00024tq',
                 'ASG000dvj4', 'ASG0014fc1', 'ASG00124xa', 'ASG0003xl4', 'ASG000cou8', 'ASG000suln'],
  'hippopotamus': ['ASG0007xwo', 'ASG000ysm7', 'ASG000ygub', 'ASG000ebyx', 'ASG0004d2b', 'ASG000ohwm', 'ASG0004441',
                   'ASG00098u1', 'ASG000ciuo', 'ASG000yguu', 'ASG000npw9', 'ASG0018m59', 'ASG000ntwi', 'ASG00167l4',
                   'ASG000yh6b', 'ASG0004ug7', 'ASG0007yd1', 'ASG000diqn', 'ASG0007yc5', 'ASG0019h1x'],
  'honeybadger': ['ASG00007mn', 'ASG0015ga1', 'ASG0002hk3', 'ASG0001wl4', 'ASG000a8r4', 'ASG0006dx1', 'ASG001co18',
                  'ASG0011rxb', 'ASG0013cd6', 'ASG0007l5n', 'ASG0002dip', 'ASG0005uhh', 'ASG00038tl', 'ASG0012ajw',
                  'ASG00146bh', 'ASG0019lwy', 'ASG000397z', 'ASG000yj3f', 'ASG0019h75', 'ASG0015h7j'],
  'human': ['ASG0007ohh', 'ASG0000h59', 'ASG001clhc', 'ASG00045u9', 'ASG000706v', 'ASG0012ytz', 'ASG00055sa',
            'ASG0005w6q', 'ASG001392k', 'ASG0014a34', 'ASG0002hk1', 'ASG0017e0a', 'ASG0007ecj', 'ASG0004lyu',
            'ASG00100u2', 'ASG000rk35', 'ASG00156tn', 'ASG00019nt', 'ASG00111pk', 'ASG000y9aa'],
  'hyenaspotted': ['ASG0008odh', 'ASG0015l9k', 'ASG000p8c2', 'ASG0003tx5', 'ASG00007k6', 'ASG000y26m', 'ASG0013jix',
                   'ASG0008hyt', 'ASG000p0hl', 'ASG0003vlt', 'ASG000290c', 'ASG0008hyx', 'ASG0013chh', 'ASG00062p9',
                   'ASG000dsmd', 'ASG000qc0e', 'ASG000ffcb', 'ASG000bcd1', 'ASG0003sfr', 'ASG0018mme'],
  'hyenastriped': ['ASG000qgcu', 'ASG0004ge9', 'ASG0019lm9', 'ASG00007nr', 'ASG0019e8r', 'ASG0019e7v', 'ASG00112iy',
                   'ASG000tkif', 'ASG00052lb', 'ASG0000ewf', 'ASG0009psj', 'ASG000dofg', 'ASG0003bm7', 'ASG0005dhi',
                   'ASG00036n3', 'ASG001dkq0', 'ASG00070dv', 'ASG001586v', 'ASG00168ns', 'ASG0002thc'],
  'impala': ['ASG00178hq', 'ASG000bxb1', 'ASG001dszp', 'ASG000dz1x', 'ASG001ekz5', 'ASG000og4h', 'ASG000zcdu',
             'ASG001f9k2', 'ASG000yqem', 'ASG0006w6h', 'ASG001enws', 'ASG00078p3', 'ASG001el14', 'ASG000p8f2',
             'ASG000yr2i', 'ASG000pnem', 'ASG00191oc', 'ASG000su90', 'ASG0017a0d', 'ASG000bz2x'],
  'insectspider': ['ASG001fdsk', 'ASG001dv46', 'ASG001f2bc', 'ASG001bdgd', 'ASG001fjgo', 'ASG001f30q', 'ASG001c0lq',
                   'ASG001f2r2', 'ASG001bzw9', 'ASG001ao8w', 'ASG001b30q', 'ASG001bvlz', 'ASG001bzn1', 'ASG001bvoa',
                   'ASG001f15s', 'ASG001dvav', 'ASG001by4s', 'ASG001aakp', 'ASG001f3ix', 'ASG001g0ip'],
  'jackal': ['ASG0016axm', 'ASG000y3wm', 'ASG000y3qz', 'ASG000cc58', 'ASG00039zg', 'ASG000c52l', 'ASG0005ksh',
             'ASG00052ry', 'ASG000dilf', 'ASG00188ib', 'ASG0004rx2', 'ASG000y7v8', 'ASG000o7hk', 'ASG000cc21',
             'ASG0008g8s', 'ASG000ow3f', 'ASG0001hvf', 'ASG0014ec9', 'ASG0011luz', 'ASG0004sum'],
  'koribustard': ['ASG00071cw', 'ASG000cehu', 'ASG0012i1d', 'ASG0005cvb', 'ASG00007ow', 'ASG00074dp', 'ASG000ct6q',
                  'ASG000tqci', 'ASG00013ea', 'ASG001beoj', 'ASG000ae16', 'ASG000d4w3', 'ASG000f15m', 'ASG0001evj',
                  'ASG0000h8b', 'ASG0003lzj', 'ASG0006i7w', 'ASG000ql9z', 'ASG00001kn', 'ASG000z0bw'],
  'leopard': ['ASG000okx8', 'ASG000efqk', 'ASG00069xl', 'ASG001b0w2', 'ASG000ojq1', 'ASG0006a06', 'ASG000bl7s',
              'ASG00069vv', 'ASG000ssoo', 'ASG0005ccf', 'ASG0018lnm', 'ASG000okt1', 'ASG00007mt', 'ASG0004ekv',
              'ASG000okao', 'ASG000sf6w', 'ASG0018wg1', 'ASG000okx7', 'ASG000566q', 'ASG000cinm'],
  'lionfemale': ['ASG0006e6t', 'ASG0015t55', 'ASG001amkz', 'ASG000o5z9', 'ASG0010ha3', 'ASG000702o', 'ASG0004jeq',
                 'ASG001d7nr', 'ASG0004jhi', 'ASG0011wfb', 'ASG0005ci8', 'ASG0003utl', 'ASG0007eby', 'ASG000r7zx',
                 'ASG00165a7', 'ASG001dn4h', 'ASG0015jpx', 'ASG0012dmy', 'ASG0000svh', 'ASG001bhar'],
  'lionmale': ['ASG0001i0w', 'ASG0005mdn', 'ASG0012dmi', 'ASG000732v', 'ASG0006e45', 'ASG0006e5q', 'ASG0012w5r',
               'ASG0011ran', 'ASG0000adn', 'ASG000b5ut', 'ASG0001i1o', 'ASG000o5za', 'ASG000cdl9', 'ASG0008j0n',
               'ASG0006eg3', 'ASG0006e36', 'ASG0019a7z', 'ASG000dfgw', 'ASG0006zz2', 'ASG0005mbt'],
  'mongoose': ['ASG001axg0', 'ASG0013pvb', 'ASG000nsqi', 'ASG0012f1u', 'ASG000q4d1', 'ASG0007d1t', 'ASG0011bzx',
               'ASG0001hqs', 'ASG0015toe', 'ASG00084wm', 'ASG00011vl', 'ASG0002hzy', 'ASG00038tm', 'ASG0014ntv',
               'ASG000szbp', 'ASG0004bzq', 'ASG0000hb4', 'ASG000berj', 'ASG0002ufm', 'ASG0018mk9'],
  'ostrich': ['ASG0007j6f', 'ASG000slur', 'ASG000tfu8', 'ASG000n6oc', 'ASG001arva', 'ASG000y31p', 'ASG000p07x',
              'ASG0006art', 'ASG000335b', 'ASG000nhkq', 'ASG0008pel', 'ASG001dqo7', 'ASG00162i6', 'ASG00005ri',
              'ASG000r1ia', 'ASG0002rz0', 'ASG000e77c', 'ASG00142wc', 'ASG000a9qe', 'ASG000tkgh'],
  'otherbird': ['ASG00041hd', 'ASG001cyxm', 'ASG000a9pb', 'ASG0001h4t', 'ASG000t79b', 'ASG000c4mm', 'ASG00162zo',
                'ASG0017e38', 'ASG001biue', 'ASG0005voj', 'ASG0002hsw', 'ASG001309e', 'ASG000c6dp', 'ASG000ewhi',
                'ASG00044ug', 'ASG000yj79', 'ASG000epqe', 'ASG0005ws8', 'ASG001aksq', 'ASG000761w'],
  'porcupine': ['ASG000ew81', 'ASG000qkyl', 'ASG000yrii', 'ASG000yroz', 'ASG0018kc4', 'ASG0002kk9', 'ASG000yrov',
                'ASG000709g', 'ASG0018jn7', 'ASG00131l4', 'ASG000qkyu', 'ASG0007zun', 'ASG0018ojk', 'ASG0007zzv',
                'ASG00049r5', 'ASG000y3ko', 'ASG00198ae', 'ASG000f8sc', 'ASG0014q7h', 'ASG0008m1d'],
  'reedbuck': ['ASG000nfsw', 'ASG0005uu6', 'ASG000130c', 'ASG00105x6', 'ASG000pnr8', 'ASG0001wut', 'ASG0019cnm',
               'ASG000b4kp', 'ASG000zve6', 'ASG0004b96', 'ASG000613g', 'ASG000qzus', 'ASG00190ve', 'ASG000onya',
               'ASG000zk5c', 'ASG000a82v', 'ASG0016aje', 'ASG000e92k', 'ASG00060ee', 'ASG00073fy'],
  'reptiles': ['ASG0000cjs', 'ASG0003994', 'ASG000qozp', 'ASG0000ctp', 'ASG0000ums', 'ASG00039nk', 'ASG0000cnp',
               'ASG0000d9g', 'ASG0000cy8', 'ASG0010d6h', 'ASG000395g', 'ASG0000dwc', 'ASG0000d0d', 'ASG00131dx',
               'ASG0003990', 'ASG000zwn8', 'ASG0000cla', 'ASG0000djo', 'ASG0010d8w', 'ASG0000cxm'],
  'rhinoceros': ['ASG0005eti', 'ASG0005fpp', 'ASG0005esb', 'ASG000z6g2', 'ASG001brf2', 'ASG001brap', 'ASG0012kge',
                 'ASG001br8k', 'ASG0005esv', 'ASG0006ef9', 'ASG000red5', 'ASG001br8o', 'ASG000pfo5', 'ASG0005etj',
                 'ASG00147ku', 'ASG0005ujl', 'ASG001brdi', 'ASG000bkf3', 'ASG0005ev4', 'ASG000pfmi'],
  'rodents': ['ASG0018v1q', 'ASG0018v4j', 'ASG0018v5b', 'ASG0001793', 'ASG0000cp9', 'ASG0018v3q', 'ASG0001hev',
              'ASG00002xx', 'ASG0013ydw', 'ASG0001hdu', 'ASG00021bq', 'ASG0018v13', 'ASG0000chq', 'ASG0002183',
              'ASG0001he2', 'ASG00003g7', 'ASG0000cud', 'ASG00017fs', 'ASG0001hgs', 'ASG0001hdw'],
  'secretarybird': ['ASG0012xwi', 'ASG0012xxd', 'ASG000on3d', 'ASG0012xwd', 'ASG0018ems', 'ASG000b62t', 'ASG0018ew4',
                    'ASG0018en8', 'ASG000b814', 'ASG001acyz', 'ASG0012xtn', 'ASG001ad35', 'ASG00165vg', 'ASG0001yzg',
                    'ASG0016lkm', 'ASG0012xtp', 'ASG0012y3b', 'ASG0012xsf', 'ASG0012y0i', 'ASG0018ec5'],
  'serval': ['ASG0018um7', 'ASG000c8k2', 'ASG000zwpg', 'ASG0000ssf', 'ASG00191al', 'ASG0014jy9', 'ASG0013172',
             'ASG000zwph', 'ASG000zxf7', 'ASG0010axw', 'ASG0015ir2', 'ASG000zwmc', 'ASG000eivp', 'ASG0011x3o',
             'ASG0015xwh', 'ASG0016ksq', 'ASG00132aj', 'ASG001c6ma', 'ASG000zwgc', 'ASG00131yv'],
  'topi': ['ASG001deyp', 'ASG0014avf', 'ASG00017af', 'ASG0005iyt', 'ASG000p94s', 'ASG0011c87', 'ASG0005r44',
           'ASG000biep', 'ASG0004sog', 'ASG00072t7', 'ASG0007zgy', 'ASG000conl', 'ASG000r0b3', 'ASG0005mcs',
           'ASG001fw8x', 'ASG0008co9', 'ASG000qlbr', 'ASG00032jl', 'ASG001f7gv', 'ASG000zmn1'],
  'vervetmonkey': ['ASG000nu3e', 'ASG000yeh2', 'ASG000dim4', 'ASG0004bpo', 'ASG000bz39', 'ASG0004ckp', 'ASG0004cu6',
                   'ASG0004cp7', 'ASG0005i4f', 'ASG000by9i', 'ASG000ntwg', 'ASG000dior', 'ASG000yqp6', 'ASG001ervl',
                   'ASG0016b1a', 'ASG00094u1', 'ASG0004cyc', 'ASG0004cvx', 'ASG000cj6g', 'ASG0004ckw'],
  'warthog': ['ASG00060hc', 'ASG0001v8a', 'ASG000bp8k', 'ASG00178f8', 'ASG000s8y9', 'ASG000f0we', 'ASG0001htz',
              'ASG001bqyp', 'ASG000eef1', 'ASG0007cj7', 'ASG0005m98', 'ASG000oev5', 'ASG0019uj0', 'ASG000fhnh',
              'ASG000bc98', 'ASG000by3r', 'ASG0014eo0', 'ASG00178gl', 'ASG0018yt3', 'ASG0000sq9'],
  'waterbuck': ['ASG0004bww', 'ASG000dyuf', 'ASG0008b3r', 'ASG000y5io', 'ASG0013fmh', 'ASG0017e43', 'ASG0018q9v',
                'ASG000zn9f', 'ASG000q0cm', 'ASG000rbbv', 'ASG000euzs', 'ASG000f25h', 'ASG000zn0q', 'ASG000zn8h',
                'ASG001ehda', 'ASG000zt38', 'ASG000y5ip', 'ASG0007gf9', 'ASG0008az0', 'ASG0014alr'],
  'wildcat': ['ASG000602e', 'ASG0013r5f', 'ASG0018rfg', 'ASG00040re', 'ASG00131x9', 'ASG00066nv', 'ASG0002k96',
              'ASG00165q8', 'ASG00060bt', 'ASG0003k89', 'ASG0019evd', 'ASG00066mw', 'ASG001960f', 'ASG000tqay',
              'ASG000tgjy', 'ASG0000aes', 'ASG00017cq', 'ASG000cbrb', 'ASG000t83a', 'ASG00060hd'],
  'wildebeest': ['ASG000ei3r', 'ASG00132d6', 'ASG0018wc1', 'ASG000ak3y', 'ASG0007gyk', 'ASG001a6v3', 'ASG00063sw',
                 'ASG000clsf', 'ASG000awxi', 'ASG000tt3p', 'ASG000bvfv', 'ASG0006vw4', 'ASG000tfbx', 'ASG000tfcd',
                 'ASG0005l6a', 'ASG000n8of', 'ASG001epvd', 'ASG000dsmr', 'ASG00098n5', 'ASG00123z6'],
  'zebra': ['ASG000764f', 'ASG000pe4e', 'ASG0004ryj', 'ASG0009twx', 'ASG000nngy', 'ASG000db59', 'ASG000nqaw',
            'ASG000bgm5', 'ASG000y7m8', 'ASG000c4n3', 'ASG000b23c', 'ASG000fhju', 'ASG000yfqv', 'ASG000anpe',
            'ASG000n2ct', 'ASG000my08', 'ASG000976y', 'ASG00156lq', 'ASG000n8v3', 'ASG000a8o5'],
  'zorilla': ['ASG0018pj3', 'ASG00145sp', 'ASG000qd1j', 'ASG0019ks3', 'ASG0018ym2', 'ASG0007fct', 'ASG0007egh',
              'ASG000s9kh', 'ASG000sxkm', 'ASG000b64t', 'ASG0004rya', 'ASG0007eay', 'ASG0011pfu', 'ASG00145tu',
              'ASG0001kxk', 'ASG0003uhf', 'ASG000atfw', 'ASG0003bl0', 'ASG00055qf', 'ASG00146a0'],
}

###
less than 20 examples available, therefore these are excluded.
###
EXCLUDED_SPECIES = ['steenbok', 'vulture', 'bat', 'cattle']


# VARIABLES #

###
Do not modify this initialization, it is used by the code below to keep track of the cohort so as to avoid checking many times
###
currentCohort = null

###
Do not modify this initialization, it is used to keep track of when the last experiment server failure was
###
lastFailedAt = null

###
until the experiment server supports storage of viewed and available subjects, we use local variables for storage.
since this will not yet persist across sessions so is only a temporary measure.
Structure of each object element:
  intervention_histories [userID] = { 'active': true, 'interesting_subjects_viewed':['ASD123','ASD134'], .... }
###
interventionHistories = {}

###
This method will contact the experiment server to find the cohort for this user & subject in the specified experiment
###
getCohort = (user_id = User.current?.zooniverse_id, subject_id = Subject.current?.zooniverseId) ->
  eventualCohort = new $.Deferred
  if currentCohort?
    eventualCohort.resolve currentCohort
  else
    if ACTIVE_EXPERIMENT?
      now = new Date().getTime()
      if lastFailedAt?
        timeSinceLastFail = now - lastFailedAt.getTime()
      if lastFailedAt == null || timeSinceLastFail > RETRY_INTERVAL
        try
          $.get('http://experiments.zooniverse.org/experiment/' + ACTIVE_EXPERIMENT + '?userid=' + user_id)
          .then (data) =>
            currentCohort = data.cohort
            eventualCohort.resolve data.cohort
          .fail =>
            lastFailedAt = new Date()
            AnalyticsLogger.logError "500", "Couldn't retrieve experimental split data", "error"
            eventualCohort.resolve null
        catch error
          eventualCohort.resolve null
      else
        eventualCohort.resolve null
    else
      eventualCohort.resolve null
  eventualCohort.promise()

exports.getCohort = getCohort
exports.currentCohort = currentCohort
exports.ACTIVE_EXPERIMENT = ACTIVE_EXPERIMENT
exports.INSERTION_RATIO = INSERTION_RATIO
exports.SPECIES_INTEREST_PROFILES = SPECIES_INTEREST_PROFILES
exports.SPECIES_SUBJECTS = SPECIES_SUBJECTS
exports.EXCLUDED_SPECIES = EXCLUDED_SPECIES
exports.interventionHistories = interventionHistories