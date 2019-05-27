# Name:         get-data.R
# Author:       Arnob L. Alam <arnoblalam@gmail.com>
# Last Updated: 2019-05-26
#
# Functions to get and read DC open data


#' Get Computer Assisted Mass Appraisal - Residential Data
#' Saves the data in destfile
#'
#' @param url the URL to download data from
#' '@param destfile the location to save the file
#'
#' @return NULL
#' @export
#'
#' @examples
#' get_cama_residential()
get_cama_residential <- function(
    url = "https://opendata.arcgis.com/datasets/c5fb3fbe4c694a59a6eef7bf5f8bc49a_25.csv",
    destfile = "data/Computer_Assisted_Mass_Appraisal__Residential.csv") {
    download.file(url = url,
                  destfile = destfile)
}

#' GetComputer Assisted Mass Appraisal - Condo data
#' Saves the data to destfile
#'
#' @param url the URL to download data file
#' @param destfile the location to save the file
#'
#' @return
#' @export
#'
#' @examples
get_cama_condo <- function(
    url = "https://opendata.arcgis.com/datasets/d6c70978daa8461992658b69dccb3dbf_24.csv",
    destfile = "data/Computer_Assisted_Mass_Appraisal__Condominium.csv") {
    download.file(url = url,
                  destfile = destfile)
}

#' Get Integrated Tax System Public Extract Facts data
#' Save the data to destfile
#'
#' @param url the URL to download the data from
#' @param destfile the location to save the file
#'
#' @return
#' @export
#'
#' @examples
get_tax_system_public_extract_facts <- function(
    url = "https://opendata.arcgis.com/datasets/014f4b4f94ea461498bfeba877d92319_56.csv",
    destfile = "data/Integrated_Tax_System_Public_Extract_Facts.csv") {
    download.file(url = url, destfile = destfile)
}

get_tax_system_public_extracts <- function(
    url = "https://opendata.arcgis.com/datasets/496533836db640bcade61dd9078b0d63_53.csv",
    destfile ="data/Integrated_Tax_System_Public_Extract.csv") {
    download.file(url = url, destfile = destfile)
}

read_cama_residential <- function(filepath = "data/Computer_Assisted_Mass_Appraisal__Residential.csv") {
    readr::read_csv(filepath)
}

read_cama_condo <- function(filepath = "data/Computer_Assisted_Mass_Appraisal__Condominium.csv") {
    readr::read_csv(filepath)
}

read_tax_system_facts <- function(filepath = "data/Integrated_Tax_System_Public_Extract_Facts.csv") {
    readr::read_csv(filepath, guess_max = 1000)
}

read_tax_system_raw <- function(filepath = "data/Integrated_Tax_System_Public_Extract.csv") {
    readr::read_csv(filepath, guess_max = 1000)
}
