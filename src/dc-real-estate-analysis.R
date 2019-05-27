# Name:         dc-real-estate-analysis.R
# Author:       Arnob L. Alam <arnoblalam@gmail.com>
# Last Updated: 2019-05-26
#
# Analyze DC sales data


library(tidyverse)

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

price_data %>% arrange(PRICE)

# Computer Assisted Mass Appraisal Files have data on structure characteristics
# such as the number of bedrooms, heating, architechtural style
# There are two files: condos and detached structures
cama_condo <- read_cama_condo()
cama_residential <- read_cama_residential()

# Combine the two files together
cama <- cama_residential %>% bind_rows(cama_condo)

# Join the two files by SSL (ID the DC government assigns to property)
price_data <- price_data %>%
    inner_join(cama, by = c("SSL" = "SSL"))
