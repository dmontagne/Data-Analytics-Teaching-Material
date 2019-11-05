
devtools::install_github("ewenme/geniusr")
library(geniusr)
library(dplyr)
library(tidytext)

genius_token()

artist_ids <- vector("list", length = nrow(artist_groups))
for(i in 1:nrow(artist_groups)) {
  a <- artist_groups$artist[i]
  artist_ids[[i]] <- search_artist(a, n_results = 10,
                                   access_token = genius_token())
  print(i)
  
}
ids <- bind_rows(artist_ids)
a_ids <- left_join(artist_groups, ids, by = c("artist" = "artist_name"))
a_ids <- unique(a_ids)

songs <- vector("list", length = nrow(a_ids))
for(i in 1:length(songs)) {
  tryCatch({
    a <- a_ids$artist_id[i]
    songs[[i]] <- 
      get_artist_songs_df(a, access_token = genius_token())
  }, error = function(e) {
    e
    print("Oops, not on Genius")
  })
  print(i)
}
song_ids <- bind_rows(songs)

lyric_list <- vector("list", length = nrow(song_ids))
for(i in 1:length(lyric_list)) {
  tryCatch({
    s <- song_ids$song_id[i]
    focal_song <- get_lyrics_id(s, access_token = genius_token())
    
    lyric_list[[i]] <- focal_song %>% 
      group_by(song_id) %>% summarise(lyrics = paste(line, collapse=" "))
  }, error = function(e) {
    e
    print("Oops, something went wrong")
  })
  print(i)
}
lyric_set <- bind_rows(lyric_list)

lyrics_sample <- song_ids %>% 
  select(song_id, song_name, artist_id, artist_name) %>% 
  left_join(lyric_set, .) %>% 
  filter(lyrics != "NA")

save(lyrics_sample, file = "~/Documents/GitHub/Data-Analytics-Teaching-Material/lyrics_sample.Rda")


