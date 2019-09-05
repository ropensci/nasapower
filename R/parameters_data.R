#' NASA POWER parameters available for download
#'
#' An \R \code{list} object of \acronym{POWER} parameters and metadata available
#' for querying from the \acronym{POWER} database.
#'
#' @docType data
#'
#' @format A list with 146 weather and climate parameters contained within the
#' \acronym{POWER} database.
#'
#' \describe{
#' \item{ALLSKY_SFC_LW_DWN }{Downward Thermal Infrared (Longwave) Radiative Flux}
#' \item{ALLSKY_SFC_SW_DWN}{All Sky Insolation Incident on a Horizontal Surface}
#' \item{ALLSKY_SFC_SW_DWN_00_GMT}{All Sky Insolation Incident On A Horizontal Surface at 00 GMT}
#' \item{ALLSKY_SFC_SW_DWN_03_GMT}{All Sky Insolation Incident On A Horizontal Surface at 03 GMT}
#' \item{ALLSKY_SFC_SW_DWN_06_GMT}{All Sky Insolation Incident On A Horizontal Surface at 06 GMT}
#' \item{ALLSKY_SFC_SW_DWN_09_GMT}{All Sky Insolation Incident On A Horizontal Surface at 09 GMT}
#' \item{ALLSKY_SFC_SW_DWN_12_GMT}{All Sky Insolation Incident On A Horizontal Surface at 12 GMT}
#' \item{ALLSKY_SFC_SW_DWN_15_GMT}{All Sky Insolation Incident On A Horizontal Surface at 15 GMT}
#' \item{ALLSKY_SFC_SW_DWN_18_GMT}{All Sky Insolation Incident On A Horizontal Surface at 18 GMT}
#' \item{ALLSKY_SFC_SW_DWN_21_GMT}{All Sky Insolation Incident On A Horizontal Surface at 21 GMT}
#' \item{ALLSKY_SFC_SW_DWN_MAX_DIFF}{Maximum Monthly Difference From Monthly Averaged All Sky Insolation}
#' \item{ALLSKY_SFC_SW_DWN_MIN_DIFF}{Minimum Monthly Difference From Monthly Averaged All Sky Insolation}
#' \item{ALLSKY_TOA_SW_DWN}{Top-of-atmosphere Insolation}
#' \item{CDD0}{Cooling Degree Days Above 0 C}
#' \item{CDD10}{Cooling Degree Days Above 10 C}
#' \item{CDD18_3}{Cooling Degree Days Above 18.3 C}
#' \item{CLD_AMT}{Daylight Cloud Amount}
#' \item{CLD_AMT_00_GMT}{Cloud Amount at 00 GMT}
#' \item{CLD_AMT_03_GMT}{Cloud Amount at 03 GMT}
#' \item{CLD_AMT_06_GMT}{Cloud Amount at 06 GMT}
#' \item{CLD_AMT_09_GMT}{Cloud Amount at 09 GMT}
#' \item{CLD_AMT_12_GMT}{Cloud Amount at 12 GMT}
#' \item{CLD_AMT_15_GMT}{Cloud Amount at 15 GMT}
#' \item{CLD_AMT_18_GMT}{Cloud Amount at 18 GMT}
#' \item{CLD_AMT_21_GMT}{Cloud Amount at 21 GMT}
#' \item{CLRSKY_DIFF}{Clear Sky Diffuse Radiation On A Horizontal Surface}
#' \item{CLRSKY_NKT}{Normalized Clear Sky Insolation Clearness Index}
#' \item{CLRSKY_SFC_SW_DWN}{Clear Sky Insolation Incident on a Horizontal Surface}
#' \item{DIFF}{Diffuse Radiation On A Horizontal Surface}
#' \item{DIFF_MAX}{Maximum Diffuse Radiation On A Horizontal Surface}
#' \item{DIFF_MIN}{Minimum Diffuse Radiation On A Horizontal Surface}
#' \item{DNR}{Direct Normal Radiation}
#' \item{DNR_MAX}{Maximum Direct Normal Radiation}
#' \item{DNR_MAX_DIFF}{Maximum Difference From Monthly Averaged Direct Normal Radiation}
#' \item{DNR_MIN}{Minimum Direct Normal Radiation}
#' \item{DNR_MIN_DIFF}{Minimum Difference From Monthly Averaged Direct Normal Radiation}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_1}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 1-day Period}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_14}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 14-day Period}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_21}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 21-day Period}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_3}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 3-day Period}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_7}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive 7-day Period}
#' \item{EQVLNT_NO_SUN_BLACKDAYS_MONTH}{Equivalent Number Of NO-SUN Or BLACK Days Over A Consecutive Month Period}
#' \item{FROST_DAYS}{Frost Days}
#' \item{FRQ_BRKNCLD_10_70_00_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 00 GMT}
#' \item{FRQ_BRKNCLD_10_70_03_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 03 GMT}
#' \item{FRQ_BRKNCLD_10_70_06_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 06 GMT}
#' \item{FRQ_BRKNCLD_10_70_09_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 09 GMT}
#' \item{FRQ_BRKNCLD_10_70_12_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 12 GMT}
#' \item{FRQ_BRKNCLD_10_70_15_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 15 GMT}
#' \item{FRQ_BRKNCLD_10_70_18_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 18 GMT}
#' \item{FRQ_BRKNCLD_10_70_21_GMT}{Frequency Of Broken-cloud Skies 10 - 70 percent At 21 GMT}
#' \item{FRQ_CLRSKY_0_10_00_GMT}{Frequency Of Clear Skies < 10 percent At 00 GMT}
#' \item{FRQ_CLRSKY_0_10_03_GMT}{Frequency Of Clear Skies < 10 percent At 03 GMT}
#' \item{FRQ_CLRSKY_0_10_06_GMT}{Frequency Of Clear Skies < 10 percent At 06 GMT}
#' \item{FRQ_CLRSKY_0_10_09_GMT}{Frequency Of Clear Skies < 10 percent At 09 GMT}
#' \item{FRQ_CLRSKY_0_10_12_GMT}{Frequency Of Clear Skies < 10 percent At 12 GMT}
#' \item{FRQ_CLRSKY_0_10_15_GMT}{Frequency Of Clear Skies < 10 percent At 15 GMT}
#' \item{FRQ_CLRSKY_0_10_18_GMT}{Frequency Of Clear Skies < 10 percent At 18 GMT}
#' \item{FRQ_CLRSKY_0_10_21_GMT}{Frequency Of Clear Skies < 10 percent At 21 GMT}
#' \item{FRQ_NROVRCST_70_00_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 00 GMT}
#' \item{FRQ_NROVRCST_70_03_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 03 GMT}
#' \item{FRQ_NROVRCST_70_06_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 06 GMT}
#' \item{FRQ_NROVRCST_70_09_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 09 GMT}
#' \item{FRQ_NROVRCST_70_12_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 12 GMT}
#' \item{FRQ_NROVRCST_70_15_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 15 GMT}
#' \item{FRQ_NROVRCST_70_18_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 18 GMT}
#' \item{FRQ_NROVRCST_70_21_GMT}{Frequency Of Near-overcast Skies >= 70 percent At 21 GMT}
#' \item{HDD0}{Heating Degree Days Below 0 C}
#' \item{HDD10}{Heating Degree Days Below 10 C}
#' \item{HDD18_3}{Heating Degree Days Below 18.3 C}
#' \item{INSOL_MIN_CONSEC_1}{Minimum Available Insolation Over A Consecutive 1-day Period}
#' \item{INSOL_MIN_CONSEC_14}{Minimum Available Insolation Over A Consecutive 14-day Period}
#' \item{INSOL_MIN_CONSEC_21}{Minimum Available Insolation Over A Consecutive 21-day Period}
#' \item{INSOL_MIN_CONSEC_3}{Minimum Available Insolation Over A Consecutive 3-day Period}
#' \item{INSOL_MIN_CONSEC_7}{Minimum Available Insolation Over A Consecutive 7-day Period}
#' \item{INSOL_MIN_CONSEC_MONTH}{Minimum Available Insolation Over A Consecutive Month Period}
#' \item{KT}{Insolation Clearness Index}
#' \item{KT_CLEAR}{Clear Sky Insolation Clearness Index}
#' \item{MIDDAY_INSOL}{Midday Insolation Incident On A Horizontal Surface}
#' \item{NKT}{Normalized Insolation Clearness Index}
#' \item{NO_SUN_BLACKDAYS_MAX}{Maximum NO-SUN Or BLACK Days}
#' \item{PHIS}{Surface Geopotential}
#' \item{PRECTOT}{Precipitation}
#' \item{PS}{Surface Pressure}
#' \item{PSC}{Corrected Atmospheric Pressure (Adjusted For Site Elevation)}
#' \item{QV2M}{Specific Humidity at 2 Meters}
#' \item{RH2M}{Relative Humidity at 2 Meters}
#' \item{SG_DAY_COZ_ZEN_AVG}{Daylight Average Of Hourly Cosine Solar Zenith Angles}
#' \item{SG_DAY_HOUR_AVG}{Daylight Hours}
#' \item{SG_DEC_AVG}{Declination}
#' \item{SG_HR_AZM_ANG_AVG}{Hourly Solar Azimuth Angles}
#' \item{SG_HR_HRZ_ANG_AVG}{Hourly Solar Angles Relative To The Horizon}
#' \item{SG_HR_SET_ANG}{Sunset Hour Angle}
#' \item{SG_MAX_HRZ_ANG}{Maximum Solar Angle Relative To The Horizon}
#' \item{SG_MID_COZ_ZEN_ANG}{Cosine Solar Zenith Angle At Mid-Time Between Sunrise And Solar Noon}
#' \item{SG_NOON}{Solar Noon}
#' \item{SI_EF_MAX_OPTIMAL}{Maximum Solar Irradiance Optimal}
#' \item{SI_EF_MAX_OPTIMAL_ANG}{Maximum Solar Irradiance Optimal Angle}
#' \item{SI_EF_MAX_TILTED_ANG_ORT}{Maximum Solar Irradiance Tilted Surface Orientation}
#' \item{SI_EF_MAX_TILTED_SURFACE}{Maximum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)}
#' \item{SI_EF_MIN_OPTIMAL}{Minimum Solar Irradiance Optimal}
#' \item{SI_EF_MIN_OPTIMAL_ANG}{Minimum Solar Irradiance Optimal Angle}
#' \item{SI_EF_MIN_TILTED_ANG_ORT}{MinimumSolar Irradiance Tilted Surface Orientation}
#' \item{SI_EF_MIN_TILTED_SURFACE}{Minimum Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)}
#' \item{SI_EF_OPTIMAL}{Solar Irradiance Optimal}
#' \item{SI_EF_OPTIMAL_ANG}{Solar Irradiance Optimal Angle}
#' \item{SI_EF_TILTED_ANG_ORT}{Solar Irradiance Tilted Surface Orientation}
#' \item{SI_EF_TILTED_SURFACE}{Solar Irradiance for Equator Facing Tilted Surfaces (Set of Surfaces)}
#' \item{SR}{Surface Roughness}
#' \item{SRF_ALB}{Surface Albedo}
#' \item{T10M}{Temperature at 10 Meters}
#' \item{T10M_MAX}{Maximum Temperature at 10 Meters}
#' \item{T10M_MIN}{Minimum Temperature at 10 Meters}
#' \item{T10M_RANGE}{Temperature Range at 10 Meters}
#' \item{T2M}{Temperature at 2 Meters}
#' \item{T2MDEW}{Dew/Frost Point at 2 Meters}
#' \item{T2MWET}{Wet Bulb Temperature at 2 Meters}
#' \item{T2M_MAX}{Maximum Temperature at 2 Meters}
#' \item{T2M_MIN}{Minimum Temperature at 2 Meters}
#' \item{T2M_RANGE}{Temperature Range at 2 Meters}
#' \item{TM_ZONES}{Climate Thermal and Moisture Zones}
#' \item{TQV}{Total Column Precipitable Water}
#' \item{TS}{Earth Skin Temperature}
#' \item{TS_AMP}{Earth Skin Temperature Amplitude}
#' \item{TS_MAX}{Maximum Earth Skin Temperature}
#' \item{TS_MIN}{Minimum Earth Skin Temperature}
#' \item{TS_RANGE}{Earth Skin Temperature Range}
#' \item{T_ZONES}{Climate Thermal Zones}
#' \item{U10M}{Eastward Wind at 10 Meters }
#' \item{V10M}{Northward Wind at 10 Meters }
#' \item{WD10M}{Wind Direction at 10 Meters (Meteorological Convention)}
#' \item{WD2M}{Wind Direction at 2 Meters (Meteorological Convention)}
#' \item{WD50M}{Wind Direction at 50 Meters (Meteorological Convention)}
#' \item{WS10M}{Wind Speed at 10 Meters}
#' \item{WS10M_MAX}{Maximum Wind Speed at 10 Meters}
#' \item{WS10M_MIN}{Minimum Wind Speed at 10 Meters}
#' \item{WS10M_RANGE}{Wind Speed Range at 10 Meters}
#' \item{WS2M}{Wind Speed at 2 Meters}
#' \item{WS2M_MAX}{Maximum Wind Speed at 2 Meters}
#' \item{WS2M_MIN}{Minimum Wind Speed at 2 Meters}
#' \item{WS2M_RANGE}{Wind Speed Range at 2 Meters}
#' \item{WS50M}{Wind Speed at 50 Meters}
#' \item{WS50M_MAX}{Maximum Wind Speed at 50 Meters}
#' \item{WS50M_MIN}{Minimum Wind Speed at 50 Meters}
#' \item{WS50M_RANGE}{Wind Speed Range at 50 Meters}
#' \item{WSC}{Corrected Wind Speed (Adjusted For Elevation)}
#' }
#'
#' @author Adam H Sparks \email{adamhsparks@@gmail.com}
#' @source
#' \url{https://power.larc.nasa.gov/RADAPP/GEODATA/powerWeb/POWER_Parameters_v109.json}
#' @references
#' \url{https://power.larc.nasa.gov/docs/v1/}

"parameters"
