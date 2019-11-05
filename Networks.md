<style>


.reveal section p {
  color: black;
  font-size: .7em;
  font-family: 'Helvetica'; #this is the font/color of text in slides
}


.section .reveal .state-background {
    background: white;}
.section .reveal h1,
.section .reveal p {
    color: black;
    position: relative;
    top: 4%;}


.wrap-url pre code {
  word-wrap:break-word;
}

</style>

Networks
========================================================
autosize: true
transition: fade

follow along with code: https://dmontagne.github.io/Data-Analytics-Teaching-Material/Networks_R_code.R 
  
Agenda:
========================================================
- Visualize a social network
- Build a topic model

Install and Load Packages
========================================================


```r
install.packages("igraph")
```


```r
library(igraph)
library(dplyr)
library(tidyverse)
```

Load in Data 
========================================================
- Data was collected through Spotify.com
- All artists on Spotify's "Today's Top Hits" playlist, and those Spotify suggests as "Related Artists"

Load in Data 
========================================================


```r
download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/Music%20Network%20Data/artist_edges.Rda?raw=true", "git_edges")
load("git_edges")

download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/Music%20Network%20Data/vertices_info.Rda?raw=true", "git_vertices")
load("git_vertices")
```

Make Network Object
========================================================

```r
artist_network <- graph.data.frame(artist_edges[, -1], directed=F) # , vertices=vertices_info
```


Visualize Network 
========================================================


```r
# Let's plot our network
plot(artist_network,
     layout = layout.fruchterman.reingold(artist_network),
     vertex.size = .5,
     vertex.label = V(artist_network)$simple_labels)
```

Visualize Network 
========================================================

![plot of chunk unnamed-chunk-6](Networks-figure/unnamed-chunk-6-1.png)

Visualize Network 
========================================================
- That looked bad

Visualize Network 
========================================================
- Let's filter by degree
- Info we need:

```r
degree(artist_network)
V(artist_network)$name
```

Visualize Network 
========================================================


```r
V(artist_network)$simple_labels <- ifelse(
  # If an artist's degree is less than 20, don't give it a label (`NA`)
  degree(artist_network) < 20, NA, 
  # If an artist's degree is 20 or more, however, label it with the artist's
  # name (stored in `V(artist_network)$name`)
  V(artist_network)$name)
```

Visualize Network (again)
========================================================


```r
plot(artist_network,
     layout = layout.fruchterman.reingold(artist_network),
     vertex.size = 1,
     vertex.label = V(artist_network)$simple_labels)
```

Visualize Network (again)
========================================================

![plot of chunk unnamed-chunk-10](Networks-figure/unnamed-chunk-10-1.png)

Individual Level Measures (vertices)
========================================================


```r
betweenness(artist_network, v = V(artist_network), directed = F)
```

```
                Post Malone                  Young Thug 
               1.884683e+04                1.660601e+04 
                  Sam Smith                Shawn Mendes 
               1.953122e+04                2.647440e+03 
             Camila Cabello               Lewis Capaldi 
               8.833829e+03                1.364750e+04 
              Ariana Grande                Social House 
               1.578434e+04                1.562469e+04 
               Taylor Swift                  Ed Sheeran 
               7.176686e+03                9.270005e+03 
                     Khalid                   Lil Tecca 
               2.944932e+04                7.506658e+03 
                Tones and I               Billie Eilish 
               1.900000e+02                2.117403e+04 
              Justin Bieber                       Bazzi 
               5.001914e+03                1.869479e+04 
                       Lauv                  Anne-Marie 
               3.009735e+04                1.278464e+04 
                Miley Cyrus                       Lizzo 
               1.878086e+04                1.317622e+04 
        Megan Thee Stallion                 Nicki Minaj 
               1.049289e+04                3.657151e+04 
              Ty Dolla $ign                 Chris Brown 
               1.873563e+04                7.756268e+03 
                      Drake            The Chainsmokers 
               2.654761e+04                2.035613e+04 
                   ILLENIUM               Lennon Stella 
               1.227400e+04                8.932369e+03 
     A Boogie Wit da Hoodie                     Normani 
               7.194964e+03                1.371706e+04 
                   DJ Snake                    J Balvin 
               8.493284e+03                9.262402e+02 
                       Tyga                   Ali Gatie 
               9.088344e+03                2.283207e+04 
                         NF                   Lil Nas X 
               1.950584e+04                5.416962e+03 
                      bbno$                  Katy Perry 
               1.117911e+04                9.857603e+03 
                   Anuel AA                Daddy Yankee 
               4.442167e+02                4.530000e+02 
                    KAROL G                       Ozuna 
               3.642113e+02                3.547122e+02 
                   Labrinth                     Zendaya 
               1.558332e+04                1.163750e+04 
                 Marshmello                  Kane Brown 
               2.670346e+04                3.830000e+02 
             Ellie Goulding                  Juice WRLD 
               1.991466e+04                5.668471e+03 
                  Rick Ross               Jeremy Zucker 
               9.973826e+03                3.530417e+04 
        5 Seconds of Summer                Charlie Puth 
               3.359151e+03                3.294792e+03 
              Alec Benjamin                Maren Morris 
               6.542229e+03                3.830000e+02 
             Dermot Kennedy             Billy Ray Cyrus 
               9.327147e+03                1.900000e+02 
                  Sam Feldt            Kelsea Ballerini 
               7.272458e+03                4.565000e+02 
                       Kygo             Whitney Houston 
               6.552082e+03                1.227400e+04 
                      Mabel               Martin Garrix 
               1.317988e+04                1.139577e+04 
                 Macklemore                Fall Out Boy 
               1.020844e+04                1.900000e+02 
                OneRepublic                 Huncho Jack 
               1.227400e+04                3.036250e+02 
               Metro Boomin                Rae Sremmurd 
               1.534715e+03                0.000000e+00 
                      Migos                       Quavo 
               0.000000e+00                2.440416e+03 
               Lil Uzi Vert                   Lil Skies 
               2.002920e+02                3.159726e+02 
                Kodak Black                       6LACK 
               1.250236e+02                4.840303e+03 
                   Lil Pump                    PnB Rock 
               0.000000e+00                2.407042e+02 
                  Desiigner                Travis Scott 
               0.000000e+00                0.000000e+00 
            Quality Control                  Lil Yachty 
               0.000000e+00                6.410615e+02 
                  Fetty Wap                     6ix9ine 
               0.000000e+00                0.000000e+00 
              gianni & kyle                         NAV 
               3.156399e+04                3.445389e+03 
                  Lil Gotit                    Lil Keed 
               0.000000e+00                5.183103e+02 
                  MadeinTYO                  Famous Dex 
               3.374365e+02                3.374365e+02 
                      Gunna                    A$AP Mob 
               0.000000e+00                0.000000e+00 
              Playboi Carti                  Young Nudy 
               0.000000e+00                0.000000e+00 
             Pi’erre Bourne                   21 Savage 
               5.183103e+02                0.000000e+00 
                    Takeoff           Mike WiLL Made-It 
               0.000000e+00                0.000000e+00 
                      Tay-K                 Don Toliver 
               0.000000e+00                0.000000e+00 
                    G Herbo                    James TW 
               0.000000e+00                2.155702e+01 
               Alessia Cara                        ZAYN 
               6.395643e+03                1.241083e+03 
               James Arthur                 Niall Horan 
               1.272000e+04                7.377845e+01 
                Calum Scott                   James Bay 
               2.155702e+01                2.155702e+01 
                Gavin James                   JP Cooper 
               1.863064e+03                2.155702e+01 
                Jess Glynne              Julia Michaels 
               7.005871e+03                6.564081e+03 
                The Mayries                       Birdy 
               0.000000e+00                0.000000e+00 
               Zara Larsson                  Liam Payne 
               1.237585e+03                1.961328e+02 
              Alex & Sierra                 Troye Sivan 
               0.000000e+00                1.262325e+03 
                       DNCE               Fifth Harmony 
               5.421973e+01                8.183084e+03 
               Harry Styles                Selena Gomez 
               1.433823e+02                8.342069e+02 
                Demi Lovato                  PRETTYMUCH 
               3.077813e+02                6.887589e+02 
                  The Vamps               One Direction 
               2.075705e+01                7.640184e-01 
                 Dinah Jane             Lauren Jauregui 
               2.013338e+02                0.000000e+00 
                Ally Brooke                     Pia Mia 
               0.000000e+00                6.322476e+03 
               Madison Beer              Riverdale Cast 
               9.813694e+03                0.000000e+00 
                 Bea Miller                  Rhys Lewis 
               4.944895e+03                0.000000e+00 
           Declan J Donovan                     Plested 
               0.000000e+00                0.000000e+00 
              Maisie Peters                  Dean Lewis 
               0.000000e+00                2.048929e+03 
                  Juke Ross                Grace Carter 
               0.000000e+00                1.094404e+03 
              Freya Ridings                  Noah Kahan 
               0.000000e+00                2.048929e+03 
               Picture This                  Tom Walker 
               0.000000e+00                0.000000e+00 
             Ella Henderson                 Mitch James 
               6.994685e+03                0.000000e+00 
                Tom Grennan            Hailee Steinfeld 
               0.000000e+00                4.100032e+02 
                   Dua Lipa                      Halsey 
               1.108836e+02                2.986284e+02 
                 Little Mix                    Rita Ora 
               0.000000e+00                3.966962e+02 
   Selena Gomez & The Scene                  Quinn XCII 
               5.517580e+01                0.000000e+00 
                 Bryce Vine            Christian French 
               2.851641e+03                0.000000e+00 
              Anthony Russo                   Souly Had 
               0.000000e+00                0.000000e+00 
                   mansionz               Marc E. Bassy 
               0.000000e+00                2.104748e+03 
                 Tayla Parx              Victoria Monét 
               0.000000e+00                0.000000e+00 
                Jon Bellion            Luke Christopher 
               2.851641e+03                2.851641e+03 
               Cashmere Cat                      Zandhr 
               0.000000e+00                0.000000e+00 
                     Njomza              Chelsea Cutler 
               0.000000e+00                3.881331e+03 
                 Kiana Ledé              Meghan Trainor 
               5.851563e+02                2.613564e+00 
           Carly Rae Jepsen              Kelly Clarkson 
               2.714342e+02                2.714342e+02 
           Carrie Underwood                       Lorde 
               0.000000e+00                5.462211e+02 
             Rachel Platten                        Ruel 
               0.000000e+00                1.585289e+02 
                  blackbear             Sabrina Claudio 
               0.000000e+00                2.076065e+02 
               Jessie Reyez                     Kehlani 
               5.246422e+03                8.394393e+02 
                     H.E.R.               Summer Walker 
               0.000000e+00                0.000000e+00 
                   Ella Mai                 Alina Baraz 
               0.000000e+00                0.000000e+00 
              Daniel Caesar                benny blanco 
               0.000000e+00                4.067190e+04 
                  Roy Woods              Olivia O'Brien 
               1.403020e+04                2.661287e+02 
                  YK Osiris                 Roddy Ricch 
               1.069805e+04                0.000000e+00 
                  Yung Tory                      DaBaby 
               0.000000e+00                0.000000e+00 
                   Blueface                   YNW Melly 
               2.150286e+01                0.000000e+00 
                   Lil Tjay                   Lil Mosey 
               0.000000e+00                3.354568e+01 
                 YBN Cordae                Flipp Dinero 
               2.150286e+01                3.354568e+01 
               Quando Rondo                      Polo G 
               0.000000e+00                0.000000e+00 
                Comethazine            Smooky MarGielaa 
               2.150286e+01                0.000000e+00 
                 Yung Pinch                      G Flip 
               0.000000e+00                0.000000e+00 
                Thelma Plum                        KIAN 
               0.000000e+00                0.000000e+00 
               Eves Karydas               Thundamentals 
               0.000000e+00                0.000000e+00 
                     Allday                   Vera Blue 
               0.000000e+00                0.000000e+00 
                    Meg Mac                  The Rubens 
               0.000000e+00                0.000000e+00 
                      BENEE                  Jack River 
               0.000000e+00                0.000000e+00 
                     Odette                  Peking Duk 
               0.000000e+00                0.000000e+00 
                       Illy                   Amy Shark 
               0.000000e+00                0.000000e+00 
                     GRAACE                 Ruby Fields 
               0.000000e+00                0.000000e+00 
                      SAFIA                     Mallrat 
               0.000000e+00                0.000000e+00 
                  Cub Sport               King Princess 
               0.000000e+00                3.271117e+02 
           Melanie Martinez                    Cavetown 
               0.000000e+00                0.000000e+00 
                      gnash           Rex Orange County 
               2.090840e+04                0.000000e+00 
                 Conan Gray                     FINNEAS 
               0.000000e+00                0.000000e+00 
                    mxmtoon                Cody Simpson 
               0.000000e+00                2.849469e+00 
              Austin Mahone                  Nick Jonas 
               2.849469e+00                1.356826e+02 
                Jack & Jack                Ansel Elgort 
               0.000000e+00                0.000000e+00 
               Why Don't We          Charlotte Lawrence 
               0.000000e+00                1.466654e+03 
           Maggie Lindemann                 Sasha Sloan 
               7.690460e+02                1.707232e+03 
              Carlie Hanson                    FLETCHER 
               9.839376e+01                9.839376e+01 
                      Loote                      Wrabel 
               0.000000e+00                0.000000e+00 
                       NOTD                   Ella Eyre 
               0.000000e+00                7.990065e+02 
                 Rudimental                Nina Nesbitt 
               0.000000e+00                1.494767e+03 
                 Bebe Rexha                       Kesha 
               0.000000e+00                0.000000e+00 
             Hannah Montana              Ashley Tisdale 
               0.000000e+00                0.000000e+00 
                Hilary Duff           The Cheetah Girls 
               0.000000e+00                0.000000e+00 
            Bridgit Mendler             Victorious Cast 
               6.042000e+03                6.042000e+03 
              Avril Lavigne                  Cher Lloyd 
               0.000000e+00                2.453747e+02 
                   Aly & AJ                   Glee Cast 
               0.000000e+00                0.000000e+00 
                     Fergie              Jonas Brothers 
               3.888702e+03                0.000000e+00 
                   Doja Cat                  Rico Nasty 
               0.000000e+00                0.000000e+00 
                The Carters                 Qveen Herby 
               1.316863e+03                7.583080e+02 
                   cupcakKe                   Leikeli47 
               5.585547e+02                0.000000e+00 
              Chloe x Halle               Janelle Monáe 
               7.583080e+02                0.000000e+00 
                        SZA                Tierra Whack 
               5.585547e+02                0.000000e+00 
                    Solange                      WILLOW 
               0.000000e+00                0.000000e+00 
                 Charli XCX                Jamila Woods 
               3.591655e+03                0.000000e+00 
              Azealia Banks                  Kim Petras 
               5.585547e+02                0.000000e+00 
              Maggie Rogers                  Kali Uchis 
               0.000000e+00                0.000000e+00 
                Molly Brazy                   Kash Doll 
               0.000000e+00                0.000000e+00 
                  Queen Key                  Asian Doll 
               0.000000e+00                0.000000e+00 
                  Bali Baby                  Cuban Doll 
               0.000000e+00                0.000000e+00 
             Maliibu Miitch                      Dreezy 
               0.000000e+00                0.000000e+00 
                   BbyMutha                 Junglepussy 
               0.000000e+00                0.000000e+00 
                      Melii                  City Girls 
               0.000000e+00                0.000000e+00 
                  Kari Faux                     Mulatto 
               0.000000e+00                0.000000e+00 
                 Tokyo Jetz                       Trina 
               0.000000e+00                5.213780e+03 
              Tommy Genesis                 Iggy Azalea 
               0.000000e+00                0.000000e+00 
                    Rihanna                Stefflon Don 
               0.000000e+00                1.718456e+03 
                      Ciara                     Cardi B 
               1.546902e+03                0.000000e+00 
              Kelly Rowland                     Jeremih 
               0.000000e+00                2.438389e+04 
                 Trey Songz                 Keri Hilson 
               1.546902e+03                0.000000e+00 
                   Lil' Kim                     Kid Ink 
               0.000000e+00                5.599798e+01 
                 Tory Lanez               August Alsina 
               0.000000e+00                0.000000e+00 
                      Preme                        Wale 
               0.000000e+00                5.734217e+02 
                Kirko Bangz                    Jacquees 
               0.000000e+00                0.000000e+00 
             French Montana                    DJ Drama 
               0.000000e+00                5.734217e+02 
                Young Money              Eric Bellinger 
               5.734217e+02                0.000000e+00 
            Sage The Gemini                      K CAMP 
               0.000000e+00                0.000000e+00 
              PARTYNEXTDOOR                     Omarion 
               0.000000e+00                0.000000e+00 
                     Iamsu!               Bryson Tiller 
               0.000000e+00                0.000000e+00 
                    Mustard                       Mario 
               0.000000e+00                0.000000e+00 
                      Ne-Yo                       Lloyd 
               0.000000e+00                0.000000e+00 
                     T-Pain                Pretty Ricky 
               5.599798e+01                0.000000e+00 
                      Usher                   The-Dream 
               0.000000e+00                0.000000e+00 
                    Bow Wow                    Jay Sean 
               0.000000e+00                0.000000e+00 
                 Pleasure P                Keyshia Cole 
               0.000000e+00                0.000000e+00 
                   Big Sean                     J. Cole 
               0.000000e+00                0.000000e+00 
                   2 Chainz                   Meek Mill 
               0.000000e+00                0.000000e+00 
                  DJ Khaled                      Miguel 
               0.000000e+00                0.000000e+00 
                     Future                  Gucci Mane 
               0.000000e+00                0.000000e+00 
                  Lil Wayne               Martin Jensen 
               0.000000e+00                3.162500e+01 
                 Mike Perry                 Loud Luxury 
               3.162500e+01                3.624589e+03 
                     Matoma                 Cheat Codes 
               3.162500e+01                3.624589e+03 
                 Lost Kings                  Jonas Blue 
               0.000000e+00                0.000000e+00 
                     Sigala                     Gryffin 
               7.264250e+03                0.000000e+00 
           Lost Frequencies                   Cash Cash 
               0.000000e+00                0.000000e+00 
                Felix Jaehn                    Galantis 
               0.000000e+00                0.000000e+00 
                       Zedd                      Alesso 
               0.000000e+00                1.520855e+03 
              William Black                       Nurko 
               0.000000e+00                0.000000e+00 
                    ARMNHMR                       Dabin 
               0.000000e+00                0.000000e+00 
                      Skrux                     Slushii 
               0.000000e+00                0.000000e+00 
               Said the Sky                 Seven Lions 
               0.000000e+00                0.000000e+00 
                Win and Woo                       Kasbo 
               0.000000e+00                0.000000e+00 
               Manila Killa                    Jai Wolf 
               0.000000e+00                0.000000e+00 
                    Crywolf                 Taska Black 
               0.000000e+00                0.000000e+00 
                      Ekali                      Kaivon 
               0.000000e+00                0.000000e+00 
                    DROELOE                        SMLE 
               0.000000e+00                0.000000e+00 
                     1788-L                       Vanic 
               0.000000e+00                0.000000e+00 
             Lennon & Maisy              Nashville Cast 
               0.000000e+00                0.000000e+00 
                  Ivy Adara                       bülow 
               0.000000e+00                7.029583e+01 
                   Robinson                        EXES 
               0.000000e+00                0.000000e+00 
                       LÉON                    Ella Vos 
               0.000000e+00                0.000000e+00 
                     Shoffy                  Noah Cyrus 
               0.000000e+00                0.000000e+00 
                     Valley                     JP Saxe 
               0.000000e+00                1.279237e+03 
 YoungBoy Never Broke Again                Trippie Redd 
               0.000000e+00                1.204282e+01 
                     Calboy                 Yungeen Ace 
               0.000000e+00                0.000000e+00 
                  iann dior                      88GLAM 
               0.000000e+00                0.000000e+00 
               Tee Grizzley                    Lil Baby 
               0.000000e+00                0.000000e+00 
                 YBN Nahmir                Rich The Kid 
               1.204282e+01                0.000000e+00 
                    Tinashe                Justine Skye 
               0.000000e+00                0.000000e+00 
                  Dumblonde                 Keke Palmer 
               0.000000e+00                0.000000e+00 
                     Asiahn              Yung Baby Tate 
               0.000000e+00                0.000000e+00 
               Dawn Richard                        RAYE 
               0.000000e+00                5.657184e+02 
                   Afrojack              Dillon Francis 
               0.000000e+00                0.000000e+00 
                Yellow Claw                       Diplo 
               0.000000e+00                0.000000e+00 
                     Deorro                 Major Lazer 
               4.400000e+01                0.000000e+00 
                      R3HAB                  Don Diablo 
               4.400000e+01                4.400000e+01 
                       Jauz            Good Times Ahead 
               0.000000e+00                0.000000e+00 
  Dimitri Vegas & Like Mike                       DVBBS 
               4.400000e+01                0.000000e+00 
                     Jack Ü                  Steve Aoki 
               0.000000e+00                0.000000e+00 
                Party Favor              Oliver Heldens 
               0.000000e+00                0.000000e+00 
                     Tujamo                      Reykon 
               0.000000e+00                6.190476e+01 
                    Farruko                   J Alvarez 
               2.775000e+01                0.000000e+00 
              Zion & Lennox                       Wisin 
               2.775000e+01                2.775000e+01 
                   Arcangel               Alexis y Fido 
               2.775000e+01                2.775000e+01 
               De La Ghetto                 Danny Ocean 
               2.775000e+01                1.342095e+02 
                     Maluma                   Nicky Jam 
               0.000000e+00                2.775000e+01 
              Manuel Turizo                      Yandel 
               2.676997e+02                2.775000e+01 
                Cosculluela                       Fuego 
               2.775000e+01                0.000000e+00 
                       Ñejo              Jowell & Randy 
               2.775000e+01                2.775000e+01 
                  Tony Dize                       Lunay 
               2.775000e+01                2.676997e+02 
                    Piso 21           Waka Flocka Flame 
               0.000000e+00                0.000000e+00 
                Wiz Khalifa               Travis Porter 
               0.000000e+00                0.000000e+00 
                   Yo Gotti                    Ace Hood 
               0.000000e+00                0.000000e+00 
                    Juicy J                          YG 
               0.000000e+00                0.000000e+00 
                  Sik World                       Phora 
               8.202412e+02                0.000000e+00 
                     Marvin                 Toni Romiti 
               0.000000e+00                0.000000e+00 
                       ASTN                       Ollie 
               4.793184e+02                8.202412e+02 
                     Smiley                    K-Clique 
               0.000000e+00                0.000000e+00 
                   Yo Trane               Trevor Daniel 
               0.000000e+00                0.000000e+00 
           Drumma Battalion                Mark Diamond 
               0.000000e+00                0.000000e+00 
                    Luh Kel              SadBoyProlific 
               0.000000e+00                0.000000e+00 
                       eli.                   Leek Jack 
               0.000000e+00                0.000000e+00 
                 Reo Cragun               Tom MacDonald 
               0.000000e+00                0.000000e+00 
                  Lucidious                  Witt Lowry 
               0.000000e+00                0.000000e+00 
               Ryan Caraveo                     Bazanji 
               0.000000e+00                0.000000e+00 
               Justin Stone                       Token 
               0.000000e+00                0.000000e+00 
                   Jez Dior                      Josh A 
               0.000000e+00                4.453426e+03 
                 Ryan Oakes                Joyner Lucas 
               0.000000e+00                0.000000e+00 
                   K.A.A.N.                 Chris Webby 
               0.000000e+00                1.007282e+03 
             Arizona Zervas                      Ivan B 
               0.000000e+00                0.000000e+00 
                Iamjakehill                  Futuristic 
               4.453426e+03                0.000000e+00 
     Ski Mask The Slump God                      Offset 
               0.000000e+00                0.000000e+00 
                 Yung Gravy           Billy Marchiafava 
               2.748140e+03                0.000000e+00 
                  Joey Trap                   Roy Purdy 
               0.000000e+00                0.000000e+00 
              Bandingo YGNE                      Dbangz 
               0.000000e+00                0.000000e+00 
                      Jakey              Tiny Meat Gang 
               0.000000e+00                0.000000e+00 
                Oliver Tree                   Shakewell 
               0.000000e+00                0.000000e+00 
                     Fukkit                 Terror Reid 
               0.000000e+00                0.000000e+00 
                  Craig Xen                       Aries 
               0.000000e+00                0.000000e+00 
             Hovey Benjamin               Freddie Dredd 
               0.000000e+00                0.000000e+00 
                     6 Dogs              Oliver Francis 
               0.000000e+00                0.000000e+00 
             Britney Spears                Gwen Stefani 
               0.000000e+00                0.000000e+00 
                   Jessie J               The Veronicas 
               0.000000e+00                0.000000e+00 
         The Pussycat Dolls               Jordin Sparks 
               0.000000e+00                0.000000e+00 
              The Saturdays          Christina Aguilera 
               0.000000e+00                0.000000e+00 
                Leona Lewis                  Nio Garcia 
               1.272000e+04                1.345098e+00 
                  Bad Bunny                    Brytiago 
               1.345098e+00                1.345098e+00 
                    Rvssian                       Jon Z 
               0.000000e+00                0.000000e+00 
               Bryant Myers                 Myke Towers 
               1.345098e+00                1.345098e+00 
                  Lary Over                 Lalo Ebratt 
               1.345098e+00                0.000000e+00 
                Chris Jeday                 Mau y Ricky 
               1.345098e+00                1.345098e+00 
                  Alex Rose                Kevin Roldan 
               0.000000e+00                1.345098e+00 
                 Miky Woodz               Casper Magico 
               0.000000e+00                0.000000e+00 
                   DJ Luian                   Kenny Man 
               0.000000e+00                0.000000e+00 
                Trebol Clan           Tito "El Bambino" 
               0.000000e+00                0.000000e+00 
                  Ivy Queen               Tego Calderon 
               0.000000e+00                0.000000e+00 
                   Don Omar              Wisin & Yandel 
               0.000000e+00                0.000000e+00 
                 Luny Tunes                        Zion 
               0.000000e+00                0.000000e+00 
                    Greeicy                       Nacho 
               0.000000e+00                0.000000e+00 
            Sebastian Yatra                        CNCO 
               0.000000e+00                0.000000e+00 
             Mario Bautista               Chyno Miranda 
               0.000000e+00                0.000000e+00 
                      Cazzu                    Amenazzy 
               0.000000e+00                0.000000e+00 
             Tinchy Stryder                Tinie Tempah 
               0.000000e+00                0.000000e+00 
                        LSD             Professor Green 
               0.000000e+00                0.000000e+00 
                   DJ Fresh                      N-Dubz 
               0.000000e+00                0.000000e+00 
                Emeli Sandé                   Wretch 32 
               0.000000e+00                0.000000e+00 
                      Dappy                     Example 
               0.000000e+00                0.000000e+00 
               Rizzle Kicks                         JLS 
               0.000000e+00                0.000000e+00 
                  Olly Murs                      Plan B 
               1.530498e+03                0.000000e+00 
              Lethal Bizzle          Scouting For Girls 
               0.000000e+00                0.000000e+00 
         China Anne McClain             McClain Sisters 
               0.000000e+00                0.000000e+00 
                 Ross Lynch                   Rags Cast 
               0.000000e+00                0.000000e+00 
               Bella Thorne                Laura Marano 
               0.000000e+00                0.000000e+00 
                 Debby Ryan Disney's Friends For Change 
               0.000000e+00                0.000000e+00 
               Sofia Carson                 Olivia Holt 
               0.000000e+00                0.000000e+00 
                Austin Moon                 Drew Seeley 
               0.000000e+00                0.000000e+00 
            Kyra Christiaan            Miranda Cosgrove 
               0.000000e+00                0.000000e+00 
       Tyler James Williams                  Coco Jones 
               0.000000e+00                0.000000e+00 
                Corbin Bleu                  The GGGG's 
               0.000000e+00                0.000000e+00 
                   San Holo                       KREAM 
               0.000000e+00                3.162500e+01 
                Dylan Scott                Jordan Davis 
               0.000000e+00                0.000000e+00 
              Morgan Wallen                  Dan + Shay 
               0.000000e+00                0.000000e+00 
                Michael Ray                  Luke Combs 
               0.000000e+00                0.000000e+00 
                 Seth Ennis                Devin Dawson 
               0.000000e+00                0.000000e+00 
               Jon Langston                   Ryan Hurd 
               0.000000e+00                0.000000e+00 
          James Barker Band             Dylan Schneider 
               0.000000e+00                0.000000e+00 
              Cole Swindell                Old Dominion 
               0.000000e+00                0.000000e+00 
          Mitchell Tenpenny                Dustin Lynch 
               0.000000e+00                0.000000e+00 
                 Chris Lane                      LOCASH 
               0.000000e+00                0.000000e+00 
               Maddie & Tae                      MARINA 
               6.050000e+01                0.000000e+00 
               Paloma Faith                  The Wanted 
               0.000000e+00                0.000000e+00 
            Christina Perri                 Mark Ronson 
               0.000000e+00                0.000000e+00 
                  Cooliecut                  Smokepurpp 
               0.000000e+00                0.000000e+00 
               Wifisfuneral                    Ugly God 
               0.000000e+00                0.000000e+00 
                    Ronny J                   Jim Jones 
               0.000000e+00                0.000000e+00 
                   Curren$y                     Birdman 
               0.000000e+00                0.000000e+00 
                   Fabolous                       Jeezy 
               0.000000e+00                0.000000e+00 
                      Bun B               Juelz Santana 
               0.000000e+00                0.000000e+00 
                  Slim Thug                   Young Dro 
               0.000000e+00                0.000000e+00 
                Lloyd Banks                Beanie Sigel 
               0.000000e+00                0.000000e+00 
                 Young Buck               The Diplomats 
               0.000000e+00                0.000000e+00 
                     Webbie                    Jadakiss 
               0.000000e+00                0.000000e+00 
                  Kid Quill                   Timeflies 
               1.095735e+03                0.000000e+00 
                       DYSN                Xuitcasecity 
               0.000000e+00                0.000000e+00 
                Oliver Riot                      ayokay 
               0.000000e+00                0.000000e+00 
            Louis Tomlinson              Hot Chelle Rae 
               1.559496e+00                0.000000e+00 
              Big Time Rush               New Hope Club 
               0.000000e+00                1.367251e+02 
                       MKTO                         MAX 
               1.559496e+00                0.000000e+00 
                     Rixton                 AJ Mitchell 
               0.000000e+00                0.000000e+00 
                 Tate McRae             Anna Clendening 
               0.000000e+00                0.000000e+00 
            Christian Leave                Anson Seabra 
               0.000000e+00                0.000000e+00 
                 SHY Martin              Eli Young Band 
               0.000000e+00                0.000000e+00 
          Danielle Bradbery             Miranda Lambert 
               0.000000e+00                0.000000e+00 
                        Cam             Kacey Musgraves 
               0.000000e+00                0.000000e+00 
        Jessie James Decker                Runaway June 
               0.000000e+00                0.000000e+00 
              Lauren Alaina             Little Big Town 
               0.000000e+00                0.000000e+00 
              Pistol Annies                   Sugarland 
               0.000000e+00                0.000000e+00 
               Hunter Hayes                 Jana Kramer 
               0.000000e+00                0.000000e+00 
                    RaeLynn                Walker Hayes 
               0.000000e+00                0.000000e+00 
              Granger Smith          Jillian Jacqueline 
               0.000000e+00                0.000000e+00 
              Cassadee Pope             James Gillespie 
               0.000000e+00                0.000000e+00 
             Harrison Storm                Allman Brown 
               0.000000e+00                0.000000e+00 
             George Ogilvie                Riley Pearce 
               0.000000e+00                0.000000e+00 
                Wild Rivers                Hollow Coves 
               0.000000e+00                0.000000e+00 
              Henry Jamison                   Ed Prosek 
               0.000000e+00                0.000000e+00 
             Dustin Tebbutt             Old Sea Brigade 
               0.000000e+00                0.000000e+00 
         Charlie Cunningham               Ryan McMullan 
               0.000000e+00                0.000000e+00 
               Blanco White                 Diamond Rio 
               0.000000e+00                0.000000e+00 
               Little Texas               Mark Chesnutt 
               0.000000e+00                0.000000e+00 
                Collin Raye               Sammy Kershaw 
               0.000000e+00                0.000000e+00 
                 Joe Diffie                 Clay Walker 
               0.000000e+00                0.000000e+00 
               Randy Travis                Aaron Tippin 
               0.000000e+00                0.000000e+00 
                   Lonestar                  Shenandoah 
               0.000000e+00                0.000000e+00 
               Sawyer Brown             Trisha Yearwood 
               0.000000e+00                0.000000e+00 
          Daryle Singletary               Brooks & Dunn 
               0.000000e+00                0.000000e+00 
               Trace Adkins                  Tracy Byrd 
               0.000000e+00                0.000000e+00 
                Clint Black                Travis Tritt 
               0.000000e+00                0.000000e+00 
    John Michael Montgomery                   Klingande 
               0.000000e+00                0.000000e+00 
            Charming Horses                 Alex Schulz 
               0.000000e+00                0.000000e+00 
                      Kungs              Campsite Dream 
               0.000000e+00                0.000000e+00 
            GAMPER & DADONI                      filous 
               0.000000e+00                0.000000e+00 
                  LVNDSCAPE                        Möwe 
               0.000000e+00                0.000000e+00 
              Mike Williams                     The Him 
               1.057429e+02                0.000000e+00 
                Deep Chills                   Y.V.E. 48 
               0.000000e+00                0.000000e+00 
          Catherine McGrath                       LANCO 
               0.000000e+00                0.000000e+00 
               Carly Pearce          Tungevaag & Raaban 
               0.000000e+00                0.000000e+00 
              Lucas Estrada                Robin Schulz 
               0.000000e+00                0.000000e+00 
                  Jax Jones                    Syn Cole 
               3.605949e+03                1.410959e+02 
               Toni Braxton               Janet Jackson 
               0.000000e+00                0.000000e+00 
                   En Vogue                      Brandy 
               0.000000e+00                0.000000e+00 
            Jennifer Hudson                Mariah Carey 
               0.000000e+00                0.000000e+00 
            Luther Vandross                      Monica 
               0.000000e+00                0.000000e+00 
                Céline Dion                       Tamia 
               0.000000e+00                0.000000e+00 
              Patti LaBelle                 Paula Abdul 
               0.000000e+00                0.000000e+00 
                        TLC                  Diana Ross 
               0.000000e+00                0.000000e+00 
                Deborah Cox                Peabo Bryson 
               0.000000e+00                0.000000e+00 
              Lionel Richie                 Tina Turner 
               0.000000e+00                0.000000e+00 
                       Cher                       WSTRN 
               0.000000e+00                0.000000e+00 
                        M.O                      Rak-Su 
               0.000000e+00                0.000000e+00 
               Anton Powers                      Blonde 
               0.000000e+00                0.000000e+00 
                       Ramz                  Becky Hill 
               0.000000e+00                0.000000e+00 
                      Not3s                        M-22 
               0.000000e+00                0.000000e+00 
                   Astrid S                        MNEK 
               0.000000e+00                0.000000e+00 
                     Yungen                   Yxng Bane 
               0.000000e+00                0.000000e+00 
                   Zak Abel               Steel Banglez 
               0.000000e+00                0.000000e+00 
                     AREA21                      Brooks 
               0.000000e+00                0.000000e+00 
              Lucas & Steve                    Borgeous 
               0.000000e+00                0.000000e+00 
                      KAAZE                       KSHMR 
               0.000000e+00                0.000000e+00 
                        GRX                 Jay Hardway 
               0.000000e+00                0.000000e+00 
               Nicky Romero                      Yves V 
               0.000000e+00                0.000000e+00 
                  DubVision                Madison Mars 
               0.000000e+00                0.000000e+00 
                   Hardwell     Macklemore & Ryan Lewis 
               0.000000e+00                0.000000e+00 
                    SonReal                  Classified 
               0.000000e+00                0.000000e+00 
               Hoodie Allen                 Chiddy Bang 
               0.000000e+00                0.000000e+00 
              Blue Scholars                      Watsky 
               0.000000e+00                0.000000e+00 
                Cam Meekins                   Lil Dicky 
               0.000000e+00                0.000000e+00 
                Sammy Adams                    E-Dubble 
               0.000000e+00                0.000000e+00 
                    Grieves                 Skizzy Mars 
               0.000000e+00                0.000000e+00 
                Mike Posner                         Sol 
               0.000000e+00                0.000000e+00 
        Panic! At The Disco         My Chemical Romance 
               0.000000e+00                0.000000e+00 
               All Time Low    The All-American Rejects 
               0.000000e+00                0.000000e+00 
               We The Kings             Boys Like Girls 
               0.000000e+00                0.000000e+00 
             Good Charlotte               Mayday Parade 
               0.000000e+00                0.000000e+00 
                  The Maine                  Yellowcard 
               0.000000e+00                0.000000e+00 
                    The Cab                     Anarbor 
               0.000000e+00                0.000000e+00 
              You Me At Six                    Paramore 
               0.000000e+00                0.000000e+00 
   Forever The Sickest Kids              Cobra Starship 
               0.000000e+00                0.000000e+00 
            Marianas Trench                       3OH!3 
               0.000000e+00                0.000000e+00 
 The Red Jumpsuit Apparatus                 Simple Plan 
               0.000000e+00                0.000000e+00 
                 The Script                    The Fray 
               0.000000e+00                0.000000e+00 
           American Authors                  Neon Trees 
               0.000000e+00                0.000000e+00 
           Phillip Phillips                    Maroon 5 
               0.000000e+00                0.000000e+00 
                  Lifehouse                   Parachute 
               0.000000e+00                0.000000e+00 
               Gavin DeGraw                    Owl City 
               0.000000e+00                0.000000e+00 
                Snow Patrol             Plain White T's 
               0.000000e+00                0.000000e+00 
                Mat Kearney                Andy Grammer 
               0.000000e+00                0.000000e+00 
          Five For Fighting             Imagine Dragons 
               0.000000e+00                0.000000e+00 
                      Keane               WALK THE MOON 
               0.000000e+00                0.000000e+00 
                   Daughtry 
               0.000000e+00 
```

```r
closeness(artist_network, v = V(artist_network))
```

```
                Post Malone                  Young Thug 
               7.235576e-06                7.225016e-06 
                  Sam Smith                Shawn Mendes 
               7.271247e-06                7.270612e-06 
             Camila Cabello               Lewis Capaldi 
               7.275796e-06                7.254683e-06 
              Ariana Grande                Social House 
               7.273045e-06                7.270242e-06 
               Taylor Swift                  Ed Sheeran 
               7.263430e-06                7.264485e-06 
                     Khalid                   Lil Tecca 
               7.283639e-06                7.212509e-06 
                Tones and I               Billie Eilish 
               1.522487e-06                7.275479e-06 
              Justin Bieber                       Bazzi 
               7.264696e-06                7.282685e-06 
                       Lauv                  Anne-Marie 
               7.284064e-06                7.269397e-06 
                Miley Cyrus                       Lizzo 
               7.252841e-06                7.244172e-06 
        Megan Thee Stallion                 Nicki Minaj 
               7.223763e-06                7.274103e-06 
              Ty Dolla $ign                 Chris Brown 
               7.252210e-06                7.231704e-06 
                      Drake            The Chainsmokers 
               7.247060e-06                7.247480e-06 
                   ILLENIUM               Lennon Stella 
               7.215736e-06                7.257842e-06 
     A Boogie Wit da Hoodie                     Normani 
               7.211937e-06                7.271987e-06 
                   DJ Snake                    J Balvin 
               7.186748e-06                1.596042e-06 
                       Tyga                   Ali Gatie 
               7.240186e-06                7.252368e-06 
                         NF                   Lil Nas X 
               7.224911e-06                7.197248e-06 
                      bbno$                  Katy Perry 
               7.171852e-06                7.250843e-06 
                   Anuel AA                Daddy Yankee 
               1.596014e-06                1.595899e-06 
                    KAROL G                       Ozuna 
               1.596019e-06                1.596004e-06 
                   Labrinth                     Zendaya 
               7.240815e-06                7.188504e-06 
                 Marshmello                  Kane Brown 
               7.247952e-06                1.565406e-06 
             Ellie Goulding                  Juice WRLD 
               7.262744e-06                7.206740e-06 
                  Rick Ross               Jeremy Zucker 
               7.215268e-06                7.269344e-06 
        5 Seconds of Summer                Charlie Puth 
               7.262217e-06                7.265647e-06 
              Alec Benjamin                Maren Morris 
               7.268921e-06                1.565406e-06 
             Dermot Kennedy             Billy Ray Cyrus 
               7.225486e-06                1.522487e-06 
                  Sam Feldt            Kelsea Ballerini 
               7.222928e-06                1.565435e-06 
                       Kygo             Whitney Houston 
               7.229665e-06                7.206168e-06 
                      Mabel               Martin Garrix 
               7.262692e-06                7.217246e-06 
                 Macklemore                Fall Out Boy 
               7.219591e-06                1.522487e-06 
                OneRepublic                 Huncho Jack 
               7.211573e-06                7.213862e-06 
               Metro Boomin                Rae Sremmurd 
               7.217715e-06                7.201446e-06 
                      Migos                       Quavo 
               7.201446e-06                7.218288e-06 
               Lil Uzi Vert                   Lil Skies 
               7.205909e-06                7.206376e-06 
                Kodak Black                       6LACK 
               7.204559e-06                7.231547e-06 
                   Lil Pump                    PnB Rock 
               7.202898e-06                7.205234e-06 
                  Desiigner                Travis Scott 
               7.201446e-06                7.201446e-06 
            Quality Control                  Lil Yachty 
               7.201446e-06                7.215111e-06 
                  Fetty Wap                     6ix9ine 
               7.201446e-06                7.201446e-06 
              gianni & kyle                         NAV 
               7.253578e-06                7.218914e-06 
                  Lil Gotit                    Lil Keed 
               7.190985e-06                7.203314e-06 
                  MadeinTYO                  Famous Dex 
               7.203521e-06                7.203521e-06 
                      Gunna                    A$AP Mob 
               7.190985e-06                7.190985e-06 
              Playboi Carti                  Young Nudy 
               7.190985e-06                7.190985e-06 
             Pi’erre Bourne                   21 Savage 
               7.203314e-06                7.190985e-06 
                    Takeoff           Mike WiLL Made-It 
               7.190985e-06                7.190985e-06 
                      Tay-K                 Don Toliver 
               7.190985e-06                7.190985e-06 
                    G Herbo                    James TW 
               7.190985e-06                7.243333e-06 
               Alessia Cara                        ZAYN 
               7.277861e-06                7.270982e-06 
               James Arthur                 Niall Horan 
               7.243805e-06                7.256262e-06 
                Calum Scott                   James Bay 
               7.243333e-06                7.243333e-06 
                Gavin James                   JP Cooper 
               7.241444e-06                7.240029e-06 
                Jess Glynne              Julia Michaels 
               7.261531e-06                7.277014e-06 
                The Mayries                       Birdy 
               7.236780e-06                7.236780e-06 
               Zara Larsson                  Liam Payne 
               7.267812e-06                7.259792e-06 
              Alex & Sierra                 Troye Sivan 
               7.241706e-06                7.267495e-06 
                       DNCE               Fifth Harmony 
               7.250527e-06                7.267283e-06 
               Harry Styles                Selena Gomez 
               7.254051e-06                7.257473e-06 
                Demi Lovato                  PRETTYMUCH 
               7.255104e-06                7.262270e-06 
                  The Vamps               One Direction 
               7.246114e-06                7.241234e-06 
                 Dinah Jane             Lauren Jauregui 
               7.262481e-06                7.241287e-06 
                Ally Brooke                     Pia Mia 
               7.254578e-06                7.275849e-06 
               Madison Beer              Riverdale Cast 
               7.281306e-06                7.241287e-06 
                 Bea Miller                  Rhys Lewis 
               7.278444e-06                7.221833e-06 
           Declan J Donovan                     Plested 
               7.221833e-06                7.221833e-06 
              Maisie Peters                  Dean Lewis 
               7.221833e-06                7.257842e-06 
                  Juke Ross                Grace Carter 
               7.220373e-06                7.248688e-06 
              Freya Ridings                  Noah Kahan 
               7.220373e-06                7.257842e-06 
               Picture This                  Tom Walker 
               7.220373e-06                7.220373e-06 
             Ella Henderson                 Mitch James 
               7.253683e-06                7.220373e-06 
                Tom Grennan            Hailee Steinfeld 
               7.220373e-06                7.256210e-06 
                   Dua Lipa                      Halsey 
               7.250790e-06                7.258896e-06 
                 Little Mix                    Rita Ora 
               7.243437e-06                7.254788e-06 
   Selena Gomez & The Scene                  Quinn XCII 
               7.250107e-06                7.246114e-06 
                 Bryce Vine            Christian French 
               7.247900e-06                7.246114e-06 
              Anthony Russo                   Souly Had 
               7.235785e-06                7.246114e-06 
                   mansionz               Marc E. Bassy 
               7.246114e-06                7.264433e-06 
                 Tayla Parx              Victoria Monét 
               7.247480e-06                7.247480e-06 
                Jon Bellion            Luke Christopher 
               7.247900e-06                7.247900e-06 
               Cashmere Cat                      Zandhr 
               7.235785e-06                7.235785e-06 
                     Njomza              Chelsea Cutler 
               7.235785e-06                7.270136e-06 
                 Kiana Ledé              Meghan Trainor 
               7.261004e-06                7.240396e-06 
           Carly Rae Jepsen              Kelly Clarkson 
               7.240605e-06                7.240972e-06 
           Carrie Underwood                       Lorde 
               7.229038e-06                7.255894e-06 
             Rachel Platten                        Ruel 
               7.229038e-06                7.266861e-06 
                  blackbear             Sabrina Claudio 
               7.249056e-06                7.254630e-06 
               Jessie Reyez                     Kehlani 
               7.254525e-06                7.263799e-06 
                     H.E.R.               Summer Walker 
               7.249056e-06                7.249056e-06 
                   Ella Mai                 Alina Baraz 
               7.249056e-06                7.249056e-06 
              Daniel Caesar                benny blanco 
               7.249056e-06                7.269185e-06 
                  Roy Woods              Olivia O'Brien 
               7.261215e-06                7.267442e-06 
                  YK Osiris                 Roddy Ricch 
               7.228620e-06                7.180607e-06 
                  Yung Tory                      DaBaby 
               7.178596e-06                7.180039e-06 
                   Blueface                   YNW Melly 
               7.185560e-06                7.180607e-06 
                   Lil Tjay                   Lil Mosey 
               7.180039e-06                7.186025e-06 
                 YBN Cordae                Flipp Dinero 
               7.185560e-06                7.186025e-06 
               Quando Rondo                      Polo G 
               7.178596e-06                7.178596e-06 
                Comethazine            Smooky MarGielaa 
               7.185560e-06                7.178596e-06 
                 Yung Pinch                      G Flip 
               7.178596e-06                1.522443e-06 
                Thelma Plum                        KIAN 
               1.522443e-06                1.522443e-06 
               Eves Karydas               Thundamentals 
               1.522443e-06                1.522443e-06 
                     Allday                   Vera Blue 
               1.522443e-06                1.522443e-06 
                    Meg Mac                  The Rubens 
               1.522443e-06                1.522443e-06 
                      BENEE                  Jack River 
               1.522443e-06                1.522443e-06 
                     Odette                  Peking Duk 
               1.522443e-06                1.522443e-06 
                       Illy                   Amy Shark 
               1.522443e-06                1.522443e-06 
                     GRAACE                 Ruby Fields 
               1.522443e-06                1.522443e-06 
                      SAFIA                     Mallrat 
               1.522443e-06                1.522443e-06 
                  Cub Sport               King Princess 
               1.522443e-06                7.244487e-06 
           Melanie Martinez                    Cavetown 
               7.240972e-06                7.240972e-06 
                      gnash           Rex Orange County 
               7.270084e-06                7.240972e-06 
                 Conan Gray                     FINNEAS 
               7.240972e-06                7.240972e-06 
                    mxmtoon                Cody Simpson 
               7.240972e-06                7.237880e-06 
              Austin Mahone                  Nick Jonas 
               7.237880e-06                7.241287e-06 
                Jack & Jack                Ansel Elgort 
               7.260530e-06                7.252789e-06 
               Why Don't We          Charlotte Lawrence 
               7.260530e-06                7.268234e-06 
           Maggie Lindemann                 Sasha Sloan 
               7.266122e-06                7.261848e-06 
              Carlie Hanson                    FLETCHER 
               7.253894e-06                7.253894e-06 
                      Loote                      Wrabel 
               7.256841e-06                7.249476e-06 
                       NOTD                   Ella Eyre 
               7.234948e-06                7.244539e-06 
                 Rudimental                Nina Nesbitt 
               7.234948e-06                7.247742e-06 
                 Bebe Rexha                       Kesha 
               7.234948e-06                7.223242e-06 
             Hannah Montana              Ashley Tisdale 
               7.218549e-06                7.218549e-06 
                Hilary Duff           The Cheetah Girls 
               7.223242e-06                7.218549e-06 
            Bridgit Mendler             Victorious Cast 
               7.220529e-06                7.220529e-06 
              Avril Lavigne                  Cher Lloyd 
               7.223242e-06                7.238352e-06 
                   Aly & AJ                   Glee Cast 
               7.218549e-06                7.218549e-06 
                     Fergie              Jonas Brothers 
               7.253157e-06                7.218549e-06 
                   Doja Cat                  Rico Nasty 
               7.209961e-06                7.210897e-06 
                The Carters                 Qveen Herby 
               7.252000e-06                7.242755e-06 
                   cupcakKe                   Leikeli47 
               7.243437e-06                7.210897e-06 
              Chloe x Halle               Janelle Monáe 
               7.242755e-06                7.209961e-06 
                        SZA                Tierra Whack 
               7.243437e-06                7.210897e-06 
                    Solange                      WILLOW 
               7.209961e-06                7.209961e-06 
                 Charli XCX                Jamila Woods 
               7.238456e-06                7.209961e-06 
              Azealia Banks                  Kim Petras 
               7.243437e-06                7.209961e-06 
              Maggie Rogers                  Kali Uchis 
               7.209961e-06                7.209961e-06 
                Molly Brazy                   Kash Doll 
               7.189745e-06                7.189745e-06 
                  Queen Key                  Asian Doll 
               7.189745e-06                7.189745e-06 
                  Bali Baby                  Cuban Doll 
               7.189745e-06                7.189745e-06 
             Maliibu Miitch                      Dreezy 
               7.189745e-06                7.189745e-06 
                   BbyMutha                 Junglepussy 
               7.189745e-06                7.189745e-06 
                      Melii                  City Girls 
               7.189745e-06                7.189745e-06 
                  Kari Faux                     Mulatto 
               7.189745e-06                7.189745e-06 
                 Tokyo Jetz                       Trina 
               7.189745e-06                7.242283e-06 
              Tommy Genesis                 Iggy Azalea 
               7.189745e-06                7.239609e-06 
                    Rihanna                Stefflon Don 
               7.239609e-06                7.256052e-06 
                      Ciara                     Cardi B 
               7.242178e-06                7.239609e-06 
              Kelly Rowland                     Jeremih 
               7.249161e-06                7.257842e-06 
                 Trey Songz                 Keri Hilson 
               7.242178e-06                7.239609e-06 
                   Lil' Kim                     Kid Ink 
               7.239609e-06                7.220112e-06 
                 Tory Lanez               August Alsina 
               7.226321e-06                7.218653e-06 
                      Preme                        Wale 
               7.217924e-06                7.227157e-06 
                Kirko Bangz                    Jacquees 
               7.217924e-06                7.218653e-06 
             French Montana                    DJ Drama 
               7.226321e-06                7.219695e-06 
                Young Money              Eric Bellinger 
               7.220269e-06                7.218653e-06 
            Sage The Gemini                      K CAMP 
               7.217924e-06                7.217924e-06 
              PARTYNEXTDOOR                     Omarion 
               7.225851e-06                7.218653e-06 
                     Iamsu!               Bryson Tiller 
               7.217924e-06                7.225851e-06 
                    Mustard                       Mario 
               7.217924e-06                7.197610e-06 
                      Ne-Yo                       Lloyd 
               7.197610e-06                7.197610e-06 
                     T-Pain                Pretty Ricky 
               7.207571e-06                7.197610e-06 
                      Usher                   The-Dream 
               7.197610e-06                7.197610e-06 
                    Bow Wow                    Jay Sean 
               7.197610e-06                7.197610e-06 
                 Pleasure P                Keyshia Cole 
               7.197610e-06                7.197610e-06 
                   Big Sean                     J. Cole 
               7.213394e-06                7.212822e-06 
                   2 Chainz                   Meek Mill 
               7.213394e-06                7.213394e-06 
                  DJ Khaled                      Miguel 
               7.213394e-06                7.212822e-06 
                     Future                  Gucci Mane 
               7.212822e-06                7.212822e-06 
                  Lil Wayne               Martin Jensen 
               7.212822e-06                7.216934e-06 
                 Mike Perry                 Loud Luxury 
               7.216934e-06                7.217976e-06 
                     Matoma                 Cheat Codes 
               7.216934e-06                7.217976e-06 
                 Lost Kings                  Jonas Blue 
               7.214487e-06                7.216309e-06 
                     Sigala                     Gryffin 
               7.232174e-06                7.216309e-06 
           Lost Frequencies                   Cash Cash 
               7.215736e-06                7.214487e-06 
                Felix Jaehn                    Galantis 
               7.215736e-06                7.216309e-06 
                       Zedd                      Alesso 
               7.214487e-06                7.215736e-06 
              William Black                       Nurko 
               7.181793e-06                7.181793e-06 
                    ARMNHMR                       Dabin 
               7.181793e-06                7.181793e-06 
                      Skrux                     Slushii 
               7.181793e-06                7.214747e-06 
               Said the Sky                 Seven Lions 
               7.181793e-06                7.181793e-06 
                Win and Woo                       Kasbo 
               7.181793e-06                7.181793e-06 
               Manila Killa                    Jai Wolf 
               7.181793e-06                7.181793e-06 
                    Crywolf                 Taska Black 
               7.181793e-06                7.181793e-06 
                      Ekali                      Kaivon 
               7.181793e-06                7.181793e-06 
                    DROELOE                        SMLE 
               7.181793e-06                7.181793e-06 
                     1788-L                       Vanic 
               7.181793e-06                7.181793e-06 
             Lennon & Maisy              Nashville Cast 
               7.223502e-06                7.223502e-06 
                  Ivy Adara                       bülow 
               7.223502e-06                7.239557e-06 
                   Robinson                        EXES 
               7.223502e-06                7.223502e-06 
                       LÉON                    Ella Vos 
               7.223502e-06                7.223502e-06 
                     Shoffy                  Noah Cyrus 
               7.223502e-06                7.223502e-06 
                     Valley                     JP Saxe 
               7.223502e-06                7.229299e-06 
 YoungBoy Never Broke Again                Trippie Redd 
               7.178029e-06                7.184218e-06 
                     Calboy                 Yungeen Ace 
               7.178029e-06                7.178029e-06 
                  iann dior                      88GLAM 
               7.178029e-06                7.178029e-06 
               Tee Grizzley                    Lil Baby 
               7.178029e-06                7.178029e-06 
                 YBN Nahmir                Rich The Kid 
               7.184218e-06                7.179679e-06 
                    Tinashe                Justine Skye 
               7.237513e-06                7.237513e-06 
                  Dumblonde                 Keke Palmer 
               7.237513e-06                7.237513e-06 
                     Asiahn              Yung Baby Tate 
               7.237513e-06                7.237513e-06 
               Dawn Richard                        RAYE 
               7.237513e-06                7.252315e-06 
                   Afrojack              Dillon Francis 
               7.153076e-06                7.153076e-06 
                Yellow Claw                       Diplo 
               7.153076e-06                7.153076e-06 
                     Deorro                 Major Lazer 
               7.184837e-06                7.153076e-06 
                      R3HAB                  Don Diablo 
               7.184837e-06                7.184837e-06 
                       Jauz            Good Times Ahead 
               7.153076e-06                7.153076e-06 
  Dimitri Vegas & Like Mike                       DVBBS 
               7.184837e-06                7.153076e-06 
                     Jack Ü                  Steve Aoki 
               7.153076e-06                7.153076e-06 
                Party Favor              Oliver Heldens 
               7.153076e-06                7.153076e-06 
                     Tujamo                      Reykon 
               7.153076e-06                1.595993e-06 
                    Farruko                   J Alvarez 
               1.595945e-06                1.595899e-06 
              Zion & Lennox                       Wisin 
               1.595945e-06                1.595945e-06 
                   Arcangel               Alexis y Fido 
               1.595945e-06                1.595945e-06 
               De La Ghetto                 Danny Ocean 
               1.595945e-06                1.596024e-06 
                     Maluma                   Nicky Jam 
               1.595899e-06                1.595945e-06 
              Manuel Turizo                      Yandel 
               1.596042e-06                1.595945e-06 
                Cosculluela                       Fuego 
               1.595945e-06                1.595899e-06 
                       Ñejo              Jowell & Randy 
               1.595945e-06                1.595945e-06 
                  Tony Dize                       Lunay 
               1.595945e-06                1.596042e-06 
                    Piso 21           Waka Flocka Flame 
               1.595899e-06                7.206013e-06 
                Wiz Khalifa               Travis Porter 
               7.206013e-06                7.206013e-06 
                   Yo Gotti                    Ace Hood 
               7.206896e-06                7.206896e-06 
                    Juicy J                          YG 
               7.206013e-06                7.206013e-06 
                  Sik World                       Phora 
               7.223555e-06                7.218080e-06 
                     Marvin                 Toni Romiti 
               7.218080e-06                7.218080e-06 
                       ASTN                       Ollie 
               7.239557e-06                7.223555e-06 
                     Smiley                    K-Clique 
               7.218080e-06                7.218080e-06 
                   Yo Trane               Trevor Daniel 
               7.218080e-06                7.218080e-06 
           Drumma Battalion                Mark Diamond 
               7.218080e-06                7.218080e-06 
                    Luh Kel              SadBoyProlific 
               7.218080e-06                7.218080e-06 
                       eli.                   Leek Jack 
               7.218080e-06                7.218080e-06 
                 Reo Cragun               Tom MacDonald 
               7.218080e-06                7.190882e-06 
                  Lucidious                  Witt Lowry 
               7.190882e-06                7.190882e-06 
               Ryan Caraveo                     Bazanji 
               7.190882e-06                7.190882e-06 
               Justin Stone                       Token 
               7.190882e-06                7.190882e-06 
                   Jez Dior                      Josh A 
               7.190882e-06                7.194762e-06 
                 Ryan Oakes                Joyner Lucas 
               7.190882e-06                7.190882e-06 
                   K.A.A.N.                 Chris Webby 
               7.190882e-06                7.202950e-06 
             Arizona Zervas                      Ivan B 
               7.190882e-06                7.190882e-06 
                Iamjakehill                  Futuristic 
               7.194762e-06                7.190882e-06 
     Ski Mask The Slump God                      Offset 
               7.163478e-06                7.163478e-06 
                 Yung Gravy           Billy Marchiafava 
               7.168921e-06                7.138319e-06 
                  Joey Trap                   Roy Purdy 
               7.138319e-06                7.138319e-06 
              Bandingo YGNE                      Dbangz 
               7.138319e-06                7.138319e-06 
                      Jakey              Tiny Meat Gang 
               7.138319e-06                7.138319e-06 
                Oliver Tree                   Shakewell 
               7.138319e-06                7.138319e-06 
                     Fukkit                 Terror Reid 
               7.138319e-06                7.138319e-06 
                  Craig Xen                       Aries 
               7.138319e-06                7.138319e-06 
             Hovey Benjamin               Freddie Dredd 
               7.138319e-06                7.138319e-06 
                     6 Dogs              Oliver Francis 
               7.138319e-06                7.138319e-06 
             Britney Spears                Gwen Stefani 
               7.216569e-06                7.216569e-06 
                   Jessie J               The Veronicas 
               7.236257e-06                7.216569e-06 
         The Pussycat Dolls               Jordin Sparks 
               7.216569e-06                7.216569e-06 
              The Saturdays          Christina Aguilera 
               7.236257e-06                7.216569e-06 
                Leona Lewis                  Nio Garcia 
               7.238352e-06                1.595909e-06 
                  Bad Bunny                    Brytiago 
               1.595902e-06                1.595909e-06 
                    Rvssian                       Jon Z 
               1.595902e-06                1.595871e-06 
               Bryant Myers                 Myke Towers 
               1.595902e-06                1.595909e-06 
                  Lary Over                 Lalo Ebratt 
               1.595902e-06                1.595902e-06 
                Chris Jeday                 Mau y Ricky 
               1.595909e-06                1.595909e-06 
                  Alex Rose                Kevin Roldan 
               1.595871e-06                1.595909e-06 
                 Miky Woodz               Casper Magico 
               1.595871e-06                1.595871e-06 
                   DJ Luian                   Kenny Man 
               1.595871e-06                1.595871e-06 
                Trebol Clan           Tito "El Bambino" 
               1.595757e-06                1.595757e-06 
                  Ivy Queen               Tego Calderon 
               1.595757e-06                1.595757e-06 
                   Don Omar              Wisin & Yandel 
               1.595757e-06                1.595757e-06 
                 Luny Tunes                        Zion 
               1.595757e-06                1.595757e-06 
                    Greeicy                       Nacho 
               1.595892e-06                1.595892e-06 
            Sebastian Yatra                        CNCO 
               1.595892e-06                1.595892e-06 
             Mario Bautista               Chyno Miranda 
               1.595892e-06                1.595876e-06 
                      Cazzu                    Amenazzy 
               1.595876e-06                1.595861e-06 
             Tinchy Stryder                Tinie Tempah 
               7.206636e-06                7.206636e-06 
                        LSD             Professor Green 
               7.206636e-06                7.206636e-06 
                   DJ Fresh                      N-Dubz 
               7.206636e-06                7.206636e-06 
                Emeli Sandé                   Wretch 32 
               7.206636e-06                7.206636e-06 
                      Dappy                     Example 
               7.206636e-06                7.206636e-06 
               Rizzle Kicks                         JLS 
               7.206636e-06                7.206636e-06 
                  Olly Murs                      Plan B 
               7.239609e-06                7.206636e-06 
              Lethal Bizzle          Scouting For Girls 
               7.206636e-06                7.206636e-06 
         China Anne McClain             McClain Sisters 
               7.154816e-06                7.154816e-06 
                 Ross Lynch                   Rags Cast 
               7.154816e-06                7.154816e-06 
               Bella Thorne                Laura Marano 
               7.154816e-06                7.154816e-06 
                 Debby Ryan Disney's Friends For Change 
               7.154816e-06                7.154816e-06 
               Sofia Carson                 Olivia Holt 
               7.154816e-06                7.154816e-06 
                Austin Moon                 Drew Seeley 
               7.154816e-06                7.154816e-06 
            Kyra Christiaan            Miranda Cosgrove 
               7.154816e-06                7.154816e-06 
       Tyler James Williams                  Coco Jones 
               7.154816e-06                7.154816e-06 
                Corbin Bleu                  The GGGG's 
               7.154816e-06                7.154816e-06 
                   San Holo                       KREAM 
               7.213706e-06                7.216830e-06 
                Dylan Scott                Jordan Davis 
               1.565362e-06                1.565362e-06 
              Morgan Wallen                  Dan + Shay 
               1.565305e-06                1.565305e-06 
                Michael Ray                  Luke Combs 
               1.565362e-06                1.565305e-06 
                 Seth Ennis                Devin Dawson 
               1.565362e-06                1.565362e-06 
               Jon Langston                   Ryan Hurd 
               1.565305e-06                1.565362e-06 
          James Barker Band             Dylan Schneider 
               1.565362e-06                1.565362e-06 
              Cole Swindell                Old Dominion 
               1.565305e-06                1.565305e-06 
          Mitchell Tenpenny                Dustin Lynch 
               1.565305e-06                1.565305e-06 
                 Chris Lane                      LOCASH 
               1.565305e-06                1.565305e-06 
               Maddie & Tae                      MARINA 
               1.565389e-06                7.228358e-06 
               Paloma Faith                  The Wanted 
               7.228358e-06                7.228358e-06 
            Christina Perri                 Mark Ronson 
               7.228358e-06                7.228358e-06 
                  Cooliecut                  Smokepurpp 
               7.172881e-06                7.172881e-06 
               Wifisfuneral                    Ugly God 
               7.172881e-06                7.172881e-06 
                    Ronny J                   Jim Jones 
               7.172881e-06                7.181329e-06 
                   Curren$y                     Birdman 
               7.181329e-06                7.181329e-06 
                   Fabolous                       Jeezy 
               7.181329e-06                7.181329e-06 
                      Bun B               Juelz Santana 
               7.181329e-06                7.181329e-06 
                  Slim Thug                   Young Dro 
               7.181329e-06                7.181329e-06 
                Lloyd Banks                Beanie Sigel 
               7.181329e-06                7.181329e-06 
                 Young Buck               The Diplomats 
               7.181329e-06                7.181329e-06 
                     Webbie                    Jadakiss 
               7.181329e-06                7.181329e-06 
                  Kid Quill                   Timeflies 
               7.236675e-06                7.234895e-06 
                       DYSN                Xuitcasecity 
               7.234895e-06                7.234895e-06 
                Oliver Riot                      ayokay 
               7.234895e-06                7.234895e-06 
            Louis Tomlinson              Hot Chelle Rae 
               7.234006e-06                7.227836e-06 
              Big Time Rush               New Hope Club 
               7.227836e-06                7.246482e-06 
                       MKTO                         MAX 
               7.234006e-06                7.231233e-06 
                     Rixton                 AJ Mitchell 
               7.231233e-06                7.234477e-06 
                 Tate McRae             Anna Clendening 
               7.234477e-06                7.234477e-06 
            Christian Leave                Anson Seabra 
               7.234477e-06                7.234477e-06 
                 SHY Martin              Eli Young Band 
               7.234477e-06                1.565305e-06 
          Danielle Bradbery             Miranda Lambert 
               1.565362e-06                1.565305e-06 
                        Cam             Kacey Musgraves 
               1.565362e-06                1.565305e-06 
        Jessie James Decker                Runaway June 
               1.565362e-06                1.565362e-06 
              Lauren Alaina             Little Big Town 
               1.565362e-06                1.565305e-06 
              Pistol Annies                   Sugarland 
               1.565305e-06                1.565305e-06 
               Hunter Hayes                 Jana Kramer 
               1.565305e-06                1.565362e-06 
                    RaeLynn                Walker Hayes 
               1.565362e-06                1.565305e-06 
              Granger Smith          Jillian Jacqueline 
               1.565305e-06                1.565362e-06 
              Cassadee Pope             James Gillespie 
               1.565305e-06                7.191451e-06 
             Harrison Storm                Allman Brown 
               7.191451e-06                7.191451e-06 
             George Ogilvie                Riley Pearce 
               7.191451e-06                7.191451e-06 
                Wild Rivers                Hollow Coves 
               7.191451e-06                7.191451e-06 
              Henry Jamison                   Ed Prosek 
               7.191451e-06                7.191451e-06 
             Dustin Tebbutt             Old Sea Brigade 
               7.191451e-06                7.191451e-06 
         Charlie Cunningham               Ryan McMullan 
               7.191451e-06                7.191451e-06 
               Blanco White                 Diamond Rio 
               7.191451e-06                1.522443e-06 
               Little Texas               Mark Chesnutt 
               1.522443e-06                1.522443e-06 
                Collin Raye               Sammy Kershaw 
               1.522443e-06                1.522443e-06 
                 Joe Diffie                 Clay Walker 
               1.522443e-06                1.522443e-06 
               Randy Travis                Aaron Tippin 
               1.522443e-06                1.522443e-06 
                   Lonestar                  Shenandoah 
               1.522443e-06                1.522443e-06 
               Sawyer Brown             Trisha Yearwood 
               1.522443e-06                1.522443e-06 
          Daryle Singletary               Brooks & Dunn 
               1.522443e-06                1.522443e-06 
               Trace Adkins                  Tracy Byrd 
               1.522443e-06                1.522443e-06 
                Clint Black                Travis Tritt 
               1.522443e-06                1.522443e-06 
    John Michael Montgomery                   Klingande 
               1.522443e-06                7.196212e-06 
            Charming Horses                 Alex Schulz 
               7.188918e-06                7.188918e-06 
                      Kungs              Campsite Dream 
               7.196212e-06                7.188918e-06 
            GAMPER & DADONI                      filous 
               7.188918e-06                7.188918e-06 
                  LVNDSCAPE                        Möwe 
               7.188918e-06                7.188918e-06 
              Mike Williams                     The Him 
               7.192796e-06                7.188918e-06 
                Deep Chills                   Y.V.E. 48 
               7.188918e-06                7.188918e-06 
          Catherine McGrath                       LANCO 
               1.565335e-06                1.565335e-06 
               Carly Pearce          Tungevaag & Raaban 
               1.565335e-06                7.195591e-06 
              Lucas Estrada                Robin Schulz 
               7.195591e-06                7.195591e-06 
                  Jax Jones                    Syn Cole 
               7.238718e-06                7.197559e-06 
               Toni Braxton               Janet Jackson 
               7.172315e-06                7.172315e-06 
                   En Vogue                      Brandy 
               7.172315e-06                7.172315e-06 
            Jennifer Hudson                Mariah Carey 
               7.172315e-06                7.172315e-06 
            Luther Vandross                      Monica 
               7.172315e-06                7.172315e-06 
                Céline Dion                       Tamia 
               7.172315e-06                7.172315e-06 
              Patti LaBelle                 Paula Abdul 
               7.172315e-06                7.172315e-06 
                        TLC                  Diana Ross 
               7.172315e-06                7.172315e-06 
                Deborah Cox                Peabo Bryson 
               7.172315e-06                7.172315e-06 
              Lionel Richie                 Tina Turner 
               7.172315e-06                7.172315e-06 
                       Cher                       WSTRN 
               7.172315e-06                7.228306e-06 
                        M.O                      Rak-Su 
               7.228306e-06                7.228306e-06 
               Anton Powers                      Blonde 
               7.228306e-06                7.228306e-06 
                       Ramz                  Becky Hill 
               7.228306e-06                7.228306e-06 
                      Not3s                        M-22 
               7.228306e-06                7.228306e-06 
                   Astrid S                        MNEK 
               7.228306e-06                7.228306e-06 
                     Yungen                   Yxng Bane 
               7.228306e-06                7.228306e-06 
                   Zak Abel               Steel Banglez 
               7.228306e-06                7.228306e-06 
                     AREA21                      Brooks 
               7.183289e-06                7.183289e-06 
              Lucas & Steve                    Borgeous 
               7.183289e-06                7.183289e-06 
                      KAAZE                       KSHMR 
               7.183289e-06                7.183289e-06 
                        GRX                 Jay Hardway 
               7.183289e-06                7.183289e-06 
               Nicky Romero                      Yves V 
               7.183289e-06                7.183289e-06 
                  DubVision                Madison Mars 
               7.183289e-06                7.183289e-06 
                   Hardwell     Macklemore & Ryan Lewis 
               7.183289e-06                7.185612e-06 
                    SonReal                  Classified 
               7.185612e-06                7.185612e-06 
               Hoodie Allen                 Chiddy Bang 
               7.185612e-06                7.185612e-06 
              Blue Scholars                      Watsky 
               7.185612e-06                7.185612e-06 
                Cam Meekins                   Lil Dicky 
               7.185612e-06                7.185612e-06 
                Sammy Adams                    E-Dubble 
               7.185612e-06                7.185612e-06 
                    Grieves                 Skizzy Mars 
               7.185612e-06                7.185612e-06 
                Mike Posner                         Sol 
               7.185612e-06                7.185612e-06 
        Panic! At The Disco         My Chemical Romance 
               1.522443e-06                1.522443e-06 
               All Time Low    The All-American Rejects 
               1.522443e-06                1.522443e-06 
               We The Kings             Boys Like Girls 
               1.522443e-06                1.522443e-06 
             Good Charlotte               Mayday Parade 
               1.522443e-06                1.522443e-06 
                  The Maine                  Yellowcard 
               1.522443e-06                1.522443e-06 
                    The Cab                     Anarbor 
               1.522443e-06                1.522443e-06 
              You Me At Six                    Paramore 
               1.522443e-06                1.522443e-06 
   Forever The Sickest Kids              Cobra Starship 
               1.522443e-06                1.522443e-06 
            Marianas Trench                       3OH!3 
               1.522443e-06                1.522443e-06 
 The Red Jumpsuit Apparatus                 Simple Plan 
               1.522443e-06                1.522443e-06 
                 The Script                    The Fray 
               7.177669e-06                7.177669e-06 
           American Authors                  Neon Trees 
               7.177669e-06                7.177669e-06 
           Phillip Phillips                    Maroon 5 
               7.177669e-06                7.177669e-06 
                  Lifehouse                   Parachute 
               7.177669e-06                7.177669e-06 
               Gavin DeGraw                    Owl City 
               7.177669e-06                7.177669e-06 
                Snow Patrol             Plain White T's 
               7.177669e-06                7.177669e-06 
                Mat Kearney                Andy Grammer 
               7.177669e-06                7.177669e-06 
          Five For Fighting             Imagine Dragons 
               7.177669e-06                7.177669e-06 
                      Keane               WALK THE MOON 
               7.177669e-06                7.177669e-06 
                   Daughtry 
               7.177669e-06 
```

Network Level Measures
========================================================


```r
edge_density(artist_network)
```

```
[1] 0.003862036
```

```r
transitivity(artist_network)
```

```
[1] 0.09257732
```

Clustering
========================================================
- There are many, many, many clustering algorithms
- We are going to look at only one, edge betweenness based community structure
     + The idea behind this algorithm is that it is likely that edges connecting separate modules have high edge betweenness as all the shortest paths from one module to another must traverse through them
     + `cluster_edge_betweenness` performs this algorithm by calculating the edge betweenness of the graph, removing the edge with the highest edge betweenness score, then recalculating edge betweenness of the edges and again removing the one with the highest score, and so on
    
Clustering
========================================================
Perform Algorithm:

```r
artist_clusters <- cluster_edge_betweenness(artist_network)
```

Extract relevant information:

```r
artist_groups <- data.frame("artist" = artist_clusters$names, "group" = artist_clusters$membership)
```

Clustering
========================================================
- Now we should explore the groups!
- Open the dataframe, and sort by `group`. Artists with the same number are part of the same cluster. 
     + Do these groups make sense?
     







