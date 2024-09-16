library('move2')
library('lubridate')

# dur = duration in hours
# low_bat = threshold below which a battery is considered lightly charged between 0 and 100 (in %).
# column_name = name of the battery charge percentage column between "".

rFunction = function(data, time_now = NULL, dur = 24, low_bat = 10, column_name = "battery_charge_percent")
{
  Sys.setenv(tz = "UTC") 
  
  if (is.null(time_now)) time_now <- Sys.time() else time_now <- as.POSIXct(time_now, format = "%Y-%m-%d %H:%M:%OS", tz = "UTC")
  
  logger.info(paste("You have selected the data of the last", dur,"hours starting from", time_now, "(UTC)."))
  
  startTime <- time_now - lubridate::hours(dur)
  
  # Splits the stack to account for various individuals
  splitStack <- split(data, mt_track_id(data))
  
  # Helper function to analyse the different stacks separately
  helperFunction = function(splitMoveStack) {
    
    # Initializes the variables
    Ind <- c()
    Bat_percent <- c()
    Nloc <- c()
    
    # data of the defined last hours
    data_dur <- splitMoveStack[which(mt_time(splitMoveStack) > startTime ), ]
    
    # --------------------------------------------------------------------------
      
    # Get the battery charge percentage of the last location
      if(nrow(data_dur) > 0) { 
      bat_percent <- as.numeric(data_dur[[nrow(data_dur),column_name]])
      } else { bat_percent = NA}
      
    # Get the number of locations recorded during the defined time duration
      if(nrow(data_dur) > 0 ) { 
        nloc <- nrow(data_dur)
      } else { nloc = 0}
    
    #---------------------------------------------------------------------------
     
     # Is the battery's charge below the set threshold?
      if(!is.na(bat_percent)){
        if(bat_percent < low_bat) {
        Bat_percent <- append(Bat_percent, bat_percent)
        Nloc <- append(Nloc, nloc)
        Ind <- append(Ind, unique(mt_track_id(splitMoveStack)))
      }
    }
    return(data.frame(Ind, Bat_percent, Nloc, row.names = NULL))
    
  }

  output <- lapply(splitStack, helperFunction)	
  
  # Gathers the results in a data frame
  output <- do.call("rbind", output)
  
  if(nrow(output > 0)) {
    
    log_warn(paste("You have", nrow(output),"individuals whose battery charge is less than ", low_bat, "%."))
    
    # Writes the csv
    write.csv(output, appArtifactPath("Low_Battery_Animals.csv"), row.names = FALSE)
    
    # Keep movestack of individuals affected by a low battery charge
    finalStack <- mt_stack(splitStack[output$Ind])
    mt_track_id(finalStack) <- factor(mt_track_id(finalStack),unique(mt_track_id(finalStack)))
    return(finalStack)
    
  } else {
    
    logger.info("You have no individuals whose battery charge is less than ", low_bat, "%.")
    return(NULL)
  }
  
}



