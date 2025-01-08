clear all
set more off

cd "D:\Downloads\DATA MOVEMENT DISTRIBUTION IDN COMBINED"

use "D:\Downloads\DATA MOVEMENT DISTRIBUTION IDN COMBINED\Combined_IDN_Data.dta", replace

gen date_num = date(date, "YMD")  // Mengonversi ke format tanggal
format date_num %td              // Memberikan format tanggal

encode gadm_name, generate(gadm_name_labeled)
encode home_to_ping_distance_category, generate(home_to_ping_category_labeled)
encode gadm_id, generate(gadm_id_labeled)

drop gadm_name ds date gadm_id

rename date_num date
rename gadm_name_labeled gadm_name
rename home_to_ping_category_labeled home_to_ping_distance_category 
rename gadm_id_labeled gadm_id

save "D:\Downloads\DATA MOVEMENT DISTRIBUTION IDN COMBINED\Full_Combined_IDN_Data.dta"


//Buat Dummy untuk home_to_ping_distance_category
tabulate home_to_ping_distance_category, generate(distance_cat_)


//Kategorikal
gen distance_category_numeric = .
replace distance_category_numeric = 1 if home_to_ping_distance_category == "0"
replace distance_category_numeric = 2 if home_to_ping_distance_category == "(0, 10)"
replace distance_category_numeric = 3 if strpos(home_to_ping_distance_category, "10, 100")
replace distance_category_numeric = 4 if home_to_ping_distance_category == "100+"


keep if gadm_name == "Jakarta Barat" | gadm_name == "Jakarta Pusat" | gadm_name == "Jakarta Selatan" | gadm_name == "Jakarta Timur" | gadm_name == "Jakarta Utara"
table gadm_name_num home_to_ping_distance_category, statistic(mean distance_category_ping_fraction)


table gadm_name_num home_to_ping_category_num, statistic(mean distance_category_ping_fraction)

