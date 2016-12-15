<cfcomponent>
<!---cfset ivdata = "iv_spduser"--->
<cffunction name="getByAreaFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfquery name="DataSelect" datasource="#dsn#">
	select
      rept.area_id,
      ad.area_name,
      sum(total_piece_cnt) total_piece_cnt,
      sum(last_scan_fss_cnt) last_scan_fss_cnt,
      sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
      case when nvl(sum(total_piece_cnt),0) > 0 then
      round((sum(total_piece_cnt) -sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
      else 0 end pct_fss_lkg
	from spd_fss_leakage rept
		inner join AREADISTNAME_t ad
		on rept.area_id = ad.area_id
	where rept.fss_zone_ind = 'Y'
      and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
      and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
      group by rept.area_id, ad.area_name
      order by fss_lkg 
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "area_id,area_name,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>

	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getByDistrictFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	
	<cfset selArea = Replace(selArea, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	rept.dist_id,
	ad.district_name,
	sum(total_piece_cnt) total_piece_cnt,
    sum(last_scan_fss_cnt) last_scan_fss_cnt,
    sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
    case when nvl(sum(total_piece_cnt),0) > 0 then
    	round((sum(total_piece_cnt) -sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
    else 0 end pct_fss_lkg
	from
	spd_fss_leakage rept inner join AREADISTNAME_t ad
	on rept.dist_id = ad.district_id
    where rept.fss_zone_ind = 'Y'
	and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
	and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
	group by rept.dist_id, ad.district_name
	order by fss_lkg  
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "dist_id,district_name,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getByFacilityFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
		rept.fac_seq_id,
		fac.fac_name,
        sum(total_piece_cnt) total_piece_cnt,
        sum(last_scan_fss_cnt) last_scan_fss_cnt,
        sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
        case when nvl(sum(total_piece_cnt),0) > 0 then
        round((sum(total_piece_cnt) - sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
        else 0 end pct_fss_lkg
	from spd_fss_leakage rept
	inner join facility fac 
	on rept.fac_seq_id = fac.fac_seq_id
    where rept.fss_zone_ind = 'Y'
	and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
	and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
	group by rept.fac_seq_id, fac.fac_name
	order by fss_lkg 
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "fac_seq_id,fac_name,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<!--- mail-class vis --->
<cffunction name="getByMailClassFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	<cfargument name="selFacility" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
	<cfset selFacility = Replace(selFacility, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
		rept.mail_class mail_class,
		mail.code_desc_long  mail_name,
		sum(total_piece_cnt) total_piece_cnt,
        sum(last_scan_fss_cnt) last_scan_fss_cnt,
        sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
    	case when nvl(sum(total_piece_cnt),0) > 0 then
    		round((sum(total_piece_cnt) -sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
    	else 0 end pct_fss_lkg
		from spd_fss_leakage rept, spduser.code_value mail
	    where 
        rept.fss_zone_ind = 'Y'
        and mail.code_type_name = 'ML_CL_CODE' and rept.mail_class = mail.code_val (+)
		and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
		<cfif selFacility is not "">
			and rept.fac_seq_id in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">
		</cfif>
		group by rept.mail_class, mail.code_desc_long
		order by fss_lkg 
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "mail_class,mail_name,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<!--- entry point discount vis --->
<cffunction name="getByEntPntDiscFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	<cfargument name="selFacility" type="string" required="no" default="">
	<cfargument name="selMailClass" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
	<cfset selFacility = Replace(selFacility, "'", "", "ALL")>
	<cfset selMailClass = Replace(selMailClass, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
		epfed.code_val as entry_discount_code,
		epfed.code_desc_long as entry_discount,
		sum(total_piece_cnt) total_piece_cnt,
        sum(last_scan_fss_cnt) last_scan_fss_cnt,
        sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
    	case when nvl(sum(total_piece_cnt),0) > 0 then
    		round((sum(total_piece_cnt) -sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
    	else 0 end pct_fss_lkg
	from spd_fss_leakage rept, spduser.code_value epfed
	where 
	<!---
	spduser.code_value mail_class, 
	mail_class.code_type_name = 'ML_CL_CODE' and rept.mail_class = mail_class.code_val (+)
        and 
        --->
        epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' and rept.epfed_fac_type_code = epfed.code_val (+)
        and rept.fss_zone_ind = 'Y'
		and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
		and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
		<cfif selFacility is not "">
			and rept.fac_seq_id in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">
		</cfif>
		<cfif selMailClass is not "">
			and rept.mail_class in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selMailClass#">
		</cfif>
	group by epfed.code_val, epfed.code_desc_long
	order by fss_lkg 
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "entry_discount_code,entry_discount,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<!--- sortation level vis --->
<cffunction name="getBySortLevelFSS" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	<cfargument name="selFacility" type="string" required="no" default="">
	<cfargument name="selMailClass" type="string" required="no" default="">
	<cfargument name="selEntPntDisc" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
	<cfset selFacility = Replace(selFacility, "'", "", "ALL")>
	<cfset selMailClass = Replace(selMailClass, "'", "", "ALL")>
	<cfset selEntPntDisc = Replace(selEntPntDisc, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
	select
	rept.sortation_level as sort_code,
	sort_level.code_desc_long as sort_name,
	sum(total_piece_cnt) total_piece_cnt,
    sum(last_scan_fss_cnt) last_scan_fss_cnt,
    sum(nvl(total_piece_cnt - last_scan_fss_cnt, 0)) fss_lkg,
	case when nvl(sum(total_piece_cnt),0) > 0 then
		round((sum(total_piece_cnt) -sum(last_scan_fss_cnt)) /sum(total_piece_cnt), 2)  
	else 0 end pct_fss_lkg
	from spd_fss_leakage rept, spduser.code_value sort_level, spduser.code_value epfed
    where epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' and rept.epfed_fac_type_code = epfed.code_val (+)
    and sort_level.code_type_name = 'RATE_CAT_CODE' and rept.sortation_level = sort_level.code_val (+)
    and rept.fss_zone_ind = 'Y'
	and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#">
	and rept.actual_dlvry_date < <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
	<cfif selArea is not "">
		and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
	</cfif>
	<cfif selDistrict is not "">
		and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
	</cfif>
	<cfif selFacility is not "">
		and rept.fac_seq_id in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">
	</cfif>
	<cfif selMailClass is not "">
		and rept.mail_class in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selMailClass#">
	</cfif>
	<cfif selEntPntDisc is not "">
		and epfed.code_val in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selEntPntDisc#">
	</cfif>
	group by rept.sortation_level, sort_level.code_desc_long
	order by fss_lkg
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset lstCols = "sort_code,sort_name,fss_lkg,pct_fss_lkg">
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getOverall" access="remote" returntype="array">
	<cfargument name="ReqId" type="string" required="yes">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="dtFrom" type="string" required="yes">
	<cfargument name="dtTo" type="string" required="yes">
	<cfargument name="selArea" type="string" required="no" default="">
	<cfargument name="selDistrict" type="string" required="no" default="">
	<cfargument name="selFacility" type="string" required="no" default="">
	<cfargument name="selMailClass" type="string" required="no" default="">
	<cfargument name="selEntPntDisc" type="string" required="no" default="">
	<cfargument name="selSortLvl" type="string" required="no" default="">

	<cfset selArea = Replace(selArea, "'", "", "ALL")>
	<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
	<cfset selFacility = Replace(selFacility, "'", "", "ALL")>
	<cfset selMailClass = Replace(selMailClass, "'", "", "ALL")>
	<cfset selEntPntDisc = Replace(selEntPntDisc, "'", "", "ALL")>
	<cfset selSortLvl = Replace(selSortLvl, "'", "", "ALL")>

	<cfquery name="DataSelect" datasource="#dsn#">
		Select 
		total_piece_cnt TOTAL_PIECES,
		last_scan_apps_cnt APPS_CNT, 
		last_scan_fss_cnt FSS_CNT,
		case when nvl(total_piece_cnt, 0) > 0
		then round(last_scan_fss_cnt/total_piece_cnt, 2)
		else 0 end PCT_FSS_CNT,
		last_scan_fss_after_apps_cnt FSS_AFTER_APPS_CNT,
		last_scan_fss_after_afsm_cnt FSS_AFTER_AFSM_CNT,
		last_scan_afsm_cnt AFSM_CNT,
		last_scan_afsm_after_fss_cnt AFSM_AFTER_FSS_CNT,
		lstscn_afsm_after_apps_fss_cnt AFSM_AFTER_APPS_FSS_CNT,
		last_scan_other_cnt OTHER_CNT
		from 
		(
		select
		sum(total_piece_cnt) total_piece_cnt,
		sum(last_scan_apps_cnt)last_scan_apps_cnt,
		sum(last_scan_fss_cnt) last_scan_fss_cnt,
		sum(last_scan_fss_after_apps_cnt) last_scan_fss_after_apps_cnt,
		sum(last_scan_fss_after_afsm_cnt) last_scan_fss_after_afsm_cnt,
		sum(last_scan_afsm_cnt) last_scan_afsm_cnt,
		sum(last_scan_afsm_after_fss_cnt) last_scan_afsm_after_fss_cnt,
		sum(lstscn_afsm_after_apps_fss_cnt) lstscn_afsm_after_apps_fss_cnt,
		sum(last_scan_other_cnt) last_scan_other_cnt
		from spd_fss_leakage rept, spduser.code_value mail_class, spduser.code_value epfed, spduser.code_value sort_level
        where 
        mail_class.code_type_name = 'ML_CL_CODE' and rept.mail_class = mail_class.code_val (+)
        and epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' and rept.epfed_fac_type_code = epfed.code_val (+)
        and sort_level.code_type_name = 'RATE_CAT_CODE' and rept.sortation_level = sort_level.code_val (+)
        and rept.fss_zone_ind = 'Y' and 
		rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#"> and 
		rept.actual_dlvry_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
		<cfif selArea is not "">
			and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
		</cfif>
		<cfif selDistrict is not "">
			and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
		</cfif>
		<cfif selFacility is not "">
			and rept.fac_seq_id in (<cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">)
		</cfif>
		<cfif selMailClass is not "">
			and rept.mail_class in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selMailClass#">
		</cfif>
		<cfif selEntPntDisc is not "">
			and epfed.code_val in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selEntPntDisc#">
		</cfif>
		<cfif selSortLvl is not "">
			and rept.sortation_level in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selSortLvl#">
		</cfif>
		)
	</cfquery>

	<cfset aryData = ArrayNew(2)>
	<cfset lstCols = DataSelect.ColumnList>
	<cfset idx = 1>
	<cfset aryData[idx] = ListToArray(DataSelect.columnList)>
	<cfoutput query="DataSelect">
		<cfset idx ++>
		<cfset idx1 = "0">
		<cfloop list="#lstCols#" index="col">
			<cfset aryData[idx][++idx1] = Evaluate(col)>
		</cfloop>
	</cfoutput>
	<cfset aryData[++idx][1] = ReqId>
	<cfreturn aryData>
</cffunction>

<cffunction name="getDates" access="remote" returntype="array">
	<cfargument name="dsn" type="string" required="yes">
	<cfargument name="range" type="string" required="yes">
	
	<cfquery name="DateSelect" datasource="#dsn#" blockfactor="100">
	<cfif range is 'MON'>
		select dt as beg_mon_date,
		add_months(dt,1)-1 as end_mon_date,
		to_char(dt,'mm/dd/yyyy') as strdate,
		to_char(add_months(dt,1)-1,'mm/dd/yyyy') as strend 
		from
			(
			select
				(
				select min(actual_dlvry_date) from spd_fss_leakage
				) + rownum as dt
				from spd_fss_leakage
				where rownum <=
				(
				select max(actual_dlvry_date) from spd_fss_leakage
				)
				-
				(
				select min(actual_dlvry_date) from spd_fss_leakage
				)
			)
		where to_char(dt, 'dd')=1
		order by dt desc
	<cfelseif range is 'QTR'>
		select dt as beg_qtr_date,
		add_months(dt, 3) - 1 as end_qtr_date,
		to_char(dt, 'mm/dd/yyyy') as strdate,
		to_char(add_months(dt, 3) - 1, 'mm/dd/yyyy') as strend 
		from
			(
			select
				(
				select min(actual_dlvry_date)
				from spd_fss_leakage
				) + rownum - 1 as dt
			from spd_fss_leakage
			where rownum <=
				(
				select max(actual_dlvry_date) from spd_fss_leakage
				)
				-
				(
				select min(actual_dlvry_date) from spd_fss_leakage
				)
			)
		where to_char(dt,'MM') IN('01', '04', '07', '10') AND to_char(dt, 'DD') = 1
		order by dt desc
	<cfelse>
		select
		dt beg_wk_date,
		dt + 6 end_wk_date,
		to_char (dt, 'mm/dd/yyyy') strdate,
		to_char(dt + 6,'mm/dd/yyyy') strend
		from
		(
		select
			(
			select min(actual_dlvry_date)
			from spd_fss_leakage
			)
			+ rownum dt
			from spd_fss_leakage
			where rownum <=
				(
				select max(actual_dlvry_date)
				from spd_fss_leakage
				)
				-
				(
				select min(actual_dlvry_date)
				from spd_fss_leakage
				)
		)
		where to_char (dt, 'd') = 7
		order by dt desc
 	</cfif>
	</cfquery>
	
	<cfset ar = ArrayNew(2)>
	<cfloop query="DateSelect">
		<cfset ar[currentrow][1]= strDate>      
		<cfset ar[currentrow][2]= strEnd>                  
	</cfloop>        
	<cfreturn ar>
</cffunction>

<cffunction name="getTrend" access="remote" returntype="array">
<cfargument name="ReqId" type="string" required="yes">
<cfargument name="dsn" type="string" required="yes">
<cfargument name="dtFrom" type="string" required="yes">
<cfargument name="dtTo" type="string" required="yes">
<cfargument name="selRange" type="string" required="yes">        
<cfargument name="selArea" type="string" required="no" default="">
<cfargument name="selDistrict" type="string" required="no" default="">
<cfargument name="selFacility" type="string" required="no" default="">
<cfargument name="selMailClass" type="string" required="no" default="">
<cfargument name="selEntPntDisc" type="string" required="no" default="">
<cfargument name="selSortLvl" type="string" required="no" default="">


<cfset selArea = Replace(selArea, "'", "", "ALL")>
<cfset selDistrict = Replace(selDistrict, "'", "", "ALL")>
<cfset selFacility = Replace(selFacility, "'", "", "ALL")>
<cfset selMailClass = Replace(selMailClass, "'", "", "ALL")>
<cfset selEntPntDisc = Replace(selEntPntDisc, "'", "", "ALL")>
<cfset selSortLvl = Replace(selSortLvl, "'", "", "ALL")>
<cfset dtFrom = DateFormat(dtFrom, "MM/DD/YYYY")>
<cfset dtTo = selRange is "MON" ? DateAdd("M", 1, dtFrom) - 1 : dtTo>
<cfset dtSort = DateFormat(dtFrom, 'YYYYMMDD')>

<cfquery name="DataSelect" datasource="#dsn#" blockfactor="100">
select 
'#dtFrom#' strDate,
'#dtSort#' sortDate,
fss_leakage_vol,
case when nvl(intTotal,0) > 0 
then round(fss_leakage_trend / intTotal, 2)  
else 0 end pctLeakage
from
	(
	select
	sum(total_piece_cnt) - sum(last_scan_fss_cnt) fss_leakage_vol,
	sum(total_piece_cnt) - sum(last_scan_fss_cnt) / sum(total_piece_cnt) fss_leakage_trend,
	sum(total_piece_cnt) intTotal
	from spd_fss_leakage rept, spduser.code_value mail_class, spduser.code_value epfed, spduser.code_value sort_level
    where 
    mail_class.code_type_name = 'ML_CL_CODE' and rept.mail_class = mail_class.code_val (+)
    and epfed.code_type_name = 'EPFED_FAC_TYPE_CODE' and rept.epfed_fac_type_code = epfed.code_val (+)
    and sort_level.code_type_name = 'RATE_CAT_CODE' and rept.sortation_level = sort_level.code_val (+)
    and rept.fss_zone_ind = 'Y' 
	and rept.actual_dlvry_date >= <cfqueryparam cfsqltype="cf_sql_date" value="#dtFrom#"> 
	and rept.actual_dlvry_date <= <cfqueryparam cfsqltype="cf_sql_date" value="#dtTo#">
	<cfif selArea is not "">
		and rept.area_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selArea#">)
	</cfif>
	<cfif selDistrict is not "">
		and rept.dist_id in (<cfqueryparam cfsqltype="cf_sql_char" list="yes" value="#selDistrict#">)
	</cfif>
	<cfif selFacility is not "">
		and rept.fac_seq_id in (<cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selFacility#">)
	</cfif>
	<cfif selMailClass is not "">
		and rept.mail_class in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selMailClass#">
	</cfif>
	<cfif selEntPntDisc is not "">
		and epfed.code_val in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selEntPntDisc#">
	</cfif>
	<cfif selSortLvl is not "">
		and rept.sortation_level in <cfqueryparam cfsqltype="cf_sql_decimal" list="yes" value="#selSortLvl#">
	</cfif>
	)
</cfquery>
<cfset aryData = ArrayNew(2)>
<cfset lstCols = DataSelect.columnList>
<cfset aryData[1] = ListToArray(DataSelect.columnList)>
<cfoutput query="DataSelect">
	<cfset idx = "0">
	<cfloop list="#lstCols#" index="col">
		<cfset aryData[2][++idx] = Evaluate(col)>
	</cfloop>
</cfoutput>
<cfset aryData[3][1] = ReqId>
<cfreturn aryData>
</cffunction>

</cfcomponent>