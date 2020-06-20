
gitPush <- function(..., list = character(), repoPath. = repoPath, subDir = 'R', message = "Changed with rgit", gitUserName = gitName, gitUserEmail = gitEmail, 
                     autoExit = TRUE, deleteRepoAfterPush = TRUE, verbose = FALSE)  {

    # Initial setup - the oddity of calling a character vector 'list' keeped from the rm() function code.
    
    dots <- match.call(expand.dots = FALSE)$...
    if (length(dots) && !all(vapply(dots, function(x) is.symbol(x) || 
        is.character(x), NA, USE.NAMES = FALSE))) 
        stop("... must contain names or character strings")
    names <- vapply(dots, as.character, "")
    if (length(names) == 0L) 
        names <- character()
    list <- .Primitive("c")(list, names)
	list.R <- paste(list, ".R", sep = "")
    
    HomeDir <- paste0(getwd(), "/")
    
    repo <- JRWToolBox::get.subs(repoPath., "/")[2] # Avoid the list produced by strsplit() (I wrote get.subs() to work in both R and SPlus before strsplit() came out.) 
    if(dir.exists(repo)) {
    
       cat(paste0("\nThe directory: ", repo, " will be removed.\n"))
       switch(menu(c("Stop?", "Delete the directory and continue?")) + 1,
           stop("Stopped by user."), stop("Stopped by user."), cat("\n"))
    }
   
    system(paste0("rm -r -f ", repo)) # Make sure the repo directory is deleted 
    
    # Download function and scripts from GitHub (you will be asked once for your password, if you are not already logged into GitHub).
    rgit::git(paste0("config --global user.name --replace-all '", gitUserName, "'"), autoExit = autoExit)
    rgit::git(paste0("config --global user.email --replace-all '", gitUserEmail, "'"), autoExit = autoExit)
    rgit::git(paste0("clone https://github.com/", repoPath., ".git"), autoExit = autoExit)
    
    if(verbose) {
       cat("\n\nThe local working directory is: ", HomeDir)
       cat("\n\nThe git URL is: https://github.com/", repoPath., ".git", sep = "")
       cat("\n\nThe list of files to be pushed is:\n", list.R)
       cat("\n\nFiles and directories cloned from the remote ", repo, " repo:\n", sep = "")
       cat("  ", vapply(list.files(repo), as.character, ""), "\n")
    }
    
    # Copy the files to the local repo, add the files to the repo, and push the repo (only files that are changed are moved, that's how git push works).
    
    for (i in list.R)  {
    
      file.copy(i, paste0(repo, "/", subDir), overwrite = TRUE)
      if(verbose)
         cat("\n", i, "was copied from", HomeDir, "to", paste0(repo, "/", subDir), "\n")
    }
    
    setwd(paste0(HomeDir, repo))
    if(verbose) 
        cat("\nWorking directory is now:", getwd(), "\n")
    
    for (i in list.R)  {
    
	  if(!is.null(subDir))
	       i <- paste0(subDir,"/", i)
      rgit::git(paste0('add ', i), autoExit = autoExit)
      if(verbose)
         cat("\n", i, "was added to the local repo.\n")
    }
    
    rgit::git(paste0('commit --amend --no-edit --allow-empty -m"', message, '"'), autoExit = autoExit)  # The message text needs double quotes (") to work
    rgit::git('push -u -v --force-with-lease origin master', autoExit = autoExit) 
        
    if(verbose)
       cat(paste0("\nFiles that are changed in the local repo of ", repo, " have been pushed to GitHub.\n"))
    
    setwd(HomeDir)
    if(verbose) 
        cat("\nWorking directory is now:", getwd(), "\n\n")
    
    if(deleteRepoAfterPush) {
       system(paste0("rm -r -f ", repo))
       if(verbose) 
          cat("The local", repo, "directory was deleted.\n\n")   
    }
	
	if(length(list) == 1)
	   cat("\nIs the file on the remote repo equal to the local file:\n\n")
	else
	   cat("\nAre the files on the remote repo equal to the local files:\n\n")
	   
	for( i in list) {
	
	   cat("\n", i, ":", rgit::gitEqual(list = i, subDir = subDir, verbose = verbose), "\n", sep = "")
    }
	
    invisible()
}









