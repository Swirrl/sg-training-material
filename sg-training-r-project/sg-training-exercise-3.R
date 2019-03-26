# libraries

#install.packages("httr")
#install.packages("SPARQL")

library(httr)
library(SPARQL)

alc_rel_dcharge_sparql <- "
PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/concept#>
PREFIX data: <http://statistics.gov.scot/data/>
PREFIX sdmxd: <http://purl.org/linked-data/sdmx/2009/dimension#>
PREFIX mp: <http://statistics.gov.scot/def/measure-properties/>
PREFIX stat: <http://statistics.data.gov.uk/def/statistical-entity#>

SELECT ?areaname ?nratio ?yearname ?areatypename 
WHERE {
  ?indicator qb:dataSet data:alcohol-related-discharge ;
    sdmxd:refArea ?area ;
    sdmxd:refPeriod ?year ;
    mp:ratio ?nratio .
  ?year rdfs:label ?yearname .
  ?area stat:code ?areatype ;
    rdfs:label ?areaname .
  ?areatype rdfs:label ?areatypename .
}"

endpoint <- "http://statistics.gov.scot/sparql"

qd <- SPARQL(endpoint,alc_rel_dcharge_sparql)

df <- qd$results
