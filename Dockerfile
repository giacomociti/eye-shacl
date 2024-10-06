# Use the EYE reasoner Docker image as the base image
FROM eyereasoner/eye:latest

# Set the working directory inside the container
WORKDIR /workspace

# Install curl
RUN apt-get update && apt-get install -y curl

# Copy the entire project into the container
COPY . /workspace

# Make the scripts executable
RUN chmod +x build.sh test/test.sh test/testFile.sh dist/eye-shacl-compile.sh dist/eye-shacl-validate.sh dist/eye-shacl.sh

# Run the build script to prepare the necessary files
RUN ./build.sh

# Set the entrypoint to the bash shell
ENTRYPOINT ["/bin/bash"]