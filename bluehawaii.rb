#This code solves the problem propose at:  http://puzzlenode.com/puzzles/7-blue-hawaii

	require 'json'
	require 'date'

	input_date = File.read("./input.txt")
	id = input_date.split(" - ")

	start_date = id[0]
	end_date = id[1]
	sd = start_date.split("/")
	ed = end_date.split("/")
	sd_in_t = 15
	ed_out_t = 11	

	vacation_sd = DateTime.new(sd[0].to_i, sd[1].to_i, sd[2].to_i, sd_in_t, 00)
	vacation_ed = DateTime.new(ed[0].to_i, ed[1].to_i, ed[2].to_i, ed_out_t, 00)

	vacation_whole_period = Range.new(vacation_sd, vacation_ed)

	apartments = JSON.parse(File.read("./vacation_rentals.json"))

	apartments.each do |apt|
		name = apt['name']
		cleaning_fee = apt['cleaning fee']	
		seasons = apt['seasons']
		
		if cleaning_fee
  		xa = cleaning_fee.slice(1..-1)
		end

		total = 0

		if seasons
			seasons.each do |season|
				season.keys.each do |season_name|
					start_raw = season[season_name]['start']
					end_raw = season[season_name]['end']
					rate = season[season_name]['rate']

					start_month, start_day = start_raw.split('-')	
					end_month, end_day = end_raw.split('-')	
					rate = rate.slice(1..-1).to_i

					start_date = DateTime.new(2011, start_month.to_i, start_day.to_i, 15,00)
					end_date = DateTime.new(2011, end_month.to_i, end_day.to_i, 11,00)

					if start_date.month > end_date.month	
						year = start_date.year + 1
					else
		  			year = start_date.year
					end

					ss = DateTime.new(start_date.year, start_date.month, start_date.day, 15,00)
					se = DateTime.new(year, end_date.month, end_date.day, 11,00)
					saison = Range.new(ss, se)

					vacation_whole_period.each do |datetime|
						if saison.include?(datetime)
							total += rate
						end
					end
				end	
			end
			
			$total = (total + xa.to_i)*1.0411416
			puts ""
			puts "#{name}: $#{sprintf("%.2f", total)}"
			puts ""
		end
	end



