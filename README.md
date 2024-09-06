# SelectIndividual-byBatteryCharge
MoveApps

Github repository: *https://github.com/alerte-telemetrie/SelectIndividual-byBatteryCharge*

Description*

## Description
Takes an end date (default NOW) and filters on all locations within the last X hours (default 24 hours). Retrieves the percentage of battery charge during the last location and the number of locations recorded by the GPS transmitter (or tag) over the set time period. Then, extracts the names of individuals with a battery charge percentage below a defined low battery charge percentage threshold (default 10%).

## Documentation
This function is designed to identify individuals whose GPS transmitter have a low battery charge. The battery charge percentage at the last location is retrieved, as well as the number of locations in the last X hours. If the battery charge is below a user-defined threshold, a table and movestack are extracted with the individual's movebank ID.

### Input data
MoveStack in Movebank format

### Output data
MoveStack in Movebank format

### Artefacts
Low_BatteryCharge_Animals.csv: csv-file with Table of all individuals whose tag has a battery charge percentage below the defined threshold
Movestack object : Movestack object of all individuals whose GPS transmitter has a battery charge percentage below the defined threshold

### Settings 
Reference timestamp (time_now): reference/end timestamp towards which the data selection is performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window.

Duration of data to select (dur): duration number of the data to be selected. Unit hours. Default 24.

Low battery charge threshold (low_bat): threshold below which a battery is considered lightly charged between 0 and 100. Unit %. Default 10.

Reference column name (column_name) : name of the battery charge percentage column between quotation marks. Default : "battery_charge_percent"

### Null or error handling
Setting time_now: If this parameter is left empty (NULL) the reference time is set to NOW. The present timestamp is extracted in UTC from the MoveApps server system.

Setting dur: Duration NULL defaults to 24 (hours).

Setting low_bat: Battery charge percentage NULL defaults to 10 (%).

Setting column_name : Name of the battery charge percentage column defaults : "battery_charge_percent".

Artefacts: If no individual has had a battery charge below the predefined threshold in the last X hours, no csv and movestack object files are extracted.
