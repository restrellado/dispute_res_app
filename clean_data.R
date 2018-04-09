library(tidyverse)
library(stringr)

fnames <- c(
  "https://www2.ed.gov/programs/osepidea/618-data/state-level-data-files/part-b-data/dispute-resolution/bdispres2014-15.csv",
  "https://www2.ed.gov/programs/osepidea/618-data/state-level-data-files/part-b-data/dispute-resolution/bdispres2013-14.csv", 
  "https://www2.ed.gov/programs/osepidea/618-data/state-level-data-files/part-b-data/dispute-resolution/bdispres2012-13.csv"
  )

# Read files
allfiles <- fnames %>% 
  map(
    ~read_csv(., skip = 4, col_types = cols(Year = col_character()), n_max = 61)
    )

# Combine files
dpr <- bind_rows(allfiles)

# Rename variables 
#------------------------------------------------------------------------------
# Variables prefixed with `wsc` refer to categories that related to written and signed complaints.  
# Variables prefixed with `med` refer to categories related to mediations.  
# Variables prefixed with `edpc` refer to categories related to expedited due process complaints.  

dpr <- dpr %>% 
  rename(
    # Written signed complaints
    wsc_total = `Written, Signed Complaints (WSC) Total (1)`, 
    wsc_reports = `WSC with Reports Issued Total (1.1)`, 
    wsc_reports_with_findings = `WSC Reports with Findings (1.1a)`, 
    wsc_reports_ontime  = `WSC Reports within Timeline (1.1b)`, 
    wsc_reports_ext_timelines = `WSC Reports within Extended Timelines (1.1c)`, 
    wsc_pending = `WSC Pending Total  (1.2)`, 
    wsc_pending_due_proc = `WSC Pending a Due Process Hearing (1.2a)`, 
    wsc_withdrawn = `WSC Withdrawn or Dismissed(1.3)`, 
    # Mediations
    med_total = `Mediation Requests Total (2)`, 
    med_held = `Mediations Held Total (2.1)`, 
    med_from_due_proc = `Mediations Held Related to Due Process Complaints(2.1a)`, 
    med_agreed_from_due_proc = `Mediation Agreements Related to Due Process Complaints (2.1ai)`, 
    med_not_from_due_proc = `Mediations Held Not Related to Due Process Complaints (2.1b)`,
    med_agreed_not_from_due_proc = `Mediation Agreements Not Related to Due Process Complaints (2.1bi)`, 
    med_pending = `Mediations Pending (2.2)`, 
    med_withdrawn = `Mediations Withdrawn or Not Held (2.3)`, 
    # Due process
    dpc_total = `Due Process Complaints (DPC) Total (3)`, 
    dpc_resolutions = `DPC Resolution Meetings Total (3.1)`, 
    dpc_resolutions_settlements = `DPC Resolution Meetings - Written Settlement Agreements (3.1a)`, 
    dpc_adjudicated = `DPC Hearings (fully adjudicated) Total (3.2)`, 
    dpc_decisions_ontime = `DPC Written Decisions within Timeline (3.2a)`, 
    dpc_decisions_ext_timeline = `DPC Written Decisions within Extended Timelines (3.2b)`, 
    dpc_pending = `DPC Pending (3.3)`, 
    dpc_withdrawn = `DPC Withdrawn or Dismissed (3.4)`, 
    # Expedited due process complaints
    edpc_total = `Expedited Due Process Complaints (EDPC) Total (4)`, 
    edpc_resolutions = `EDPC Resulted in a Resolution Meeting Total (4.1)`, 
    edpc_resolutions_settlements = `EDPC Resolution Meetings - Written Settlement Agreements (4.1a)`, 
    edpc_adjudicated = `EDPC Expedited Hearings (fully adjudicated) Total (4.2)`, 
    edpc_placement_changes = `EDPC Expedited Hearings - Change of Placement Ordered (4.2a)`, 
    edpc_pending = `EDPC Pending (4.3)`, 
    edpc_withdrawn = `EDPC Withdrawn or Dismissed (4.4)`
    )

# Turn state names into lower case letters 
dpr$State <- tolower(dpr$State) 

# Gather variables 
test <- dpr %>% 
  gather(Category, Count, -c(Year, State)) 
test