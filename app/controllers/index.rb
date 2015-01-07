get '/' do

	@homicides = Crime.where(primary_type: "HOMICIDE").order("RANDOM()").limit(10)
 
# DETERMINE THE NUMBER OF HOMICIDES WITHIN A PARTICULAR TEMPERATURE RANGE - can clean up the below code with a case statement
# For the bar graph

	twenty = []

	@homicides.each do |homicide|
		if homicide.temp > 0 && homicide.temp < 21
			twenty << homicide
		end
	end

	@twenty = twenty.count

	forty = []

	@homicides.each do |homicide|
		if homicide.temp > 20 && homicide.temp < 41
			forty << homicide
		end
	end

	@forty = forty.count

	sixty = []

	@homicides.each do |homicide|
		if homicide.temp > 40 && homicide.temp < 61
			sixty << homicide
		end
	end

	@sixty = sixty.count

	seventy = []

	@homicides.each do |homicide|
		if homicide.temp > 60 && homicide.temp < 71
			seventy << homicide
		end
	end

	@seventy = seventy.count

	eighty = []

	@homicides.each do |homicide|
		if homicide.temp > 70 && homicide.temp < 81
			eighty << homicide
		end
	end

	@eighty = eighty.count

	high = []

	@homicides.each do |homicide|
		if homicide.temp > 80
			high << homicide
		end
	end

	@high = high.count


	@hom2 = [
		{temperature: "0-20", homicides: @twenty},
		{temperature: "21-40", homicides: @forty},
		{temperature: "41-60", homicides: @sixty},
		{temperature: "61-70", homicides: @seventy},
		{temperature: "71-80", homicides: @eighty},
		{temperature: "81+", homicides: @high}
	]

# ---------------------------------------------------------------------------------
	
# DETERMINE THE NUMBER OF HOMICIDES THAT OCCURRED IN A PARTICULAR DISTRICT
# For the color clipper graph

# Clunky to keep all of the below logic in this controller... perhaps use a helper?

	@hom1 = Crime.where(primary_type: "HOMICIDE")

	@d_homicides = []
	@hom1.each do |homicides|
		@d_homicides << homicides.district
	end

	@uniq = @d_homicides.uniq.sort

	@homicide_count = Hash.new(0)
	@d_homicides.each { |district| @homicide_count[district] += 1 }


	@district_homicides = [
		{district: 1, homicide_total: @homicide_count[1] },
		{district: 2, homicide_total: @homicide_count[2] },
		{district: 3, homicide_total: @homicide_count[3] },
		{district: 4, homicide_total: @homicide_count[4] },
		{district: 5, homicide_total: @homicide_count[5] },
		{district: 6, homicide_total: @homicide_count[6] },
		{district: 7, homicide_total: @homicide_count[7] },
		{district: 8, homicide_total: @homicide_count[8] },
		{district: 9, homicide_total: @homicide_count[9] },
		{district: 10, homicide_total: @homicide_count[10] },
		{district: 11, homicide_total: @homicide_count[11] },
		{district: 12, homicide_total: @homicide_count[12] },
		{district: 14, homicide_total: @homicide_count[14] },
		{district: 15, homicide_total: @homicide_count[15] },
		{district: 16, homicide_total: @homicide_count[16] },
		{district: 17, homicide_total: @homicide_count[17] },
		{district: 18, homicide_total: @homicide_count[18] },
		{district: 19, homicide_total: @homicide_count[19] },
		{district: 20, homicide_total: @homicide_count[20] },
		{district: 22, homicide_total: @homicide_count[22] },
		{district: 24, homicide_total: @homicide_count[24] },
		{district: 25, homicide_total: @homicide_count[25] }
	]

  erb :index
end

			

