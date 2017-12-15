#! /usr/bin/env ruby


#this script is for vcf generated by sniffles
#sniffles output is as below:
#   #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	rel4-all.bam
#   chr1	564431	668	N	<TRA>	.	PASS	PRECISE;SVMETHOD=Snifflesv1.0.3;CHR2=chr12;END=41757454;STD_quant_start=2.695025;STD_quant_stop=3.471690;Kurtosis_quant_start=-0.015561;Kurtosis_quant_stop=-0.910005;SVTYPE=TRA;SUPTYPE=SR;SVLEN=1992118429;STRANDS=--;RE=38	GT:DR:DV	./.:.:38
#
#output example
#source_id,source_breakpoint,source_strand,target_id,target_breakpoint,target_strand,priority,svtype
#chr2,181265670,+,chr7,149006956,+,0,TRA,,,id1
#chr2,176643961,+,chr8,57149801,-,0,TRA,,,id2
#chr9,13643427,+,chr9,32391692,+,0,TRA,,,id3
#chr9,24354925,+,chr9,33924070,+,0,TRA,,,id4
if ARGV.size < 1 || ARGV[0].split(".")[-1] != "vcf" then
	puts "vcf2pcf.rb <xxx.vcf>"
	exit(1)
end
File.open(ARGV[0], "r") do |f|
	line = f.gets
	if line.split("=")[1].strip != "VCFv4.2" then
		puts "input VCFv4.2 format file"
		exit(1)
	end
	line = f.gets
	if line.split("=")[1].strip != "Sniffles" then
		puts "input VCFv4.2 from Sniffles"
		exit(1)
	end
	while line[0] == "#" && line.split("\t")[0] != "#CHROM"
		line = f.gets
	end
	puts "source_id,source_breakpoint,source_strand,target_id,target_breakpoint,target_strand,priority,svtype,sequence"
	str1 = ""
	chr2 = ""
	pos2 = ""
	str2 = ""
	seq = ""
	type = ""
	priority = nil
	f.each_line do |line|
		list = line.strip.split("\t")
		chr1 = list[0]
		pos1 = list[1]
		info = list[7].split(";")
		info.each do |element|
			if element.include?("=") then
				case element.split("=")[0]
				when "CHR2" then
					chr2 = element.split("=")[1]
				when "END" then
					pos2 = element.split("=")[1]
				when "SVTYPE" then
					type = element.split("=")[1]
				when "STRANDS" then
					str1 = element.split("=")[1][0]
					str2 = element.split("=")[1][1]
				when "SEQ" then
					seq = element.split("=")[1]
				when "RE" then
					priority = element.split("=")[1]
				else
				end
			end
		end
	print chr1, ",", pos1, ",", str1, ",", chr2, ",", pos2, ",", str2, ",", priority, ",", type,",", seq, "\n"
	seq = ""
	end
end
