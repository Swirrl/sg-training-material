# We're going to use the SPARQL query to get the results straight from statistics.gov.scot

# install the packages that we need for this - SPARQL is a library that makes it easier to interact with SPARQL APIs
# ggplot is the charting package we've seen previously

library(SPARQL)
library(ggplot2)

# first we need to create a variable to hold the url of the sparql endpoint

endpoint <- "http://statistics.gov.scot/sparql"

# next we load the SPARQL query string into a variable

query <- "PREFIX dcat: <http://www.w3.org/ns/dcat#>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/concept#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX void: <http://rdfs.org/ns/void#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?areaname ?value
WHERE {
   ?obs  <http://purl.org/linked-data/cube#dataSet> <http://statistics.gov.scot/data/alcohol-related-discharge> ;
         <http://statistics.gov.scot/def/measure-properties/ratio> ?value ;
         <http://purl.org/linked-data/sdmx/2009/dimension#refArea> ?area ;
         <http://purl.org/linked-data/sdmx/2009/dimension#refPeriod> <http://reference.data.gov.uk/id/government-year/2016-2017> .
   ?area rdfs:label ?areaname ;
  	 <http://statistics.data.gov.uk/def/statistical-entity#code> <http://statistics.gov.scot/id/statistical-entity/S12>                                                                                                                     
}"

# we use these two variables in conjunction with the SPARQL library to get the data
# this may take some time depending on the query

qd <- SPARQL(endpoint,query)

#  this creates a list with two dataframes inside - ignore the namespace one. We just want results

alcodataframe <- qd$results

# now we can make a simple bar chart of this as we've done previously

alcochart <- ggplot(alcodataframe, aes(x=areaname, y=value)) + 
  geom_bar(stat='identity')

alcochart
