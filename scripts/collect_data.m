disp("Processing data");
voltage = rand(1000, 1);
data = table(voltage);
mkdir("../data/raw");
parquetwrite("../data/raw/data.parquet", data);