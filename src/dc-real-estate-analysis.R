# Name:         dc-real-estate-analysis.R
# Author:       Arnob L. Alam <arnoblalam@gmail.com>
# Last Updated: 2019-05-26
#
# Analyze DC sales data


library(tidyverse)
# library(caret)

# Source helper scrpt
source("src/get-data.R")

# The Integrated tax system public extract facts has information on
# land use (condo, co-op, commercial, etc.), land area, assessment value,
# sales price
tax_facts <- read_tax_system_facts()

# Filter for condos and residential structures sold in the last five years
price_data <- tax_facts %>%
    filter(TAX_TYPE_DESCRIPTION == "Residential real property, including multifamily") %>%
    filter(LAND_USE_CODE %in% c("011", "012", "013", "014", "016", "017",
                                  "023", "024")) %>%
    filter(LAST_SALE_DATE >= "2014-01-01") %>%
    mutate(PRICE = LAST_SALE_PRICE/LANDAREA)

# Computer Assisted Mass Appraisal Files have data on structure characteristics
# such as the number of bedrooms, heating, architechtural style
# There are two files: condos and detached structures
cama_condo <- read_cama_condo()
cama_residential <- read_cama_residential()

# Combine the two files together
cama <- cama_residential %>%
    bind_rows(cama_condo)

# Join the two files by SSL (ID the DC government assigns to property)
# Filter for only QUALIFIED sales
price_data <- price_data %>%
    inner_join(cama, by = c("SSL" = "SSL")) %>%
    filter(QUALIFIED == "Q")

# Graph stuff
ggplot(data = price_data) +
    geom_point(aes(
        x = LANDAREA.x,
        y = PRICE.x,
        color = factor(BEDRM))) +
    scale_x_log10(name = "LAND AREA") +
    scale_y_log10(name = "PRICE/SQ. FT.")




# The integrated tax system public extract contains more information
# about the property, including type of sale
#tax_raw <- read_tax_system_raw() %>%
#  select(SSL, ACCEPTCODE)

#price_data <- price_data %>%
#  inner_join(tax_raw, by = c("SSL" = "SSL"))


weird_props = "1314 W ST|304 Q ST NW|1433 R ST NW|1111  23RD ST NW|1414 22ND ST NW|1391 PENNSYLVANIA AVE SE|0045  SUTTON SQ SW|631 D ST NW|2328 CHAMPLAIN|777 7TH ST NW|2501  M ST NW|1111  24TH ST|1111  23RD ST NW|475 K ST NW|1080 WISCONSIN AVE NW|1324 14TH ST NW|920 I ST NW"
qplot(data = price_data %>%
          filter(!grepl(weird_props, PROPERTY_ADDRESS),
                 BATHRM == 1,
                 BEDRM == 1,
                 LAST_SALE_DATE > "2018-01-01",
                 OTR_NEIGHBORHOOD_NAME %in% c("FOGGY BOTTOM")),
      y = PRICE.x,
      x = LANDAREA.x,
      facets = ~ LAND_USE_DESCRIPTION,
      log = "xy") + geom_smooth(method = "lm", se = FALSE) +
    theme(legend.position = "none")

model_data <- price_data %>%
    filter(!grepl(weird_props, PROPERTY_ADDRESS),
           BATHRM == 1,
           BEDRM == 2,
           LAST_SALE_DATE > "2018-01-01",
           OTR_NEIGHBORHOOD_NAME %in% c("TRINIDAD"))

model_1 <- glm(PRICE.x ~ log(LANDAREA.x),
               data = model_data,
               family = gaussian(link = "log"))

model_2 <- glm(PRICE.x ~ log(LANDAREA.x),
               data = model_data,
               family = Gamma(link = "log"))

model_3 <- glm(log(PRICE.x) ~ log(LANDAREA.x),
               data = model_data)


newdata <- data.frame(LANDAREA.x = 677)
predict(model_1, newdata = newdata, type = "response")
predict(model_2, newdata = newdata, type = "response")
exp(predict(model_3, newdata = newdata, type = "response"))
