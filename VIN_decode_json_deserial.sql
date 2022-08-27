use clictell_auto_master
  IF OBJECT_ID('tempdb..#vin_decoded_json_deserial') IS NOT NULL DROP TABLE #vin_decoded_json_deserial

  --select top 100 * from master.vin_decoded (nolock) 

select
		vin_decoded_id
		,master_vehicle_id
		,vin
		,[key_name]
		,JSon_Value([key_value], '$.NADA_GCW2') as NADA_GCW2
		,JSon_Value([key_value], '$.NADA_MSRP3') as NADA_MSRP3
		,JSon_Value([key_value], '$.NADA_GCW3') as NADA_GCW3
		,JSon_Value([key_value], '$.NADA_GVWC4') as NADA_GVWC4

		,JSon_Value([key_value], '$.NADA_SERIES7') as NADA_SERIES7
		,JSon_Value([key_value], '$.NADA_MSRP7') as NADA_MSRP7
		,JSon_Value([key_value], '$.NADA_GCW7') as NADA_GCW7
		,JSon_Value([key_value], '$.OPT1_TRIM_DESC') as OPT1_TRIM_DESC

		,JSon_Value([key_value], '$.OPT3_TRIM_DESC') as OPT3_TRIM_DESC
		,JSon_Value([key_value], '$.NADA_SERIES1') as NADA_SERIES1
		,JSon_Value([key_value], '$.NADA_BODY2') as NADA_BODY2
		,JSon_Value([key_value], '$.NADA_GVWC2') as NADA_GVWC2

		,JSon_Value([key_value], '$.NADA_GCW6') as NADA_GCW6
		,JSon_Value([key_value], '$.NADA_BODY7') as NADA_BODY7
		,JSon_Value([key_value], '$.NADA_GVWC7') as NADA_GVWC7
		,JSon_Value([key_value], '$.NADA_SERIES8') as NADA_SERIES8

		,JSon_Value([key_value], '$.NADA_BODY8') as NADA_BODY8
		,JSon_Value([key_value], '$.NADA_ID9') as NADA_ID9
		,JSon_Value([key_value], '$.NADA_ID10') as NADA_ID10
		,JSon_Value([key_value], '$.MDL_DESC') as MDL_DESC

		,JSon_Value([key_value], '$.MDL_CD') as MDL_CD
		,JSon_Value([key_value], '$.VEH_TYP_DESC') as VEH_TYP_DESC
		,JSon_Value([key_value], '$.PROACTIVE_IND') as PROACTIVE_IND
		,JSon_Value([key_value], '$.NADA_MSRP1') as NADA_MSRP1

		,JSon_Value([key_value], '$.NADA_GVWC3') as NADA_GVWC3
		,JSon_Value([key_value], '$.NADA_ID4') as NADA_ID4
		,JSon_Value([key_value], '$.NADA_BODY4') as NADA_BODY4
		,JSon_Value([key_value], '$.NADA_GVWC5') as NADA_GVWC5

		,JSon_Value([key_value], '$.NADA_SERIES6') as NADA_SERIES6
		,JSon_Value([key_value], '$.NADA_MSRP8') as NADA_MSRP8
		,JSon_Value([key_value], '$.BODY_STYLE_DESC') as BODY_STYLE_DESC
		,JSon_Value([key_value], '$.NCI_MAK_ABBR_CD') as NCI_MAK_ABBR_CD

		,JSon_Value([key_value], '$.OPT2_TRIM_DESC') as OPT2_TRIM_DESC
		,JSon_Value([key_value], '$.OPT4_TRIM_DESC') as OPT4_TRIM_DESC
		,JSon_Value([key_value], '$.VINA_SERIES_ABBR_CD') as VINA_SERIES_ABBR_CD
		,JSon_Value([key_value], '$.NADA_SERIES2') as NADA_SERIES2

		,JSon_Value([key_value], '$.NADA_MSRP2') as NADA_MSRP2
		,JSon_Value([key_value], '$.NADA_ID6') as NADA_ID6
		,JSon_Value([key_value], '$.NADA_GVWC6') as NADA_GVWC6
		,JSon_Value([key_value], '$.NADA_ID7') as NADA_ID7

		,JSon_Value([key_value], '$.NADA_GVWC8') as NADA_GVWC8
		,JSon_Value([key_value], '$.VEH_TYP_CD') as VEH_TYP_CD
		,JSon_Value([key_value], '$.MAK_CD') as MAK_CD
		,JSon_Value([key_value], '$.NADA_ID2') as NADA_ID2

		,JSon_Value([key_value], '$.NADA_BODY3') as NADA_BODY3
		,JSon_Value([key_value], '$.NADA_SERIES4') as NADA_SERIES4
		,JSon_Value([key_value], '$.NADA_GCW4') as NADA_GCW4
		,JSon_Value([key_value], '$.NADA_GCW5') as NADA_GCW5

		,JSon_Value([key_value], '$.NADA_GCW8') as NADA_GCW8
		,JSon_Value([key_value], '$.NADA_GVWC9') as NADA_GVWC9
		,JSon_Value([key_value], '$.VIN_PATRN') as VIN_PATRN
		,JSon_Value([key_value], '$.BODY_STYLE_CD') as BODY_STYLE_CD

		,JSon_Value([key_value], '$.DOOR_CNT') as DOOR_CNT
		,JSon_Value([key_value], '$.MAK_NM') as MAK_NM
		,JSon_Value([key_value], '$.NADA_BODY1') as NADA_BODY1
		,JSon_Value([key_value], '$.NADA_GVWC1') as NADA_GVWC1

		,JSon_Value([key_value], '$.NADA_GCW1') as NADA_GCW1
		,JSon_Value([key_value], '$.NADA_ID3') as NADA_ID3
		,JSon_Value([key_value], '$.NADA_SERIES5') as NADA_SERIES5
		,JSon_Value([key_value], '$.NADA_BODY5') as NADA_BODY5

		,JSon_Value([key_value], '$.NADA_GCW9') as NADA_GCW9
		,JSon_Value([key_value], '$.NADA_MSRP4') as NADA_MSRP4
		,JSon_Value([key_value], '$.NADA_BODY6') as NADA_BODY6
		,JSon_Value([key_value], '$.NADA_MSRP6') as NADA_MSRP6

		,JSon_Value([key_value], '$.NADA_SERIES9') as NADA_SERIES9
		,JSon_Value([key_value], '$.NADA_MSRP9') as NADA_MSRP9
		,JSon_Value([key_value], '$.NADA_SERIES10') as NADA_SERIES10
		,JSon_Value([key_value], '$.NADA_BODY10') as NADA_BODY10

		,JSon_Value([key_value], '$.NADA_MSRP10') as NADA_MSRP10
		,JSon_Value([key_value], '$.TRIM_DESC') as TRIM_DESC
		,JSon_Value([key_value], '$.VINA_BODY_TYPE_CD') as VINA_BODY_TYPE_CD
		,JSon_Value([key_value], '$.NCI_SERIES_ABBR_CD') as NCI_SERIES_ABBR_CD

		,JSon_Value([key_value], '$.NADA_ID1') as NADA_ID1
		,JSon_Value([key_value], '$.NADA_SERIES3') as NADA_SERIES3
		,JSon_Value([key_value], '$.NADA_ID5') as NADA_ID5
		,JSon_Value([key_value], '$.NADA_MSRP5') as NADA_MSRP5

		,JSon_Value([key_value], '$.NADA_ID8') as NADA_ID8
		,JSon_Value([key_value], '$.NADA_BODY9') as NADA_BODY9
		,JSon_Value([key_value], '$.NADA_GVWC10') as NADA_GVWC10
		,JSon_Value([key_value], '$.NADA_GCW10') as NADA_GCW10

		,JSon_Value([key_value], '$.MDL_YR') as MDL_YR
		,JSon_Value([key_value], '$.errorBytes') as errorBytes
		,JSon_Value([key_value], '$.returnCode') as returnCode
		,JSon_Value([key_value], '$.correctedVin') as correctedVin
		,is_deleted
		,GETDATE() as created_dt
		,SUSER_NAME() as created_by

	into #vin_decoded_json_deserial
from master.vin_decoded (nolock) 

--select count(*) from #vin_decoded_json_deserial where VEH_TYP_DESC <>''
--where correctedVin <> ''
--where TRIM_DESC <>''
--where BODY_STYLE_DESC <> ''
--where DOOR_CNT <> 0
--where MDL_DESC <> '' 
--and VEH_TYP_DESC <>'' and BODY_STYLE_DESC <> '' and TRIM_DESC <>'' and correctedVin <> ''
--where MDL_YR <>0
--where MAK_NM <>''

select count(vin) from #vin_decoded_json_deserial 
