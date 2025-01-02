disp("Processing data");
data = table(1:1000:0.1);
mkdir("../data/raw");
parquetwrite("../data/raw/data.parquet", data);