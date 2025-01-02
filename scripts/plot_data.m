disp("Plotting");
data = parquetread("../data/raw/data.parquet");
plot(data, "Var1");
mkdir("../figures");
saveas(gcf, "../figures/plot.png")