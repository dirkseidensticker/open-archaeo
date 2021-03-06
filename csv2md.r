library(glue)
library(dplyr)
library(readr)
x <- readr::read_csv("open-archaeo.csv")
x <- arrange(x, item_name)


# concatenate authors
x$author_list1 <- ifelse(!is.na(x$author1_name) &
                          is.na(x$author2_name) &
                          is.na(x$author3_name) &
                          is.na(x$author4_name) &
                          is.na(x$author5_name),
                        paste(x$author1_name),
                        NA)

x$author_list2 <- ifelse(!is.na(x$author1_name) &
                          !is.na(x$author2_name) &
                          is.na(x$author3_name) &
                          is.na(x$author4_name) &
                          is.na(x$author5_name),
                        paste(x$author1_name," and ",x$author2_name, sep = ""),
                        NA)

x$author_list3 <- ifelse(!is.na(x$author1_name) &
                          !is.na(x$author2_name) &
                          !is.na(x$author3_name) &
                          is.na(x$author4_name) &
                          is.na(x$author5_name),
                        paste(x$author1_name,", ",x$author2_name," and ",x$author3_name, sep = ""),
                        NA)

x$author_list4 <- ifelse(!is.na(x$author1_name) &
                          !is.na(x$author2_name) &
                          !is.na(x$author3_name) &
                          !is.na(x$author4_name) &
                          is.na(x$author5_name),
                        paste(x$author1_name,", ",x$author2_name,", ",x$author3_name," and ",x$author4_name, sep = ""),
                        NA)

x$author_list5 <- ifelse(!is.na(x$author1_name) &
                          !is.na(x$author2_name) &
                          !is.na(x$author3_name) &
                          !is.na(x$author4_name) &
                          !is.na(x$author5_name),
                        paste(x$author1_name,", ",x$author2_name,", ",x$author3_name,", ",x$author4_name, " and ", x$author5_name, sep = ""),
                        NA)

x$author_list <- coalesce(x$author_list1, x$author_list2, x$author_list3, x$author_list4, x$author_list5)

# concatenate links
# generate links with target = _blank
# <a href="http://example.com/" target="_blank">Hello, world!</a>

scr.lst <- list(github = "GitHub", 
                gist = "Gist", 
                gitlab = "GitLab", 
                bitbucket = "BitBucket", 
                launchpad = "LaunchPad", 
                twitter = "Twitter", 
                blogpost = "Blog Post", 
                cran = "CRAN", 
                pypi = "PyPi", 
                website = "Website")


for(i in 1:nrow(x)){
  
  for(j in 1:length(scr.lst)) {
    
    url <- x[i,names(scr.lst)[j]]
    
    if(!is.na(url)){
      
      link <- paste0("<a href='",url,"' target='_blank'>",scr.lst[[j]],"</a>")
      x[i,names(scr.lst)[j]] <- link
      
    }
  }
}

x$link_list <- apply( x[,names(scr.lst)] , 1 , paste , collapse = " " )
x$link_list <- gsub("NA","",x$link_list,fixed = TRUE)
x$link_list <- gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", x$link_list, perl=TRUE) # remove surplus spaces

# concatenate tags
x$tag1 <- paste("[",x$tag1,"]", sep = "")
x$tag2 <- paste("[",x$tag2,"]", sep = "")
x$tag3 <- paste("[",x$tag3,"]", sep = "")
x$tag4 <- paste("[",x$tag4,"]", sep = "")
x$tag5 <- paste("[",x$tag5,"]", sep = "")

x$tag1 <- gsub("[NA]",NA,x$tag1)
x$tag2 <- gsub("[NA]",NA,x$tag2)
x$tag3 <- gsub("[NA]",NA,x$tag3)
x$tag4 <- gsub("[NA]",NA,x$tag4)
x$tag5 <- gsub("[NA]",NA,x$tag5)


x$tag_list1 <- ifelse(!is.na(x$tag1) &
                           is.na(x$tag2) &
                           is.na(x$tag3) &
                           is.na(x$tag4) &
                           is.na(x$tag5),
                         paste(x$tag1),
                         NA)

x$tag_list2 <- ifelse(!is.na(x$tag1) &
                           !is.na(x$tag2) &
                           is.na(x$tag3) &
                           is.na(x$tag4) &
                           is.na(x$tag5),
                         paste(x$tag1," and ",x$tag2, sep = ""),
                         NA)

x$tag_list3 <- ifelse(!is.na(x$tag1) &
                           !is.na(x$tag2) &
                           !is.na(x$tag3) &
                           is.na(x$tag4) &
                           is.na(x$tag5),
                         paste(x$tag1,", ",x$tag2," and ",x$tag3, sep = ""),
                         NA)

x$tag_list4 <- ifelse(!is.na(x$tag1) &
                           !is.na(x$tag2) &
                           !is.na(x$tag3) &
                           !is.na(x$tag4) &
                           is.na(x$tag5),
                         paste(x$tag1,", ",x$tag2,", ",x$tag3," and ",x$tag4, sep = ""),
                         NA)

x$tag_list5 <- ifelse(!is.na(x$tag1) &
                           !is.na(x$tag2) &
                           !is.na(x$tag3) &
                           !is.na(x$tag4) &
                           !is.na(x$tag5),
                         paste(x$tag1,", ",x$tag2,", ",x$tag3,", ",x$tag4, " and ", x$tag5, sep = ""),
                         NA)

x$tag_list <- coalesce(x$tag_list1, x$tag_list2, x$tag_list3, x$tag_list4, x$tag_list5)

x$tag_list[is.na(x$tag_list)] = ""

# put it all together
z <- glue("
* **{x$item_name}**: {x$description}
  * by: {x$author_list}
  * links: {x$link_list}
  * tags: {x$tag_list}
----

")

intro <- "# Open Archaeology Software & Resources
A list of open source archaeological software and resources

See [ToDo.md](https://github.com/zackbatist/open-archaeo/blob/master/ToDo.md) for a list of tools or resources that are in demand, but which currently do not exist or need to be significantly improved.
"

# export
fileConn<-file("content/_index.md")
writeLines(z, fileConn)
close(fileConn)

q <- read_file("content/_index.md")
readme <- paste(intro,q, sep="\n")

fileConn<-file("README.md")
writeLines(readme, fileConn)
close(fileConn)
