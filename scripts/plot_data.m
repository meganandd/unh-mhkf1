disp("Plotting");
data = parquetread("../data/raw/data.parquet");
plot(data, "voltage");
mkdir("../figures");
saveas(gcf, "../figures/plot.png")