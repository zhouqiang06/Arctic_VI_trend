library(dplyr)
library(stringr)

library(LandsatTS)

# 1. Simulate sample data and write to a CSV file for demonstration

# 2. Read the CSV file into an R data frame
df <- read.csv("/panfs/ccds02/nobackup/projects/hls/HLS/qzhou2/Arctic_VI_trend/TS/60VXR_HLS_SR_rec.csv")

df <- df %>%
mutate(year = as.integer(str_sub(DT, start = 1, end = 4)))
df <- df %>%
mutate(doy = as.integer(str_sub(DT, start = 5, end = 7)))

# # Optional: View the structure of the original data frame
# print("Original Data Frame:")
# print(df)


# 3. Calculate the difference (R - NIR) as a new column "diff"
# We can use the 'mutate' function from dplyr for this
df <- df %>%
  mutate(ndvi = (NIR - R) / (NIR + R))


# 4. Split the data frame into a list of data frames based on unique combinations of "lat" and "lon"
# We can use the 'group_by' and 'group_split' functions from dplyr
list_of_dfs <- df %>%
  group_by(latitude, longitude) %>%
  group_split()

# Optional: View the resulting list of data frames
# print("\nList of Data Frames (split by unique lat/lon combination):")
# print(list_of_dfs)

# print(length(list_of_dfs))

# Optional: Access a specific split data frame, e.g., the first one
# print("\nFirst split data frame:")
# print(list_of_dfs[[1]])

# Clean up the created CSV file (optional)
# file.remove("satellite_data.csv")

site_df = list_of_dfs[[1]]
site_df <- site_df %>%
mutate(sample.id = 1)
# print(head(site_df))
# print(nrow(site_df))
site_df_pheno = lsat_fit_phenological_curves(site_df, si = 'ndvi', window.yrs = 5, window.min.obs = 10, spl.fit.outfile = F, progress = F)
print(site_df_pheno)

# for (i in 1:length(list_of_dfs)) {
#   site_df = list_of_dfs[[i]]
#   site_df <- site_df %>%
#   mutate(sample.id = i)
#   print(head(site_df))
#   print(nrow(site_df))
#   print(lsat_fit_phenological_curves(site_df, si = 'ndvi', window.yrs = 5, window.min.obs = 10, spl.fit.outfile = F, progress = F))
# }

