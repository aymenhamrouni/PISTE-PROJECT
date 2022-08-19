library(sets)
sets_options('universe', seq(from = 0,to = 4196, by = 1))
variables1 <-set(temperature =fuzzy_partition(varnames =c(cold = 0, medium = 25,hot = 50),sd = 12.5),
humidity =fuzzy_partition(varnames =c(wet = 0, medium = 37.5,dry = 75),sd = 18.75),
radiation =fuzzy_partition(varnames =c(low = 0, medium = 2098,intense = 4196),sd = 1049),
volume =fuzzy_partition(varnames =c(small = 0, medium = 50,big = 100),sd = 12.5))
rules1 <-set(
fuzzy_rule(temperature %is% hot || humidity %is% wet || radiation %is% intense,
           volume %is% big),
fuzzy_rule(temperature %is% cold || humidity %is% dry|| radiation %is% low,
           volume %is% small))
system1 <- fuzzy_system(variables1, rules1)

variables2 <-set(temperature =fuzzy_partition(varnames =c(cold = 0, medium = 25,hot = 50),sd = 12.5),
humidity =fuzzy_partition(varnames =c(wet = 0, medium = 37.5,dry = 75),sd = 18.75),
radiation =fuzzy_partition(varnames =c(low = 0, medium = 2098,intense = 4196),sd = 1049),
duration =fuzzy_partition(varnames =c(short = 0, medium = 30,long = 60),sd = 12.5))
rules2 <-set(
fuzzy_rule(temperature %is% hot || humidity %is% wet || radiation %is% intense,
           duration %is% long),
fuzzy_rule(temperature %is% cold || humidity %is% dry|| radiation %is% low,
           duration %is% short))
system2 <- fuzzy_system(variables2, rules2)
	
count <- 0
con = file("~/Desktop/PISTE01-2018-V1.2/Codes@PISTE01-2018/02-Data-Processing/SolutionA/input_data.txt","r")
line_in = length(readLines(con))
while (TRUE) {
  while (count < line_in ) {
        con = file("~/Desktop/PISTE01-2018-V1.2/Codes@PISTE01-2018/02-Data-Processing/SolutionA/input_data.txt","r")
        line_in = length(readLines(con))
        v<-scan(file="~/Desktop/PISTE01-2018-V1.2/Codes@PISTE01-2018/02-Data-Processing/SolutionA/input_data.txt", what=double(),nmax=3,skip= count )
        count <- count +1;
        f1 <- fuzzy_inference(system1, list( temperature=v[1], humidity=v[2], radiation=v[3]))
        a <- gset_defuzzify(f1, "centroid")
    
        f2 <- fuzzy_inference(system2, list( temperature=v[1], humidity=v[2], radiation=v[3]))
        b <- gset_defuzzify(f2, "centroid")
        line_out =paste(a,b,sep=" ")
        write(line_out,file ="~/Desktop/PISTE01-2018-V1.2/Codes@PISTE01-2018/02-Data-Processing/SolutionA/output_data.txt",append=TRUE)
        cono = file("~/Desktop/PISTE01-2018-V1.2/Codes@PISTE01-2018/02-Data-Processing/SolutionA/output_data.txt","r")
        print("Number of lines written in the output file :")
        print(length(readLines(cono)))

  }
	Sys.sleep(5)
	print('Data stored successfully in the output file : Sleep Time before Relaunch!')
}
close(cono)
close(con)