def countarticle(article):
    clean_article = article.replace('.','').replace(',','').replace('"','').split() #Answer 1
    dict_article = dict.fromkeys(article.replace('.','').replace(',','').replace('"','a').split(),0) #Answer 2
    listbook = []
    for word in dict_article:
        for count in clean_article:
            if word == count:
                dict_article[word] += 1
    sort_dict_article = {p:q for p,q in sorted(dict_article.items(), key = lambda item: item[1], reverse = True)}
    sort_alphabet = list(dict.items({p:q for p,q in sorted(dict_article.items(), key = lambda item: item[0])}))
    
    list_sort_dict_article = list(sort_dict_article.items())
    reversedlist = [(q,p) for p,q in list_sort_dict_article] #Answer 4
    print("Answer 1 = "+"\n")
    print(clean_article)
    print("\n"+"Answer 2 = "+"\n")
    print(dict_article)
    print("\n"+"Answer 3 = "+"\n")
    print(list(sort_dict_article.values()))
    print("\n"+"Answer 4 = "+"\n")
    print(list(reversedlist))
    print("\n"+"Answer 5 = "+"\n")
    print(sort_alphabet)

countarticle("""
Between the former site of old Fort Dearborn and the present site of our newest Board of Trade there lies a restricted yet tumultuous territory through which, during the course of the last fifty years, the rushing streams of commerce have worn many a deep and rugged chasm. These great canons—conduits, in fact, for the leaping volume of an ever-increasing prosperity—cross each other with a sort of systematic rectangularity, and in deference to the practical directness of local requirements they are in general called simply—streets. Each of these canons is closed in by a long frontage of towering cliffs, and these soaring walls of brick and limestone and granite rise higher and higher with each succeeding year, according as the work of erosion at their bases goes onward—the work of that seething flood of carts, carriages, omnibuses, cabs, cars, messengers, shoppers, clerks, and capitalists, which surges with increasing violence for every passing day. This erosion, proceeding with a sort of fateful regularity, has come to be a matter of constant and growing interest. Means have been found to measure its progress—just as a scale has been arranged to measure the rising of the Nile or to gauge the draught of an ocean liner. In this case the unit of measurement is called the "story." Ten years ago the most rushing and irrepressible of the torrents which devastate Chicago had not worn its bed to a greater depth than that indicated seven of these "stories." This depth has since increased to eight—to ten—to fourteen—to sixteen, until some of the leading avenues of activity promise soon to become little more than mere obscure trails half lost between the bases of perpendicular precipices.

High above this architectural upheaval rise yet other structures in crag-like isolation. El Capitan is duplicated time and again both in bulk and in stature, and around him the floating spray of the Bridal Veil is woven by the breezes of lake and prairie from the warp of soot-flakes and the woof of damp-drenched smoke.

The explorer who has climbed to the shoulder of one of these great captains and has found one of the thinnest folds in the veil may readily make out the nature of the surrounding country. The rugged and erratic plateau of the Bad Lands lies before him in all its hideousness and impracticability. It is a wild tract full of sudden falls, unexpected rises, precipitous dislocations. The high and the low are met together. The big and the little alternate in a rapid and illogical succession. Its perilous trails are followed successfully by but few—by a lineman, perhaps, who is balanced on a cornice, by a roofer astride some dizzy gable, by a youth here and there whose early apprehension of the main chance and the multiplication table has stood him in good stead. This country is a treeless country—if we overlook the "forest of chimneys" comprised in a bird's-eye view of any great city, and if we are unable to detect any botanical analogies in the lofty articulated iron funnels whose ramifying cables reach out wherever they can, to fasten wherever they may. It is a shrubless country—if we give no heed to the gnarled carpentry of the awkward frame-works which carry the telegraph, and which are set askew on such dizzy corners as the course of the wires may compel. It is an arid country—if we overlook the numberless tanks that squat on the high angles of alley walls, or if we fail to see the little pools of tar and gravel that ooze and shimmer in the summer sun on the roofs of old-fashioned buildings of the humbler sort. It is an airless country—if by air we mean the mere combination of oxygen and nitrogen which is commonly indicated by that name. For here the medium of sight, sound, light, and life becomes largely carbonaceous, and the remoter peaks of this mighty yet unprepossessing landscape loom up grandly, but vaguely, through swathing mists of coal-smoke.

From such conditions as these—along with the Tacoma, the Monadnock, and a great host of other modern monsters—towers the Clifton. From the beer-hall in its basement to the barber-shop just under its roof the Clifton stands full eighteen stories tall. Its hundreds of windows glitter with multitudinous letterings in gold and in silver, and on summer afternoons its awnings flutter score on score in the tepid breezes that sometimes come up from Indiana. Four ladder-like constructions which rise skyward stage by stage promote the agility of the clambering hordes that swarm within it, and ten elevators—devices unknown to the real, aboriginal inhabitants—ameliorate the daily cliff-climbing for the frail of physique and the pressed for time.

The tribe inhabiting the Clifton is large and rather heterogeneous. All told, it numbers about four thousand souls. It includes bankers, capitalists, lawyers, "promoters"; brokers in bonds, stocks, pork, oil, mortgages; real-estate people and railroad people and insurance people—life, fire, marine, accident; a host of principals, agents, middlemen, clerks, cashiers, stenographers, and errand-boys; and the necessary force of engineers, janitors, scrub-women, and elevator-hands.

All these thousands gather daily around their own great camp-fire. This fire heats the four big boilers under the pavement of the court which lies just behind, and it sends aloft a vast plume of smoke to mingle with those of other like communities that are settled round about. These same thousands may also gather—in instalments—at their tribal feast, for the Clifton has its own lunch-counter just off one corner of the grand court, as well as a restaurant several floors higher up. The members of the tribe may also smoke the pipe of peace among themselves whenever so minded, for the Clifton has its own cigar-stand just within the principal entrance. Newspapers and periodicals, too, are sold at the same place. The warriors may also communicate their messages, hostile or friendly, to chiefs more or less remote; for there is a telegraph office in the corridor and a squad of messenger-boys in wait close by.

In a word, the Clifton aims to be complete within itself, and it will be unnecessary for us to go afield either far or frequently during the present simple succession of brief episodes in the lives of the Cliff-dwellers.

""")






