
install.packages("igraph")
install.packages("stm")

library(igraph)
library(dplyr)
library(tidyverse)
library(stm)

# Load in data 

download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/Music%20Network%20Data/artist_edges.Rda?raw=true", "git_edges")
load("git_edges")

download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/Music%20Network%20Data/vertices_info.Rda?raw=true", "git_vertices")
load("git_vertices")

artist_network <- graph.data.frame(artist_edges[, -1], directed=F) # , vertices=vertices_info

# Let's plot our network
plot(artist_network,
     layout = layout.fruchterman.reingold(artist_network),
     vertex.size = .5,
     vertex.label = V(artist_network)$simple_labels)

# Right now it looks like a wall of text more than anything else.
# How can we make this more readable?

# Let's make a new variable in the igraph object that tells igraph to
# only label those artists that are connected to 20 or more other artists.
# In network lingo, this means that we only want labels for artists with
# a "degree" of 20 or more.


# To calculate the degree of each node (artist) in our network, we use the
# `degree` function:
degree(artist_network)

# To get a vector of names for each node, we extract the `name` variable
# from our `igraph` object:
V(artist_network)$name


# The information from the two calls above give us all the information we need
# to make simpler labels. Let's add a new variable, `simple_labels`, to our igraph
# object using the `ifelse` function:
V(artist_network)$simple_labels <- ifelse(
  # If an artist's degree is less than 20, don't give it a label (`NA`)
  degree(artist_network) < 20, NA, 
  # If an artist's degree is 20 or more, however, label it with the artist's
  # name (stored in `V(artist_network)$name`)
  V(artist_network)$name)


# Now that we've build our `simple_labels` variable, let's tell `igraph` to
# use this variable when plotting our network. To do this, set the `vertex.label`
# argument to `simple_labels` in the `plot` function:
plot(artist_network,
     layout = layout.fruchterman.reingold(artist_network),
     vertex.size = 1,
     vertex.label = V(artist_network)$simple_labels)

# It looks a lot better, though some names are still hard to read in the
# middle of the network.

V(artist_network)$popularity <- vertices_info$popularity
V(artist_network)$transformed_popularity <- scale(vertices_info$popularity) + min(scale(vertices_info$popularity))*-1.5

# Measures of the vertices
betweenness(artist_network, v = V(artist_network), directed = F)
closeness(artist_network, v = V(artist_network))

# Whole graph measures
edge_density(artist_network)
transitivity(artist_network)

# Clustering
artist_clusters <- cluster_edge_betweenness(artist_network)
artist_groups <- data.frame("artist" = artist_clusters$names, "group" = artist_clusters$membership)

artist_groups %>% 
  mutate(group_num = paste("group", group))  

# Topic Modeling

download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/lyric_stm_sample.rda?raw=true", "git_lyrics")
load("git_lyrics")

metadata_lyrics <- lyrics_sample %>% 
  select(artist_id)

process_lyrics <- textProcessor(lyrics_sample$lyrics, metadata = metadata_lyrics)
# OR
download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/process_lyrics.rda?raw=true", "git_process_lyrics")
load("git_process_lyrics")

prep_lyrics <- prepDocuments(process_lyrics$documents, process_lyrics$vocab, process_lyrics$meta)
# OR
download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/prep_lyrics.rda?raw=true", "git_prep_lyrics")
load("git_prep_lyrics")

which_k <- searchK(prep_lyrics$documents, prep_lyrics$vocab, K = seq(10, 50, by = 10),
                   data = prep_lyrics$meta, verbose = T) # Takes a while to run

lyrics_30 <-  stm(documents = prep_lyrics$documents,
                  vocab = prep_lyrics$vocab,
                  K = 30,
                  data = prep_lyrics$meta,
                  init.type = "Spectral",
                  verbose = F)
# OR

download.file("https://github.com/dmontagne/Data-Analytics-Teaching-Material/blob/master/lyrics_stm.rda?raw=true", "git_stm_lyrics")
load("git_stm_lyrics")

plot.STM(lyrics_30)

labelTopics(lyrics_30)



