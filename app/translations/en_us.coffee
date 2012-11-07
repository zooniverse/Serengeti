module.exports =
  navigation:
    home: 'Home'
    about: 'About'
    classify: 'Classify'
    profile: 'Profile'
    discuss: 'Discuss'
    blog: 'Blog'

  home:
    heading: 'Welcome to Snapshot Serengeti'
    content: '''
      Hundreds of camera traps in Serengeti National Park, Tanzania,
      are providing a powerful new window into the dynamics of Africa’s most elusive wildlife species.
      We need your help to classify all the different animals caught in millions of camera trap images.
    '''
    action: 'Start classifying'
    currentStatus: '<span class="classification-count">0</span> classifications by <span class="user-count">0</span> volunteers'

  classify:
    deleteAnnotation: 'Delete'
    notSignedIn: 'You\'re not signed in!'
    favorite: 'Favorite'
    unfavorite: 'Unfavorite'
    play: 'View series'
    pause: 'Stop'
    satellite: 'Satellite view'
    nothingLabel: 'Nothing here'
    nextSubjectButton: 'Finish'
    share: 'Share'
    tweet: 'Tweet'
    pin: 'Pin it'
    discuss: 'Discuss'
    next: 'Next capture'

    nothingToShow: 'There\'s nothing to show with these filters.'
    clearFilters: 'Clear filters'

    count: 'How many'

    behavior: 'Behavior'
    behaviors:
      resting: 'Resting'
      standing: 'Standing'
      moving: 'Moving'
      eating: 'Eating'
      interacting: 'Interacting'

    babies: 'Young present'
    rain: 'Raining'

    cancel: 'Cancel'
    identify: 'Identify'

    tutorial:
      continueButton: 'Continue'

      welcome: '''
        Welcome to Snapshot Serengeti!

        This short tutorial will walk you through your first classification.

        Let's get started!
      '''

      traps: '''
        All over the Serengeti, scientists have set up motion sensitive camera traps.
        The camera snaps a few shots anytime something moves in front of it.
        Many of these photos come as a sequence of two or three.
        Check out other snapshots in the sequence using the buttons below the image.
        You can even play them like a flipbook by clicking the play button.
      '''

      task: '''
        Your task is to identify all the different animals that appear in the photos.
        The species that will appear are listed to the right.
        That's a big list, and not all the species are familiar,
        so let's take a look at some ways we can narrow that list down using
        characteristics we can identify in the image.
      '''

      chooseAntelope: '''
        The animal in the foreground of this photo looks like a large antelope of some kind.
        Let's choose "Antelope/deer" from the "looks like" menu.
      '''

      chooseSolid: '''
        That narrows things down a bit.

        It's primarily one solid color over most of its body,
        so let's choose the "solid" icon under the "Pattern" menu.
      '''

      chooseBrown: '''
        Now we can see photos representing the possible animals.

        We can probably make a good match from these photos,
        but let's narrow the list down one more time
        by choosing "brown" from the "Color" menu.
      '''

      chooseWildebeest: '''
        Great, that leaves us with two options.
        This animal looks most like the wildebeest, so let's choose it and make sure.
      '''

      confirmWildebeest: '''
        We can confirm that this is indeed a wildebeest by comparing it to to the photos here and reading the description below.
        You can flip through the photos to see examples of the animal from multiple angles using the bullets on the right.
      '''

      identifyWildebeest: '''
        Once you're confident that this is a wildebeest,
        chooose "1" from the count menu and "Moving" from the behavior menu.
        Then click "Identify."
      '''

      findZebras: '''
        We want to try to identify all the animals in each capture.
        Look closely and you'll notice that there are some zebras in the distance.

        Let's look at another way of classifying when we already know which species we can see.
      '''

      typeZebra: '''
        The seach field is a quick way to highlight animals
        whose descriptions contain certain words.

        Type "zebra" in the search field...
      '''

      clickZebra: '''
        ...and click "Zebra," which is the only animal highlighted.
      '''

      confirmZebra: '''
        It's hard to make out the zebras in the distance, but we'll classify as best we can.
        Each classification is compared with the classifications of other volunteers,
        so do your best, even if you're not sure!
      '''

      identifyZebra: '''
        There are two zebras in the distance, and they appear to be grazing with their heads bowed.
        Mark "2," "Standing," and "Eating," then click "Identify."
      '''

      finish: '''
        Nice job! Now you're ready to classify some images on your own.

        In each image, make your best effort to identify all the animals you can, even if you can't see enough to be completely sure.
        If there aren't any animals in an image, check "Nothing here" and then "Finish."

        Your observations will be combined with those of multiple volunteers,
        so even if you're not sure on something, your contribution is still very useful!

        Click "Finish" now to move on.
        Don't forget: you can discuss an image with professional and citizen scientists after classifying it.
      '''

    splits:
      social: 'Good job! You and ### other Zooniverse volunteers have contributed to Snapshot Serengeti.'
      task: 'Good job! You just successfully finished classifying an image taken in Serengeti National Park.'
      science: 'Good job! Your work is directly helping scientists understand how competing animal species coexist in the Serengeti.'

  animals:
    aardvark:
      label: 'Aardvark'
      description: '''
        The elusive aardvark has a long, tubular, pig-like snout with large, pointed ears.  It has short, stout legs with large digging claws and a very rounded back that tapers into a thick tail.  This animal has skin that appears gray to pinkish-brown and is only sparsely covered with bristly hair.
      '''

    aardwolf:
      label: 'Aardwolf'
      description: '''
        The aardwolf can be easily confused for its larger cousin, the striped hyena: it has the same downward sloping build, gray/tan coat color, vertical black stripes, and a crest of long hair along its neck.  However, aardwolves are smaller than striped hyenas, and their bushy tails are tipped with black.  They only have about 3, very vertical stripes along their sides, and their black snouts are shorter and narrower than those of hyenas.
      '''

    baboon:
      label: 'Baboon'
      description: '''
        This is the largest Serengeti primate.  Baboons are olive-brown in color, with grey/pink bare patches on their rump.  Adults have large, dog-like muzzles and close-set eyes, whereas young dark brown and have flat, pink faces.
      '''

    batEaredFox:
      label: 'Bat-eared fox'
      description: '''
        This silvery-gray/tan insectivore has short legs, a humped appearance, and a very busy black-tipped tail.  It has distinctively large ears and a pointy muzzle with pale band across its forehead.
      '''

    otherBird:
      label: 'Bird (other)'
      description: '''
        See a bird that doesn't have its own category? Mark it here!
      '''

    buffalo:
      label: 'Buffalo'
      description: '''
        Buffalo are massive and cattle like.  They dark brown to black, with relatively long, tufted tails.  Both sexes have horns but those of males are more developed and join in the middle in what is called a ‘boss’. Their large, droopy ears stick out sideways under their horns
      '''

    bushbuck:
      label: 'Bushbuck'
      description: '''
        Bushbucks have a chestnut to dark brown coat, with white spots and faint stripes on their flanks.  They also have a white patch under their chin, white stripe on their lower neck, and white patch under their bushy tail.  Males have backward-pointing horns with a single twist.
      '''

    caracal:
      label: 'Caracal'
      description: '''
        A medium to large cat, the caracal is uniformly reddish-brown/tawny in color with a pale white belly.  It is relatively muscular, with hind quarters rising slightly higher than its shoulders.  The caracal looks almost as though it is wearing makeup – with darkly lined eyes, and striking black markings above its eyes and around its whiskers.  Its large, pointed ears have prominent tufts of black hair.
      '''

    cheetah:
      label: 'Cheetah'
      description: '''
        This is a lanky, slender cat with long legs, short rounded head, and very round ears.  The cheetah is pale tawny/yellow with black spots.  The tail long and also spotted with several black rings towards the tip.  “Tears ” refers to the distinctive black line that runs from the cheetah’s eyes down its cheeks.
      '''

    civet:
      label: 'Civet'
      description: '''
        Long, and heavy-set with short legs, the civet looks like a cross between a cat and a dog.  It has a racoon-like black band across its eyes and a white muzzle, its body is generally gray with black spots that darken to solid black on the legs and tail tip.
      '''

    dikDik:
      label: 'Dik dik'
      description: '''
        This is the smallest Serengeti antelope.  It has large eyes and an elongated upper lip and nose, with tufts of hair between its ears.  Males have short, spiky horns.
      '''

    eland:
      label: 'Eland'
      description: '''
        Elands are large and vaguely ox-like in appearance.  They are tawny-grey with faint white vertical stripes.  Both sexes have straight horns with a single spiral.  Males develop a thick neck with a large, draping dewlap.
      '''

    elephant:
      label: 'Elephant'
      description: '''
        This massive, grey, thick skinned animal is famous for its very large ears, long trunk, and ivory tusks.  Because elephants are so tall, we frequently see only their legs or trunk in the camera trap photos.
      '''

    gazelleGrants:
      label: 'Gazelle (Grant\'s)'
      description: '''
        This pale fawn gazelle has distinctive white belly, white rump, and white tail, with vertical black stripes on either side of the rump.  Juveniles have a band of darker fur along their sides that can mimic a Thomson gazelle.  Long black lines extend from both corners of their eyes.  Adult males have long, ridged horns that widen slightly towards their tips.
      '''

    gazelleThomsons:
      label: 'Gazelle (Thomson\'s)'
      description: '''
        Locally referred to as a “tommy,” this small, fawn-colored gazelle has a horizontal dark black stripe that runs from their elbow to hip.  They have a white rump and underbelly, but black tail.  They have dark fur running from the inner corners of their eyes to their nose.  Both sexes have ridged horns that curve up and slightly backward.
      '''

    genet:
      label: 'Genet'
      description: '''
        This long, lithe animal appears a bit like a cross between a cat and a racoon.  Genets (also called “genet cats”) , have short legs, silvery grey fur with black spots, and a long bushy, ringed tail.
      '''

    giraffe:
      label: 'Giraffe'
      description: '''
        The tallest animals in Serengeti, giraffes are immediately recognizable by their long necks, long legs, and sloping body.  Their reddish-orange blotches give every individual its own unique pattern.  Both sexes have two short horns, covered in hair, with black tufts on the end.  Their tails are tipped with long black tassels.
      '''

    guineaFowl:
      label: 'Guinea fowl'
      description: '''
        A chicken sized bird with dark blue-grey feathers and white spots.  These have large, rounded body with longish necks, and small heads with blue and red skin.
      '''

    hare:
      label: 'Hare'
      description: '''
        The Cape hare looks a lot like the rabbits in your backyard.  It has large ears, a grizzled coat that ranges from gray to brown to red, and a short fluffy tail.
      '''

    hartebeest:
      label: 'Hartebeest'
      description: '''
        This large antelope is yellowish tan with pale lower rump.  Its body slopes distinctively from shoulders towards rump.  The hartebeest has a long nose and high-set eyes.  Both sexes have horns that curve out sideways and then inward.
      '''

    hippopotamus:
      label: 'Hippopotamus'
      description: '''
        Hippos are large, rounded animal with short legs and grey to pink skin.  They have small ears and a massive, wide mouth.  Their short, thick tail is trimmed with black bristles.  You mostly see them in the cameras at night when the leave the rivers to forage.
      '''

    honeyBadger:
      label: 'Honey-badger'
      description: '''
        This fierce creature is stocky with short legs, black fur with a white/grey band covering its head and back.  Its ears are very small and close to its head.
      '''

    hyenaSpotted:
      label: 'Hyena (spotted)'
      description: '''
        The spotted hyena looks typically dog-like.  Juveniles have dark gray fur with black spots; both spots and fur tend to fade to red/brown in adults. Their lower legs and muzzle are black.  Their heads are broad, they have large, rather pointed ears, and they slope dramatically from shoulder to hip.
      '''

    hyenaStriped:
      label: 'Hyena (striped)'
      description: '''
        Striped hyenas have the same sloping build as spotted hyenas, but their beige or grey coats have vertical black stripes.  They have a crest of long hair along their neck that sometimes rises, and a very bushy grey tail.
      '''

    impala:
      label: 'Impala'
      description: '''
        Impalas are lightly built antelopes, reddish brown in color, with paler fur on sides.  They have white under their belly and chin, and around their eyes.  They have black tufts of hair between their ears, black lines on their rump, and black spots above their heels.  Males have large, S-shaped horns.
      '''

    jackal:
      label: 'Jackal'
      description: '''
        Jackals look much like a small dog or coyote.  They have yellow-brown bodies and legs, with grizzled black grey back trimmed with a  black band.  Black-backed jackals have a predominantly black tail with black tip, whereas side-striped jackals have a white-tipped tail.
      '''

    koriBustard:
      label: 'Kori bustard'
      description: '''
        This is a large, heavy bird with a thick pale grey neck, brown back, and white belly, and long yellow legs
      '''

    leopard:
      label: 'Leopard'
      description: '''
        These are powerfully built, golden brown cats with black rosettes.  Leopards have a spotted face - no black lines as cheetahs have – and small, round ears.  Their long, spotted tail has bright white fur underneath the tip, which is easy to see when they curl their tails upward.
      '''

    lionFemale:
      label: 'Lion (female or cub)'
      description: '''
        These are massive, muscular cats.  They are tawny coloured with paler underparts; cubs show some spots, especially on their bellies and legs.  They have a long tail with smooth fur and a dark tuft on its tip.  Males have manes that get darker and thicker with age.
      '''

    lionMale:
      label: 'Lion (male)'
      description: '''
        These are massive, muscular cats.  They are tawny coloured with paler underparts; cubs show some spots, especially on their bellies and legs.  They have a long tail with smooth fur and a dark tuft on its tip.  Males have manes that get darker and thicker with age.
      '''

    mongoose:
      label: 'Mongoose'
      description: '''
        With short legs and a humped back, mongooses appear very weasel- or ferret-like.  The mongooses you’ll see here range in size and color – from the tiny, brown dwarf mongoose to the larger banded mongoose, to the bushy tailed white-tailed mongoose.
      '''

    ostrich:
      label: 'Ostrich'
      description: '''
        This is a very large, tall bird with long, heavy legs.  Females are mainly brown with pale legs and necks.  Males have black fur with white tail and wing tips, and their legs and neck turn pink in mating season.
      '''

    porcupine:
      label: 'Porcupine'
      description: '''
        This short, rounded creature is covered from head to tail with long, black and white quills.  Porcupines have tiny black eyes set in gopher-like faces.
      '''

    reedbuck:
      label: 'Reedbuck'
      description: '''
        Reedbucks range in color from tan to reddish brown.  They have white bellies and a  short fluffy tail with a white underside.  The have a dark black nose, with white mouth and chin, and a black spot beneath their large ears.  Males have forward-curving ridged horns.
      '''

    reptiles:
      label: 'Reptiles'
      description: '''
        You will occasionally see skinks, Agama lizards, snakes, and other reptiles sunning themselves in front of the camera.  This category includes any reptiles that you see.
      '''

    rhinoceros:
      label: 'Rhinoceros'
      description: '''
        Despite its name, the black rhino is grey.  It is immediately recognizable by the large horn on its nose, which can get up to 60cm long.  It has another smaller horn higher on its nose as well.  These are massive, thick animals and are a rare find on our camera traps.
      '''

    rodents:
      label: 'Rodents'
      description: '''
        Though the name is deceiving, spring hares are actually rodents and not hares.  (Hares are lagomorphs, not rodents, and have their own category here.)  The springhare looks like a rabbit-sized kangaroo, with long, powerful hind legs, short front legs, a long semi-bushy, black-tipped tail.  Mainly found on the open grassland, the spring hare grazes primarily at night.  Mice are seen infrequently in the cameras because they are so small, but you might get lucky.
      '''

    secretaryBird:
      label: 'Secretary bird'
      description: '''
        This is a tall bird with long legs and black feathered thighs.  It has a grey neck, body and tail plumes, with black feathers across its lower back and wings.  The bare skin on its face is red and yellow.  It has several long plumes on back of its head that sometimes stick out.
      '''

    serval:
      label: 'Serval'
      description: '''
        This relatively small cat has long slender legs, a small head, and a yellowish coat which dotted with black spots that sometimes run into stripes. The serval’s enormous pointed ears and distinctive black nose help distinguish it from the cheetah.
      '''

    topi:
      label: 'Topi'
      description: '''
        The topi is a tall hoofed animal that is recognizable for standing sentry on termite mounds.  It has a long nose with high set eyes and horns that curve up and back.  Like the hartebeest, its body slopes steeply down from their shoulder to rump, but topis are reddish brown in color with black patches on their shoulder and hip.
      '''

    vervetMonkey:
      label: 'Vervet monkey'
      description: '''
        A regular sight in the Serengeti, this small monkey has a light gray/brown coat, small black face, and a very, very long gray tail.
      '''

    warthog:
      label: 'Warthog'
      description: '''
        This pig-like animal has a grey body covered sparsely with darker hairs, and aane of long, wiry hairs along its neck and back.  Its tail is think with a black tassel.  It has tusks that curve up around its snout.
      '''

    waterbuck:
      label: 'Waterbuck'
      description: '''
        Waterbucks are large, bulky antelope with brown coarse hair and a white circle around their rumps.  They have white markings on their chin and nose, and a white band runs from ear to ear under their neck. Males have ridged horns that curve first backwards then forwards towards the tips.
      '''

    wildcat:
      label: 'Wildcat'
      description: '''
        Resembling a large, domestic cat, wildcats are sandy brown to grey with lighter underparts.  They have sometimes-visible dark stripes on their legs and tail.
      '''

    wildebeest:
      label: 'Wildebeest'
      description: '''
        This long-legged, migratory antelope has dark grey-brown fur with faint stripes of darker fur on its neck and flank.  It has a large head with a rounded black nose and white ‘beard’.  It stands higher at the shoulder than the rump.  Both sexes have horns that extend out sideways then curve sharply back towards head.
      '''

    zebra:
      label: 'Zebra'
      description: '''
        The Swahili word for zebra means “striped donkey” – and that’s exactly what this animal looks like.  Horse or donkey-like in appearance, zebras are white, with dark stripes, a thick, bristly mane, and a black-tasselled tail.
      '''

    zorilla:
      label: 'Zorilla'
      description: '''
        Also known as the striped polecat, this member of the weasel family looks a lot like a skunk.  It has short legs and long white stripes down its back – and even emits a foul smell when threatened!
      '''

    human:
      label: 'Human'
      description: '''
        Vehicles and hot-air balloons are some of the signs you’ll see that people visit Serengeti.  You might even catch a researcher checking the camera, or a curious tourist investigating over lunch.
      '''

  characteristics:
    like: 'Looks like'
    pattern: 'Pattern'
    coat: 'Color'
    horns: 'Horns'
    tail: 'Tail'
    build: 'Build'

  characteristicValues:
    likeCatDog: 'Cat/dog'
    likeCowHorse: 'Cow/horse'
    likeAntelopeDeer: 'Antelope/deer'
    likeBird: 'Bird'
    likeWeasel: 'Weasel'
    likeOther: 'Other'
    patternVerticalStripe: 'Stripes'
    patternHorizontalStripe: 'Bands'
    patternSpots: 'Spots'
    patternSolid: 'Solid'
    coatTanYellow: 'Tan/yellow'
    coatRedBrown: 'Red'
    coatBrownBlack: 'Brown'
    coatWhite: 'White'
    coatGray: 'Gray'
    coatBlack: 'Black'
    hornsNone: 'None'
    hornsStraight: 'Straight'
    hornsSimpleCurve: 'Curved'
    hornsLyrate: 'Lyrate'
    hornsCurly: 'Curly'
    tailBushy: 'Bushy'
    tailSmooth: 'Smooth'
    tailTufted: 'Tufted'
    tailLong: 'Long'
    tailShort: 'Short'
    buildStocky: 'Stocky'
    buildLanky: 'Lanky'
    buildTall: 'Tall'
    buildSmall: 'Small'
    buildLowSlung: 'Low-slung'
    buildSloped: 'Sloped'

  profile:
    favorites: 'Favorites'
    recents: 'Recents'
    noFavorites: 'You have no favorites!'
    noRecents: 'You have no recent classifications!'
    showing: 'Showing'
    loadMore: 'Load more'

  about:
    sections:
      information: 'Information'
      organizations: 'Organizations'
      teams: 'Teams'
      scienceTeam: 'Science team'
      developmentTeam: 'Development team'

    information:
      main: '''
        <h2>Observing animals in the wild</h2>
        <p>Over the last 45 years, the University of Minnesota Lion Project has discovered a lot about lions – everything from why they have manes to why they live in groups. Now we’re turning our sights to understanding how an entire community of large animals interacts. We currently monitor 24 lion prides in Serengeti National Park, Tanzania, using radio-tracking.  To collect information about other species, we’ve set out a grid of 225 camera traps.  With photographs from these cameras, we’re able to study how over 30 species are distributed across the landscape – and how they interact with lions and one another.</p>

        <h3>Our scientific questions</h3>
        <p>Understanding how competing species coexist is a fundamental theme in ecology, with important implications for food webs, biodiversity, and the sustainability of life on Earth.  Much of our current research focuses on how carnivores coexist with carnivores, herbivores with herbivores, and the joint dynamics of predators and their prey. These insights will guide strategies for species reintroduction, conservation, and ecosystem management around the world.</p>
        <ul>
          <li>Carnivore Coexistence: Carnivores eat meat. If two carnivore species eat the same prey, one of those species can outcompete the other, preventing coexistence of both species in the same area. Even where carnivores don’t compete for the exact same prey, aggressive interactions such as scavenging from and killing each other can prevent coexistence.  Research in other parts of the world suggests that when one species avoids the other, the two species might be able to coexist, but coexistence may depend on the structure and complexity of the habitat. Our cameras reveal whether lions, leopards, cheetah and hyenas avoid each other in space or in time and the extent to which this varies across the landscape.</li>
          <li>Herbivore Coexistence: Herbivores eat plants. The Serengeti supports sixteen different species of hoofed herbivores.  Although these species don’t kill or steal food from each other, we still don’t really understand how they all manage to coexist in this system.  Herbivores that are able to feed most efficiently may also be more likely to be killed by predators, and this could explain some of the coexistence. Another possibility is that different herbivores may specialize on different habitat areas. We are using the camera traps to investigate these ideas, as well as study how the annual migration of 1.5 million wildebeest and zebra through our study area affects changes these dynamics.</li>
          <li>Predator Prey Relationships: Recent advances in ecology have suggested that there may be costs to herbivores when they avoid predators. For example, if predators hunt in areas with the best plants, herbivores may avoid those areas and only be able to eat plants that aren’t as good. We are using the camera trap data on herbivore distributions to study whether herbivores are found where the best food is or where the risk of being killed by predators is lowest.</li>
        </ul>
      '''

      sidebar: '''
        <h3>The Serengeti Lion Project</h3>
        <p>The camera trapping survey is operated by the long-term Serengeti Lion Project.  The Lion Project has been studying African lions in Tanzania’s Serengeti National Park and the Ngorongoro Conservation Area since the 1960’s.  At any given time, our field teams keep track of about 330 lions in 24 prides in the Serengeti, and 50–60 lions in 5 prides on the floor of Ngorongoro Crater.  This daily monitoring has produced one of the most extensive datasets on any mammalian species anywhere in the world - over 5,000 lions have been included in the Serengeti and Crater studies over the past 40+ years, and genealogical data from these two populations extend over 12 generations. The daily records include information on the lions’ location, group size, diet, food intake, health and reproduction.  You can find out more about the Lion Project at <a href="http://www.cbs.umn.edu/lionresearch/" target="_blank">http://www.cbs.umn.edu/lionresearch/</a>.</p>
        <h3>What we do</h3>
        <p>We check on the camera traps in the course of daily lion monitoring.  We change batteries, exchange the SD cards, and cut tall grass in front of the camera so that grass waving in the wind doesn’t accidentally trigger the sensor.  225 cameras are a lot of work!  When things run smoothly, a camera can last about two months before needing maintenance.  But that’s not always the case – sometimes we return to a camera only to find it chewed on by hyenas or torn down by elephants, waterlogged from a heavy rain or infested by ants. </p>
        <h3>How the cameras work</h3>
        <p>The cameras use passive infrared sensors that are triggered when an object warmer than the ambient temperature moves in front of the sensor.  This is usually an animal…but tall sunlit grass can also trigger the camera when it blows in the wind.  We currently use the Scoutguard 565 and DLC Covert Reveal models – these are incandescent flash cameras (with a white flash).  Some people worry that incandescent flashes startle the animals, but in our study area the same individuals often come back to the same camera site night after night!</p>
        <h3>Where we live</h3>
        <p>When in Serengeti, we live in the remote Serengeti Wildlife Research Center—a small community of houses and research offices near the park headquarters in the middle of the park.  Our house is modest, but the outdoor toilet provides some of our more exciting run-ins with nocturnal wildlife.  In recent years donations from visitors and supporters have allowed us to install a solar power system that gives us electricity at night and supports the most exciting recent addition to our house – a refrigerator!  </p>
      '''

    organizations:
      umn:
        name: 'University of Minnesota'
        url: "http://www.cbs.umn.edu/eeb"
        image: 'images/about/organizations/umn.jpg'
        description: '''
          The members of Snapshot Serengeti’s science team are ecologists at the University of Minnesota in the Department of Ecology, Evolution, and Behavior.
          The University of Minnesota, founded in the belief that all people are enriched by understanding,
          is dedicated to the advancement of learning and the search for truth;
          to the sharing of this knowledge through education for a diverse community;
          and to the application of this knowledge to benefit the people of the state, the nation, and the world.
        '''

      mnZoo:
        name: 'Minnesota Zoo'
        url: 'http://www.mnzoo.com/'
        image: ''
        description: '''
          The Minnesota Zoo has provided partial funding for the camera trap survey through a Ulysses S. Seal Conservation Grant
          and has helped recruit volunteers who have assisted the development of Snapshot Serengeti.
          The Minnesota Zoo connects people, animals, and the natural world.
          It is dedicated to inspiring guests to act on behalf of wildlife and wild lands.
          To accomplish this, the zoo provides award-winning recreational, educational, and conservation programs, locally, nationally, and internationally.
        '''

      nsf:
        name: 'National Science Foundation'
        url: 'http://www.nsf.gov/'
        image: 'images/about/organizations/nsf.jpg'
        description: '''
          The National Science Foundation (NSF) provides ongoing funding support for the long-term Serengeti Lion Project (grant DEB‐1020479)
          that provides the underlying infrastructure for the camera trapping survey.
          The mission of NSF is to promote the progress of science; to advance the national health, prosperity, and welfare; and to secure the national defense.
          NSF envisions a nation that capitalizes on new concepts in science and engineering and provides global leadership in advancing research and education.
        '''

      gpsa:
        name: 'The Global Programs and Strategy Alliance'
        url: 'http://global.umn.edu/'
        image: ''
        description: '''
          The Global Programs and Strategy Alliance provided the funding for the first 50 cameras of the camera trap survey, which were established in June 2010.
          The mission of the Global Programs and Strategy Alliance is to be the driving force for the University of Minnesota in globalizing teaching, learning, research, and engagement.
          The office sponsors many programs and strategies that promote and support international activities by students, faculty, and staff across the University system.
        '''

      umnGradSChool:
        name: 'University of Minnesota Graduate School'
        url: 'http://www.grad.umn.edu/'
        image: ''
        description: '''
          The University of Minnesota Graduate School provided funding for the initial camera trap survey in 2010 through a Thesis Research Grant.
          As one of the world's most comprehensive public research universities, the University of Minnesota offers outstanding graduate and professional education
          across a range of disciplines—agriculture, engineering, humanities, sciences, and social sciences.
        '''

      explorersClub:
        name: 'Explorers Club'
        url: 'http://www.explorers.org/'
        image: ''
        description: '''
          The Explorers Club provided funding for the initial camera trap survey through its Exploration Fund.
          The Explorers Club is an international multidisciplinary professional society dedicated to the advancement of field research and the ideal that it is vital to preserve the instinct to explore.
          The Explorers Club promotes the scientific exploration of land, sea, air, and space by supporting research and education in the physical, natural and biological sciences.
        '''
      asm:
        name: 'American Society of Mammalogists'
        url: 'http://www.mammalsociety.org/'
        image: ''
        description: '''
          The American Society of Mammalogists provided funding for the initial camera trap survey through its Grants-in-aid of Research program.
          ASM was established in 1919 for the purpose of promoting interest in the study of mammals.
          The ASM is currently composed of over 4,500 members, many of whom are professional scientists.
          Members of the Society have always had a strong interest in the public good,
          and this is reflected in their involvement in providing information for public policy, resources management, conservation, and education.
        '''

      bellMuseum:
        name: 'James Ford Bell Museum of Natural History'
        url: 'www.bellmuseum.org'
        image: ''
        description: '''
          The James Ford Bell Museum of Natural History provided funding for 2009 pilot work that led to the camera survey through a Rothman Fellowship
          and provided funding for the initial 2010 camera trap survey through a Dayton-Wilkie Fellowship.
          The Bell Museum was established by Minnesota legislative mandate in 1872 to collect, preserve, skillfully prepare, display, and interpret
          our state's diverse animal and plant life for scholarly research and teaching and for public appreciation, enrichment, and enjoyment.
          Collecting, researching, and teaching serve to inform exhibits, exhibitions, and public outreach.
        '''

      trailCamPro:
        name: 'TrailCamPro.com'
        url: 'http://www.trailcampro.com/'
        image: ''
        description: '''
          TrailCamPro has provided affordable camera traps for the survey and has shared invaluable personal expertise and advice on using them,
          which has had a large impact on the survey’s success.
          TrailCamPro specializes in selling trail cameras, camera traps, and security cameras.
        '''

      zgf:
        name: 'Frankfurt Zoological Society'
        url: 'http://www.zgf.de/?id=14&language=en'
        image: ''
        description: '''
          The Frankfurt Zoological Society (FZS) provides logistical support for the field team in the Serengeti.
          FZS is a non-profit, internationally operating, conservation organization based in Frankfurt/Main.
          The Society is committed to conserving biological diversity.
          FZS is therefore faced with one of the greatest challenges of the 21st century: the preservation of the world’s natural environments.
        '''

      tawiri:
        name: 'Tanzania Wildlife Research Institute'
        url: 'http://www.tawiri.or.tz/'
        image: ''
        description: '''
          Tanzania Wildlife Research Institute (TAWIRI) provides permission and facilities for the camera trapping project.
          TAWIRI is a parastatal organization under the Ministry of Natural Resources and Tourism responsible for conducting and coordinating wildlife research in the United Republic Tanzania.
          TAWIRI’s overall objective is providing scientific information and advice to the Government and wildlife management authorities on the sustainable conservation of wildlife and natural resources.
        '''

      tanzaniaParks:
        name: 'Tanzania National Parks'
        url: 'http://www.tanzaniaparks.com/'
        image: ''
        description: '''
          Tanzania National Parks (TANAPA) provides permission and facilities for the camera trapping project.
          The mission of TANAPA is to manage and regulate National Parks to preserve the country’s heritage, encompassing natural and cultural resources.
          TANAPA sustainably conserves and manages park resources and their aesthetic value, for the benefit of present and future generations of mankind, as well as efficiently provide high-class tourism products and services.
        '''

      adler:
        name: 'Adler Planetarium'
        url: 'http://www.adlerplanetarium.org/'
        image: ''
        description: '''
          The Adler Planetarium - America's First Planetarium - was founded in 1930 by Chicago business leader Max Adler.
          The Adler is a recognized leader in science education, with a focus on inspiring young people to pursue careers in science, technology, engineering and math.
          Throughout 80 years, the Adler has inspired the next generation of explorers by sharing the personal stories of space exploration and America’s space heroes.
        '''

    teams:
      science:
        swanson:
          name: 'Ali Swanson'
          image: 'images/about/team/ali.jpg'
          description: '''
            Ali spent several years chasing mammals, fish, and birds around North America (scientifically, of course) before beginning her Ph.D. at the University of Minnesota.
            She initiated the camera trapping survey in 2010 for her dissertation research on how Serengeti carnivores coexist.
            She now spends about half the year in Serengeti devising ways to foil the relentless efforts of hyenas and elephants to munch and destroy the cameras.
          '''

        kosmala:
          name: 'Margaret Kosmala'
          image: 'images/about/team/margaret.jpg'
          description: '''
            Margaret is an ecologist finishing her Ph.D. at the University of Minnesota.
            She explores the complex interactions among species and is especially interested in understanding how humans impact species communities.
            She is currently a fellow at the National Museum of Natural History in Washington, D.C.
            where she is trying to figure out what might happen to insect communities as the planet warms.
          '''

        packer:
          name: 'Craig Packer'
          image: 'images/about/team/craig.jpg'
          description: '''
            Craig Packer is a Distinguished McKnight University Professor at the University of Minnesota
            and a research scientist at the Tanzanian Wildlife Research Institute.
            He has worked in Tanzania for 40 years and has two enduring passions: the Serengeti and photography.
            But he no longer carries his own camera, preferring the dramatic and exciting photographs captured by Serengeti Snapshot.
          '''

        rosengren:
          name: 'Daniel Rosengren'
          image: '//placehold.it/40x50.png'
          description: '''
            Daniel got his master’s degree in Sweden studying vole population dynamics.
            After cycling from the Northern Cape of Europe to the southernmost point in Africa, Daniel left his bike for a Lion Project Land Rover.
            He is now the senior Serengeti field assistant and is rarely seen without his camera in hand.
          '''

        mwampeta:
          name: 'Stanslaus Mwampeta'
          image: '//placehold.it/40x50.png'
          description: '''
            Stan joined the Lion Project after graduating from the University of Dar es Salaam, Tanzania.
            When he’s not watching lions, he’s making the rounds on the camera trap survey to ensure that Snapshot Serengeti never runs out of footage.
          '''

        finlay:
          name: 'Fred Finlay'
          image: 'images/about/team/fred.jpg'
          description: '''
            Fred is an Associate Professor at University of Minnesota’s College of Education and Human Development.
            He’s interested in how social and cultural context influence how people learn about science, and conducts much of his research in Thailand.
          '''

      development:
        borden:
          name: 'Kelly Borden'
          image: 'images/about/team/kelly.jpg'
          description: '''
            Kelly is an archaeologist by training but an educator by passion.
            While working at the Museum of Science and Industry and the Adler Planetarium she became an enthusiastic science educator eager to bring science to the masses.
            When not pondering the wonders of science, Kelly can often be found baking or spending time with her herd of cats – Murray, Ada, & Kepler.
          '''

        carstensen:
          name: 'Brian Carstensen'
          image: 'images/about/team/brian.jpg'
          description: '''
            Brian is a web developer working on the Zooniverse family of projects at the Adler Planearium.
            Brian has a degree in graphic design from Columbia College in Chicago, and worked in that field for a number of years before finding a niche in web development.
          '''

        lintott:
          name: 'Chris Lintott'
          image: 'images/about/team/chris.jpg'
          description: '''
            Chris Lintott leads the Zooniverse team, and is his copious spare time is a researcher at the University of Oxford specialising in galaxy formation and evolution.
            A keen popularizer of science, he is best known as co-presenter of the BBC's long running Sky at Night program. He's currently drinking a lot of sherry.
          '''

        miller:
          name: 'David Miller'
          image: 'images/about/team/david.jpg'
          description: '''
            As a visual communicator, David is passionate about tellings stories through clear, clean, and effective design.
            Before joining the Zooniverse team as Visual Designer, David worked for The Raindance Film Festival, the News 21 Initiative's Apart From War, Syracuse Magazine, and as a freelance designer for his small business, Miller Visual.
            David is a graduate of the S.I. Newhouse School of Public Communications at Syracuse University, where he studied Visual & Interactive Communications.
          '''

        parrish:
          name: 'Michael Parrish'
          image: 'images/about/team/michael.jpg'
          description: '''
            Michael has a degree in Computer Science and has been working with The Zooniverse for the past three years as a Software Developer.
            Aside from web development; new technologies, science, AI, reptiles, and coffee tend to occupy his attention.
          '''

        smith:
          name: 'Arfon Smith'
          image: 'images/about/team/arfon.jpg'
          description: '''
            As an undergraduate, Arfon studied Chemistry at the University of Sheffield before completing his Ph.D. in Astrochemistry at The University of Nottingham in 2006.
            He worked as a senior developer at the Wellcome Trust Sanger Institute (Human Genome Project) in Cambridge before joining the Galaxy Zoo team in Oxford.
            Over the past 3 years he has been responsible for leading the development of a platform for citizen science called Zooniverse.
            In August of 2011 he took up the position of Director of Citizen Science at the Adler Planetarium where he continues to lead the software and infrastructure development for the Zooniverse.
          '''
