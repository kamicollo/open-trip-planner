# Demo Open Trip Planner instance

This folder contains the Dockerfile to create an Atlanta-based OTP instance.

To use:

- Build docker image `docker build -t otp-atlanta .` (will take 5-10 minutes as it needs to download various datasets)
- Run the image and expose port 8080 ` docker run -dp 8062:8080 --name docker_container_name otp-atlanta`

You can then:
 - Navigate to `localhost:8062` and confirm that the OTP planner is running.
 - Try out a sample Jupyter notebook (`isochrones.ipynb`) which retrieves an isochrones for a location in Atlanta.


Details on isochrone API endpoint can be found @ http://dev.opentripplanner.org/apidoc/1.5.0/resource_LIsochrone.html.