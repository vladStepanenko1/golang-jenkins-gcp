# builder image
FROM golang:alpine3.14 as builder

# setup working directory
WORKDIR /usr/app/src/

# copy the source code into the container
COPY . .

# build the application
RUN go build -o ./bin/app ./main.go

# runtime image
FROM alpine:3.14.0

# setup working directory
WORKDIR /usr/bin/

# copy binary file
COPY --from=builder /usr/app/src/bin/app /usr/bin/

# expose application's port
EXPOSE 8000

# run application
CMD [ "/usr/bin/app" ]