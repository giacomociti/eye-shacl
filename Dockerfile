FROM node:24-alpine

# Set the working directory inside the container
WORKDIR /workspace

RUN apk add --no-cache bash

# Copy the entire project into the container
COPY . /workspace

RUN npm install

# Make the scripts executable
RUN chmod +x build.sh test/test.sh test/testFile.sh

# Set the entrypoint to the bash shell
ENTRYPOINT ["/bin/bash"]