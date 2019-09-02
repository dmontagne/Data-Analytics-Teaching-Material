
# NOTE: This is not great code: probably difficult to follow along... 

library(httr)


#authenticate spotify API 
clientID <- "XXXXXXXXXXXXXXXXXXXXXXXXXXX"
secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXX"

response = POST(
  'https://accounts.spotify.com/api/token',
  accept_json(),
  authenticate(clientID, secret),
  body = list(grant_type = 'client_credentials'),
  encode = 'form',
  verbose()
)

mytoken = httr::content(response)$access_token
HeaderValue = paste0('Bearer ', mytoken) #Authorization is always Bearer + unique token

###################################################
################# QUERYING ########################
###################################################

id <- "37i9dQZF1DXcBWIGoYBM5M" # Spotify's "Todays Top Hits"
query <- paste0("https://api.spotify.com/v1/playlists/", id)
r <- GET(url = query, add_headers(Authorization = HeaderValue))
r2 <- httr::content(r)

tracks <- r2$tracks$items

artists <- vector(length = length(tracks), "list")
for(i in 1:length(tracks)) {
  artists[[i]] <- tracks[[i]]$track$artists
}

artist_ids <- data.frame(names, ids)
for(i in 1:length(artists)) {
  tick <- length(artists[[i]])
  for (y in 1:tick){
    artist_ids <- rbind(artist_ids, data.frame(names = artists[[i]][[y]]$name,
                        ids = artists[[i]][[y]]$id))
  }
}
artist_ids <- unique(artist_ids)

############ Now for related artists ###############
# Re authorize first...

artist_edges <- data.frame(focal_art = NULL, rec_art = NULL)
artist_attributes <- data.frame(name = NULL, popularity = NULL, genre = NULL)

for(k in 1:nrow(artist_ids)) {
  id <- as.character(artist_ids$ids[k]) 
  query <- paste0("https://api.spotify.com/v1/artists/", id, "/related-artists")
  r <- GET(url = query, add_headers(Authorization = HeaderValue))
  r2 <- httr::content(r)
  
  for(i in 1:length(r2$artists)){
    current_attributes <- data.frame(name = r2$artists[[i]]$name,
                                     popularity = r2$artists[[i]]$popularity,
                                     focal_artist = as.character(artist_ids$names[k]),
                                     genres = 
                                       ifelse(length(r2$artists[[i]]$genres) == 0, "NA", r2$artists[[i]]$genres))
    genre_count <- ncol(current_attributes) - 3
    names(current_attributes) <- c("name", "popularity", "focal_artist", rep("genre", genre_count))
    artist_attributes <- plyr::rbind.fill(artist_attributes, current_attributes)
    
  }
  print(as.character(artist_ids$name[k]))
}
artist_edges <- artist_attributes %>% select(art_i = focal_artist, art_j = name)

artist_attributes <- artist_attributes %>% select(art_i = focal_artist, art_j = name, genre, popularity)
artist_attributes$genre <- as.character(artist_attributes$genre)
save(artist_attributes, file = "~/Documents/GitHub/Data-Analytics-Teaching-Material/artist_attributes.Rda")

for(i in 1:nrow(artist_ids)) {
  id <- as.character(artist_ids$ids[i]) 
  query <- paste0("https://api.spotify.com/v1/artists/", id)
  r <- GET(url = query, add_headers(Authorization = HeaderValue))
  r2 <- httr::content(r)
  artist_ids$popularity[i] <- r2$popularity
}

# can add genre to above loop if you want later
  
############## MAKING THE NETWORK ##################

library(igraph)

core_pop <- artist_ids %>% select(c(name = names, popularity))
core_pop <- artist_attributes %>% select(name = art_j, popularity) %>% 
  rbind(core_pop)
core_pop <- unique(core_pop)

vertices_info <- data.frame(id = 1:length(unique(c(as.character(artist_attributes$art_i), 
                                                   as.character(artist_attributes$art_j)))),
                              name = unique(c(as.character(artist_attributes$art_i), 
                                              as.character(artist_attributes$art_j)))) 
vertices_info <- left_join(vertices_info, core_pop)

artist_edges <- artist_edges %>% mutate(id = 1:nrow(artist_edges)) %>% select(id, everything())

artist_network <- graph.data.frame(artist_edges[, -1], directed=F) # , vertices=vertices_info
plot(artist_network,
     layout = layout.fruchterman.reingold(artist_network),
     vertex.size = .5)







