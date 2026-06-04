
	clear all 
	set more off 
*************************************************
   	if c(os) == "Windows" {
		global dropbox "C:/Users/`c(username)'/Box"	
	}
	else if c(os) == "MacOSX" {
		global dropox "/Users/`c(username)'/Box"
	}
	
	global projectfolder	"${dropbox}/AAU-DS"
	
    global nat_data        "${projectfolder}/mdcp/national"
	global urb_data        "${projectfolder}/mdcp/urban"
    global code            "${projectfolder}/codes"
    global cleaned_data    "${projectfolder}/teluke/cleaned_data"
    global log_opt         "${projectfolder}/teluke/output"
    global graphs         "${log_opt}/graphs"
    global tables         "${log_opt}/tables"
    global today : di %tdCCYYNNDD date(c(current_date), "DMY")
*========================================================
********************************************
********************************************
//Individual Level Data...CHILD Data
*========================================
//-----Urban
//To merge HH level data	
	use "${urb_data}\member_level\S1_T1_HH_Roster_long.dta" //HH Roster	
	keep if index == 1
	keep caseid sex age marital_status age_marriage occupation oth_occupation
	rename (sex age marital_status age_marriage occupation oth_occupation) ///
	(head_sex head_age head_marital_status head_age_marriage head_occupation head_oth_occupation)

	tempfile urban_head_data
	saveold `urban_head_data'


*========================
//-----Urban----
*======================
*=======================
//1. HH Level Data
*=======================
//1.1. HH head demo
//To merge HH level data	
	use "${urb_data}\member_level\S1_T1_HH_Roster_long.dta" //HH Roster	
	
	*keep if index == 1
*to count number of hh member below 18
	gen num_children=(age<18)
*to count number of hh member below 5 (need crowding variable)
	gen num_childrenU5=(age<5) 
	gen HHhead_male=(sex==1) if relation_hhhead==1
	clonevar HHhead_marital = marital_status if relation_hhhead==1
	clonevar HHhead_age = age if relation_hhhead==1
	clonevar HHhead_occup = occupation if relation_hhhead==1
	clonevar HHhead_age_marriage = age_marriage if relation_hhhead==1
	
	keep caseid HHhead_male num_children num_childrenU5 HHhead_marital HHhead_age HHhead_occup HHhead_age_marriage


	collapse HHhead_male HHhead_marital HHhead_age HHhead_occup ///
	HHhead_age_marriage (sum) num_children num_childrenU5, by(caseid) //Household level data


	label var num_children "Number of children below 18 in the HH"
	label var num_childrenU5 "Number of members below 5 in the HH"

	tempfile urban_head_data
	saveold `urban_head_data'
*-------------------------
//-----------------------------------------------------------
*To merge all relevant household Level datasets---Urban Data
*-------------------------------------------------------------
**************
*Assets Data
***************
	use "${urb_data}\hh_level\S7_T1_Asset_long.dta", clear

replace oth_asset_own = "Water filter" if oth_asset_own == "Water Filter"

tab asset_name if asset_name == "Kerosene stove"
gen kerosene_stove = asset_own if asset_name == "Kerosene stove"
tab kerosene_stove if asset_name == "Kerosene stove"
lab var kerosene_stove "HH owns at least one kerosene stove"

tab asset_name if asset_name == "Cylinder gas stove"
gen cylinder_gas_stove = asset_own if asset_name == "Cylinder gas stove"
tab cylinder_gas_stove if asset_name == "Cylinder gas stove"
lab var cylinder_gas_stove "HH owns at least one cylinder gas stove"

tab asset_name if asset_name == "Electric stove"
gen electric_stove = asset_own if asset_name == "Electric stove"
tab electric_stove if asset_name == "Electric stove"
lab var electric_stove "HH owns at least one electric stove"

tab asset_name if asset_name == "Blanket/Gabi"
gen blanket_gabi = asset_own if asset_name == "Blanket/Gabi"
tab blanket_gabi if asset_name == "Blanket/Gabi"
lab var blanket_gabi "HH owns at least one blanket/gabi"

tab asset_name if asset_name == "Bed"
gen bed = asset_own if asset_name == "Bed"
tab bed if asset_name == "Bed"
lab var bed "HH owns at least one bed"

tab asset_name if asset_name == "cotton/sponge/spring mattress"
gen mattress = asset_own if asset_name == "cotton/sponge/spring mattress"
tab mattress if asset_name == "cotton/sponge/spring mattress"
lab var mattress "HH owns at least one cotton/sponge/spring mattress"

tab asset_name if asset_name == "Wrist watch/clock"
gen watch = asset_own if asset_name == "Wrist watch/clock"
tab watch if asset_name == "Wrist watch/clock"
lab var watch "HH owns at least one wristwatch/clock"

tab asset_name if asset_name == "Fixed line telephone"
gen fixed_phone = asset_own if asset_name == "Fixed line telephone"
tab fixed_phone if asset_name == "Fixed line telephone"
lab var fixed_phone "HH owns at least one fixed line phone"

tab asset_name if asset_name == "Mobile Telephone"
gen mob_phone = asset_own if asset_name == "Mobile Telephone"
tab mob_phone if asset_name == "Mobile Telephone"
lab var mob_phone "HH owns at least one mobile phone"

tab asset_name if asset_name == "Radio/ tape recorder"
gen recorder = asset_own if asset_name == "Radio/ tape recorder"
tab recorder if asset_name == "Radio/ tape recorder"
lab var recorder "HH owns at least one radio/tape recorder"

tab asset_name if asset_name == "Television"
gen tv = asset_own if asset_name == "Television"
tab tv if asset_name == "Television"
lab var tv "HH owns at least one TV"

tab asset_name if asset_name == "Satelite Dish"
gen sat_dish = asset_own if asset_name == "Satelite Dish"
tab sat_dish if asset_name == "Satelite Dish"
lab var sat_dish "HH owns at least one satelite dish"

tab asset_name if asset_name == "Computer (desktop or laptop)"
gen computer = asset_own if asset_name == "Computer (desktop or laptop)"
tab computer if asset_name == "Computer (desktop or laptop)"
lab var computer "HH owns at least one computer"

tab asset_name if asset_name == "Sofa set"
gen sofa = asset_own if asset_name == "Sofa set"
tab sofa if asset_name == "Sofa set"
lab var sofa "HH owns at least one sofa set"

tab asset_name if asset_name == "Table"
gen table = asset_own if asset_name == "Table"
tab table if asset_name == "Table"
lab var table "HH owns at least one table"

tab asset_name if asset_name == "Chair"
gen chair = asset_own if asset_name == "Chair"
tab chair if asset_name == "Chair"
lab var chair "HH owns at least one chair"

tab asset_name if asset_name == "Bicycle"
gen bike = asset_own if asset_name == "Bicycle"
tab bike if asset_name == "Bicycle"
lab var bike "HH owns at least one bike"

tab asset_name if asset_name == "Motor cycle /Bajaj"
gen motorcycle = asset_own if asset_name == "Motor cycle /Bajaj"
tab motorcycle if asset_name == "Motor cycle /Bajaj"
lab var motorcycle "HH owns at least one motorcycle"

tab asset_name if asset_name == "Cart (Hand pushed)"
gen hand_cart = asset_own if asset_name == "Cart (Hand pushed)"
tab hand_cart if asset_name == "Cart (Hand pushed)"
lab var hand_cart "HH owns at least one hand pushed cart"

tab asset_name if asset_name == "Cart (animal drawn)- for transporting people and goods"
gen anim_cart = asset_own if asset_name == "Cart (animal drawn)- for transporting people and goods"
tab anim_cart if asset_name == "Cart (animal drawn)- for transporting people and goods"
lab var anim_cart "HH owns at least one animal-drawn cart"

tab asset_name if asset_name == "Sewing machine"
gen sew = asset_own if asset_name == "Sewing machine"
tab sew if asset_name == "Sewing machine"
lab var sew "HH owns at least one sewing machine"

tab asset_name if asset_name == "Weaving equipment"
gen weave = asset_own if asset_name == "Weaving equipment"
tab weave if asset_name == "Weaving equipment"
lab var weave "HH owns at least one piece of weaving equipment"

tab asset_name if asset_name == "Mitad-Electric"
gen mitad = asset_own if asset_name == "Mitad-Electric"
tab mitad if asset_name == "Mitad-Electric"
lab var mitad "HH owns at least one Mitad-Electric appliance"

tab asset_name if asset_name == "Energy saving stove (lakech, mirt etc)"
gen energ_save_stove = asset_own if asset_name == "Energy saving stove (lakech, mirt etc)"
tab energ_save_stove if asset_name == "Energy saving stove (lakech, mirt etc)"
lab var energ_save_stove "HH owns at least one energy saving stove"

tab asset_name if asset_name == "Refrigerator"
gen fridge = asset_own if asset_name == "Refrigerator"
tab fridge if asset_name == "Refrigerator"
lab var fridge "HH owns at least one fridge"

tab asset_name if asset_name == "Car or truck"
gen vehicle = asset_own if asset_name == "Car or truck"
tab vehicle if asset_name == "Car or truck"
lab var vehicle "HH owns at least one car or truck"

tab asset_name if asset_name == "Wardrobe"
gen wardrobe = asset_own if asset_name == "Wardrobe"
tab wardrobe if asset_name == "Wardrobe"
lab var wardrobe "HH owns at least one wardrobe"

tab asset_name if asset_name == "Shelf for storing goods"
gen shelf = asset_own if asset_name == "Shelf for storing goods"
tab shelf if asset_name == "Shelf for storing goods"
lab var shelf "HH owns at least one shelf for storing goods"

tab asset_name if asset_name == "Washing machine or Dish washer"
gen wash_dish = asset_own if asset_name == "Washing machine or Dish washer"
tab wash_dish if asset_name == "Washing machine or Dish washer"
lab var wash_dish "HH owns at least one washing machine or dishwasher"

tab asset_name if asset_name == "WIFI modem /router/dongle"
gen wifi = asset_own if asset_name == "WIFI modem /router/dongle"
tab wifi if asset_name == "WIFI modem /router/dongle"
lab var wifi "HH owns at least one WIFI modem /router/dongle"

gen oth = asset_own if asset_name == "Other (list)"
tab oth if asset_name == "Other (list)"
lab var oth "HH owns at least one other durable asset"

encode oth_asset_own, generate(oth_list)

collapse kerosene_stove cylinder_gas_stove electric_stove blanket_gabi bed mattress watch fixed_phone mob_phone recorder tv sat_dish computer sofa table chair bike motorcycle hand_cart anim_cart sew weave mitad energ_save_stove fridge vehicle wardrobe shelf wash_dish oth oth_list, by(caseid)


pca  kerosene_stove cylinder_gas_stove electric_stove blanket_gabi bed mattress watch fixed_phone mob_phone ///
	recorder tv sat_dish computer sofa table chair bike motorcycle hand_cart anim_cart sew weave mitad energ_save_stove ///
	fridge vehicle wardrobe shelf wash_dish, factor(3)
predict asset_urban 
xtile asset_index=asset_urban, nq(5)


label define quintile_urban 1 "Poorest" 2 "Poorer" 3"Middle" 4"Richer" 5"Richest"
label values asset_index quintile_urban
lab var asset_index "Wealth quintile"
gen quintile2=(asset_index==3 | asset_index==4 | asset_index==5) if asset_index!=. // 0=poorest 40%, 1=wealthiest 60%.
lab var quintile2 "Wealthiest 60%"
ta asset_index
ta quintile2


************************************
*Information devices ...Media access 
*1 if there is TV, radio, computer, satellite dish, cellphone, fixedline phone
**********************************
	tab fixed_phone, miss 
	tab mob_phone, miss 
	tab recorder, miss 
	tab tv, miss 
	tab sat_dish, miss 
	tab computer, miss

recode fixed_phone mob_phone recorder tv sat_dish computer (.=0)

	gen media_access = .
	replace media_access = 0 if (fixed_phone==0 & mob_phone==0 & tv==0 & sat_dish==0 & computer==0)
	replace media_access = 1 if (fixed_phone == 1 | mob_phone == 1 | recorder == 1 | tv == 1 | sat_dish == 1 | computer == 1)

tab media_access

	label var media_access "Media access: have TV, mobile, pc, radio, phone or satellite dish"
	label define yesno 1 "Yes" 0 "No"
	label values media_access yesno
	tab media_access, miss







merge 1:1 caseid using `urban_head_data', nogen keep(3) //merge at household level
	tempfile urban_hhlevel_data
	saveold `urban_hhlevel_data'


********************************************
//2. Individual Level Data...CHILD Data
*========================================
*-------------------------
	use "${urb_data}/member_level/S3_T4_0-5Aged_Antro_long.dta", clear
//To merge with the HH roster
	merge 1:1 uuid using "${urb_data}\member_level\S1_T1_HH_Roster_long.dta" //HH Roster
keep if _merge == 3
drop if missing(height_for_age_z_cat)
drop _merge
	merge 1:1 uuid using "${urb_data}\member_level\S3_T4_0-5Aged_VaccineInfo_long.dta" //Vaccine info
keep if _merge == 3
drop _merge
//Biological father and mother 
	merge 1:1 uuid using "${urb_data}\member_level\S1_T2_0_17Aged_long.dta", nogen keep(3)
	merge 1:1 uuid using "${urb_data}\member_level\S3_T1_0-17Aged_long.dta", nogen keep(3) //Health module
	merge m:1 caseid using "${urb_data}\hh_level\MCP_Survey_HH_level.dta", nogen keep(3)
count //1134	

gen age_weeks = (date_only - child_dob) / 7
sum age_weeks
gen age_in_month = (age*12) + age_month if !missing(age_month)
sum age_in_month

	drop sampling_strata
	merge m:1 caseid using `urban_hhlevel_data', nogen keep(3)


	
	

//To get age and marriage of mother and father
	gen father_ID = string(caseid,  "%13.0f") + string(father_id, "%2.0f") if !mi(father_id)
	gen mother_ID = string(caseid,  "%13.0f") + string(mother_id, "%2.0f") if !mi(mother_id)

	destring father_ID mother_ID, replace
	format %15.0g father_ID mother_ID
//To save mother Data
preserve
	keep uuid mother_ID
	rename uuid child_ID
	rename mother_ID uuid 

	merge m:1 uuid using "${urb_data}\member_level\S1_T1_HH_Roster_long.dta", nogen keep(3)
	
	rename (age marital_status age_marriage occupation)(mother_age mother_marital_status ///
	mother_age_marriage mother_occup)
	rename uuid mother_ID
	rename child_ID uuid 
	
	keep uuid mother_ID mother_age mother_marital_status ///
	mother_age_marriage mother_occup
	save "${urb_data}\member_level\S1_T2_MotherData.dta", replace
restore	

//To save Father Data
preserve
	keep uuid father_ID
	rename uuid child_ID
	rename father_ID uuid 

	merge m:1 uuid using "${urb_data}\member_level\S1_T1_HH_Roster_long.dta", nogen keep(3)
	
	rename (age marital_status age_marriage occupation)(father_age father_marital_status ///
	father_age_marriage father_occup)
	rename uuid father_ID
	rename child_ID uuid 
	
	keep uuid father_ID father_age father_marital_status ///
	father_age_marriage father_occup
	save "${urb_data}\member_level\S1_T2_FatherData.dta", replace
restore	

	merge m:m father_ID using "${urb_data}\member_level\S1_T2_FatherData.dta", nogen //Father Data
	merge m:m mother_ID using "${urb_data}\member_level\S1_T2_MotherData.dta", nogen //Mother Data

	gen dist_hf =  (health_facil_dist_hr * 60) + health_facil_dist_min
	gen dr_water_im_um = cond(inlist(drinking_water, 1, 2, 3, 4), 1, 0)
	label define dr_water_im_um_lbl 1 "Improved" 0 "Unimproved"
	label val dr_water_im_um dr_water_im_um_lbl
	label var dr_water_im_um "Drinking water: Improved/unimproved"
	

	gen toilet_im_um = cond(inlist(type_toilet_facility, 1, 2, 3, 6, 9), 1, 0)
	label define toilet_im_um_lbl 1 "Improved" 0 "Unimproved"
	label val toilet_im_um toilet_im_um_lbl
	label var toilet_im_um "Toilet: Improved/unimproved"

	gen own_business = (hh_owned_business + processed_products + own_busi_street + service_street + own_prof_office +  drive_hh_taxi +  own_restaurant)>0
	label var own_business "HH own business"
	label val own_business yesno


	gen age_inmonth = (age * 12 + age_month)
	destring calc_child_age5, replace
	destring type_illness_*, replace


	tempfile urban_data
	saveold `urban_data'
*===========================================================	
	
	
	
	
	
	
	
	
	
	
	
*******************************************************
*******************************************************
//-------National data
//To merge HH level data	
	use "${nat_data}\member_level\S1_T1_HH_Roster_long.dta", clear //HH Roster	
	
	*keep if index == 1
*to count number of hh member below 18
	gen num_children=(age<18)
*to count number of hh member below 5 (need crowding variable)
	gen num_childrenU5=(age<5) 
	gen HHhead_male=(sex==1) if relation_hhhead==1
	clonevar HHhead_marital = marital_status if relation_hhhead==1
	clonevar HHhead_age = age if relation_hhhead==1
	clonevar HHhead_occup = occupation if relation_hhhead==1
	clonevar HHhead_age_marriage = age_marriage if relation_hhhead==1
	
	keep caseid HHhead_male num_children num_childrenU5 HHhead_marital HHhead_age HHhead_occup HHhead_age_marriage


	collapse HHhead_male HHhead_marital HHhead_age HHhead_occup ///
	HHhead_age_marriage (sum) num_children num_childrenU5, by(caseid) //Household level data


	label var num_children "Number of children below 18 in the HH"
	label var num_childrenU5 "Number of members below 5 in the HH"

	tempfile national_head_data
	saveold `national_head_data'
*-------------------------
//-----------------------------------------------------------
*To merge all relevant household Level datasets---Urban Data
*-------------------------------------------------------------
**************
*Assets Data
***************
	use "${nat_data}\hh_level\S7_T1_Asset_long.dta", clear

replace oth_asset_own = "Water filter" if oth_asset_own == "Water Filter"

tab asset_name if asset_name == "Kerosene stove"
gen kerosene_stove = asset_own if asset_name == "Kerosene stove"
tab kerosene_stove if asset_name == "Kerosene stove"
lab var kerosene_stove "HH owns at least one kerosene stove"

tab asset_name if asset_name == "Cylinder gas stove"
gen cylinder_gas_stove = asset_own if asset_name == "Cylinder gas stove"
tab cylinder_gas_stove if asset_name == "Cylinder gas stove"
lab var cylinder_gas_stove "HH owns at least one cylinder gas stove"

tab asset_name if asset_name == "Electric stove"
gen electric_stove = asset_own if asset_name == "Electric stove"
tab electric_stove if asset_name == "Electric stove"
lab var electric_stove "HH owns at least one electric stove"

tab asset_name if asset_name == "Blanket/Gabi"
gen blanket_gabi = asset_own if asset_name == "Blanket/Gabi"
tab blanket_gabi if asset_name == "Blanket/Gabi"
lab var blanket_gabi "HH owns at least one blanket/gabi"

tab asset_name if asset_name == "Bed"
gen bed = asset_own if asset_name == "Bed"
tab bed if asset_name == "Bed"
lab var bed "HH owns at least one bed"

tab asset_name if asset_name == "cotton/sponge/spring mattress"
gen mattress = asset_own if asset_name == "cotton/sponge/spring mattress"
tab mattress if asset_name == "cotton/sponge/spring mattress"
lab var mattress "HH owns at least one cotton/sponge/spring mattress"

tab asset_name if asset_name == "Wrist watch/clock"
gen watch = asset_own if asset_name == "Wrist watch/clock"
tab watch if asset_name == "Wrist watch/clock"
lab var watch "HH owns at least one wristwatch/clock"

tab asset_name if asset_name == "Fixed line telephone"
gen fixed_phone = asset_own if asset_name == "Fixed line telephone"
tab fixed_phone if asset_name == "Fixed line telephone"
lab var fixed_phone "HH owns at least one fixed line phone"

tab asset_name if asset_name == "Mobile Telephone"
gen mob_phone = asset_own if asset_name == "Mobile Telephone"
tab mob_phone if asset_name == "Mobile Telephone"
lab var mob_phone "HH owns at least one mobile phone"

tab asset_name if asset_name == "Radio/ tape recorder"
gen recorder = asset_own if asset_name == "Radio/ tape recorder"
tab recorder if asset_name == "Radio/ tape recorder"
lab var recorder "HH owns at least one radio/tape recorder"

tab asset_name if asset_name == "Television"
gen tv = asset_own if asset_name == "Television"
tab tv if asset_name == "Television"
lab var tv "HH owns at least one TV"

tab asset_name if asset_name == "Satelite Dish"
gen sat_dish = asset_own if asset_name == "Satelite Dish"
tab sat_dish if asset_name == "Satelite Dish"
lab var sat_dish "HH owns at least one satelite dish"

tab asset_name if asset_name == "Computer (desktop or laptop)"
gen computer = asset_own if asset_name == "Computer (desktop or laptop)"
tab computer if asset_name == "Computer (desktop or laptop)"
lab var computer "HH owns at least one computer"

tab asset_name if asset_name == "Sofa set"
gen sofa = asset_own if asset_name == "Sofa set"
tab sofa if asset_name == "Sofa set"
lab var sofa "HH owns at least one sofa set"

tab asset_name if asset_name == "Table"
gen table = asset_own if asset_name == "Table"
tab table if asset_name == "Table"
lab var table "HH owns at least one table"

tab asset_name if asset_name == "Chair"
gen chair = asset_own if asset_name == "Chair"
tab chair if asset_name == "Chair"
lab var chair "HH owns at least one chair"

tab asset_name if asset_name == "Bicycle"
gen bike = asset_own if asset_name == "Bicycle"
tab bike if asset_name == "Bicycle"
lab var bike "HH owns at least one bike"

tab asset_name if asset_name == "Motor cycle /Bajaj"
gen motorcycle = asset_own if asset_name == "Motor cycle /Bajaj"
tab motorcycle if asset_name == "Motor cycle /Bajaj"
lab var motorcycle "HH owns at least one motorcycle"

tab asset_name if asset_name == "Cart (Hand pushed)"
gen hand_cart = asset_own if asset_name == "Cart (Hand pushed)"
tab hand_cart if asset_name == "Cart (Hand pushed)"
lab var hand_cart "HH owns at least one hand pushed cart"

tab asset_name if asset_name == "Cart (animal drawn)- for transporting people and goods"
gen anim_cart = asset_own if asset_name == "Cart (animal drawn)- for transporting people and goods"
tab anim_cart if asset_name == "Cart (animal drawn)- for transporting people and goods"
lab var anim_cart "HH owns at least one animal-drawn cart"

tab asset_name if asset_name == "Sewing machine"
gen sew = asset_own if asset_name == "Sewing machine"
tab sew if asset_name == "Sewing machine"
lab var sew "HH owns at least one sewing machine"

tab asset_name if asset_name == "Weaving equipment"
gen weave = asset_own if asset_name == "Weaving equipment"
tab weave if asset_name == "Weaving equipment"
lab var weave "HH owns at least one piece of weaving equipment"

tab asset_name if asset_name == "Mitad-Electric"
gen mitad = asset_own if asset_name == "Mitad-Electric"
tab mitad if asset_name == "Mitad-Electric"
lab var mitad "HH owns at least one Mitad-Electric appliance"

tab asset_name if asset_name == "Energy saving stove (lakech, mirt etc)"
gen energ_save_stove = asset_own if asset_name == "Energy saving stove (lakech, mirt etc)"
tab energ_save_stove if asset_name == "Energy saving stove (lakech, mirt etc)"
lab var energ_save_stove "HH owns at least one energy saving stove"

tab asset_name if asset_name == "Refrigerator"
gen fridge = asset_own if asset_name == "Refrigerator"
tab fridge if asset_name == "Refrigerator"
lab var fridge "HH owns at least one fridge"

tab asset_name if asset_name == "Car or truck"
gen vehicle = asset_own if asset_name == "Car or truck"
tab vehicle if asset_name == "Car or truck"
lab var vehicle "HH owns at least one car or truck"

tab asset_name if asset_name == "Wardrobe"
gen wardrobe = asset_own if asset_name == "Wardrobe"
tab wardrobe if asset_name == "Wardrobe"
lab var wardrobe "HH owns at least one wardrobe"

tab asset_name if asset_name == "Shelf for storing goods"
gen shelf = asset_own if asset_name == "Shelf for storing goods"
tab shelf if asset_name == "Shelf for storing goods"
lab var shelf "HH owns at least one shelf for storing goods"

tab asset_name if asset_name == "Washing machine or Dish washer"
gen wash_dish = asset_own if asset_name == "Washing machine or Dish washer"
tab wash_dish if asset_name == "Washing machine or Dish washer"
lab var wash_dish "HH owns at least one washing machine or dishwasher"

tab asset_name if asset_name == "WIFI modem /router/dongle"
gen wifi = asset_own if asset_name == "WIFI modem /router/dongle"
tab wifi if asset_name == "WIFI modem /router/dongle"
lab var wifi "HH owns at least one WIFI modem /router/dongle"

gen oth = asset_own if asset_name == "Other (list)"
tab oth if asset_name == "Other (list)"
lab var oth "HH owns at least one other durable asset"

encode oth_asset_own, generate(oth_list)

collapse kerosene_stove cylinder_gas_stove electric_stove blanket_gabi bed mattress watch fixed_phone mob_phone recorder tv sat_dish computer sofa table chair bike motorcycle hand_cart anim_cart sew weave mitad energ_save_stove fridge vehicle wardrobe shelf wash_dish oth oth_list, by(caseid)


pca  kerosene_stove cylinder_gas_stove electric_stove blanket_gabi bed mattress watch fixed_phone mob_phone ///
	recorder tv sat_dish computer sofa table chair bike motorcycle hand_cart anim_cart sew weave mitad energ_save_stove ///
	fridge vehicle wardrobe shelf wash_dish, factor(3)
predict asset_urban 
xtile asset_index=asset_urban, nq(5)


label define quintile_urban 1 "Poorest" 2 "Poorer" 3"Middle" 4"Richer" 5"Richest"
label values asset_index quintile_urban
lab var asset_index "Wealth quintile"
gen quintile2=(asset_index==3 | asset_index==4 | asset_index==5) if asset_index!=. // 0=poorest 40%, 1=wealthiest 60%.
lab var quintile2 "Wealthiest 60%"
ta asset_index
ta quintile2


************************************
*Information devices ...Media access 
*1 if there is TV, radio, computer, satellite dish, cellphone, fixedline phone
**********************************
	tab fixed_phone, miss 
	tab mob_phone, miss 
	tab recorder, miss 
	tab tv, miss 
	tab sat_dish, miss 
	tab computer, miss

recode fixed_phone mob_phone recorder tv sat_dish computer (.=0)

	gen media_access = .
	replace media_access = 0 if (fixed_phone==0 & mob_phone==0 & tv==0 & sat_dish==0 & computer==0)
	replace media_access = 1 if (fixed_phone == 1 | mob_phone == 1 | recorder == 1 | tv == 1 | sat_dish == 1 | computer == 1)

tab media_access

	label var media_access "Media access: have TV, mobile, pc, radio, phone or satellite dish"
	label define yesno 1 "Yes" 0 "No"
	label values media_access yesno
	tab media_access, miss







merge 1:1 caseid using `national_head_data', nogen keep(3) //merge at household level
	tempfile national_hhlevel_data
	saveold `national_hhlevel_data'


********************************************
//2. Individual Level Data...CHILD Data
*========================================
*-------------------------
	use "${nat_data}/member_level/S3_T4_0-5Aged_Antro_long.dta", clear
//To merge with the HH roster
	merge 1:1 uuid using "${nat_data}\member_level\S1_T1_HH_Roster_long.dta" //HH Roster
keep if _merge == 3
drop if missing(height_for_age_z_cat)
drop _merge
	merge 1:1 uuid using "${nat_data}\member_level\S3_T4_0-5Aged_VaccineInfo_long.dta" //Vaccine info
keep if _merge == 3
drop _merge
//Biological father and mother 
	merge 1:1 uuid using "${nat_data}\member_level\S1_T2_0_17Aged_long.dta", nogen keep(3)
	merge 1:1 uuid using "${nat_data}\member_level\S3_T1_0-17Aged_long.dta", nogen keep(3) //Health module
	merge m:1 caseid using "${nat_data}\hh_level\MDCPDE_Survey_HH_level.dta", nogen keep(3)
count //

gen age_weeks = (date_only - child_dob) / 7
sum age_weeks
gen age_in_month = (age*12) + age_month if !missing(age_month)
sum age_in_month

	drop sampling_strata
	merge m:1 caseid using `national_hhlevel_data', nogen keep(3)


	
	

//To get age and marriage of mother and father
	gen father_ID = string(caseid,  "%17.0f") + string(father_id, "%2.0f") if !mi(father_id)
	gen mother_ID = string(caseid,  "%17.0f") + string(mother_id, "%2.0f") if !mi(mother_id)

	destring father_ID mother_ID, replace
	format %19.0g father_ID mother_ID
//To save mother Data
preserve
	keep uuid mother_ID
	rename uuid child_ID
	rename mother_ID uuid 

	merge m:1 uuid using "${nat_data}\member_level\S1_T1_HH_Roster_long.dta", nogen keep(3)
	
	rename (age marital_status age_marriage occupation)(mother_age mother_marital_status ///
	mother_age_marriage mother_occup)
	rename uuid mother_ID
	rename child_ID uuid 
	
	keep uuid mother_ID mother_age mother_marital_status ///
	mother_age_marriage mother_occup
	save "${nat_data}\member_level\S1_T2_MotherData.dta", replace
restore	

//To save Father Data
preserve
	keep uuid father_ID
	rename uuid child_ID
	rename father_ID uuid 

	merge m:1 uuid using "${nat_data}\member_level\S1_T1_HH_Roster_long.dta", nogen keep(3)
	
	rename (age marital_status age_marriage occupation)(father_age father_marital_status ///
	father_age_marriage father_occup)
	rename uuid father_ID
	rename child_ID uuid 
	
	keep uuid father_ID father_age father_marital_status ///
	father_age_marriage father_occup
	save "${nat_data}\member_level\S1_T2_FatherData.dta", replace
restore	

	merge m:m father_ID using "${nat_data}\member_level\S1_T2_FatherData.dta", nogen //Father Data
	merge m:m mother_ID using "${nat_data}\member_level\S1_T2_MotherData.dta", nogen //Mother Data


	gen dist_hf =  (health_facil_dist_hr * 60) + health_facil_dist_min
	
	gen dr_water_im_um = cond(inlist(drinking_water, 1, 2, 3, 4), 1, 0)
	label define dr_water_im_um_lbl 1 "Improved" 0 "Unimproved"
	label val dr_water_im_um dr_water_im_um_lbl
	label var dr_water_im_um "Drinking water: Improved/unimproved"

	gen toilet_im_um = cond(inlist(type_toilet_facility, 1, 2, 3, 6, 9), 1, 0)
	label define toilet_im_um_lbl 1 "Improved" 0 "Unimproved"
	label val toilet_im_um toilet_im_um_lbl
	label var toilet_im_um "Toilet: Improved/unimproved"

	gen own_business = (hh_owned_business + processed_products + own_busi_street + service_street + own_prof_office +  drive_hh_taxi +  own_restaurant)>0
	label var own_business "HH own business"
	label val own_business yesno

	gen age_inmonth = (age * 12 + age_month)
	destring calc_child_age5, replace
	destring type_illness_*, replace
	
	append using `urban_data'

sum age_in_month
***********
//Total count
count //3913
*********
gen target_variable = cond(weight_for_age_z_cat == "underweight" |height_for_age_z_cat == "Stunted"|weight_for_height_z_cat == "wasted", 1, 0)

tab target_variable
**********************************

 //Universal codes
 //44 in a Day column---Card shows that a dose was given but no date is recorded
 //WRITE ‘44'  IF CARD SHOWS THAT A DOSE WAS GIVEN, BUT NO DATE IS RECORDED. WRITE '0' IF NOT VACCINATED. WRITE '99' IF NOT APPLICABLE, WRITE '88' IF CARD IS NOT FOUND.
 //
//To generate class variable

///-----merge mother related variables.....
	save "${cleaned_data}/MCP_final_mal.dta", replace
***========================END===========================================*******


***Continued*****
use "MCP_final_mal.dta", clear

foreach v of varlist _all {
    
    local lbl : value label `v'
    
    if "`lbl'" != "" {
        local newlbl "`v'_label"
        
        capture label copy `lbl' `newlbl'
        label values `v' `newlbl'
    }
}

foreach v of varlist _all {
    local lbl : value label `v'
    if "`lbl'" != "" {
        label list `v'_label
    }
  }
egen FSI = rowtotal(worry relyless_preferred limit_variety limit_size ///
reduce_meal restrict_adults borrow_food no_any_kind whole_day_without), missing

gen FS_category = .

replace FS_category = 1 if FSI == 0
replace FS_category = 2 if inrange(FSI,1,3)
replace FS_category = 3 if inrange(FSI,4,6)
replace FS_category = 4 if inrange(FSI,7,9)

label define fscat 1 "Food Secure" ///
                    2 "Mildly Insecure" ///
                    3 "Moderately Insecure" ///
                    4 "Severely Insecure"

label values FS_category fscat




* --- Recode household head education into 5 categories ---
capture drop educ_cat
gen educ_cat = .

* 1 = No education
replace educ_cat = 1 if inlist(hhhead_educ, -1, 0, 97, 98)

* 2 = Informal education
replace educ_cat = 2 if inlist(hhhead_educ, 93, 94, 95, 96)

* 3 = Primary (Grades 1–8)
replace educ_cat = 3 if inrange(hhhead_educ, 1, 8)

* 4 = Secondary (Grades 9–12 + vocational basic)
replace educ_cat = 4 if inrange(hhhead_educ, 9, 18)

* 5 = Higher (Diploma, College, Bachelor, Above)
replace educ_cat = 5 if inrange(hhhead_educ, 19, 25)

* --- Add labels ---
label define educ_cat_lbl ///
1 "No education" ///
2 "Informal" ///
3 "Primary" ///
4 "Secondary" ///
5 "Higher", replace

label values educ_cat educ_cat_lbl

* --- Check recoding ---
tab educ_cat
tab educ_cat hhhead_educ


* --- Replace missing values with Urban ---
replace urb_rur = 1 if missing(urb_rur)

* --- Rename variable ---
rename urb_rur residence

* --- Optional: Add value labels ---
label define residence_lbl 0 "Rural" 1 "Urban", replace
label values residence residence_lbl

* --- Check result ---
tab residence, missing

replace age_in_month = floor(age_weeks/4.345) if age_in_month < 6

replace age_in_month = round(age_weeks/4.345) if age_weeks == 26


gen ebf = breastfed_months + ( breastfed_days/30)


gen ever_bf_binary = .
replace ever_bf_binary = 1 if ever_breastfed == 1 | ever_breastfed == 2
replace ever_bf_binary = 0 if ever_breastfed == 3

label define bf_lbl 1 "Yes" 0 "No"
label values ever_bf_binary bf_lbl

rename breastfed_months ebf_months


replace drug_intestinal_worm = -99 if missing(drug_intestinal_worm)

replace mother_age_marriage = -99 if missing(mother_age_marriage)


recode drug_intestinal_worm (-99 = .) (3 = .)
tab drug_intestinal_worm
