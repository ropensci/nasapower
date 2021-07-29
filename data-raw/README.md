Fetch NASA-POWER Parameters
================
Adam H Sparks
2021-07-29

# Create parameters list for internal checks before sending queries to POWER server

These data are used for internal checks to be sure that data requested
from the POWER dataset are valid. The POWER list of parameters that can
be queried is available as an API query from the POWER server.

## POWER JSON file

Using `jsonlite::fromJSON()` read the JSON file into R creating a list.

``` r
parameters <-
  jsonlite::fromJSON("https://power.larc.nasa.gov/beta/api/system/manager/system/parameters")

parameters <- parameters[order(names(parameters))]
```

## View list of parameters and units

The following list of 389 valid POWER parameters has the following
format:

    ## $PARAMETER_NAME
    ## [1] "standard_name"

Where `PARAMETER_NAME` is used in the internal `parameters` list and is
used in checking against user requests for API queries. The
`standard_name` is a longer, more descriptive name for the parameter
that may be more instructive to users in finding the data that they wish
to fetch from the POWER server.

``` r
purrr::map(parameters, "longname")
```

    ## $AIRMASS
    ## [1] "Air Mass"
    ## 
    ## $ALLSKY_KT
    ## [1] "All Sky Insolation Clearness Index"
    ## 
    ## $ALLSKY_KT_MAX
    ## [1] "All Sky Insolation Clearness Index Maximum"
    ## 
    ## $ALLSKY_KT_MIN
    ## [1] "All Sky Insolation Clearness Index Minimum"
    ## 
    ## $ALLSKY_KT_SD
    ## [1] "All Sky Insolation Clearness Index Standard Deviation"
    ## 
    ## $ALLSKY_NKT
    ## [1] "All Sky Normalized Insolation Clearness Index"
    ## 
    ## $ALLSKY_SFC_LW_DWN
    ## [1] "All Sky Surface Longwave Downward Irradiance"
    ## 
    ## $ALLSKY_SFC_LW_DWN_MAX
    ## [1] "All Sky Surface Longwave Downward Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_LW_DWN_MIN
    ## [1] "All Sky Surface Longwave Downward Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_LW_DWN_SD
    ## [1] "All Sky Surface Longwave Downward Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_LW_UP
    ## [1] "All Sky Surface Longwave Upward Irradiance"
    ## 
    ## $ALLSKY_SFC_LW_UP_MAX
    ## [1] "All Sky Surface Longwave Upward Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_LW_UP_MIN
    ## [1] "All Sky Surface Longwave Upward Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_LW_UP_SD
    ## [1] "All Sky Surface Longwave Upward Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_PAR_TOT
    ## [1] "All Sky Surface PAR Total"
    ## 
    ## $ALLSKY_SFC_PAR_TOT_MAX
    ## [1] "All Sky Surface PAR Total Maximum"
    ## 
    ## $ALLSKY_SFC_PAR_TOT_MIN
    ## [1] "All Sky Surface PAR Total Minimum"
    ## 
    ## $ALLSKY_SFC_PAR_TOT_SD
    ## [1] "All Sky Surface PAR Total Standard Deviation"
    ## 
    ## $ALLSKY_SFC_SW_DIFF
    ## [1] "All Sky Surface Shortwave Diffuse Irradiance"
    ## 
    ## $ALLSKY_SFC_SW_DIFF_MAX
    ## [1] "All Sky Surface Shortwave Diffuse Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_SW_DIFF_MIN
    ## [1] "All Sky Surface Shortwave Diffuse Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_SW_DIFF_SD
    ## [1] "All Sky Surface Shortwave Diffuse Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_SW_DIRH
    ## [1] "All Sky Surface Shortwave Direct Horizontal Irradiance"
    ## 
    ## $ALLSKY_SFC_SW_DIRH_MAX
    ## [1] "All Sky Surface Shortwave Direct Horizontal Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_SW_DIRH_MIN
    ## [1] "All Sky Surface Shortwave Direct Horizontal Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_SW_DIRH_SD
    ## [1] "All Sky Surface Shortwave Direct Horizontal Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_SW_DNI
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance"
    ## 
    ## $ALLSKY_SFC_SW_DNI_MAX
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_SW_DNI_MAX_RD
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance Maximum Relative Difference"
    ## 
    ## $ALLSKY_SFC_SW_DNI_MIN
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_SW_DNI_MIN_RD
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance Minimum Relative Difference"
    ## 
    ## $ALLSKY_SFC_SW_DNI_SD
    ## [1] "All Sky Surface Shortwave Downward Direct Normal Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_SW_DWN
    ## [1] "All Sky Surface Shortwave Downward Irradiance"
    ## 
    ## $ALLSKY_SFC_SW_DWN_00
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 00 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_01
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 01 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_02
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 02 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_03
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 03 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_04
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 04 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_05
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 05 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_06
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 06 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_07
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 07 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_08
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 08 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_09
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 09 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_10
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 10 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_11
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 11 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_12
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 12 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_13
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 13 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_14
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 14 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_15
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 15 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_16
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 16 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_17
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 17 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_18
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 18 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_19
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 19 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_20
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 20 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_21
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 21 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_22
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 22 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_23
    ## [1] "All Sky Surface Shortwave Downward Irradiance at 23 GMT"
    ## 
    ## $ALLSKY_SFC_SW_DWN_HR
    ## [1] "All Sky Surface Shortwave Downward Irradiance at GMT Times"
    ## 
    ## $ALLSKY_SFC_SW_DWN_MAX
    ## [1] "All Sky Surface Shortwave Downward Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_SW_DWN_MAX_RD
    ## [1] "All Sky Surface Shortwave Downward Irradiance Maximum Relative Difference"
    ## 
    ## $ALLSKY_SFC_SW_DWN_MIN
    ## [1] "All Sky Surface Shortwave Downward Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_SW_DWN_MIN_RD
    ## [1] "All Sky Surface Shortwave Downward Irradiance Minimum Relative Difference"
    ## 
    ## $ALLSKY_SFC_SW_DWN_SD
    ## [1] "All Sky Surface Shortwave Downward Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_SW_UP
    ## [1] "All Sky Surface Shortwave Upward Irradiance"
    ## 
    ## $ALLSKY_SFC_SW_UP_MAX
    ## [1] "All Sky Surface Shortwave Upward Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_SW_UP_MIN
    ## [1] "All Sky Surface Shortwave Upward Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_SW_UP_SD
    ## [1] "All Sky Surface Shortwave Upward Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_UV_INDEX
    ## [1] "All Sky Surface UV Index"
    ## 
    ## $ALLSKY_SFC_UV_INDEX_MAX
    ## [1] "All Sky Surface UV Index Maximum"
    ## 
    ## $ALLSKY_SFC_UV_INDEX_MIN
    ## [1] "All Sky Surface UV Index Minimum"
    ## 
    ## $ALLSKY_SFC_UV_INDEX_SD
    ## [1] "All Sky Surface UV Index Standard Deviation"
    ## 
    ## $ALLSKY_SFC_UVA
    ## [1] "All Sky Surface UVA Irradiance"
    ## 
    ## $ALLSKY_SFC_UVA_MAX
    ## [1] "All Sky Surface UVA Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_UVA_MIN
    ## [1] "All Sky Surface UVA Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_UVA_SD
    ## [1] "All Sky Surface UVA Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SFC_UVB
    ## [1] "All Sky Surface UVB Irradiance"
    ## 
    ## $ALLSKY_SFC_UVB_MAX
    ## [1] "All Sky Surface UVB Irradiance Maximum"
    ## 
    ## $ALLSKY_SFC_UVB_MIN
    ## [1] "All Sky Surface UVB Irradiance Minimum"
    ## 
    ## $ALLSKY_SFC_UVB_SD
    ## [1] "All Sky Surface UVB Irradiance Standard Deviation"
    ## 
    ## $ALLSKY_SRF_ALB
    ## [1] "All Sky Surface Albedo"
    ## 
    ## $AOD_55
    ## [1] "Aerosol Optical Depth 55"
    ## 
    ## $AOD_55_ADJ
    ## [1] "Adjusted Aerosol Optical Depth 55"
    ## 
    ## $AOD_84
    ## [1] "Aerosol Optical Depth 84"
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
    ## $CLOUD_AMT
    ## [1] "Cloud Amount"
    ## 
    ## $CLOUD_AMT_00
    ## [1] "Cloud Amount at 00 GMT"
    ## 
    ## $CLOUD_AMT_01
    ## [1] "Cloud Amount at 01 GMT"
    ## 
    ## $CLOUD_AMT_02
    ## [1] "Cloud Amount at 02 GMT"
    ## 
    ## $CLOUD_AMT_03
    ## [1] "Cloud Amount at 03 GMT"
    ## 
    ## $CLOUD_AMT_04
    ## [1] "Cloud Amount at 04 GMT"
    ## 
    ## $CLOUD_AMT_05
    ## [1] "Cloud Amount at 05 GMT"
    ## 
    ## $CLOUD_AMT_06
    ## [1] "Cloud Amount at 06 GMT"
    ## 
    ## $CLOUD_AMT_07
    ## [1] "Cloud Amount at 07 GMT"
    ## 
    ## $CLOUD_AMT_08
    ## [1] "Cloud Amount at 08 GMT"
    ## 
    ## $CLOUD_AMT_09
    ## [1] "Cloud Amount at 09 GMT"
    ## 
    ## $CLOUD_AMT_10
    ## [1] "Cloud Amount at 10 GMT"
    ## 
    ## $CLOUD_AMT_11
    ## [1] "Cloud Amount at 11 GMT"
    ## 
    ## $CLOUD_AMT_12
    ## [1] "Cloud Amount at 12 GMT"
    ## 
    ## $CLOUD_AMT_13
    ## [1] "Cloud Amount at 13 GMT"
    ## 
    ## $CLOUD_AMT_14
    ## [1] "Cloud Amount at 14 GMT"
    ## 
    ## $CLOUD_AMT_15
    ## [1] "Cloud Amount at 15 GMT"
    ## 
    ## $CLOUD_AMT_16
    ## [1] "Cloud Amount at 16 GMT"
    ## 
    ## $CLOUD_AMT_17
    ## [1] "Cloud Amount at 17 GMT"
    ## 
    ## $CLOUD_AMT_18
    ## [1] "Cloud Amount at 18 GMT"
    ## 
    ## $CLOUD_AMT_19
    ## [1] "Cloud Amount at 19 GMT"
    ## 
    ## $CLOUD_AMT_20
    ## [1] "Cloud Amount at 20 GMT"
    ## 
    ## $CLOUD_AMT_21
    ## [1] "Cloud Amount at 21 GMT"
    ## 
    ## $CLOUD_AMT_22
    ## [1] "Cloud Amount at 22 GMT"
    ## 
    ## $CLOUD_AMT_23
    ## [1] "Cloud Amount at 23 GMT"
    ## 
    ## $CLOUD_AMT_DAY
    ## [1] "Cloud Amount at Daytime"
    ## 
    ## $CLOUD_AMT_HR
    ## [1] "Cloud Amount at GMT Times"
    ## 
    ## $CLOUD_AMT_NIGHT
    ## [1] "Cloud Amount at Nighttime"
    ## 
    ## $CLOUD_OD
    ## [1] "Cloud Optical Visible Depth"
    ## 
    ## $CLOUD_OD_00
    ## [1] "Cloud Optical Visible Depth at 00 GMT"
    ## 
    ## $CLOUD_OD_01
    ## [1] "Cloud Optical Visible Depth at 01 GMT"
    ## 
    ## $CLOUD_OD_02
    ## [1] "Cloud Optical Visible Depth at 02 GMT"
    ## 
    ## $CLOUD_OD_03
    ## [1] "Cloud Optical Visible Depth at 03 GMT"
    ## 
    ## $CLOUD_OD_04
    ## [1] "Cloud Optical Visible Depth at 04 GMT"
    ## 
    ## $CLOUD_OD_05
    ## [1] "Cloud Optical Visible Depth at 05 GMT"
    ## 
    ## $CLOUD_OD_06
    ## [1] "Cloud Optical Visible Depth at 06 GMT"
    ## 
    ## $CLOUD_OD_07
    ## [1] "Cloud Optical Visible Depth at 07 GMT"
    ## 
    ## $CLOUD_OD_08
    ## [1] "Cloud Optical Visible Depth at 08 GMT"
    ## 
    ## $CLOUD_OD_09
    ## [1] "Cloud Optical Visible Depth at 09 GMT"
    ## 
    ## $CLOUD_OD_10
    ## [1] "Cloud Optical Visible Depth at 10 GMT"
    ## 
    ## $CLOUD_OD_11
    ## [1] "Cloud Optical Visible Depth at 11 GMT"
    ## 
    ## $CLOUD_OD_12
    ## [1] "Cloud Optical Visible Depth at 12 GMT"
    ## 
    ## $CLOUD_OD_13
    ## [1] "Cloud Optical Visible Depth at 13 GMT"
    ## 
    ## $CLOUD_OD_14
    ## [1] "Cloud Optical Visible Depth at 14 GMT"
    ## 
    ## $CLOUD_OD_15
    ## [1] "Cloud Optical Visible Depth at 15 GMT"
    ## 
    ## $CLOUD_OD_16
    ## [1] "Cloud Optical Visible Depth at 16 GMT"
    ## 
    ## $CLOUD_OD_17
    ## [1] "Cloud Optical Visible Depth at 17 GMT"
    ## 
    ## $CLOUD_OD_18
    ## [1] "Cloud Optical Visible Depth at 18 GMT"
    ## 
    ## $CLOUD_OD_19
    ## [1] "Cloud Optical Visible Depth at 19 GMT"
    ## 
    ## $CLOUD_OD_20
    ## [1] "Cloud Optical Visible Depth at 20 GMT"
    ## 
    ## $CLOUD_OD_21
    ## [1] "Cloud Optical Visible Depth at 21 GMT"
    ## 
    ## $CLOUD_OD_22
    ## [1] "Cloud Optical Visible Depth at 22 GMT"
    ## 
    ## $CLOUD_OD_23
    ## [1] "Cloud Optical Visible Depth at 23 GMT"
    ## 
    ## $CLOUD_OD_HR
    ## [1] "Cloud Optical Visible Depth at GMT Times"
    ## 
    ## $CLRSKY_DAYS
    ## [1] "Clear Sky Day"
    ## 
    ## $CLRSKY_KT
    ## [1] "Clear Sky Insolation Clearness Index"
    ## 
    ## $CLRSKY_KT_MAX
    ## [1] "Clear Sky Insolation Clearness Index Maximum"
    ## 
    ## $CLRSKY_KT_MIN
    ## [1] "Clear Sky Insolation Clearness Index Minimum"
    ## 
    ## $CLRSKY_KT_SD
    ## [1] "Clear Sky Insolation Clearness Index Standard Deviation"
    ## 
    ## $CLRSKY_NKT
    ## [1] "Clear Sky Normalized Insolation Clearness Index"
    ## 
    ## $CLRSKY_SFC_LW_DWN
    ## [1] "Clear Sky Surface Longwave Downward Irradiance"
    ## 
    ## $CLRSKY_SFC_LW_DWN_MAX
    ## [1] "Clear Sky Surface Longwave Downward Irradiance Maximum"
    ## 
    ## $CLRSKY_SFC_LW_DWN_MIN
    ## [1] "Clear Sky Surface Longwave Downward Irradiance Minimum"
    ## 
    ## $CLRSKY_SFC_LW_DWN_SD
    ## [1] "Clear Sky Surface Longwave Downward Irradiance Standard Deviation"
    ## 
    ## $CLRSKY_SFC_LW_UP
    ## [1] "Clear Sky Surface Longwave Upward Irradiance"
    ## 
    ## $CLRSKY_SFC_LW_UP_MAX
    ## [1] "Clear Sky Surface Longwave Upward Irradiance Maximum"
    ## 
    ## $CLRSKY_SFC_LW_UP_MIN
    ## [1] "Clear Sky Surface Longwave Upward Irradiance Minimum"
    ## 
    ## $CLRSKY_SFC_LW_UP_SD
    ## [1] "Clear Sky Surface Longwave Upward Irradiance Standard Deviation"
    ## 
    ## $CLRSKY_SFC_PAR_TOT
    ## [1] "Clear Sky Surface PAR Total"
    ## 
    ## $CLRSKY_SFC_PAR_TOT_MAX
    ## [1] "Clear Sky Surface PAR Total Maximum"
    ## 
    ## $CLRSKY_SFC_PAR_TOT_MIN
    ## [1] "Clear Sky Surface PAR Total Minimum"
    ## 
    ## $CLRSKY_SFC_PAR_TOT_SD
    ## [1] "Clear Sky Surface PAR Total Standard Deviation"
    ## 
    ## $CLRSKY_SFC_SW_DWN
    ## [1] "Clear Sky Surface Shortwave Downward Irradiance"
    ## 
    ## $CLRSKY_SFC_SW_DWN_MAX
    ## [1] "Clear Sky Surface Shortwave Downward Irradiance Maximum"
    ## 
    ## $CLRSKY_SFC_SW_DWN_MIN
    ## [1] "Clear Sky Surface Shortwave Downward Irradiance Minimum"
    ## 
    ## $CLRSKY_SFC_SW_DWN_SD
    ## [1] "Clear Sky Surface Shortwave Downward Irradiance Standard Deviation"
    ## 
    ## $CLRSKY_SFC_SW_UP
    ## [1] "Clear Sky Surface Shortwave Upward Irradiance"
    ## 
    ## $CLRSKY_SFC_SW_UP_MAX
    ## [1] "Clear Sky Surface Shortwave Upward Irradiance Maximum"
    ## 
    ## $CLRSKY_SFC_SW_UP_MIN
    ## [1] "Clear Sky Surface Shortwave Upward Irradiance Minimum"
    ## 
    ## $CLRSKY_SFC_SW_UP_SD
    ## [1] "Clear Sky Surface Shortwave Upward Irradiance Standard Deviation"
    ## 
    ## $CLRSKY_SRF_ALB
    ## [1] "Clear Sky Surface Albedo"
    ## 
    ## $DIFFUSE_ILLUMINANCE
    ## [1] "Diffuse Illuminance"
    ## 
    ## $DIRECT_ILLUMINANCE
    ## [1] "Direct Illuminance"
    ## 
    ## $DISPH
    ## [1] "Zero Plane Displacement Height"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_01
    ## [1] "Equivalent No-Sun Days Over A Consecutive 1-day Period"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_03
    ## [1] "Equivalent No-Sun Days Over A Consecutive 3-day Period"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_07
    ## [1] "Equivalent No-Sun Days Over A Consecutive 7-day Period"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_14
    ## [1] "Equivalent No-Sun Days Over A Consecutive 14-day Period"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_21
    ## [1] "Equivalent No-Sun Days Over A Consecutive 21-day Period"
    ## 
    ## $EQUIV_NO_SUN_CONSEC_MONTH
    ## [1] "Equivalent No-Sun Days Over A Consecutive Month Period"
    ## 
    ## $EVLAND
    ## [1] "Evaporation Land"
    ## 
    ## $EVPTRNS
    ## [1] "Evapotranspiration Energy Flux"
    ## 
    ## $FROST_DAYS
    ## [1] "Frost Days"
    ## 
    ## $FRSEAICE
    ## [1] "Ice Covered Fraction"
    ## 
    ## $FRSNO
    ## [1] "Land Snowcover Fraction"
    ## 
    ## $GLOBAL_ILLUMINANCE
    ## [1] "Global Illuminance"
    ## 
    ## $GWETPROF
    ## [1] "Profile Soil Moisture"
    ## 
    ## $GWETROOT
    ## [1] "Root Zone Soil Wetness"
    ## 
    ## $GWETTOP
    ## [1] "Surface Soil Wetness"
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
    ## $INSOL_CONSEC_01
    ## [1] "Surplus Insolation Over A Consecutive 1-day Period"
    ## 
    ## $INSOL_CONSEC_01_MIN
    ## [1] "Minimum Insolation Over A Consecutive 1-day Period"
    ## 
    ## $INSOL_CONSEC_03
    ## [1] "Surplus Insolation Over A Consecutive 3-day Period"
    ## 
    ## $INSOL_CONSEC_03_MIN
    ## [1] "Minimum Insolation Over A Consecutive 3-day Period"
    ## 
    ## $INSOL_CONSEC_07
    ## [1] "Surplus Insolation Over A Consecutive 7-day Period"
    ## 
    ## $INSOL_CONSEC_07_MIN
    ## [1] "Minimum Insolation Over A Consecutive 7-day Period"
    ## 
    ## $INSOL_CONSEC_14
    ## [1] "Surplus Insolation Over A Consecutive 14-day Period"
    ## 
    ## $INSOL_CONSEC_14_MIN
    ## [1] "Minimum Insolation Over A Consecutive 14-day Period"
    ## 
    ## $INSOL_CONSEC_21
    ## [1] "Surplus Insolation Over A Consecutive 21-day Period"
    ## 
    ## $INSOL_CONSEC_21_MIN
    ## [1] "Minimum Insolation Over A Consecutive 21-day Period"
    ## 
    ## $INSOL_CONSEC_MONTH
    ## [1] "Surplus Insolation Over A Consecutive Month Period"
    ## 
    ## $INSOL_CONSEC_MONTH_MIN
    ## [1] "Minimum Insolation Over A Consecutive Month Period"
    ## 
    ## $MAX_EQUIV_NO_SUN_DEFICIT
    ## [1] "Maximum Equivalent No-Sun Days Deficit"
    ## 
    ## $MIDDAY_INSOL
    ## [1] "Midday Insolation Incident"
    ## 
    ## $MIDDAY_INSOL_MAX
    ## [1] "Midday Insolation Incident Maximum"
    ## 
    ## $MIDDAY_INSOL_MIN
    ## [1] "Midday Insolation Incident Minimum"
    ## 
    ## $MIDDAY_INSOL_SD
    ## [1] "Midday Insolation Incident Standard Deviation"
    ## 
    ## $NO_SUN_BLACKDAYS_MAX
    ## [1] "Equivalent No-Sun Days"
    ## 
    ## $PBLTOP
    ## [1] "Planetary Boundary Layer Top Pressure"
    ## 
    ## $PRECSNO
    ## [1] "Snow Precipitation"
    ## 
    ## $PRECSNOLAND
    ## [1] "Precipitation Land"
    ## 
    ## $PRECSNOLAND_SUM
    ## [1] "Snow Precipitation Land Sum"
    ## 
    ## $PRECTOTCORR
    ## [1] "Precipitation Corrected"
    ## 
    ## $PRECTOTCORR_SUM
    ## [1] "Precipitation Corrected Sum"
    ## 
    ## $PS
    ## [1] "Surface Pressure"
    ## 
    ## $PSC
    ## [1] "Corrected Atmospheric Pressure (Adjusted For Site Elevation)"
    ## 
    ## $PW
    ## [1] "Precipitable Water"
    ## 
    ## $QV10M
    ## [1] "Specific Humidity at 10 Meters"
    ## 
    ## $QV2M
    ## [1] "Specific Humidity at 2 Meters"
    ## 
    ## $RH2M
    ## [1] "Relative Humidity at 2 Meters"
    ## 
    ## $RHOA
    ## [1] "Surface Air Density"
    ## 
    ## $SG_DAY_COZ_ZEN_AVG
    ## [1] "Daylight Average Of Hourly Cosine Solar Zenith Angles for Climatological Month"
    ## 
    ## $SG_DAY_HOURS
    ## [1] "Solar Geometry Day Hours"
    ## 
    ## $SG_DEC
    ## [1] "Average Declination for Climatological Month"
    ## 
    ## $SG_HR_SET_ANG
    ## [1] "Average Sunset Hour Angle for Climatological Month"
    ## 
    ## $SG_HRZ_00
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 00 GMT"
    ## 
    ## $SG_HRZ_01
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 01 GMT"
    ## 
    ## $SG_HRZ_02
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 02 GMT"
    ## 
    ## $SG_HRZ_03
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 03 GMT"
    ## 
    ## $SG_HRZ_04
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 04 GMT"
    ## 
    ## $SG_HRZ_05
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 05 GMT"
    ## 
    ## $SG_HRZ_06
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 06 GMT"
    ## 
    ## $SG_HRZ_07
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 07 GMT"
    ## 
    ## $SG_HRZ_08
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 08 GMT"
    ## 
    ## $SG_HRZ_09
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 09 GMT"
    ## 
    ## $SG_HRZ_10
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 10 GMT"
    ## 
    ## $SG_HRZ_11
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 11 GMT"
    ## 
    ## $SG_HRZ_12
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 12 GMT"
    ## 
    ## $SG_HRZ_13
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 13 GMT"
    ## 
    ## $SG_HRZ_14
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 14 GMT"
    ## 
    ## $SG_HRZ_15
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 15 GMT"
    ## 
    ## $SG_HRZ_16
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 16 GMT"
    ## 
    ## $SG_HRZ_17
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 17 GMT"
    ## 
    ## $SG_HRZ_18
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 18 GMT"
    ## 
    ## $SG_HRZ_19
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 19 GMT"
    ## 
    ## $SG_HRZ_20
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 20 GMT"
    ## 
    ## $SG_HRZ_21
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 21 GMT"
    ## 
    ## $SG_HRZ_22
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 22 GMT"
    ## 
    ## $SG_HRZ_23
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month at 23 GMT"
    ## 
    ## $SG_HRZ_HR
    ## [1] "Average Hourly Solar Angles Relative To The Horizon for Climatological Month"
    ## 
    ## $SG_HRZ_MAX
    ## [1] "Maximum Solar Angle Relative To The Horizon for Climatological Month"
    ## 
    ## $SG_MID_COZ_ZEN_ANG
    ## [1] "Average Cosine Solar Zenith Angle At Mid-Time Between Sunrise And Solar Noon for Climatological Month"
    ## 
    ## $SG_NOON
    ## [1] "Solar Geometry Based Noon"
    ## 
    ## $SG_SAA
    ## [1] "Solar Azimuth Angle"
    ## 
    ## $SG_SAA_00
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 00 GMT"
    ## 
    ## $SG_SAA_01
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 01 GMT"
    ## 
    ## $SG_SAA_02
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 02 GMT"
    ## 
    ## $SG_SAA_03
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 03 GMT"
    ## 
    ## $SG_SAA_04
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 04 GMT"
    ## 
    ## $SG_SAA_05
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 05 GMT"
    ## 
    ## $SG_SAA_06
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 06 GMT"
    ## 
    ## $SG_SAA_07
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 07 GMT"
    ## 
    ## $SG_SAA_08
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 08 GMT"
    ## 
    ## $SG_SAA_09
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 09 GMT"
    ## 
    ## $SG_SAA_10
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 10 GMT"
    ## 
    ## $SG_SAA_11
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 11 GMT"
    ## 
    ## $SG_SAA_12
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 12 GMT"
    ## 
    ## $SG_SAA_13
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 13 GMT"
    ## 
    ## $SG_SAA_14
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 14 GMT"
    ## 
    ## $SG_SAA_15
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 15 GMT"
    ## 
    ## $SG_SAA_16
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 16 GMT"
    ## 
    ## $SG_SAA_17
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 17 GMT"
    ## 
    ## $SG_SAA_18
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 18 GMT"
    ## 
    ## $SG_SAA_19
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 19 GMT"
    ## 
    ## $SG_SAA_20
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 20 GMT"
    ## 
    ## $SG_SAA_21
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 21 GMT"
    ## 
    ## $SG_SAA_22
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 22 GMT"
    ## 
    ## $SG_SAA_23
    ## [1] "Average Solar Azimuth Angle for Climatological Month at 23 GMT"
    ## 
    ## $SG_SAA_HR
    ## [1] "Average Solar Azimuth Angle for Climatological Month"
    ## 
    ## $SG_SZA
    ## [1] "Solar Zenith Angle"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE
    ## [1] "Maximum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_HORIZONTAL
    ## [1] "Maximum Solar Irradiance for Equator Facing Horizontal Surface"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_LAT_MINUS15
    ## [1] "Maximum Solar Irradiance for Equator Facing Latitude Minus 15 Tilt"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_LAT_PLUS15
    ## [1] "Maximum Solar Irradiance for Equator Facing Latitude Plus 15 Tilt"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_LATITUDE
    ## [1] "Maximum Solar Irradiance for Equator Facing Latitude Tilt"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_OPTIMAL
    ## [1] "Maximum Solar Irradiance Optimal"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_OPTIMAL_ANG
    ## [1] "Maximum Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_OPTIMAL_ANG_ORT
    ## [1] "Maximum Solar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_TRACKER
    ## [1] "Maximum Solar Irradiance Irradiance Tracking the Sun"
    ## 
    ## $SI_EF_MAX_TILTED_SURFACE_VERTICAL
    ## [1] "Maximum Solar Irradiance for Equator Facing Vertical Surface"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE
    ## [1] "Minimum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_HORIZONTAL
    ## [1] "Minimum Solar Irradiance for Equator Facing Horizontal Surface"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_LAT_MINUS15
    ## [1] "Minimum Solar Irradiance for Equator Facing Latitude Minus 15 Tilt"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_LAT_PLUS15
    ## [1] "Minimum Solar Irradiance for Equator Facing Latitude Plus 15 Tilt"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_LATITUDE
    ## [1] "Minimum Solar Irradiance for Equator Facing Latitude Tilt"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_OPTIMAL
    ## [1] "Minimum Solar Irradiance Optimal"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_OPTIMAL_ANG
    ## [1] "Minimum Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_OPTIMAL_ANG_ORT
    ## [1] "Minimum Solar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_TRACKER
    ## [1] "Solar Irradiance Irradiance Tracking the Sun"
    ## 
    ## $SI_EF_MIN_TILTED_SURFACE_VERTICAL
    ## [1] "Minimum Solar Irradiance for Equator Facing Vertical Surface"
    ## 
    ## $SI_EF_TILTED_SURFACE
    ## [1] "Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)"
    ## 
    ## $SI_EF_TILTED_SURFACE_HORIZONTAL
    ## [1] "Solar Irradiance for Equator Facing Horizontal Surface"
    ## 
    ## $SI_EF_TILTED_SURFACE_LAT_MINUS15
    ## [1] "Solar Irradiance for Equator Facing Latitude Minus 15 Tilt"
    ## 
    ## $SI_EF_TILTED_SURFACE_LAT_PLUS15
    ## [1] "Solar Irradiance for Equator Facing Latitude Plus 15 Tilt"
    ## 
    ## $SI_EF_TILTED_SURFACE_LATITUDE
    ## [1] "Solar Irradiance for Equator Facing Latitude Tilt"
    ## 
    ## $SI_EF_TILTED_SURFACE_OPTIMAL
    ## [1] "Solar Irradiance Optimal"
    ## 
    ## $SI_EF_TILTED_SURFACE_OPTIMAL_ANG
    ## [1] "Solar Irradiance Optimal Angle"
    ## 
    ## $SI_EF_TILTED_SURFACE_OPTIMAL_ANG_ORT
    ## [1] "Solar Irradiance Tilted Surface Orientation"
    ## 
    ## $SI_EF_TILTED_SURFACE_TRACKER
    ## [1] "Solar Irradiance Tracking the Sun"
    ## 
    ## $SI_EF_TILTED_SURFACE_VERTICAL
    ## [1] "Solar Irradiance for Equator Facing Vertical Surface"
    ## 
    ## $SLP
    ## [1] "Sea Level Pressure"
    ## 
    ## $SNODP
    ## [1] "Snow Depth"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_01
    ## [1] "Solar Irradiance Deficit Over A Consecutive 1-day Period"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_03
    ## [1] "Solar Irradiance Deficit Over A Consecutive 3-day Period"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_07
    ## [1] "Solar Irradiance Deficit Over A Consecutive 7-day Period"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_14
    ## [1] "Solar Irradiance Deficit Over A Consecutive 14-day Period"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_21
    ## [1] "Solar Irradiance Deficit Over A Consecutive 21-day Period"
    ## 
    ## $SOLAR_DEFICITS_BLW_CONSEC_MONTH
    ## [1] "Solar Irradiance Deficit Over A Consecutive Month Period"
    ## 
    ## $SRF_ALB_ADJ
    ## [1] "Surface Albedo Adjusted"
    ## 
    ## $SZA
    ## [1] "Solar Zenith Angle"
    ## 
    ## $T10M
    ## [1] "Temperature at 10 Meters"
    ## 
    ## $T10M_MAX
    ## [1] "Temperature at 10 Meters Maximum"
    ## 
    ## $T10M_MAX_AVG
    ## [1] "Temperature at 10 Meters Maximum Average"
    ## 
    ## $T10M_MIN
    ## [1] "Temperature at 10 Meters Minimum"
    ## 
    ## $T10M_MIN_AVG
    ## [1] "Temperature at 10 Meters Minimum Average"
    ## 
    ## $T10M_RANGE
    ## [1] "Temperature at 10 Meters Range"
    ## 
    ## $T10M_RANGE_AVG
    ## [1] "Temperature at 10 Meters Range Average"
    ## 
    ## $T2M
    ## [1] "Temperature at 2 Meters"
    ## 
    ## $T2M_MAX
    ## [1] "Temperature at 2 Meters Maximum"
    ## 
    ## $T2M_MAX_AVG
    ## [1] "Temperature at 2 Meters Maximum Average"
    ## 
    ## $T2M_MIN
    ## [1] "Temperature at 2 Meters Minimum"
    ## 
    ## $T2M_MIN_AVG
    ## [1] "Temperature at 2 Meters Minimum Average"
    ## 
    ## $T2M_RANGE
    ## [1] "Temperature at 2 Meters Range"
    ## 
    ## $T2M_RANGE_AVG
    ## [1] "Temperature at 2 Meters Range Average"
    ## 
    ## $T2MDEW
    ## [1] "Dew/Frost Point at 2 Meters"
    ## 
    ## $T2MWET
    ## [1] "Wet Bulb Temperature at 2 Meters"
    ## 
    ## $TO3
    ## [1] "Total Column Ozone"
    ## 
    ## $TOA_SW_DNI
    ## [1] "Top-Of-Atmosphere Shortwave Direct Normal Radiation"
    ## 
    ## $TOA_SW_DNI_MAX
    ## [1] "Top-Of-Atmosphere Shortwave Direct Normal Radiation Maximum"
    ## 
    ## $TOA_SW_DNI_MIN
    ## [1] "Top-Of-Atmosphere Shortwave Direct Normal Radiation Minimum"
    ## 
    ## $TOA_SW_DNI_SD
    ## [1] "Top-Of-Atmosphere Shortwave Direct Normal Radiation Standard Deviation"
    ## 
    ## $TOA_SW_DWN
    ## [1] "Top-Of-Atmosphere Shortwave Downward Irradiance"
    ## 
    ## $TOA_SW_DWN_MAX
    ## [1] "Top-Of-Atmosphere Shortwave Downward Irradiance Maximum"
    ## 
    ## $TOA_SW_DWN_MIN
    ## [1] "Top-Of-Atmosphere Shortwave Downward Irradiance Minimum"
    ## 
    ## $TOA_SW_DWN_SD
    ## [1] "Top-Of-Atmosphere Shortwave Downward Irradiance Standard Deviation"
    ## 
    ## $TQV
    ## [1] "Total Column Precipitable Water"
    ## 
    ## $TROPPB
    ## [1] "Tropopause Pressure based on blended estimate."
    ## 
    ## $TROPQ
    ## [1] "Tropopause Specific Humidity using blended TROPP estimate."
    ## 
    ## $TROPT
    ## [1] "Tropopause Temperature using blended TROPP estimate."
    ## 
    ## $TS
    ## [1] "Earth Skin Temperature"
    ## 
    ## $TS_ADJ
    ## [1] "Earth Skin Temperature Adjusted"
    ## 
    ## $TS_AMP
    ## [1] "Earth Skin Temperature Amplitude"
    ## 
    ## $TS_MAX
    ## [1] "Earth Skin Temperature Maximum"
    ## 
    ## $TS_MAX_AVG
    ## [1] "Earth Skin Temperature Maximum Average"
    ## 
    ## $TS_MIN
    ## [1] "Earth Skin Temperature Minimum"
    ## 
    ## $TS_MIN_AVG
    ## [1] "Earth Skin Temperature Minimum Average"
    ## 
    ## $TS_RANGE
    ## [1] "Earth Skin Temperature Range"
    ## 
    ## $TS_RANGE_AVG
    ## [1] "Earth Skin Temperature Range Average"
    ## 
    ## $U10M
    ## [1] "Eastward Wind at 10 Meters"
    ## 
    ## $U2M
    ## [1] "Eastward Wind at 2 Meters"
    ## 
    ## $U50M
    ## [1] "Eastward Wind at 50 Meters"
    ## 
    ## $V10M
    ## [1] "Northward Wind at 10 Meters"
    ## 
    ## $V2M
    ## [1] "Northward Wind at 2 Meters"
    ## 
    ## $V50M
    ## [1] "Northward Wind at 50 Meters"
    ## 
    ## $WD10M
    ## [1] "Wind Direction at 10 Meters"
    ## 
    ## $WD2M
    ## [1] "Wind Direction at 2 Meters"
    ## 
    ## $WD50M
    ## [1] "Wind Direction at 50 Meters"
    ## 
    ## $WS10M
    ## [1] "Wind Speed at 10 Meters"
    ## 
    ## $WS10M_MAX
    ## [1] "Wind Speed at 10 Meters Maximum"
    ## 
    ## $WS10M_MAX_AVG
    ## [1] "Wind Speed at 10 Meters Maximum Average"
    ## 
    ## $WS10M_MIN
    ## [1] "Wind Speed at 10 Meters Minimum"
    ## 
    ## $WS10M_MIN_AVG
    ## [1] "Wind Speed at 10 Meters Minimum Average"
    ## 
    ## $WS10M_RANGE
    ## [1] "Wind Speed at 10 Meters Range"
    ## 
    ## $WS10M_RANGE_AVG
    ## [1] "Wind Speed at 10 Meters Range Average"
    ## 
    ## $WS2M
    ## [1] "Wind Speed at 2 Meters"
    ## 
    ## $WS2M_MAX
    ## [1] "Wind Speed at 2 Meters Maximum"
    ## 
    ## $WS2M_MAX_AVG
    ## [1] "Wind Speed at 2 Meters Maximum Average"
    ## 
    ## $WS2M_MIN
    ## [1] "Wind Speed at 2 Meters Minimum"
    ## 
    ## $WS2M_MIN_AVG
    ## [1] "Wind Speed at 2 Meters Minimum Average"
    ## 
    ## $WS2M_RANGE
    ## [1] "Wind Speed at 2 Meters Range"
    ## 
    ## $WS2M_RANGE_AVG
    ## [1] "Wind Speed at 2 Meters Range Average"
    ## 
    ## $WS50M
    ## [1] "Wind Speed at 50 Meters"
    ## 
    ## $WS50M_MAX
    ## [1] "Wind Speed at 50 Meters Maximum"
    ## 
    ## $WS50M_MAX_AVG
    ## [1] "Wind Speed at 50 Meters Maximum Average"
    ## 
    ## $WS50M_MIN
    ## [1] "Wind Speed at 50 Meters Minimum"
    ## 
    ## $WS50M_MIN_AVG
    ## [1] "Wind Speed at 50 Meters Minimum Average"
    ## 
    ## $WS50M_RANGE
    ## [1] "Wind Speed at 50 Meters Range"
    ## 
    ## $WS50M_RANGE_AVG
    ## [1] "Wind Speed at 50 Meters Range Average"
    ## 
    ## $WSC
    ## [1] "Corrected Wind Speed (Adjusted For Elevation)"
    ## 
    ## $Z0M
    ## [1] "Surface Roughness"
    ## 
    ## $ZENITH_LUMINANCE
    ## [1] "Zenith luminance"

## Save list for use in `nasapower` package

Using `usethis()` save the list as an R data object for use in the
*nasapower* package.

``` r
usethis::use_data(parameters, overwrite = TRUE)
```

## Session Info

``` r
sessioninfo::session_info()
```

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 4.1.0 (2021-05-18)
    ##  os       macOS Big Sur 11.5.1        
    ##  system   aarch64, darwin20           
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Perth             
    ##  date     2021-07-29                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  ! package     * version date       lib source        
    ##  P cli           2.5.0   2021-04-26 [?] CRAN (R 4.1.0)
    ##  P crayon        1.4.1   2021-02-08 [?] CRAN (R 4.1.0)
    ##  P curl          4.3.1   2021-04-30 [?] CRAN (R 4.1.0)
    ##  P desc          1.3.0   2021-03-05 [?] CRAN (R 4.1.0)
    ##  P digest        0.6.27  2020-10-24 [?] CRAN (R 4.1.0)
    ##  P ellipsis      0.3.2   2021-04-29 [?] CRAN (R 4.1.0)
    ##  P evaluate      0.14    2019-05-28 [?] CRAN (R 4.1.0)
    ##  P fansi         0.5.0   2021-05-25 [?] CRAN (R 4.1.0)
    ##  P fs            1.5.0   2020-07-31 [?] CRAN (R 4.1.0)
    ##  P glue          1.4.2   2020-08-27 [?] CRAN (R 4.1.0)
    ##  P htmltools     0.5.1.1 2021-01-22 [?] CRAN (R 4.1.0)
    ##  P jsonlite      1.7.2   2020-12-09 [?] CRAN (R 4.1.0)
    ##  P knitr         1.33    2021-04-24 [?] CRAN (R 4.1.0)
    ##  P lifecycle     1.0.0   2021-02-15 [?] CRAN (R 4.1.0)
    ##  P magrittr      2.0.1   2020-11-17 [?] CRAN (R 4.1.0)
    ##  P pillar        1.6.1   2021-05-16 [?] CRAN (R 4.1.0)
    ##  P pkgconfig     2.0.3   2019-09-22 [?] CRAN (R 4.1.0)
    ##  P purrr         0.3.4   2020-04-17 [?] CRAN (R 4.1.0)
    ##  P R6            2.5.0   2020-10-28 [?] CRAN (R 4.1.0)
    ##  P rlang         0.4.11  2021-04-30 [?] CRAN (R 4.1.0)
    ##  P rmarkdown     2.8     2021-05-07 [?] CRAN (R 4.1.0)
    ##  P rprojroot     2.0.2   2020-11-15 [?] CRAN (R 4.1.0)
    ##  P rstudioapi    0.13    2020-11-12 [?] CRAN (R 4.1.0)
    ##  P sessioninfo   1.1.1   2018-11-05 [?] CRAN (R 4.1.0)
    ##  P stringi       1.6.2   2021-05-17 [?] CRAN (R 4.1.0)
    ##  P stringr       1.4.0   2019-02-10 [?] CRAN (R 4.1.0)
    ##  P tibble        3.1.2   2021-05-16 [?] CRAN (R 4.1.0)
    ##  P usethis       2.0.1   2021-02-10 [?] CRAN (R 4.1.0)
    ##  P utf8          1.2.1   2021-03-12 [?] CRAN (R 4.1.0)
    ##  P vctrs         0.3.8   2021-04-29 [?] CRAN (R 4.1.0)
    ##  P withr         2.4.2   2021-04-18 [?] CRAN (R 4.1.0)
    ##  P xfun          0.23    2021-05-15 [?] CRAN (R 4.1.0)
    ##  P yaml          2.2.1   2020-02-01 [?] CRAN (R 4.1.0)
    ## 
    ## [1] /Users/adamsparks/Development/GitHub/rOpenSci/nasapower/renv/library/R-4.1/aarch64-apple-darwin20
    ## [2] /private/var/folders/tr/fwv720l96bz2btcr0jr_gs840000gn/T/RtmpaRhZTY/renv-system-library
    ## [3] /Library/Frameworks/R.framework/Versions/4.1-arm64/Resources/library
    ## 
    ##  P ── Loaded and on-disk path mismatch.
