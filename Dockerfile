#DOCKER STUFF
FROM openjdk:11

#STATIC
ENV OTP_JAR=https://repo1.maven.org/maven2/org/opentripplanner/otp/1.5.0/otp-1.5.0-shaded.jar
ENV BASE_PATH=otp

#DYNAMIC
ENV CITY=atlanta
ENV GTFS_URL=https://www.itsmarta.com/google_transit_feed/google_transit.zip
ENV STATE_PBF=http://download.geofabrik.de/north-america/us/georgia-latest.osm.pbf
ENV BOUNDING_BOX=-84.949036,33.261657,-83.737793,34.282184

#HELPERS
ENV ROUTER_PATH=$BASE_PATH/graphs/$CITY
RUN mkdir -p $ROUTER_PATH

#GET WGET + osmctools
RUN apt update && apt install -y wget osmctools

#DOWNLOAD data
RUN wget $GTFS_URL -O $ROUTER_PATH/gtfs.zip
RUN wget $STATE_PBF -O $ROUTER_PATH/base.pbf

#TRIM and clean up OSM data
RUN osmconvert $ROUTER_PATH/base.pbf -b=-84.949036,33.261657,-83.737793,34.282184 --complete-ways -o=$ROUTER_PATH/trimmed.pbf && rm $ROUTER_PATH/base.pbf

#DOWNLOAD OTP
RUN wget $OTP_JAR -O otp.jar

# BUILD OTP GRAPH
RUN java -Xmx2G -jar ./otp.jar --build $ROUTER_PATH

#SERVE
CMD java -Xmx2G -jar ./otp.jar --basePath $BASE_PATH --server --router $CITY
EXPOSE 8080
EXPOSE 8081