Fetch NASA-POWER Parameters
================
Adam H Sparks
2019-01-18

# Create parameters list for internal checks

These data are used for internal checks to be sure that data requested
from the POWER dataset are valid. The POWER list of parameters that can
be queried is available as a JSON file. Thanks to
[raymondben](https://github.com/raymondben) for pointing me to this
file.

## Fetch list from JSON file

Using `jsonlite` read the JSON file into R creating a list.

``` r
parameters <-
  jsonlite::fromJSON(
    "https://power.larc.nasa.gov/RADAPP/GEODATA/powerWeb/POWER_Parameters_v110.json"
  )
```

Replace UTF-8 characters in the dataset since R doesn’t like this in
packages.

``` r
parameters$SG_DEC_AVG$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_DEC_AVG$climatology_definition)

parameters$SG_HR_SET_ANG$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_HR_SET_ANG$climatology_definition)

parameters$SG_NOON$climatology_definition <-
  gsub("°",
       " degrees",
       parameters$SG_NOON$climatology_definition)
```

## View list of parameters

The following list has the format:

    ## $PARAMETER_NAME
    ## [1] "standard_name"

Where `PARAMETER_NAME` is used in the internal `parameters` list. The
`"standard_name"` is a longer, more descriptive name for the parameter
that may be more instructive to users.

``` r
purrr::map(parameters, "standard_name")
```

    ## $ALLSKY_SFC_LW_DWN
    ## [1] "Downward Thermal Infrared (Longwave) Radiative Flux"
    ## 
    ## $ALLSKY_SFC_SW_DWN
    ## [1] "All Sky Insolation Incident on a Horizontal Surface"
    ## 
    ## $ALLSKY_SFC_SW_DWN_00_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 00 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_03_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 03 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_06_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 06 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_09_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 09 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_12_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 12 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_15_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 15 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_18_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 18 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_21_GMT
    ## [1] "All Sky Insolation Incident On A Horizontal Surface at 21 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_MAX_DIFF
    ## [1] "Maximum Monthly Difference From Monthly Averaged All Sky Insolation "
    ## 
    ## $ALLSKY_SFC_SW_DWN_MIN_DIFF
    ## [1] "Minimum Monthly Difference From Monthly Averaged All Sky Insolation"
    ## 
    ## $ALLSKY_TOA_SW_DWN
    ## [1] "Top-of-atmosphere Insolation"
    ## 
    ## $CDD0
    ## [1] "Cooling Degree Days Above 0 C"
    ## 
    ## $CDD10
    ## [1] "Cooling Degree Days Above 10 C"
    ## 
    ## $CDD18_3
    ## [1] "Cooling Degree Days Above 18.3 C"
    ## 
    ## $CLD_AMT
    ## [1] "Daylight Cloud Amount"
    ## 
    ## $CLD_AMT_00_GMT
    ## [1] "Cloud Amount at 00 GMT"
    ## 
    ## $CLD_AMT_03_GMT
    ## [1] "Cloud Amount at 03 GMT"
    ## 
    ## $CLD_AMT_06_GMT
    ## [1] "Cloud Amount at 06 GMT"
    ## 
    ## $CLD_AMT_09_GMT
    ## [1] "Cloud Amount at 09 GMT"
    ## 
    ## $CLD_AMT_12_GMT
    ## [1] "Cloud Amount at 12 GMT"
    ## 
    ## $CLD_AMT_15_GMT
    ## [1] "Cloud Amount at 15 GMT"
    ## 
    ## $CLD_AMT_18_GMT
    ## [1] "Cloud Amount at 18 GMT"
    ## 
    ## $CLD_AMT_21_GMT
    ## [1] "Cloud Amount at 21 GMT"
    ## 
    ## $CLRSKY_DIFF
    ## [1] "Clear Sky Diffuse Radiation On A Horizontal Surface"
    ## 
    ## $CLRSKY_NKT
    ## [1] "Normalized Clear Sky Insolation Clearness Index"
    ## 
    ## $CLRSKY_SFC_SW_DWN
    ## [1] "Clear Sky Insolation Incident on a Horizontal Surface"
    ## 
    ## $DIFF
    ## [1] "Diffuse Radiation On A Horizontal Surface"
    ## 
    ## $DIFF_MAX
    ## [1] "Maximum Diffuse Radiation On A Horizontal Surface"
    ## 
    ## $DIFF_MIN
    ## [1] "Minimum Diffuse Radiation On A Horizontal Surface"
    ## 
    ## $DNR
    ## [1] "Direct Normal Radiation"
    ## 
    ## $DNR_MAX
    ## [1] "Maximum Direct Normal Radiation"
    ## 
    ## $DNR_MAX_DIFF
    ## [1] "Maximum Difference From Monthly Averaged Direct Normal Radiation"
    ## 
    ## $DNR_MIN
    ## [1] "Minimum Direct Normal Radiation"
    ## 
    ## $DNR_MIN_DIFF
    ## [1] "Minimum Difference From Monthly Averaged Direct Normal Radiation"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_1
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 1-day Period"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_14
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 14-day Period"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_21
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 21-day Period"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_3
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 3-day Period"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_7
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 7-day Period"
    ## 
    ## $EQVLNT_NO_SUN_BLACKDAYS_MONTH
    ## [1] "Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive Month Period"
    ## 
    ## $FROST_DAYS
    ## [1] "Frost Days"
    ## 
    ## $FRQ_BRKNCLD_10_70_00_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 00 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_03_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 03 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_06_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 06 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_09_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 09 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_12_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 12 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_15_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 15 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_18_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 18 GMT"
    ## 
    ## $FRQ_BRKNCLD_10_70_21_GMT
    ## [1] "Frequency Of Broken-cloud Skies 10 - 70 % At 21 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_00_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 00 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_03_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 03 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_06_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 06 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_09_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 09 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_12_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 12 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_15_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 15 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_18_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 18 GMT"
    ## 
    ## $FRQ_CLRSKY_0_10_21_GMT
    ## [1] "Frequency Of Clear Skies < 10% At 21 GMT"
    ## 
    ## $FRQ_NROVRCST_70_00_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 00 GMT"
    ## 
    ## $FRQ_NROVRCST_70_03_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 03 GMT"
    ## 
    ## $FRQ_NROVRCST_70_06_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 06 GMT"
    ## 
    ## $FRQ_NROVRCST_70_09_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 09 GMT"
    ## 
    ## $FRQ_NROVRCST_70_12_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 12 GMT"
    ## 
    ## $FRQ_NROVRCST_70_15_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 15 GMT"
    ## 
    ## $FRQ_NROVRCST_70_18_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 18 GMT"
    ## 
    ## $FRQ_NROVRCST_70_21_GMT
    ## [1] "Frequency Of Near-overcast Skies >= 70% At 21 GMT"
    ## 
    ## $HDD0
    ## [1] "Heating Degree Days Below 0 C"
    ## 
    ## $HDD10
    ## [1] "Heating Degree Days Below 10 C"
    ## 
    ## $HDD18_3
    ## [1] "Heating Degree Days Below 18.3 C"
    ## 
    ## $INSOL_MIN_CONSEC_1
    ## [1] "Minimum Available Insolation Over A Consecutive 1-day Period"
    ## 
    ## $INSOL_MIN_CONSEC_14
    ## [1] "Minimum Available Insolation Over A Consecutive 14-day Period"
    ## 
    ## $INSOL_MIN_CONSEC_21
    ## [1] "Minimum Available Insolation Over A Consecutive 21-day Period"
    ## 
    ## $INSOL_MIN_CONSEC_3
    ## [1] "Minimum Available Insolation Over A Consecutive 3-day Period"
    ## 
    ## $INSOL_MIN_CONSEC_7
    ## [1] "Minimum Available Insolation Over A Consecutive 7-day Period"
    ## 
    ## $INSOL_MIN_CONSEC_MONTH
    ## [1] "Minimum Available Insolation Over A Consecutive Month Period"
    ## 
    ## $KT
    ## [1] "Insolation Clearness Index"
    ## 
    ## $KT_CLEAR
    ## [1] "Clear Sky Insolation Clearness Index"
    ## 
    ## $MIDDAY_INSOL
    ## [1] "Midday Insolation Incident On A Horizontal Surface"
    ## 
    ## $NKT
    ## [1] "Normalized Insolation Clearness Index"
    ## 
    ## $NO_SUN_BLACKDAYS_MAX
    ## [1] "Maximum NO-SUN Or BLACK Days"
    ## 
    ## $PHIS
    ## [1] "Surface Geopotential"
    ## 
    ## $PRECTOT
    ## [1] "Precipitation"
    ## 
    ## $PS
    ## [1] "Surface Pressure"
    ## 
    ## $PSC
    ## [1] "Corrected Atmospheric Pressure (Adjusted For Site Elevation)"
    ## 
    ## $QV2M
    ## [1] "Specific Humidity at 2 Meters"
    ## 
    ## $RH2M
    ## [1] "Relative Humidity at 2 Meters"
    ## 
    ## $SG_DAY_COZ_ZEN_AVG
    ## [1] "Daylight Average Of Hourly Cosine Solar Zenith Angles"
    ## 
    ## $SG_DAY_HOUR_AVG
    ## [1] "Daylight Hours"
    ## 
    ## $SG_DEC_AVG
    ## [1] "Declination"
    ## 
    ## $SG_HR_AZM_ANG_AVG
    ## [1] "Hourly Solar Azimuth Angles"
    ## 
    ## $SG_HR_HRZ_ANG_AVG
    ## [1] "Hourly Solar Angles Relative To The Horizon"
    ## 
    ## $SG_HR_SET_ANG
    ## [1] "Sunset Hour Angle"
    ## 
    ## $SG_MAX_HRZ_ANG
    ## [1] "Maximum Solar Angle Relative To The Horizon"
    ## 
    ## $SG_MID_COZ_ZEN_ANG
    ## [1] "Cosine Solar Zenith Angle At Mid-Time Between Sunrise And Solar Noon"
    ## 
    ## $SG_NOON
    ## [1] "Solar Noon"
    ## 
    ## $SI_EF_MAX_OPTIMAL
    ## [1] "Maximum Solar Irradiance Optimal"
    ## 
    ## $SI_EF_MAX_OPTIMAL_ANG
    ## [1] "Maximum Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_MAX_TILTED_ANG_ORT
    ## [1] "Maximum Solar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE
    ## [1] "Maximum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SI_EF_MIN_OPTIMAL
    ## [1] "Minimum Solar Irradiance Optimal"
    ## 
    ## $SI_EF_MIN_OPTIMAL_ANG
    ## [1] "Minimum Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_MIN_TILTED_ANG_ORT
    ## [1] "MinimumSolar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE
    ## [1] "Minimum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SI_EF_OPTIMAL
    ## [1] "Solar Irradiance Optimal"
    ## 
    ## $SI_EF_OPTIMAL_ANG
    ## [1] "Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_TILTED_ANG_ORT
    ## [1] "Solar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_TILTED_SURFACE
    ## [1] "Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SR
    ## [1] "Surface Roughness"
    ## 
    ## $SRF_ALB
    ## [1] "Surface Albedo"
    ## 
    ## $T10M
    ## [1] "Temperature at 10 Meters"
    ## 
    ## $T10M_MAX
    ## [1] "Maximum Temperature at 10 Meters"
    ## 
    ## $T10M_MIN
    ## [1] "Minimum Temperature at 10 Meters"
    ## 
    ## $T10M_RANGE
    ## [1] "Temperature Range at 10 Meters"
    ## 
    ## $T2M
    ## [1] "Temperature at 2 Meters"
    ## 
    ## $T2MDEW
    ## [1] "Dew/Frost Point at 2 Meters"
    ## 
    ## $T2MWET
    ## [1] "Wet Bulb Temperature at 2 Meters"
    ## 
    ## $T2M_MAX
    ## [1] "Maximum Temperature at 2 Meters"
    ## 
    ## $T2M_MIN
    ## [1] "Minimum Temperature at 2 Meters"
    ## 
    ## $T2M_RANGE
    ## [1] "Temperature Range at 2 Meters"
    ## 
    ## $TM_ZONES
    ## [1] "Climate Thermal and Moisture Zones"
    ## 
    ## $TQV
    ## [1] "Total Column Precipitable Water"
    ## 
    ## $TS
    ## [1] "Earth Skin Temperature"
    ## 
    ## $TS_AMP
    ## [1] "Earth Skin Temperature Amplitude"
    ## 
    ## $TS_MAX
    ## [1] "Maximum Earth Skin Temperature"
    ## 
    ## $TS_MIN
    ## [1] "Minimum Earth Skin Temperature"
    ## 
    ## $TS_RANGE
    ## [1] "Earth Skin Temperature Range"
    ## 
    ## $T_ZONES
    ## [1] "Climate Thermal Zones"
    ## 
    ## $U10M
    ## [1] "Eastward Wind at 10 Meters "
    ## 
    ## $V10M
    ## [1] "Northward Wind at 10 Meters "
    ## 
    ## $WD10M
    ## [1] "Wind Direction at 10 Meters (Meteorological Convention)"
    ## 
    ## $WD2M
    ## [1] "Wind Direction at 2 Meters (Meteorological Convention)"
    ## 
    ## $WD50M
    ## [1] "Wind Direction at 50 Meters (Meteorological Convention)"
    ## 
    ## $WS10M
    ## [1] "Wind Speed at 10 Meters"
    ## 
    ## $WS10M_MAX
    ## [1] "Maximum Wind Speed at 10 Meters"
    ## 
    ## $WS10M_MIN
    ## [1] "Minimum Wind Speed at 10 Meters"
    ## 
    ## $WS10M_RANGE
    ## [1] "Wind Speed Range at 10 Meters"
    ## 
    ## $WS2M
    ## [1] "Wind Speed at 2 Meters"
    ## 
    ## $WS2M_MAX
    ## [1] "Maximum Wind Speed at 2 Meters"
    ## 
    ## $WS2M_MIN
    ## [1] "Minimum Wind Speed at 2 Meters"
    ## 
    ## $WS2M_RANGE
    ## [1] "Wind Speed Range at 2 Meters"
    ## 
    ## $WS50M
    ## [1] "Wind Speed at 50 Meters"
    ## 
    ## $WS50M_MAX
    ## [1] "Maximum Wind Speed at 50 Meters"
    ## 
    ## $WS50M_MIN
    ## [1] "Minimum Wind Speed at 50 Meters"
    ## 
    ## $WS50M_RANGE
    ## [1] "Wind Speed Range at 50 Meters"
    ## 
    ## $WSC
    ## [1] "Corrected Wind Speed (Adjusted For Elevation)"

## Save list for use in `nasapower` package

Using `usethis` save the list as an R data object for use in the
`nasapower`
    package.

``` r
usethis::use_data(parameters, overwrite = TRUE)
```

    ## ✔ Setting active project to '/Users/adamsparks/Development/nasapower'
    ## ✔ Saving 'parameters' to 'data/parameters.rda'

## Session Info

``` r
sessioninfo::session_info()
```

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.5.2 (2018-12-20)
    ##  os       macOS Mojave 10.14.2        
    ##  system   x86_64, darwin18.2.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2019-01-18                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       lib source        
    ##  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.2)
    ##  backports     1.1.3   2018-12-14 [1] CRAN (R 3.5.2)
    ##  cli           1.0.1   2018-09-25 [1] CRAN (R 3.5.2)
    ##  clisymbols    1.2.0   2017-05-21 [1] CRAN (R 3.5.2)
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.2)
    ##  curl          3.3     2019-01-10 [1] CRAN (R 3.5.2)
    ##  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.2)
    ##  evaluate      0.12    2018-10-09 [1] CRAN (R 3.5.2)
    ##  fs            1.2.6   2018-08-23 [1] CRAN (R 3.5.2)
    ##  glue          1.3.0   2018-07-17 [1] CRAN (R 3.5.2)
    ##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.2)
    ##  jsonlite      1.6     2018-12-07 [1] CRAN (R 3.5.2)
    ##  knitr         1.21    2018-12-10 [1] CRAN (R 3.5.2)
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.2)
    ##  purrr         0.2.5   2018-05-29 [1] CRAN (R 3.5.2)
    ##  Rcpp          1.0.0   2018-11-07 [1] CRAN (R 3.5.2)
    ##  rlang         0.3.1   2019-01-08 [1] CRAN (R 3.5.2)
    ##  rmarkdown     1.11    2018-12-08 [1] CRAN (R 3.5.2)
    ##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.2)
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.2)
    ##  stringi       1.2.4   2018-07-20 [1] CRAN (R 3.5.2)
    ##  stringr       1.3.1   2018-05-10 [1] CRAN (R 3.5.2)
    ##  usethis       1.4.0   2018-08-14 [1] CRAN (R 3.5.2)
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.2)
    ##  xfun          0.4     2018-10-23 [1] CRAN (R 3.5.2)
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.2)
    ## 
    ## [1] /Users/adamsparks/Library/R/3.x/library
    ## [2] /usr/local/lib/R/3.5/site-library
    ## [3] /usr/local/Cellar/r/3.5.2/lib/R/library
